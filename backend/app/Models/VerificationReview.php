<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VerificationReview extends Model
{
    protected $fillable = [
        'property_id',
        'admin_id',
        'action',
        'reason',
        'note',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }
}