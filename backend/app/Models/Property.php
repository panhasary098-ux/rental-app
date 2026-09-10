<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Property extends Model
{
    protected $fillable = [
        'owner_id',
        'name',
        'property_type',
        'size',
        'price',
        'description',
        'contact',
        'furnished',
        'address',
        'latitude',
        'longitude',
        'bedrooms',
        'bathrooms',
        'total_floor',
        'rental_status',
        'verification_status',
        'post_status',
    ];

    protected $casts = [
        'size' => 'float',
        'price' => 'float',
        'furnished' => 'boolean',
        'latitude' => 'float',
        'longitude' => 'float',
        'bedrooms' => 'integer',
        'bathrooms' => 'integer',
        'total_floor' => 'integer',
    ];

    // Property belongs to one owner
    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    // Property has many images
    public function images()
    {
        return $this->hasMany(PropertyImage::class);
    }

    // Property has one ownership document
    public function document()
    {
        return $this->hasOne(PropertyDocument::class);
    }

    // Property has one facilities record
    public function facilities()
    {
        return $this->hasOne(PropertyFacility::class);
    }

    // Property can have many available floors
    public function availableFloors()
    {
        return $this->hasMany(PropertyAvailableFloor::class);
    }

    // Property has one payment
    public function payment()
    {
        return $this->hasOne(Payment::class);
    }

    // Property can be favorited by many users
    public function favorites()
    {
        return $this->hasMany(Favorite::class);
    }

    // Property can have many admin verification reviews
    public function verificationReviews()
    {
        return $this->hasMany(VerificationReview::class);
    }
}