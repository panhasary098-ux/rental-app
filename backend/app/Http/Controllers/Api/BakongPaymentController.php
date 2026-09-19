<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Services\BakongKhqrService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class BakongPaymentController extends Controller
{
    // Generate QR
    public function generateQr(
        Request $request,
        Payment $payment
    ) {
        $user = $request->user();

        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Load property
        $payment->load('property');

        if (!$payment->property) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Property not found for this payment.',
            ], 404);
        }

        // Owner check
        if (
            $payment->property->owner_id
            !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'You do not own this property.',
            ], 403);
        }

        // Already paid
        if (
            $payment->payment_status
            === 'paid'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'This payment has already been paid.',
            ], 422);
        }

        $accountId =
            env(
                'BAKONG_ACCOUNT_USERNAME',
                ''
            );

        $accountName =
            env(
                'BAKONG_ACCOUNT_NAME',
                ''
            );

        $merchantCity =
            env(
                'BAKONG_MERCHANT_CITY',
                ''
            );

        $currency =
            strtoupper(
                env(
                    'BAKONG_CURRENCY',
                    'USD'
                )
            );

        // Configuration check
        if (
            empty($accountId) ||
            empty($accountName) ||
            empty($merchantCity) ||
            empty($currency)
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Bakong KHQR configuration is incomplete.',
            ], 500);
        }

        try {
            // Generate KHQR
            $khqrService =
                new BakongKhqrService();

            $khqr =
                $khqrService->generate(
                    $accountId,
                    $accountName,
                    $merchantCity,
                    $currency,
                    (float) $payment->amount,
                    (int) $payment->id
                );

            if (
                empty($khqr['success']) ||
                empty($khqr['qr']) ||
                empty($khqr['md5'])
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Unable to generate Bakong KHQR.',
                ], 500);
            }

            // Save QR
            $payment->update([
                'bakong_qr' =>
                    $khqr['qr'],

                'bakong_md5' =>
                    $khqr['md5'],
            ]);

            $payment->refresh();

            return response()->json([
                'success' => true,
                'message' =>
                    'Bakong KHQR generated successfully.',
                'payment' => [
                    'id' =>
                        $payment->id,

                    'property_id' =>
                        $payment->property_id,

                    'amount' =>
                        $payment->amount,

                    'currency' =>
                        $currency,

                    'payment_status' =>
                        $payment->payment_status,

                    'bakong_qr' =>
                        $payment->bakong_qr,

                    'bakong_md5' =>
                        $payment->bakong_md5,

                    'expires_at' =>
                        $khqr['expiresAt']
                        ?? null,
                ],
            ], 200);
        } catch (\Throwable $e) {
            report($e);

            return response()->json([
                'success' => false,
                'message' =>
                    'Unable to generate Bakong KHQR.',
            ], 500);
        }
    }

    // Check Payment
    public function checkPayment(
        Request $request,
        Payment $payment
    ) {
        $user = $request->user();

        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Load property
        $payment->load('property');

        if (!$payment->property) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Property not found for this payment.',
            ], 404);
        }

        // Owner check
        if (
            $payment->property->owner_id
            !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'You do not own this property.',
            ], 403);
        }

        // Already paid
        if (
            $payment->payment_status
            === 'paid'
        ) {
            return response()->json([
                'success' => true,
                'paid' => true,
                'message' =>
                    'Payment has already been confirmed.',
                'payment' => $payment,
            ], 200);
        }

        // Bakong MD5 required
        if (empty($payment->bakong_md5)) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Bakong MD5 is missing for this payment.',
            ], 422);
        }

        $baseUrl =
            rtrim(
                env(
                    'BAKONG_API_BASE_URL',
                    ''
                ),
                '/'
            );

        $token =
            env(
                'BAKONG_API_TOKEN',
                ''
            );

        $accountId =
            env(
                'BAKONG_ACCOUNT_USERNAME',
                ''
            );

        $currency =
            strtoupper(
                env(
                    'BAKONG_CURRENCY',
                    'USD'
                )
            );

        // Configuration check
        if (
            empty($baseUrl) ||
            empty($token) ||
            empty($accountId)
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Bakong API configuration is incomplete.',
            ], 500);
        }

        try {
            // Check transaction with Bakong
            $response =
                Http::withToken($token)
                    ->acceptJson()
                    ->asJson()
                    ->timeout(20)
                    ->post(
                        $baseUrl .
                        '/v1/check_transaction_by_md5',
                        [
                            'md5' =>
                                $payment->bakong_md5,
                        ]
                    );

            if (!$response->successful()) {
                return response()->json([
                    'success' => false,
                    'paid' => false,
                    'message' =>
                        'Unable to verify payment with Bakong.',
                    'bakong_status' =>
                        $response->status(),

                    // Temporary Debug
                    'bakong_response' =>
                        $response->body(),
                ], 502);
            }

            $bakong =
                $response->json();

            // Bakong success code
            if (
                (int) (
                    $bakong['responseCode']
                    ?? $bakong['code']
                    ?? -1
                ) !== 0
            ) {
                return response()->json([
                    'success' => true,
                    'paid' => false,
                    'message' =>
                        'Payment has not been confirmed yet.',

                    // Temporary Debug
                    'bakong_response' =>
                        $bakong,
                ], 200);
            }

            $data =
                $bakong['data']
                ?? [];

            if (empty($data)) {
                return response()->json([
                    'success' => true,
                    'paid' => false,
                    'message' =>
                        'Payment has not been confirmed yet.',

                    // Temporary Debug
                    'bakong_response' =>
                        $bakong,
                ], 200);
            }

            // Receiver check
            $toAccountId =
                $data['toAccountId']
                ?? null;

            if (
                $toAccountId !==
                $accountId
            ) {
                return response()->json([
                    'success' => false,
                    'paid' => false,
                    'message' =>
                        'Payment receiver does not match JoulNow.',

                    // Temporary Debug
                    'expected_receiver' =>
                        $accountId,

                    'received_receiver' =>
                        $toAccountId,
                ], 422);
            }

            // Currency check
            $transactionCurrency =
                strtoupper(
                    (string) (
                        $data['currency']
                        ?? ''
                    )
                );

            if (
                $transactionCurrency !==
                $currency
            ) {
                return response()->json([
                    'success' => false,
                    'paid' => false,
                    'message' =>
                        'Payment currency does not match.',

                    // Temporary Debug
                    'expected_currency' =>
                        $currency,

                    'received_currency' =>
                        $transactionCurrency,
                ], 422);
            }

            // Amount check
            $transactionAmount =
                (float) (
                    $data['amount']
                    ?? 0
                );

            $expectedAmount =
                (float) $payment->amount;

            if (
                abs(
                    $transactionAmount -
                    $expectedAmount
                ) > 0.001
            ) {
                return response()->json([
                    'success' => false,
                    'paid' => false,
                    'message' =>
                        'Payment amount does not match.',

                    // Temporary Debug
                    'expected_amount' =>
                        $expectedAmount,

                    'received_amount' =>
                        $transactionAmount,
                ], 422);
            }

            // Payment confirmed
            $payment->update([
                'payment_status' =>
                    'paid',

                'paid_at' =>
                    now(),

                'transaction_reference' =>
                    $data['hash']
                    ?? $payment
                        ->transaction_reference,
            ]);

            $payment->refresh();

            return response()->json([
                'success' => true,
                'paid' => true,
                'message' =>
                    'Bakong payment confirmed successfully.',
                'payment' =>
                    $payment,
            ], 200);
        } catch (\Throwable $e) {
            report($e);

            return response()->json([
                'success' => false,
                'paid' => false,
                'message' =>
                    'Unable to connect to Bakong.',

                // Temporary Debug
                'error_type' =>
                    get_class($e),

                'error' =>
                    $e->getMessage(),
            ], 500);
        }
    }
}