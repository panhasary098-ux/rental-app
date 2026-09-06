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
        Schema::create('properties', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_id')->constrained('users')->onDelete('cascade');
            $table->enum('property_type', ['house', 'room', 'apartment']);
            $table->double('size');
            $table->decimal('price', 10, 2);
            $table->text('description');
            $table->string('contact');
            $table->boolean('furnished')->default(false);
            $table->string('address')->nullable();
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();
            $table->integer('bedrooms')->nullable();
            $table->integer('bathrooms')->nullable();
            $table->integer('total_floor')->nullable();
            $table->enum('rental_status', ['available', 'rented'])->default('available');
            $table->date('available_form')->nullable();
            $table->enum('verification_status', ['pending', 'approve', 'rejected'])->default('pending');
            $table->enum('post_status', ['active', 'removed'])->default('active');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('properties');
    }
};
