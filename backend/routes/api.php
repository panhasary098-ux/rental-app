<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PropertyController;
use App\Http\Controllers\Api\AdminPropertyController;
use App\Http\Controllers\Api\FavoriteController;

// Create user
Route::post(
    '/users',
    [UserController::class, 'store']
);

// Get user by Firebase UID
Route::get(
    '/users/firebase/{firebaseUid}',
    [UserController::class, 'getByFirebaseUid']
);

// Get current logged-in user
Route::middleware('firebase.auth')->get(
    '/me',
    [UserController::class, 'me']
);

// Social login sync
Route::post(
    '/auth/social-sync',
    [UserController::class, 'socialSync']
);

// Social registration
Route::post(
    '/auth/social-register',
    [UserController::class, 'createSocialUser']
);

// Update profile image
Route::middleware('firebase.auth')->post(
    '/profile-image',
    [UserController::class, 'updateProfileImage']
);

// Submit property
Route::middleware('firebase.auth')->post(
    '/properties',
    [PropertyController::class, 'store']
);

// Get logged-in owner's properties
Route::middleware('firebase.auth')->get(
    '/owner/properties',
    [PropertyController::class, 'myProperties']
);

// Get properties visible to renters
Route::middleware('firebase.auth')->get(
    '/renter/properties',
    [PropertyController::class, 'renterProperties']
);

// Get renter favorites
Route::middleware('firebase.auth')->get(
    '/renter/favorites',
    [FavoriteController::class, 'index']
);

// Add property to favorites
Route::middleware('firebase.auth')->post(
    '/renter/favorites/{property}',
    [FavoriteController::class, 'store']
);

// Remove property from favorites
Route::middleware('firebase.auth')->delete(
    '/renter/favorites/{property}',
    [FavoriteController::class, 'destroy']
);

// Update property rental status
Route::middleware('firebase.auth')->patch(
    '/properties/{property}/rental-status',
    [PropertyController::class, 'updateRentalStatus']
);

// Update property
Route::middleware('firebase.auth')->put(
    '/properties/{property}',
    [PropertyController::class, 'updateProperty']
);

// Check owner National ID status
Route::middleware('firebase.auth')->get(
    '/owner/national-id/status',
    [UserController::class, 'nationalIdStatus']
);

// Upload owner National ID
Route::middleware('firebase.auth')->post(
    '/owner/national-id',
    [UserController::class, 'uploadNationalId']
);

// Admin view owner National ID
Route::middleware('firebase.auth')->get(
    '/admin/users/{user}/national-id',
    [UserController::class, 'viewNationalId']
);

// Get pending properties for admin
Route::middleware('firebase.auth')->get(
    '/admin/properties/pending',
    [AdminPropertyController::class, 'pendingProperties']
);

// Get approved properties for admin management
Route::middleware('firebase.auth')->get(
    '/admin/properties',
    [AdminPropertyController::class, 'managedProperties']
);

// Update approved property post status
Route::middleware('firebase.auth')->patch(
    '/admin/properties/{property}/post-status',
    [AdminPropertyController::class, 'updatePostStatus']
);

// Approve property
Route::middleware('firebase.auth')->post(
    '/admin/properties/{property}/approve',
    [AdminPropertyController::class, 'approveProperty']
);

// Reject property
Route::middleware('firebase.auth')->post(
    '/admin/properties/{property}/reject',
    [AdminPropertyController::class, 'rejectProperty']
);

// Get renters and house owners for admin
Route::middleware('firebase.auth')->get(
    '/admin/users',
    [UserController::class, 'adminUsers']
);

// Suspend or restore a user account
Route::middleware('firebase.auth')->patch(
    '/admin/users/{user}/status',
    [UserController::class, 'updateUserStatus']
);

// Get admin dashboard summary
Route::middleware('firebase.auth')->get(
    '/admin/dashboard',
    [AdminPropertyController::class, 'dashboardSummary']
);

// Admin view private ownership document
Route::middleware('firebase.auth')->get(
    '/admin/properties/{property}/ownership-document',
    [AdminPropertyController::class, 'viewOwnershipDocument']
);

// Admin view private payment proof
Route::middleware('firebase.auth')->get(
    '/admin/properties/{property}/payment-proof',
    [AdminPropertyController::class, 'viewPaymentProof']
);