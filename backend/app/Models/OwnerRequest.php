<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OwnerRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'owner_id',
        'subject',
        'message',
        'status',
        'admin_reply',
        'admin_id',
        'replied_at',
        'owner_seen_at',
    ];

    protected $casts = [
        'replied_at' => 'datetime',
        'owner_seen_at' => 'datetime',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }
}
