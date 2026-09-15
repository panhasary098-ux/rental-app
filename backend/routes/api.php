<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PropertyController;
use App\Http\Controllers\Api\AdminPropertyController;
use App\Http\Controllers\Api\AiChatController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\AuthController;

// Register
Route::post(
    '/register',
    [AuthController::class, 'register']
);

// Login
Route::post(
    '/login',
    [AuthController::class, 'login']
);

// Social Login Sync
Route::middleware('firebase.auth')->post(
    '/auth/social-sync',
    [UserController::class, 'socialSync']
);

// Social Registration
Route::middleware('firebase.auth')->post(
    '/auth/social-register',
    [UserController::class, 'createSocialUser']
);

// Old Firebase User Create
Route::post(
    '/users',
    [UserController::class, 'store']
);

// Get User By Firebase UID
Route::get(
    '/users/firebase/{firebaseUid}',
    [UserController::class, 'getByFirebaseUid']
);

// Protected
Route::middleware('auth:sanctum')->group(function () {

    // Current User
    Route::get(
        '/me',
        [AuthController::class, 'me']
    );

    // Update User
    Route::put(
        '/me',
        [UserController::class, 'updateMe']
    );


    // AI Rental Assistant
    Route::post(
        '/ai/chat',
        [AiChatController::class, 'chat']
    );

    // AI Chat
    Route::post(
        '/ai/chat',
        [AiChatController::class, 'chat']
    );

    // AI Chat History
    Route::get(
        '/ai/chat/history',
        [AiChatController::class, 'history']
    );

    // Clear AI Chat
    Route::delete(
        '/ai/chat/history',
        [AiChatController::class, 'clearHistory']
    );

    // Logout
    Route::post(
        '/logout',
        [AuthController::class, 'logout']
    );

    // Profile Image
    Route::post(
        '/profile-image',
        [UserController::class, 'updateProfileImage']
    );

    // Submit Property
    Route::post(
        '/properties',
        [PropertyController::class, 'store']
    );

    // Owner Properties
    Route::get(
        '/owner/properties',
        [PropertyController::class, 'myProperties']
    );

    // Renter Properties
    Route::get(
        '/renter/properties',
        [PropertyController::class, 'renterProperties']
    );

    // Get Favorites
    Route::get(
        '/renter/favorites',
        [FavoriteController::class, 'index']
    );

    // Add Favorite
    Route::post(
        '/renter/favorites/{property}',
        [FavoriteController::class, 'store']
    );

    // Remove Favorite
    Route::delete(
        '/renter/favorites/{property}',
        [FavoriteController::class, 'destroy']
    );

    // Update Rental Status
    Route::patch(
        '/properties/{property}/rental-status',
        [PropertyController::class, 'updateRentalStatus']
    );

    // Update Property
    Route::put(
        '/properties/{property}',
        [PropertyController::class, 'updateProperty']
    );

    // National ID Status
    Route::get(
        '/owner/national-id/status',
        [UserController::class, 'nationalIdStatus']
    );

    // Upload National ID
    Route::post(
        '/owner/national-id',
        [UserController::class, 'uploadNationalId']
    );

    // Admin View National ID
    Route::get(
        '/admin/users/{user}/national-id',
        [UserController::class, 'viewNationalId']
    );

    // Pending Properties
    Route::get(
        '/admin/properties/pending',
        [AdminPropertyController::class, 'pendingProperties']
    );

    // Managed Properties
    Route::get(
        '/admin/properties',
        [AdminPropertyController::class, 'managedProperties']
    );

    // Update Post Status
    Route::patch(
        '/admin/properties/{property}/post-status',
        [AdminPropertyController::class, 'updatePostStatus']
    );

    // Approve Property
    Route::post(
        '/admin/properties/{property}/approve',
        [AdminPropertyController::class, 'approveProperty']
    );

    // Reject Property
    Route::post(
        '/admin/properties/{property}/reject',
        [AdminPropertyController::class, 'rejectProperty']
    );

    // Admin Users
    Route::get(
        '/admin/users',
        [UserController::class, 'adminUsers']
    );

    // Update User Status
    Route::patch(
        '/admin/users/{user}/status',
        [UserController::class, 'updateUserStatus']
    );

    // Dashboard
    Route::get(
        '/admin/dashboard',
        [AdminPropertyController::class, 'dashboardSummary']
    );

    // Ownership Document
    Route::get(
        '/admin/properties/{property}/ownership-document',
        [AdminPropertyController::class, 'viewOwnershipDocument']
    );

    // Payment Proof
    Route::get(
        '/admin/properties/{property}/payment-proof',
        [AdminPropertyController::class, 'viewPaymentProof']
    );
});
