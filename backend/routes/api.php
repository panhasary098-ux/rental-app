<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\PropertyController;
use Illuminate\Http\Request;

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

