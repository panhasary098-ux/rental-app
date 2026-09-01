<?php

namespace App\Http\Middleware;

use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Kreait\Firebase\Contract\Auth;
use Symfony\Component\HttpFoundation\Response;

class FirebaseAuthMiddleware
{
    protected Auth $auth;

    public function __construct(Auth $auth)
    {
        $this->auth = $auth;
    }

    public function handle(Request $request, Closure $next): Response
    {
        // 1. Get Firebase token from:
        // Authorization: Bearer TOKEN
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication token is missing',
            ], 401);
        }

        try {
            // 2. AUTHENTICATION
            // Ask Firebase to verify that this token is genuine
            $verifiedToken = $this->auth->verifyIdToken($token);

            // 3. Get Firebase UID from the VERIFIED token
            $firebaseUid = $verifiedToken->claims()->get('sub');  // sub = the authenticated user's Firebase UID

            // 4. Find our application user in PostgreSQL
            $user = User::where('firebase_uid', $firebaseUid)->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User does not exist in the application',
                ], 401);
            }

            // 5. AUTHORIZATION CHECK
            // Suspended users should not continue using protected APIs
            if ($user->status === 'suspended') {
                return response()->json([
                    'success' => false,
                    'message' => 'Your account has been suspended',
                ], 403);
            }

            // 6. Attach our PostgreSQL user to the request
            $request->attributes->set('auth_user', $user);
            $request->setUserResolver(function () use ($user) {
                return $user;
            });

            // 7. Allow request to continue to the next middleware/controller
            return $next($request);
        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired authentication token',
                'error' => $e->getMessage(),
            ], 401);
        }
    }
}
