<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class AdminPropertyController extends Controller
{
    // Get properties waiting for admin verification
    public function pendingProperties(Request $request)
    {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can view pending properties',
            ], 403);
        }

        $properties = Property::with([
            'images' => function ($query) {
                $query->orderBy('sort_order');
            },

            'facilities',

            'availableFloors' => function ($query) {
                $query->orderBy('floor_number');
            },
        ])
            ->where(
                'verification_status',
                'pending'
            )
            ->latest()
            ->get();

        $ownerIds = $properties
            ->pluck('owner_id')
            ->unique()
            ->values();

        $owners = User::whereIn(
            'id',
            $ownerIds
        )
            ->get()
            ->keyBy('id');

        $formattedProperties =
            $properties->map(
                function ($property) use ($owners) {
                    $owner = $owners->get(
                        $property->owner_id
                    );

                    return $this->formatProperty(
                        $property,
                        $owner
                    );
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


    // Get approved properties for admin management
    public function managedProperties(Request $request)
    {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can manage properties',
            ], 403);
        }

        $properties = Property::with([
            'images' => function ($query) {
                $query->orderBy('sort_order');
            },

            'facilities',

            'availableFloors' => function ($query) {
                $query->orderBy('floor_number');
            },
        ])
            ->where(
                'verification_status',
                'approved'
            )
            ->whereIn(
                'post_status',
                [
                    'active',
                    'removed',
                ]
            )
            ->latest()
            ->get();

        $ownerIds = $properties
            ->pluck('owner_id')
            ->unique()
            ->values();

        $owners = User::whereIn(
            'id',
            $ownerIds
        )
            ->get()
            ->keyBy('id');

        $formattedProperties =
            $properties->map(
                function ($property) use ($owners) {
                    $owner = $owners->get(
                        $property->owner_id
                    );

                    return $this->formatProperty(
                        $property,
                        $owner
                    );
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


    // Change active / removed status
    public function updatePostStatus(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can update property post status',
            ], 403);
        }

        if (
            $property->verification_status
            !== 'approved'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only approved properties can have their post status changed',
            ], 422);
        }

        $validated =
            $request->validate([
                'post_status' =>
                    'required|in:active,removed',
            ]);

        $property->post_status =
            $validated['post_status'];

        $property->save();

        return response()->json([
            'success' => true,

            'message' =>
                $property->post_status === 'active'
                    ? 'Property post activated successfully'
                    : 'Property post removed successfully',

            'property' => [
                'id' =>
                    $property->id,

                'post_status' =>
                    $property->post_status,
            ],
        ], 200);
    }


    // Approve property
    public function approveProperty(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can approve properties',
            ], 403);
        }

        if (
            $property->verification_status
            !== 'pending'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only pending properties can be approved',
            ], 422);
        }

        DB::transaction(
            function () use (
                $property,
                $admin
            ) {
                // Approve and publish property
                $property->verification_status =
                    'approved';

                $property->post_status =
                    'active';

                $property->save();

                // Mark payment as paid
                $payment =
                    $property
                        ->payment()
                        ->first();

                if ($payment) {
                    $payment->payment_status =
                        'paid';

                    $payment->paid_at =
                        now();

                    $payment->save();
                }

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
            }
        );

        return response()->json([
            'success' => true,

            'message' =>
                'Property approved and published successfully',
        ], 200);
    }


    // Reject property
    public function rejectProperty(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Only admin can reject properties',
            ], 403);
        }

        if (
            $property->verification_status
            !== 'pending'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only pending properties can be rejected',
            ], 422);
        }

        $validated =
            $request->validate([
                'reason' =>
                    'required|string|max:1000',

                'note' =>
                    'nullable|string|max:1000',
            ]);

        DB::transaction(
            function () use (
                $property,
                $admin,
                $validated
            ) {
                // Reject and keep unpublished
                $property->verification_status =
                    'rejected';

                $property->post_status =
                    'unpublished';

                $property->save();

                // Payment stays unchanged.
                // Owner can edit and resubmit
                // without paying again.

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
                        $validated['note']
                            ?? null,

                    'created_at' =>
                        now(),

                    'updated_at' =>
                        now(),
                ]);
            }
        );

        return response()->json([
            'success' => true,

            'message' =>
                'Property rejected successfully',
        ], 200);
    }


    // Admin dashboard data
    public function dashboardSummary(
        Request $request
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only admin can access dashboard data',
            ], 403);
        }

        $totalUsers =
            User::whereIn(
                'role',
                [
                    'renter',
                    'house_owner',
                ]
            )->count();

        $totalProperties =
            Property::count();

        $pendingProperties =
            Property::where(
                'verification_status',
                'pending'
            )->count();

        $suspendedUsers =
            User::whereIn(
                'role',
                [
                    'renter',
                    'house_owner',
                ]
            )
                ->where(
                    'status',
                    'suspended'
                )
                ->count();

        $latestPending =
            Property::with([
                'images' => function ($query) {
                    $query->orderBy(
                        'sort_order'
                    );
                },
            ])
                ->where(
                    'verification_status',
                    'pending'
                )
                ->latest()
                ->take(2)
                ->get();

        $ownerIds =
            $latestPending
                ->pluck('owner_id')
                ->unique()
                ->values();

        $owners =
            User::whereIn(
                'id',
                $ownerIds
            )
                ->get()
                ->keyBy('id');

        $formattedPending =
            $latestPending->map(
                function ($property) use ($owners) {
                    $owner =
                        $owners->get(
                            $property->owner_id
                        );

                    $coverImage =
                        $property
                            ->images
                            ->firstWhere(
                                'is_cover',
                                true
                            );

                    if (!$coverImage) {
                        $coverImage =
                            $property
                                ->images
                                ->first();
                    }

                    $imageUrl = null;

                    if (
                        $coverImage &&
                        $coverImage->image_path
                    ) {
                        $imageUrl =
                            asset(
                                'storage/' .
                                $coverImage->image_path
                            );
                    }

                    return [
                        'id' =>
                            $property->id,

                        'title' =>
                            $property->name,

                        'owner' =>
                            $owner?->name
                            ?? 'Unknown Owner',

                        'location' =>
                            $property->address,

                        'submitted' =>
                            $property->created_at
                                ? $property
                                    ->created_at
                                    ->format('d M Y')
                                : null,

                        'image' =>
                            $imageUrl,
                    ];
                }
            );

        return response()->json([
            'success' => true,

            'stats' => [
                'total_users' =>
                    $totalUsers,

                'total_properties' =>
                    $totalProperties,

                'pending_properties' =>
                    $pendingProperties,

                'suspended_users' =>
                    $suspendedUsers,
            ],

            'recent_pending' =>
                $formattedPending,
        ], 200);
    }


    // Admin view private ownership document
    public function viewOwnershipDocument(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only admin can view ownership documents',
            ], 403);
        }

        $document =
            $property
                ->document()
                ->first();

        if (
            !$document ||
            empty(
                $document
                    ->ownership_document_path
            )
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Ownership document has not been uploaded',
            ], 404);
        }

        $path =
            $document
                ->ownership_document_path;

        if (
            !Storage::disk('local')
                ->exists($path)
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Ownership document file not found',
            ], 404);
        }

        $filePath =
            Storage::disk('local')
                ->path($path);

        return response()->file(
            $filePath
        );
    }


    // Admin view private payment proof
    public function viewPaymentProof(
        Request $request,
        Property $property
    ) {
        $admin = $request->user();

        if (
            !$admin ||
            $admin->role !== 'admin'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only admin can view payment proof',
            ], 403);
        }

        $payment =
            $property
                ->payment()
                ->first();

        if (
            !$payment ||
            empty(
                $payment
                    ->payment_proof_path
            )
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Payment proof has not been uploaded',
            ], 404);
        }

        $path =
            $payment
                ->payment_proof_path;

        if (
            !Storage::disk('local')
                ->exists($path)
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Payment proof file not found',
            ], 404);
        }

        $filePath =
            Storage::disk('local')
                ->path($path);

        return response()->file(
            $filePath
        );
    }


    // Format property data for admin Flutter screens
    private function formatProperty(
        Property $property,
        ?User $owner
    ) {
        $coverImage =
            $property
                ->images
                ->firstWhere(
                    'is_cover',
                    true
                );

        if (!$coverImage) {
            $coverImage =
                $property
                    ->images
                    ->first();
        }

        $imageUrl = null;

        if (
            $coverImage &&
            $coverImage->image_path
        ) {
            $imageUrl =
                asset(
                    'storage/' .
                    $coverImage->image_path
                );
        }

        // All property images
        $images =
            $property
                ->images
                ->map(
                    function ($image) {
                        return [
                            'id' =>
                                $image->id,

                            'image_path' =>
                                $image->image_path,

                            'image_url' =>
                                asset(
                                    'storage/' .
                                    $image->image_path
                                ),

                            'is_cover' =>
                                (bool)
                                $image->is_cover,

                            'sort_order' =>
                                $image->sort_order,
                        ];
                    }
                )
                ->values();

        // Facilities
        $facilities = [
            'wifi' =>
                (bool) (
                    $property
                        ->facilities
                        ?->wifi
                    ?? false
                ),

            'parking' =>
                (bool) (
                    $property
                        ->facilities
                        ?->parking
                    ?? false
                ),

            'air_conditioning' =>
                (bool) (
                    $property
                        ->facilities
                        ?->air_conditioning
                    ?? false
                ),

            'pet_allowed' =>
                (bool) (
                    $property
                        ->facilities
                        ?->pet_allowed
                    ?? false
                ),

            'balcony' =>
                (bool) (
                    $property
                        ->facilities
                        ?->balcony
                    ?? false
                ),

            'kitchen' =>
                (bool) (
                    $property
                        ->facilities
                        ?->kitchen
                    ?? false
                ),

            'swimming_pool' =>
                (bool) (
                    $property
                        ->facilities
                        ?->swimming_pool
                    ?? false
                ),

            'elevator' =>
                (bool) (
                    $property
                        ->facilities
                        ?->elevator
                    ?? false
                ),
        ];

        // Available floors
        $availableFloors =
            $property
                ->availableFloors
                ->pluck(
                    'floor_number'
                )
                ->map(
                    fn ($floor) =>
                        (int) $floor
                )
                ->values();

        return [
            'id' =>
                $property->id,

            'owner_id' =>
                $property->owner_id,

            'title' =>
                $property->name,

            'name' =>
                $property->name,

            'property_type' =>
                $property->property_type,

            'owner' =>
                $owner?->name
                ?? 'Unknown Owner',

            'email' =>
                $owner?->email,

            'phone' =>
                $owner?->phone,

            'location' =>
                $property->address,

            'address' =>
                $property->address,

            'latitude' =>
                $property->latitude,

            'longitude' =>
                $property->longitude,

            'submitted' =>
                $property->created_at
                    ? $property
                        ->created_at
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
                (float)
                $property->price,

            'size' =>
                (float)
                $property->size,

            'description' =>
                $property->description,

            'contact' =>
                $property->contact,

            'furnished' =>
                (bool)
                $property->furnished,

            'bedrooms' =>
                $property->bedrooms,

            'bathrooms' =>
                $property->bathrooms,

            'total_floor' =>
                $property->total_floor,

            'image' =>
                $imageUrl,

            'images' =>
                $images,

            'facilities' =>
                $facilities,

            'available_floors' =>
                $availableFloors,

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
}