<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PropertyController;
use App\Http\Controllers\Api\AdminPropertyController;
use App\Http\Controllers\Api\AiChatController;
use App\Http\Controllers\Api\FavoriteController;
use App\Http\Controllers\Api\BakongPaymentController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\OwnerRequestController;

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

// Google Login
Route::post(
    '/auth/google',
    [AuthController::class, 'googleLogin']
);

// Google Registration
Route::post(
    '/auth/google/register',
    [AuthController::class, 'googleRegister']
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

    // Public Owner Profile
    Route::get(
        '/owners/{owner}',
        [UserController::class, 'publicOwnerProfile']
    );

    // Public Owner Properties
    Route::get(
        '/owners/{owner}/properties',
        [UserController::class, 'publicOwnerProperties']
    );

    // AI Rental Assistant
    Route::post(
        '/ai/chat',
        [AiChatController::class, 'chat']
    );

    // Create AI Conversation
    Route::post(
        '/ai/conversations',
        [AiChatController::class, 'createConversation']
    );

    // Get AI Conversations
    Route::get(
        '/ai/conversations',
        [AiChatController::class, 'conversations']
    );

    // Get AI Conversation
    Route::get(
        '/ai/conversations/{conversation}',
        [AiChatController::class, 'conversation']
    );

    // Clear AI Conversation
    Route::delete(
        '/ai/conversations/{conversation}',
        [AiChatController::class, 'clearConversation']
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

    // Owner Notifications
    Route::get(
        '/owner/notifications',
        [
            PropertyController::class,
            'ownerNotifications'
        ]
    );

    // Mark Owner Notifications As Seen
    Route::post(
        '/owner/notifications/mark-seen',
        [
            PropertyController::class,
            'markOwnerNotificationsSeen'
        ]
    );

    // Generate Bakong QR
    Route::post(
        '/payments/{payment}/generate-qr',
        [
            BakongPaymentController::class,
            'generateQr'
        ]
    );

    // Check Bakong Payment
    Route::post(
        '/payments/{payment}/check',
        [
            BakongPaymentController::class,
            'checkPayment'
        ]
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

    Route::post(
        '/owner/requests',
        [OwnerRequestController::class, 'store']
    );

    Route::get(
        '/owner/requests',
        [OwnerRequestController::class, 'index']
    );

    Route::get(
        '/admin/owner-requests',
        [OwnerRequestController::class, 'adminIndex']
    );

    Route::post(
        '/admin/owner-requests/{id}/reply',
        [OwnerRequestController::class, 'reply']
    );

    Route::post(
        '/owner/requests',
        [OwnerRequestController::class, 'store']
    );

    Route::get(
        '/owner/requests',
        [OwnerRequestController::class, 'index']
    );

    Route::post(
        '/owner/requests/mark-seen',
        [OwnerRequestController::class, 'markSeen']
    );

    Route::get(
        '/admin/owner-requests',
        [OwnerRequestController::class, 'adminIndex']
    );

    Route::post(
        '/admin/owner-requests/{id}/reply',
        [OwnerRequestController::class, 'reply']
    );
});