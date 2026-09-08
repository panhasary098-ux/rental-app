<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN address SET NOT NULL
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN latitude SET NOT NULL
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN longitude SET NOT NULL
        ");

        Schema::table('properties', function (Blueprint $table) {
            $table->dropColumn('available_form');
        });
    }

    public function down(): void
    {
        Schema::table('properties', function (Blueprint $table) {
            $table->date('available_form')->nullable();
        });

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN address DROP NOT NULL
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN latitude DROP NOT NULL
        ");

        DB::statement("
            ALTER TABLE properties
            ALTER COLUMN longitude DROP NOT NULL
        ");
    }
};