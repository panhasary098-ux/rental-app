<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;

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
}
