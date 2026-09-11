<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PropertyController;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\AdminPropertyController;

Route::post('/users', [
    UserController::class,
    'store'
]);

Route::get('/users/firebase/{firebaseUid}', [
    UserController::class,
    'getByFirebaseUid'
]);

Route::middleware('firebase.auth')->get(
    '/me',
    [UserController::class, 'me']
);

Route::post(
    '/auth/social-sync',
    [UserController::class, 'socialSync']
);

Route::post(
    '/auth/social-register',
    [UserController::class, 'createSocialUser']
);

Route::middleware('firebase.auth')->post(
    '/profile-image',
    [UserController::class, 'updateProfileImage']
);

Route::middleware('firebase.auth')->post(
    '/properties',
    [PropertyController::class, 'store']
);

Route::middleware('firebase.auth')->get(
    '/owner/properties',
    [PropertyController::class, 'myProperties']
);

Route::middleware('firebase.auth')->patch(
    '/properties/{property}/rental-status',
    [PropertyController::class, 'updateRentalStatus']
);

Route::middleware('firebase.auth')->put(
    '/properties/{property}',
    [PropertyController::class, 'updateProperty']
);


Route::middleware('firebase.auth')->get(
    '/owner/national-id/status',
    [UserController::class, 'nationalIdStatus']
);

Route::middleware('firebase.auth')->post(
    '/owner/national-id',
    [UserController::class, 'uploadNationalId']
);

Route::middleware('firebase.auth')->get(
    '/admin/users/{user}/national-id',
    [UserController::class, 'viewNationalId']
);

Route::middleware('firebase.auth')->get(
    '/admin/properties/pending',
    [AdminPropertyController::class, 'pendingProperties']
);

Route::middleware('firebase.auth')->post(
    '/admin/properties/{property}/approve',
    [AdminPropertyController::class, 'approveProperty']
);

Route::middleware('firebase.auth')->post(
    '/admin/properties/{property}/reject',
    [AdminPropertyController::class, 'rejectProperty']
);
