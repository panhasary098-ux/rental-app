<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    // Register
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'nullable|string|max:30',
            'password' => 'required|string|min:6|confirmed',
            'role' => 'required|in:renter,house_owner',
        ]);

        // Create User
        $user = User::create([
            'firebase_uid' => null,
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make(
                $request->password
            ),
            'role' => $request->role,
            'status' => 'active',
        ]);

        // Token
        $token = $user->createToken(
            'flutter_app'
        )->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Registration successful',
            'token' => $token,
            'user' => $user,
        ], 201);
    }

    // Login
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        // Find User
        $user = User::where(
            'email',
            $request->email
        )->first();

        // Check Password
        if (
            !$user ||
            !$user->password ||
            !Hash::check(
                $request->password,
                $user->password
            )
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid email or password',
            ], 401);
        }

        // Check Status
        if ($user->status === 'suspended') {
            return response()->json([
                'success' => false,
                'message' => 'Your account has been suspended',
            ], 403);
        }

        // Remove Old Tokens
        $user->tokens()->delete();

        // Token
        $token = $user->createToken(
            'flutter_app'
        )->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'token' => $token,
            'user' => $user,
        ], 200);
    }

    // Google Login
    public function googleLogin(Request $request)
    {
        $request->validate([
            'access_token' => 'required|string',
        ]);

        try {
            // Get Google User
            $googleUser = Socialite::driver(
                'google'
            )->userFromToken(
                $request->access_token
            );

            $email = $googleUser->getEmail();

            if (!$email) {
                return response()->json([
                    'success' => false,
                    'message' => 'Google account email was not found',
                ], 422);
            }

            // Find User
            $user = User::where(
                'email',
                $email
            )->first();

            // New Google User
            if (!$user) {
                return response()->json([
                    'success' => true,
                    'needs_registration' => true,
                    'message' => 'Please choose your account type',
                    'google_user' => [
                        'name' => $googleUser->getName(),
                        'email' => $email,
                        'avatar' => $googleUser->getAvatar(),
                    ],
                ], 200);
            }

            // Check Status
            if ($user->status === 'suspended') {
                return response()->json([
                    'success' => false,
                    'message' => 'Your account has been suspended',
                ], 403);
            }

            // Remove Old Tokens
            $user->tokens()->delete();

            // Token
            $token = $user->createToken(
                'flutter_app'
            )->plainTextToken;

            return response()->json([
                'success' => true,
                'needs_registration' => false,
                'message' => 'Google login successful',
                'token' => $token,
                'user' => $user,
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Unable to verify Google account',
            ], 401);
        }
    }

    // Google Register
    public function googleRegister(Request $request)
    {
        $request->validate([
            'access_token' => 'required|string',
            'role' => 'required|in:renter,house_owner',
        ]);

        try {
            // Get Google User
            $googleUser = Socialite::driver(
                'google'
            )->userFromToken(
                $request->access_token
            );

            $email = $googleUser->getEmail();

            if (!$email) {
                return response()->json([
                    'success' => false,
                    'message' => 'Google account email was not found',
                ], 422);
            }

            // Check Existing User
            $existingUser = User::where(
                'email',
                $email
            )->first();

            if ($existingUser) {
                return response()->json([
                    'success' => false,
                    'message' => 'An account with this email already exists',
                ], 409);
            }

            // Create User
            $user = User::create([
                'firebase_uid' => null,
                'name' => $googleUser->getName() ??
                    $email,
                'email' => $email,
                'phone' => null,
                'password' => null,
                'role' => $request->role,
                'status' => 'active',
            ]);

            // Token
            $token = $user->createToken(
                'flutter_app'
            )->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Google registration successful',
                'token' => $token,
                'user' => $user,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Unable to verify Google account',
            ], 401);
        }
    }

    // Current User
    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'user' => $request->user(),
        ], 200);
    }

    // Logout
    public function logout(Request $request)
    {
        $request->user()
            ->currentAccessToken()
            ->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
        ], 200);
    }
}