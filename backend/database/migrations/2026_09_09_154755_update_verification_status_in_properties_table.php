<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            ALTER TABLE properties
            DROP CONSTRAINT IF EXISTS properties_verification_status_check
        ");

        DB::statement("
            ALTER TABLE properties
            ADD CONSTRAINT properties_verification_status_check
            CHECK (verification_status IN ('pending', 'approved', 'rejected'))
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN verification_status SET DEFAULT 'pending'
        ");
    }

    public function down(): void
    {
        DB::statement("
            ALTER TABLE properties
            DROP CONSTRAINT IF EXISTS properties_verification_status_check
        ");

        DB::statement("
            UPDATE properties
            SET verification_status = 'approve'
            WHERE verification_status = 'approved'
        ");

        DB::statement("
            ALTER TABLE properties
            ADD CONSTRAINT properties_verification_status_check
            CHECK (verification_status IN ('pending', 'approve', 'rejected'))
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN verification_status SET DEFAULT 'pending'
        ");
    }
};