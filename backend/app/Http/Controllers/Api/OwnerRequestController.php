<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\OwnerRequest;
use Illuminate\Http\Request;

class OwnerRequestController extends Controller
{
    // Owner - create a support request
    public function store(Request $request)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' => 'Only house owners can send requests.',
            ], 403);
        }

        $validated = $request->validate([
            'subject' => ['required', 'string', 'max:255'],
            'message' => ['required', 'string', 'max:2000'],
        ]);

        $ownerRequest = OwnerRequest::create([
            'owner_id' => $user->id,
            'subject' => $validated['subject'],
            'message' => $validated['message'],
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Request sent successfully.',
            'request' => $ownerRequest,
        ], 201);
    }

    // Owner - view all of their requests
    public function index(Request $request)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' => 'Only house owners can view owner requests.',
            ], 403);
        }

        $requests = OwnerRequest::where('owner_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'requests' => $requests,
        ]);
    }

    // Admin - view owner requests
    public function adminIndex(Request $request)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Only admins can view owner requests.',
            ], 403);
        }

        $requests = OwnerRequest::with('owner:id,name,email,phone')
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'requests' => $requests,
        ]);
    }

    // Admin - reply to an owner request
    public function reply(Request $request, $id)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Only admins can reply to owner requests.',
            ], 403);
        }

        $validated = $request->validate([
            'admin_reply' => ['required', 'string', 'max:2000'],
        ]);

        $ownerRequest = OwnerRequest::find($id);

        if (!$ownerRequest) {
            return response()->json([
                'success' => false,
                'message' => 'Owner request not found.',
            ], 404);
        }

        $ownerRequest->admin_reply = $validated['admin_reply'];
        $ownerRequest->status = 'resolved';
        $ownerRequest->admin_id = $user->id;
        $ownerRequest->replied_at = now();

        // A new/revised admin reply must appear as a new notification
        // for the owner until the owner opens the notification screen.
        $ownerRequest->owner_seen_at = null;

        $ownerRequest->save();

        return response()->json([
            'success' => true,
            'message' => 'Reply sent successfully.',
            'request' => $ownerRequest,
        ]);
    }

    // Owner - mark replied requests as seen after leaving Notifications
    public function markSeen(Request $request)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' => 'Only house owners can update request notifications.',
            ], 403);
        }

        $updated = OwnerRequest::where('owner_id', $user->id)
            ->whereNotNull('admin_reply')
            ->whereNotNull('replied_at')
            ->whereNull('owner_seen_at')
            ->update([
                'owner_seen_at' => now(),
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Request notifications marked as seen.',
            'updated' => $updated,
        ]);
    }
}
