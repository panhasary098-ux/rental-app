<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('owner_requests', function (Blueprint $table) {
            $table->id();

            // Owner who sent the request
            $table->foreignId('owner_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // Request information
            $table->string('subject');
            $table->text('message');

            // pending / resolved
            $table->string('status')
                ->default('pending');

            // Admin response
            $table->text('admin_reply')
                ->nullable();

            $table->foreignId('admin_id')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->timestamp('replied_at')
                ->nullable();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('owner_requests');
    }
};