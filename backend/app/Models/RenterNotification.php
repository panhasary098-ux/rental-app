<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RenterNotification extends Model
{
    use HasFactory;

    protected $fillable = [
        'renter_id',
        'property_id',
        'type',
        'title',
        'message',
        'old_status',
        'new_status',
        'seen_at',
    ];

    protected $casts = [
        'seen_at' => 'datetime',
    ];

    public function renter()
    {
        return $this->belongsTo(User::class, 'renter_id');
    }

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}