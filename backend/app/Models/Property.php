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
        'furnshed',
        'adress',
        'latitude',
        'longitude',
        'bedrooms',
        'total_floor',
        'rental_status',
        'available_form',
        'verification_status',
        'post_status',
    ];

    protected $casts = [
        'size' => 'float',
        'price'=>  'float',
        'furnished' => 'boolean',
        'latitude' => 'float',
        'longitude' => 'float',
        'bedrooms' => 'integer',
        'bathrooms' => 'integer',
        'total_floor' =>'integer',
        'available_form' => 'date',
    ];

    public function owner(){
        return $this->belongsTo(User::class, 'owner_id');
    }
    public function images(){
        return $this->hasMany(PropertyImage::class);
    }
}
