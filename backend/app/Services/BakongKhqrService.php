<?php

namespace App\Services;

class BakongKhqrService
{
    // Generate KHQR
    public function generate(
        string $accountId,
        string $merchantName,
        string $merchantCity,
        string $currency,
        float $amount,
        int $paymentId
    ): array {
        $currency =
            strtoupper($currency);

        // Currency
        $currencyCode =
            $currency === 'KHR'
                ? '116'
                : '840';

        // Amount
        $amountText =
            $this->formatAmount(
                $amount
            );

        // Timestamp
        $timestamp =
            (string) round(
                microtime(true) * 1000
            );

        // 5 minutes
        $expirationTimestamp =
            (string) (
                ((int) $timestamp) +
                (5 * 60 * 1000)
            );

        // Merchant Account Information
        $merchantAccount =
            $this->tlv(
                '00',
                $accountId
            );

        // Additional Data
        $additionalData =
            $this->tlv(
                '01',
                'JNL-' . $paymentId
            ) .
            $this->tlv(
                '03',
                'JoulNow'
            ) .
            $this->tlv(
                '07',
                'JoulNow App'
            );

        // Timestamp Information
        $timestampData =
            $this->tlv(
                '00',
                $timestamp
            ) .
            $this->tlv(
                '01',
                $expirationTimestamp
            );

        // KHQR
        $qr =
            $this->tlv(
                '00',
                '01'
            ) .
            $this->tlv(
                '01',
                '12'
            ) .
            $this->tlv(
                '29',
                $merchantAccount
            ) .
            $this->tlv(
                '52',
                '5999'
            ) .
            $this->tlv(
                '53',
                $currencyCode
            ) .
            $this->tlv(
                '54',
                $amountText
            ) .
            $this->tlv(
                '58',
                'KH'
            ) .
            $this->tlv(
                '59',
                $merchantName
            ) .
            $this->tlv(
                '60',
                $merchantCity
            ) .
            $this->tlv(
                '62',
                $additionalData
            ) .
            $this->tlv(
                '99',
                $timestampData
            );

        // CRC
        $qrForCrc =
            $qr . '6304';

        $crc =
            $this->crc16(
                $qrForCrc
            );

        $qr =
            $qrForCrc .
            $crc;

        // MD5
        $md5 =
            md5($qr);

        return [
            'success' => true,
            'qr' => $qr,
            'md5' => $md5,
            'amount' => $amount,
            'currency' => $currency,
            'expiresAt' =>
                (int) $expirationTimestamp,
        ];
    }

    // TLV
    private function tlv(
        string $tag,
        string $value
    ): string {
        $length =
            strlen($value);

        if ($length > 99) {
            throw new \InvalidArgumentException(
                'KHQR field is too long.'
            );
        }

        return
            $tag .
            str_pad(
                (string) $length,
                2,
                '0',
                STR_PAD_LEFT
            ) .
            $value;
    }

    // Amount
    private function formatAmount(
        float $amount
    ): string {
        $formatted =
            number_format(
                $amount,
                2,
                '.',
                ''
            );

        return
            rtrim(
                rtrim(
                    $formatted,
                    '0'
                ),
                '.'
            );
    }

    // CRC
    private function crc16(
        string $value
    ): string {
        $crc =
            0xFFFF;

        $length =
            strlen($value);

        for (
            $i = 0;
            $i < $length;
            $i++
        ) {
            $crc ^=
                ord($value[$i])
                << 8;

            for (
                $j = 0;
                $j < 8;
                $j++
            ) {
                if (
                    ($crc & 0x8000)
                    !== 0
                ) {
                    $crc =
                        (($crc << 1) ^
                        0x1021)
                        & 0xFFFF;
                } else {
                    $crc =
                        ($crc << 1)
                        & 0xFFFF;
                }
            }
        }

        return strtoupper(
            str_pad(
                dechex($crc),
                4,
                '0',
                STR_PAD_LEFT
            )
        );
    }
}