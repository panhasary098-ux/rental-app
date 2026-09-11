<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminPropertyController extends Controller
{
    // Get all properties waiting for admin verification
    public function pendingProperties(Request $request)
    {
        $admin = $request->user();

        // Only admin can access this endpoint
        if (!$admin || $admin->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can access pending properties',
            ], 403);
        }

        // Get all pending properties
        $properties = Property::with([
            'images',
        ])
            ->where('verification_status', 'pending')
            ->orderBy('created_at', 'desc')
            ->get();

        // Get all property owners
        $ownerIds = $properties
            ->pluck('owner_id')
            ->unique()
            ->values();

        $owners = User::whereIn('id', $ownerIds)
            ->get()
            ->keyBy('id');

        // Format data for Flutter
        $formattedProperties = $properties->map(
            function ($property) use ($owners) {
                $owner = $owners->get(
                    $property->owner_id
                );

                // Try to get cover image
                $coverImage = $property->images
                    ->firstWhere(
                        'is_cover',
                        true
                    );

                // If no cover image exists,
                // use the first property image
                if (!$coverImage) {
                    $coverImage = $property->images
                        ->sortBy('sort_order')
                        ->first();
                }

                $imageUrl = null;

                if (
                    $coverImage &&
                    $coverImage->image_path
                ) {
                    $imageUrl = asset(
                        'storage/' .
                        $coverImage->image_path
                    );
                }

                return [
                    'id' =>
                        $property->id,

                    'owner_id' =>
                        $property->owner_id,

                    'title' =>
                        $property->name,

                    'property_type' =>
                        $property->property_type,

                    'owner' =>
                        $owner?->name ??
                        'Unknown Owner',

                    'email' =>
                        $owner?->email,

                    'phone' =>
                        $owner?->phone,

                    'location' =>
                        $property->address,

                    'submitted' =>
                        $property->created_at
                            ? $property->created_at
                                ->format(
                                    'd M Y'
                                )
                            : null,

                    'price' =>
                        '$' .
                        number_format(
                            (float)
                            $property->price,
                            2
                        ) .
                        ' / month',

                    'raw_price' =>
                        $property->price,

                    'description' =>
                        $property->description,

                    'image' =>
                        $imageUrl,

                    'verification_status' =>
                        $property
                            ->verification_status,

                    'post_status' =>
                        $property
                            ->post_status,

                    'rental_status' =>
                        $property
                            ->rental_status,
                ];
            }
        );

        return response()->json([
            'success' => true,

            'count' =>
                $formattedProperties->count(),

            'properties' =>
                $formattedProperties,
        ], 200);
    }

    // Approve property submission
    public function approveProperty(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        // Only admin can approve properties
        if (!$admin || $admin->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only admin can approve properties',
            ], 403);
        }

        // Only pending properties can be approved
        if (
            $property->verification_status !==
            'pending'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'This property is no longer pending verification',
            ], 422);
        }

        DB::transaction(function () use (
            $property,
            $admin
        ) {
            // Approve the property
            $property->verification_status =
                'approved';

            // Publish the property
            $property->post_status =
                'active';

            $property->save();

            // Mark the payment as paid
            DB::table('payments')
                ->where(
                    'property_id',
                    $property->id
                )
                ->update([
                    'payment_status' =>
                        'paid',

                    'paid_at' =>
                        now(),

                    'updated_at' =>
                        now(),
                ]);

            // Save admin review history
            DB::table(
                'verification_reviews'
            )->insert([
                'property_id' =>
                    $property->id,

                'admin_id' =>
                    $admin->id,

                'action' =>
                    'approved',

                'reason' =>
                    null,

                'note' =>
                    null,

                'created_at' =>
                    now(),

                'updated_at' =>
                    now(),
            ]);
        });

        return response()->json([
            'success' => true,

            'message' =>
                'Property approved successfully.',
        ], 200);
    }

    // Reject property submission
    public function rejectProperty(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        // Only admin can reject properties
        if (!$admin || $admin->role !== 'admin') {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only admin can reject properties',
            ], 403);
        }

        // Only pending properties can be rejected
        if (
            $property->verification_status !==
            'pending'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'This property is no longer pending verification',
            ], 422);
        }

        // Rejection reason is required
        $validated = $request->validate([
            'reason' =>
                'required|string|max:1000',

            'note' =>
                'nullable|string|max:1000',
        ]);

        DB::transaction(function () use (
            $property,
            $admin,
            $validated
        ) {
            // Reject the property
            $property->verification_status =
                'rejected';

            // Keep the property unpublished
            $property->post_status =
                'unpublished';

            $property->save();

            // Do NOT change payment status here.
            //
            // The owner can edit the rejected property
            // and resubmit it without paying again.
            //
            // Payment remains pending until the property
            // is finally approved.

            // Save admin review history
            DB::table(
                'verification_reviews'
            )->insert([
                'property_id' =>
                    $property->id,

                'admin_id' =>
                    $admin->id,

                'action' =>
                    'rejected',

                'reason' =>
                    $validated['reason'],

                'note' =>
                    $validated['note'] ??
                    null,

                'created_at' =>
                    now(),

                'updated_at' =>
                    now(),
            ]);
        });

        return response()->json([
            'success' => true,

            'message' =>
                'Property rejected successfully.',
        ], 200);
    }
}