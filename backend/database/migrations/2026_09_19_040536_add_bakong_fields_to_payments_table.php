<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    // Add Bakong fields
    public function up(): void
    {
        Schema::table('payments', function (Blueprint $table) {
            $table->text('bakong_qr')
                ->nullable();

            $table->string('bakong_md5')
                ->nullable()
                ->unique();
        });
    }

    // Remove Bakong fields
    public function down(): void
    {
        Schema::table('payments', function (Blueprint $table) {
            $table->dropUnique([
                'bakong_md5'
            ]);

            $table->dropColumn([
                'bakong_qr',
                'bakong_md5',
            ]);
        });
    }
};