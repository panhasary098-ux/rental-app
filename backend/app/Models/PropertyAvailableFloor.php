<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PropertyAvailableFloor extends Model
{
    protected $fillable = [
        'property_id',
        'floor_number',
    ];

    protected $casts = [
        'floor_number' => 'integer',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}