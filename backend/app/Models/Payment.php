<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'property_id',
        'amount',
        'transaction_reference',
        'payment_proof_path',
        'payment_status',
        'paid_at',
        'bakong_qr',
        'bakong_md5',
    ];

    protected $casts = [
        'amount' => 'float',
        'paid_at' => 'datetime',
    ];

    // Property
    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}