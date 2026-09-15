<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AiChatMessage;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AiChatController extends Controller
{
    // Chat
    public function chat(Request $request)
    {
        $request->validate([
            'message' => 'required|string|max:1000',
            'history' => 'nullable|array',
            'history.*.role' => 'required|string|in:user,model',
            'history.*.text' => 'required|string|max:2000',
        ]);

        $userMessage = trim($request->message);
        $history = $request->history ?? [];

        $systemPrompt = <<<PROMPT
Identity:
- You are the JoulNow Rental Assistant.
- You were created for the JoulNow rental platform by the JoulNow development team.
- If the user asks who made you, who created you, or who developed you, say:
  "I was created by the JoulNow development team to help users with rental questions and guidance."
- Do not mention Google, Gemini, or the underlying AI provider unless the user specifically asks about the technology powering you.

Your purpose is to help renters understand renting and safely navigate the rental process.

You can help with:
- Rental documents
- Rental agreements and contracts
- Security deposits
- Monthly rent
- Utility payments
- Property inspections
- Moving in and moving out
- Tenant responsibilities
- House owner responsibilities
- Questions renters should ask owners
- General rental safety
- How to use JoulNow

About JoulNow:
JoulNow is a verified rental property platform.

Properties are reviewed before they become publicly available.

House owners may provide:
- Property ownership or authorization documents
- National identification

Rules:
1. Give clear and simple answers.
2. Keep answers useful for students and workers.
3. Do not invent laws.
4. Do not claim something is legally required unless certain.
5. For legal questions, explain that laws may vary and recommend checking an official authority or legal professional.
6. Do not invent properties, prices, owners, availability, or verification status.
7. Do not pretend you have access to information you were not given.
8. Stay mainly focused on renting, housing, contracts, documents, and JoulNow.
9. Keep answers concise and practical.
10. If the user asks something unrelated to renting or JoulNow, politely explain that you mainly assist with rental-related questions.

Formatting rules:
- Do not use Markdown.
- Do not use #, ##, ###, *, **, or Markdown tables.
- Use simple numbered lists when needed.
- Keep answers short and easy to read on a mobile screen.
- Prefer 3 to 5 useful points.
- Keep most answers under 120 words unless the user asks for more detail.
- Avoid long introductions before the answer.
PROMPT;

        try {
            $apiKey = config('services.gemini.key');

            $primaryModel = config(
                'services.gemini.model'
            );

            $fallbackModel = config(
                'services.gemini.fallback_model'
            );

            if ($apiKey == null || $apiKey == '') {
                return response()->json([
                    'success' => false,
                    'message' => 'Gemini API key is missing.',
                ], 500);
            }

            if (
                $primaryModel == null ||
                $primaryModel == ''
            ) {
                return response()->json([
                    'success' => false,
                    'message' => 'Primary Gemini model is missing.',
                ], 500);
            }

            // Build Conversation
            $contents = [];

            foreach ($history as $historyMessage) {
                $role =
                    $historyMessage['role'] ?? null;

                $text = trim(
                    $historyMessage['text'] ?? ''
                );

                if (
                    !in_array(
                        $role,
                        ['user', 'model']
                    ) ||
                    $text == ''
                ) {
                    continue;
                }

                $contents[] = [
                    'role' => $role,
                    'parts' => [
                        [
                            'text' => $text,
                        ],
                    ],
                ];
            }

            // Current Message
            $contents[] = [
                'role' => 'user',
                'parts' => [
                    [
                        'text' => $userMessage,
                    ],
                ],
            ];

            // Save User Message
            AiChatMessage::create([
                'user_id' => $request->user()->id,
                'role' => 'user',
                'message' => $userMessage,
            ]);

            // Primary Model
            $response = null;
            $usedModel = $primaryModel;

            try {
                $response =
                    $this->sendGeminiRequest(
                        $primaryModel,
                        $apiKey,
                        $systemPrompt,
                        $contents
                    );
            } catch (ConnectionException $e) {
                $response = null;
            }

            // Use Fallback
            $useFallback =
                $response == null ||
                $this->shouldUseFallback(
                    $response
                );

            if (
                $useFallback &&
                $fallbackModel != null &&
                $fallbackModel != '' &&
                $fallbackModel != $primaryModel
            ) {
                try {
                    $response =
                        $this->sendGeminiRequest(
                            $fallbackModel,
                            $apiKey,
                            $systemPrompt,
                            $contents
                        );

                    $usedModel =
                        $fallbackModel;
                } catch (ConnectionException $e) {
                    $response = null;
                }
            }

            // Timeout
            if ($response == null) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'The AI assistant is taking too long to respond. Please try again.',
                ], 503);
            }

            // Request Failed
            if ($response->failed()) {
                $error = $response->json();

                $status = $response->status();

                $errorStatus =
                    $error['error']['status']
                    ?? null;

                if (
                    $status == 503 ||
                    $errorStatus == 'UNAVAILABLE'
                ) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'The AI assistant is busy right now. Please try again in a moment.',
                    ], 503);
                }

                if (
                    $status == 429 ||
                    $errorStatus ==
                        'RESOURCE_EXHAUSTED'
                ) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'The AI assistant has reached its temporary usage limit. Please try again later.',
                    ], 429);
                }

                return response()->json([
                    'success' => false,
                    'message' =>
                        'AI service request failed.',
                    'error' => $error,
                ], 500);
            }

            $data = $response->json();

            $reply =
                $data['candidates'][0]
                     ['content']
                     ['parts'][0]
                     ['text']
                ?? null;

            if (
                $reply == null ||
                trim($reply) == ''
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'AI did not return a response.',
                ], 500);
            }

            $reply = trim($reply);

            // Save AI Message
            AiChatMessage::create([
                'user_id' => $request->user()->id,
                'role' => 'assistant',
                'message' => $reply,
            ]);

            return response()->json([
                'success' => true,
                'reply' => $reply,

                // Temporary For Testing
                'model' => $usedModel,
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Unable to contact AI service.',
                'error' =>
                    $e->getMessage(),
            ], 500);
        }
    }

    // Get History
    public function history(Request $request)
    {
        $messages = AiChatMessage::where(
            'user_id',
            $request->user()->id
        )
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'messages' => $messages,
        ]);
    }

    // Clear History
    public function clearHistory(Request $request)
    {
        AiChatMessage::where(
            'user_id',
            $request->user()->id
        )->delete();

        return response()->json([
            'success' => true,
            'message' =>
                'Chat history cleared successfully.',
        ]);
    }

    // Gemini Request
    private function sendGeminiRequest(
        string $model,
        string $apiKey,
        string $systemPrompt,
        array $contents
    ) {
        $url =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            . $model
            . ":generateContent?key="
            . $apiKey;

        return Http::acceptJson()
            ->connectTimeout(5)
            ->timeout(10)
            ->post(
                $url,
                [
                    'systemInstruction' => [
                        'parts' => [
                            [
                                'text' =>
                                    $systemPrompt,
                            ],
                        ],
                    ],

                    'contents' =>
                        $contents,

                    'generationConfig' => [
                        'maxOutputTokens' =>
                            1200,
                    ],
                ]
            );
    }

    // Fallback Check
    private function shouldUseFallback(
        $response
    ): bool {
        if ($response->status() == 503) {
            return true;
        }

        if ($response->status() == 429) {
            return true;
        }

        $error = $response->json();

        $errorStatus =
            $error['error']['status']
            ?? null;

        return in_array(
            $errorStatus,
            [
                'UNAVAILABLE',
                'RESOURCE_EXHAUSTED',
            ]
        );
    }
}