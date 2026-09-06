<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use Illuminate\Http\Request;

Route::post('/users', [
    UserController::class,
    'store'
]);

Route::get('/users/firebase/{firebaseUid}', [
    UserController::class,
    'getByFirebaseUid'
]);

Route::middleware('firebase.auth')->get('me', [UserController::class, 'me']);

Route::post('/auth/social-sync', [UserController::class, 'socialSync']);

Route::post('/auth/social-register', [UserController::class, 'createSocialUser']);
