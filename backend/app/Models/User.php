<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'firebase_uid',
        'name',
        'email',
        'phone',
        'password',
        'role',
        'status',
        'profile_image',
        'national_id_path',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    // Properties
    public function properties()
    {
        return $this->hasMany(
            Property::class,
            'owner_id'
        );
    }

    // Favorites
    public function favorites()
    {
        return $this->hasMany(
            Favorite::class
        );
    }

    // Verification Reviews
    public function verificationReviews()
    {
        return $this->hasMany(
            VerificationReview::class,
            'admin_id'
        );
    }
}