<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('renter_notifications', function (Blueprint $table) {
            $table->id();

            // Renter receiving the notification
            $table->foreignId('renter_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // Property related to this notification
            $table->foreignId('property_id')
                ->constrained('properties')
                ->cascadeOnDelete();

            // Example: favorite_status_changed
            $table->string('type');

            $table->string('title');

            $table->text('message');

            // Status before the change
            $table->string('old_status')->nullable();

            // Status after the change
            $table->string('new_status')->nullable();

            // Null = unread
            $table->timestamp('seen_at')->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('renter_notifications');
    }
};