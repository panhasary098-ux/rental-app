<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PropertyFacility extends Model
{
    protected $fillable = [
        'property_id',
        'wifi',
        'parking',
        'air_conditioning',
        'pet_allowed',
        'balcony',
        'kitchen',
        'swimming_pool',
        'elevator',
    ];

    protected $casts = [
        'wifi' => 'boolean',
        'parking' => 'boolean',
        'air_conditioning' => 'boolean',
        'pet_allowed' => 'boolean',
        'balcony' => 'boolean',
        'kitchen' => 'boolean',
        'swimming_pool' => 'boolean',
        'elevator' => 'boolean',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}