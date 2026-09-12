<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Kreait\Firebase\Contract\Auth;

class UserController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'firebase_uid' =>
                'required|string|unique:users,firebase_uid',

            'name' =>
                'required|string',

            'email' =>
                'required|email|unique:users,email',

            'phone' =>
                'nullable|string',

            'role' =>
                'required|in:renter,house_owner',
        ]);

        $user = User::create([
            'firebase_uid' =>
                $request->firebase_uid,

            'name' =>
                $request->name,

            'email' =>
                $request->email,

            'phone' =>
                $request->phone,

            'role' =>
                $request->role,

            'status' =>
                'active',
        ]);

        return response()->json([
            'success' => true,

            'message' =>
                'User created successfully',

            'user' =>
                $user,
        ], 201);
    }

    public function getByFirebaseUid(
        $firebaseUid
    ) {
        $user = User::where(
            'firebase_uid',
            $firebaseUid
        )->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' =>
                    'User not found',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'user' => $user,
        ]);
    }

    public function me(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,

            'message' =>
                'Get authenticated user successfully',

            'user' =>
                $user,
        ], 200);
    }

    public function socialSync(
        Request $request,
        Auth $auth
    ) {
        $token =
            $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Authentication token is missing',
            ], 401);
        }

        try {
            $verifiedToken =
                $auth->verifyIdToken(
                    $token
                );

            $firebaseUid =
                $verifiedToken
                    ->claims()
                    ->get('sub');

            $user = User::where(
                'firebase_uid',
                $firebaseUid
            )->first();

            if ($user) {
                if (
                    $user->status ===
                    'suspended'
                ) {
                    return response()->json([
                        'success' =>
                            false,

                        'message' =>
                            'Your account has been suspended',
                    ], 403);
                }

                return response()->json([
                    'success' => true,

                    'exists' => true,

                    'user' =>
                        $user,
                ], 200);
            }

            return response()->json([
                'success' => true,

                'exists' => false,

                'message' =>
                    'Please select your account type',
            ], 200);
        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Invalid or expired authentication token',
            ], 401);
        }
    }

    public function createSocialUser(
        Request $request,
        Auth $auth
    ) {
        $request->validate([
            'role' =>
                'required|in:renter,house_owner',
        ]);

        $token =
            $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Authentication token is missing',
            ], 401);
        }

        try {
            $verifiedToken =
                $auth->verifyIdToken(
                    $token
                );

            $firebaseUid =
                $verifiedToken
                    ->claims()
                    ->get('sub');

            $firebaseUser =
                $auth->getUser(
                    $firebaseUid
                );

            $existingUser =
                User::where(
                    'firebase_uid',
                    $firebaseUid
                )->first();

            if ($existingUser) {
                return response()->json([
                    'success' => true,

                    'message' =>
                        'User already exists',

                    'user' =>
                        $existingUser,
                ], 200);
            }

            if (!$firebaseUser->email) {
                return response()->json([
                    'success' => false,

                    'message' =>
                        'Email is required',
                ], 422);
            }

            $existingEmail =
                User::where(
                    'email',
                    $firebaseUser->email
                )->first();

            if ($existingEmail) {
                return response()->json([
                    'success' => false,

                    'message' =>
                        'An account with this email already exists',
                ], 409);
            }

            $user = User::create([
                'firebase_uid' =>
                    $firebaseUid,

                'name' =>
                    $firebaseUser
                        ->displayName ??
                    'User',

                'email' =>
                    $firebaseUser->email,

                'phone' =>
                    $firebaseUser
                        ->phoneNumber,

                'role' =>
                    $request->role,

                'status' =>
                    'active',
            ]);

            return response()->json([
                'success' => true,

                'message' =>
                    'Account created successfully',

                'user' =>
                    $user,
            ], 201);
        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Invalid or expired authentication token',
            ], 401);
        }
    }

    public function updateProfileImage(
        Request $request
    ) {
        $request->validate([
            'profile_image' =>
                'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $user =
            $request->user();

        $path =
            $request
                ->file(
                    'profile_image'
                )
                ->store(
                    'profile_images',
                    'public'
                );

        $user->profile_image =
            $path;

        $user->save();

        return response()->json([
            'success' => true,

            'message' =>
                'Profile image updated successfully',

            'profile_image' =>
                asset(
                    'storage/' .
                    $path
                ),
        ], 200);
    }

    // Check owner National ID status
    public function nationalIdStatus(
        Request $request
    ) {
        $user =
            $request->user();

        if (
            !$user ||
            $user->role !==
                'house_owner'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Unauthorized',
            ], 403);
        }

        return response()->json([
            'success' => true,

            'has_national_id' =>
                !empty(
                    $user
                        ->national_id_path
                ),
        ], 200);
    }

    // Upload owner National ID
    public function uploadNationalId(
        Request $request
    ) {
        $user =
            $request->user();

        if (
            !$user ||
            $user->role !==
                'house_owner'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Unauthorized',
            ], 403);
        }

        $request->validate([
            'national_id' =>
                'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        $oldNationalIdPath =
            $user
                ->national_id_path;

        // Store National ID privately
        $newNationalIdPath =
            $request
                ->file(
                    'national_id'
                )
                ->store(
                    'national_ids'
                );

        $user->national_id_path =
            $newNationalIdPath;

        $user->save();

        if (
            $oldNationalIdPath &&
            $oldNationalIdPath !==
                $newNationalIdPath
        ) {
            Storage::delete(
                $oldNationalIdPath
            );
        }

        return response()->json([
            'success' => true,

            'message' =>
                'National ID uploaded successfully.',

            'has_national_id' =>
                true,
        ], 200);
    }

    // Admin view owner's private National ID
    public function viewNationalId(
        Request $request,
        User $user
    ) {
        $admin =
            $request->user();

        if (
            !$admin ||
            $admin->role !==
                'admin'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Only admin can view National ID',
            ], 403);
        }

        if (
            $user->role !==
            'house_owner'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'This user is not a house owner',
            ], 422);
        }

        if (
            empty(
                $user
                    ->national_id_path
            )
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'National ID has not been uploaded',
            ], 404);
        }

        if (
            !Storage::disk(
                'local'
            )->exists(
                $user
                    ->national_id_path
            )
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'National ID file not found',
            ], 404);
        }

        $filePath =
            Storage::disk(
                'local'
            )->path(
                $user
                    ->national_id_path
            );

        return response()->file(
            $filePath
        );
    }

    // Admin get renters and house owners
    public function adminUsers(
        Request $request
    ) {
        $admin =
            $request->user();

        if (
            !$admin ||
            $admin->role !==
                'admin'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Only admin can manage users',
            ], 403);
        }

        // Admin accounts are not included.
        $users =
            User::whereIn(
                'role',
                [
                    'renter',
                    'house_owner',
                ]
            )
                ->orderBy(
                    'created_at',
                    'desc'
                )
                ->get();

        // Count submitted properties
        // for each house owner.
        $ownerIds =
            $users
                ->where(
                    'role',
                    'house_owner'
                )
                ->pluck('id')
                ->values();

        $propertyCounts =
            collect();

        if ($ownerIds->isNotEmpty()) {
            $propertyCounts =
                DB::table(
                    'properties'
                )
                    ->select(
                        'owner_id',
                        DB::raw(
                            'COUNT(*) as total'
                        )
                    )
                    ->whereIn(
                        'owner_id',
                        $ownerIds
                    )
                    ->groupBy(
                        'owner_id'
                    )
                    ->pluck(
                        'total',
                        'owner_id'
                    );
        }

        $formattedUsers =
            $users->map(
                function ($user) use (
                    $propertyCounts
                ) {
                    $profileImageUrl =
                        null;

                    if (
                        $user
                            ->profile_image
                    ) {
                        $profileImageUrl =
                            asset(
                                'storage/' .
                                $user
                                    ->profile_image
                            );
                    }

                    return [
                        'id' =>
                            $user->id,

                        'name' =>
                            $user->name,

                        'email' =>
                            $user->email,

                        'phone' =>
                            $user->phone,

                        'role' =>
                            $user->role,

                        'status' =>
                            $user->status,

                        'properties' =>
                            $user->role ===
                            'house_owner'
                                ? (int) (
                                    $propertyCounts[
                                        $user->id
                                    ] ??
                                    0
                                )
                                : 0,

                        'profile_image' =>
                            $profileImageUrl,

                        'created_at' =>
                            $user->created_at
                                ? $user
                                    ->created_at
                                    ->format(
                                        'd M Y'
                                    )
                                : null,
                    ];
                }
            );

        return response()->json([
            'success' => true,

            'count' =>
                $formattedUsers->count(),

            'users' =>
                $formattedUsers,
        ], 200);
    }

    // Admin suspend or restore account
    public function updateUserStatus(
        Request $request,
        User $user
    ) {
        $admin =
            $request->user();

        if (
            !$admin ||
            $admin->role !==
                'admin'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Only admin can update user status',
            ], 403);
        }

        // Admin accounts cannot be
        // suspended from this screen.
        if (
            $user->role ===
            'admin'
        ) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Admin accounts cannot be suspended',
            ], 422);
        }

        $validated =
            $request->validate([
                'status' =>
                    'required|in:active,suspended',
            ]);

        $user->status =
            $validated['status'];

        $user->save();

        return response()->json([
            'success' => true,

            'message' =>
                $user->status ===
                'suspended'
                    ? 'User account suspended successfully.'
                    : 'User account restored successfully.',

            'user' => [
                'id' =>
                    $user->id,

                'status' =>
                    $user->status,
            ],
        ], 200);
    }
}