<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Remove the old enum/check constraint
        DB::statement("
            ALTER TABLE properties
            DROP CONSTRAINT IF EXISTS properties_post_status_check
        ");

        // Allow the new values
        DB::statement("
            ALTER TABLE properties
            ADD CONSTRAINT properties_post_status_check
            CHECK (post_status IN ('unpublished', 'active', 'removed'))
        ");

        // Change the default value
        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN post_status SET DEFAULT 'unpublished'
        ");
    }

    public function down(): void
    {
        DB::statement("
            ALTER TABLE properties
            DROP CONSTRAINT IF EXISTS properties_post_status_check
        ");

        DB::statement("
            ALTER TABLE properties
            ADD CONSTRAINT properties_post_status_check
            CHECK (post_status IN ('active', 'removed'))
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN post_status SET DEFAULT 'active'
        ");
    }
};