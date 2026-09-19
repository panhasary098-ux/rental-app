<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AiChatConversation extends Model
{
    protected $fillable = [
        'user_id',
        'title',
    ];

    // User
    public function user()
    {
        return $this->belongsTo(
            User::class
        );
    }

    // Messages
    public function messages()
    {
        return $this->hasMany(
            AiChatMessage::class,
            'conversation_id'
        );
    }
}