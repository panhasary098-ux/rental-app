<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $fillable = [
        'firebase_uid',
        'name',
        'email',
        'phone',
        'role',
        'status',
        'profile_image',
        'national_id_path',
    ];

    public function properties()
    {
        return $this->hasMany(Property::class, 'owner_id');
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }

    public function verificationReviews()
    {
        return $this->hasMany(VerificationReview::class, 'admin_id');
    }
}