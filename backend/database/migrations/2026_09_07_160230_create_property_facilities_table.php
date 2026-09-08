<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('property_facilities', function (Blueprint $table) {
            $table->id();

            $table->foreignId('property_id')
                ->unique()
                ->constrained('properties')
                ->cascadeOnDelete();

            $table->boolean('wifi')->default(false);
            $table->boolean('parking')->default(false);
            $table->boolean('air_conditioning')->default(false);
            $table->boolean('pet_allowed')->default(false);
            $table->boolean('balcony')->default(false);
            $table->boolean('kitchen')->default(false);
            $table->boolean('swimming_pool')->default(false);
            $table->boolean('elevator')->default(false);

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('property_facilities');
    }
};