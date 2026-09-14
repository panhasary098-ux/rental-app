<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Firebase UID
        DB::statement("
            ALTER TABLE users
            ALTER COLUMN firebase_uid DROP NOT NULL
        ");
    }

    public function down(): void
    {
        // Firebase UID
        DB::statement("
            ALTER TABLE users
            ALTER COLUMN firebase_uid SET NOT NULL
        ");
    }
};