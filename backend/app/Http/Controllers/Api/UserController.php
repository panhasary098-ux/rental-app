<?php 
 
namespace App\Http\Controllers\Api; 
 
use App\Http\Controllers\Controller; 
use App\Models\User; 
use Illuminate\Http\Request; 
use Kreait\Firebase\Contract\Auth;
 
class UserController extends Controller 
{ 
    public function store(Request $request){ 
        $request->validate([ 
            'firebase_uid' => 'required|string|unique:users,firebase_uid', 
            'name' =>'required|string', 
            'email' => 'required|email|unique:users,email', 
            'phone' => 'nullable|string', 
            'role' => 'required|in:renter,house_owner', 
        ]); 
 
        $user = User::create([ 
            'firebase_uid' => $request->firebase_uid, 
            'name' => $request->name, 
            'email' => $request->email, 
            'phone' => $request->phone, 
            'role' => $request->role, 
            'status' => 'active', 
        ]); 
 
        return response()->json([ 
            'success' =>true, 
            'message' =>'User created successfully', 
            'user' =>$user, 
        ], 201); 
    } 

    public function getByFirebaseUid($firebaseUid) 
    { 
        $user = User::where('firebase_uid', $firebaseUid)->first(); 
 
        if (!$user) { 
            return response()->json([ 
                'success' => false, 
                'message' => 'User not found', 
            ], 404); 
        } 
 
        return response()->json([ 
            'success' => true, 
            'user' => $user, 
        ]); 
    } 
 
    public function me(Request $request){ 
        $user =$request->user(); 

        return response()->json([ 
            'success' =>true, 
            'message' =>"Get authenticated user successfully", 
            'user' =>$user, 
        ], 200); 
    } 


    public function socialSync(Request $request, Auth $auth)
    {
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication token is missing',
            ], 401);
        }

        try {
            $verifiedToken = $auth->verifyIdToken($token);

            $firebaseUid = $verifiedToken->claims()->get('sub');

            $user = User::where('firebase_uid', $firebaseUid)->first();

            if ($user) {
                if ($user->status === 'suspended') {
                    return response()->json([
                        'success' => false,
                        'message' => 'Your account has been suspended',
                    ], 403);
                }

                return response()->json([
                    'success' => true,
                    'exists' => true,
                    'user' => $user,
                ], 200);
            }

            return response()->json([
                'success' => true,
                'exists' => false,
                'message' => 'Please select your account type',
            ], 200);

        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired authentication token',
            ], 401);
        }
    }


    public function createSocialUser(Request $request, Auth $auth)
    {
        $request->validate([
            'role' => 'required|in:renter,house_owner',
        ]);

        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication token is missing',
            ], 401);
        }

        try {
            $verifiedToken = $auth->verifyIdToken($token);

            $firebaseUid = $verifiedToken->claims()->get('sub');

            $firebaseUser = $auth->getUser($firebaseUid);

            $existingUser = User::where(
                'firebase_uid',
                $firebaseUid
            )->first();

            if ($existingUser) {
                return response()->json([
                    'success' => true,
                    'message' => 'User already exists',
                    'user' => $existingUser,
                ], 200);
            }

            if (!$firebaseUser->email) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email is required',
                ], 422);
            }

            $existingEmail = User::where(
                'email',
                $firebaseUser->email
            )->first();

            if ($existingEmail) {
                return response()->json([
                    'success' => false,
                    'message' => 'An account with this email already exists',
                ], 409);
            }

            $user = User::create([
                'firebase_uid' => $firebaseUid,
                'name' => $firebaseUser->displayName ?? 'User',
                'email' => $firebaseUser->email,
                'phone' => $firebaseUser->phoneNumber,
                'role' => $request->role,
                'status' => 'active',
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Account created successfully',
                'user' => $user,
            ], 201);

        } catch (\Throwable $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired authentication token',
            ], 401);
        }
    }
}