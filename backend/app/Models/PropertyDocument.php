<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PropertyDocument extends Model
{
    protected $fillable = [
        'property_id',
        'ownership_document_path',
    ];

    public function property()
    {
        return $this->belongsTo(Property::class);
    }
}