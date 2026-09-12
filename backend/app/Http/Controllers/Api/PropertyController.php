<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class PropertyController extends Controller
{
    // Submit property
    public function store(Request $request)
    {
        $user = $request->user();

        // Only house owner can submit
        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' => 'Only house owners can submit properties',
            ], 403);
        }

        // National ID required
        if (empty($user->national_id_path)) {
            return response()->json([
                'success' => false,
                'code' => 'national_id_required',
                'message' =>
                    'Please upload your National ID before submitting a property.',
            ], 403);
        }

        // Validation
        $validated = $request->validate([
            'name' => 'required|string|max:255',

            'property_type' =>
                'required|in:house,room,apartment',

            'size' =>
                'required|numeric|min:0.01',

            'price' =>
                'required|numeric|min:0.01',

            'description' =>
                'required|string',

            'contact' =>
                'required|string|max:255',

            'furnished' =>
                'required|boolean',

            'address' =>
                'required|string|max:255',

            'latitude' =>
                'required|numeric|between:-90,90',

            'longitude' =>
                'required|numeric|between:-180,180',

            'bedrooms' =>
                'nullable|integer|min:0',

            'bathrooms' =>
                'nullable|integer|min:0',

            'total_floor' =>
                'required|integer|min:1',

            'rental_status' =>
                'required|in:available,rented',

            'facilities' =>
                'nullable|array',

            'facilities.wifi' =>
                'nullable|boolean',

            'facilities.parking' =>
                'nullable|boolean',

            'facilities.air_conditioning' =>
                'nullable|boolean',

            'facilities.pet_allowed' =>
                'nullable|boolean',

            'facilities.balcony' =>
                'nullable|boolean',

            'facilities.kitchen' =>
                'nullable|boolean',

            'facilities.swimming_pool' =>
                'nullable|boolean',

            'facilities.elevator' =>
                'nullable|boolean',

            'available_floors' =>
                'nullable|array',

            'available_floors.*' =>
                'integer|min:1',

            'property_images' =>
                'required|array|min:1',

            'property_images.*' =>
                'image|mimes:jpg,jpeg,png,webp|max:5120',

            'ownership_document' =>
                'required|image|mimes:jpg,jpeg,png,webp|max:5120',

            'transaction_reference' =>
                'nullable|string|max:255',

            'payment_proof' =>
                'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        // Validate available floors
        if (
            in_array(
                $validated['property_type'],
                ['room', 'apartment']
            )
        ) {
            $availableFloors =
                $validated['available_floors'] ?? [];

            if (empty($availableFloors)) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Please select at least one available floor.',
                ], 422);
            }

            foreach ($availableFloors as $floor) {
                if ($floor > $validated['total_floor']) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'Available floor cannot be higher than total floors.',
                    ], 422);
                }
            }

            $validated['available_floors'] =
                array_values(
                    array_unique($availableFloors)
                );
        }

        // Payment amount
        $paymentAmount =
            match ($validated['property_type']) {
                'house' => 50.00,
                'apartment' => 40.00,
                'room' => 30.00,
            };

        // Create property and related data
        $property = DB::transaction(function () use (
            $validated,
            $request,
            $user,
            $paymentAmount
        ) {
            $property = Property::create([
                'owner_id' =>
                    $user->id,

                'name' =>
                    $validated['name'],

                'property_type' =>
                    $validated['property_type'],

                'size' =>
                    $validated['size'],

                'price' =>
                    $validated['price'],

                'description' =>
                    $validated['description'],

                'contact' =>
                    $validated['contact'],

                'furnished' =>
                    $validated['furnished'],

                'address' =>
                    $validated['address'],

                'latitude' =>
                    $validated['latitude'],

                'longitude' =>
                    $validated['longitude'],

                'bedrooms' =>
                    $validated['bedrooms'] ?? null,

                'bathrooms' =>
                    $validated['bathrooms'] ?? null,

                'total_floor' =>
                    $validated['total_floor'],

                'rental_status' =>
                    $validated['rental_status'],

                'verification_status' =>
                    'pending',

                'post_status' =>
                    'unpublished',
            ]);

            // Facilities
            $facilities =
                $validated['facilities'] ?? [];

            $property->facilities()->create([
                'wifi' =>
                    $facilities['wifi'] ?? false,

                'parking' =>
                    $facilities['parking'] ?? false,

                'air_conditioning' =>
                    $facilities['air_conditioning'] ?? false,

                'pet_allowed' =>
                    $facilities['pet_allowed'] ?? false,

                'balcony' =>
                    $facilities['balcony'] ?? false,

                'kitchen' =>
                    $facilities['kitchen'] ?? false,

                'swimming_pool' =>
                    $facilities['swimming_pool'] ?? false,

                'elevator' =>
                    $facilities['elevator'] ?? false,
            ]);

            // Available floors
            if (
                in_array(
                    $validated['property_type'],
                    ['room', 'apartment']
                )
            ) {
                foreach (
                    $validated['available_floors']
                    as $floor
                ) {
                    $property
                        ->availableFloors()
                        ->create([
                            'floor_number' =>
                                $floor,
                        ]);
                }
            }

            // Property images
            foreach (
                $request->file('property_images')
                as $index => $image
            ) {
                $path = $image->store(
                    'property_images',
                    'public'
                );

                $property->images()->create([
                    'image_path' =>
                        $path,

                    'is_cover' =>
                        $index === 0,

                    'sort_order' =>
                        $index + 1,
                ]);
            }

            // Ownership document
            $ownershipPath =
                $request
                    ->file('ownership_document')
                    ->store(
                        'property_documents'
                    );

            $property->document()->create([
                'ownership_document_path' =>
                    $ownershipPath,
            ]);

            // Payment proof
            $paymentProofPath =
                $request
                    ->file('payment_proof')
                    ->store(
                        'payment_proofs'
                    );

            // Payment
            $property->payment()->create([
                'amount' =>
                    $paymentAmount,

                'transaction_reference' =>
                    $validated['transaction_reference'] ?? null,

                'payment_proof_path' =>
                    $paymentProofPath,

                'payment_status' =>
                    'pending',

                'paid_at' =>
                    null,
            ]);

            return $property;
        });

        $property->load([
            'images',
            'facilities',
            'availableFloors',
            'document',
            'payment',
        ]);

        return response()->json([
            'success' => true,

            'message' =>
                'Property submitted successfully and is waiting for admin review',

            'property' =>
                $property,
        ], 201);
    }

    // Get logged-in owner's properties
    public function myProperties(Request $request)
    {
        $user = $request->user();

        // Only house owner
        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only house owners can view their properties',
            ], 403);
        }

        $properties = Property::where(
            'owner_id',
            $user->id
        )
            ->with([
                'images' => function ($query) {
                    $query->orderBy(
                        'sort_order'
                    );
                },

                'facilities',

                'availableFloors',
            ])
            ->latest()
            ->get();

        $properties->each(function ($property) {
            // Cover image
            $coverImage =
                $property->images
                    ->firstWhere(
                        'is_cover',
                        true
                    );

            if (!$coverImage) {
                $coverImage =
                    $property->images->first();
            }

            $property->cover_image_path =
                $coverImage
                    ? $coverImage->image_path
                    : null;

            // Pending and rejected are editable.
            // Approved is not editable.
            $property->can_edit =
                $property->verification_status
                    !== 'approved';
        });

        return response()->json([
            'success' => true,

            'properties' =>
                $properties,
        ]);
    }

    // Get properties visible to renters
    public function renterProperties(Request $request)
    {
        $user = $request->user();

        // Only renter can access renter property list
        if (!$user || $user->role !== 'renter') {
            return response()->json([
                'success' => false,
                'message' =>
                    'Only renters can view rental properties',
            ], 403);
        }

        // Only admin-approved and active properties
        $properties = Property::where(
            'verification_status',
            'approved'
        )
            ->where(
                'post_status',
                'active'
            )
            ->with([
                'images' => function ($query) {
                    $query->orderBy(
                        'sort_order'
                    );
                },

                'facilities',

                'availableFloors' => function ($query) {
                    $query->orderBy(
                        'floor_number'
                    );
                },
            ])
            ->latest()
            ->get();

        // Format properties for renter Flutter app
        $formattedProperties =
            $properties->map(
                function ($property) {
                    // Images
                    $images =
                        $property->images
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
                                            (bool) $image->is_cover,

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
                                    ?->wifi ?? false
                            ),

                        'parking' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->parking ?? false
                            ),

                        'air_conditioning' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->air_conditioning ?? false
                            ),

                        'pet_allowed' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->pet_allowed ?? false
                            ),

                        'balcony' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->balcony ?? false
                            ),

                        'kitchen' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->kitchen ?? false
                            ),

                        'swimming_pool' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->swimming_pool ?? false
                            ),

                        'elevator' =>
                            (bool) (
                                $property
                                    ->facilities
                                    ?->elevator ?? false
                            ),
                    ];

                    // Available floor numbers only
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

                        'name' =>
                            $property->name,

                        'property_type' =>
                            $property->property_type,

                        'size' =>
                            (float) $property->size,

                        'price' =>
                            (float) $property->price,

                        'description' =>
                            $property->description,

                        'contact' =>
                            $property->contact,

                        'furnished' =>
                            (bool) $property->furnished,

                        'address' =>
                            $property->address,

                        'latitude' =>
                            (float) $property->latitude,

                        'longitude' =>
                            (float) $property->longitude,

                        'bedrooms' =>
                            $property->bedrooms,

                        'bathrooms' =>
                            $property->bathrooms,

                        'total_floor' =>
                            $property->total_floor,

                        'rental_status' =>
                            $property->rental_status,

                        'verification_status' =>
                            $property->verification_status,

                        'post_status' =>
                            $property->post_status,

                        'images' =>
                            $images,

                        'facilities' =>
                            $facilities,

                        'available_floors' =>
                            $availableFloors,

                        'created_at' =>
                            $property->created_at,
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

    // Update rental status
    public function updateRentalStatus(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        // Only house owner
        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Owner check
        if (
            $property->owner_id
            !== $user->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'You do not own this property',
            ], 403);
        }

        $validated =
            $request->validate([
                'rental_status' =>
                    'required|in:available,rented',
            ]);

        $property->update([
            'rental_status' =>
                $validated['rental_status'],
        ]);

        return response()->json([
            'success' => true,

            'message' =>
                'Rental status updated successfully',

            'property' =>
                $property,
        ]);
    }

    // Update property
    public function updateProperty(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        // Only house owner
        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // Owner check
        if ($property->owner_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' =>
                    'You do not own this property',
            ], 403);
        }

        // Approved property cannot be edited
        if (
            $property->verification_status
            === 'approved'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Approved properties cannot be edited',
            ], 403);
        }

        $validated = $request->validate([
            'name' =>
                'required|string|max:255',

            'size' =>
                'required|numeric|min:0.01',

            'price' =>
                'required|numeric|min:0.01',

            'description' =>
                'required|string',

            'contact' =>
                'required|string|max:255',

            'furnished' =>
                'required|boolean',

            'address' =>
                'required|string|max:255',

            'latitude' =>
                'required|numeric|between:-90,90',

            'longitude' =>
                'required|numeric|between:-180,180',

            'bedrooms' =>
                'nullable|integer|min:0',

            'bathrooms' =>
                'nullable|integer|min:0',

            'total_floor' =>
                'required|integer|min:1',

            'rental_status' =>
                'required|in:available,rented',

            'facilities' =>
                'nullable|array',

            'facilities.wifi' =>
                'nullable|boolean',

            'facilities.parking' =>
                'nullable|boolean',

            'facilities.air_conditioning' =>
                'nullable|boolean',

            'facilities.pet_allowed' =>
                'nullable|boolean',

            'facilities.balcony' =>
                'nullable|boolean',

            'facilities.kitchen' =>
                'nullable|boolean',

            'facilities.swimming_pool' =>
                'nullable|boolean',

            'facilities.elevator' =>
                'nullable|boolean',

            'available_floors' =>
                'nullable|array',

            'available_floors.*' =>
                'integer|min:1',

            'property_images' =>
                'nullable|array|min:1',

            'property_images.*' =>
                'image|mimes:jpg,jpeg,png,webp|max:5120',

            'ownership_document' =>
                'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        // Property type cannot be changed during edit
        $propertyType =
            $property->property_type;

        // Validate available floors
        if (
            in_array(
                $propertyType,
                ['room', 'apartment']
            )
        ) {
            $availableFloors =
                $validated['available_floors']
                ?? [];

            if (empty($availableFloors)) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Please select at least one available floor.',
                ], 422);
            }

            foreach (
                $availableFloors as $floor
            ) {
                if (
                    $floor >
                    $validated['total_floor']
                ) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'Available floor cannot be higher than total floors.',
                    ], 422);
                }
            }

            $validated['available_floors'] =
                array_values(
                    array_unique(
                        $availableFloors
                    )
                );
        } else {
            $validated['available_floors'] = [];
        }

        $oldImagePaths = [];

        $oldDocumentPath = null;

        DB::transaction(function () use (
            $validated,
            $request,
            $property,
            $propertyType,
            &$oldImagePaths,
            &$oldDocumentPath
        ) {
            // Update property
            $property->update([
                'name' =>
                    $validated['name'],

                'size' =>
                    $validated['size'],

                'price' =>
                    $validated['price'],

                'description' =>
                    $validated['description'],

                'contact' =>
                    $validated['contact'],

                'furnished' =>
                    $validated['furnished'],

                'address' =>
                    $validated['address'],

                'latitude' =>
                    $validated['latitude'],

                'longitude' =>
                    $validated['longitude'],

                'bedrooms' =>
                    $validated['bedrooms']
                        ?? null,

                'bathrooms' =>
                    $validated['bathrooms']
                        ?? null,

                'total_floor' =>
                    $validated['total_floor'],

                'rental_status' =>
                    $validated['rental_status'],

                // Resubmit for review
                'verification_status' =>
                    'pending',

                'post_status' =>
                    'unpublished',
            ]);

            // Update facilities
            $facilities =
                $validated['facilities']
                    ?? [];

            $property
                ->facilities()
                ->updateOrCreate(
                    [],
                    [
                        'wifi' =>
                            $facilities['wifi']
                                ?? false,

                        'parking' =>
                            $facilities['parking']
                                ?? false,

                        'air_conditioning' =>
                            $facilities['air_conditioning']
                                ?? false,

                        'pet_allowed' =>
                            $facilities['pet_allowed']
                                ?? false,

                        'balcony' =>
                            $facilities['balcony']
                                ?? false,

                        'kitchen' =>
                            $facilities['kitchen']
                                ?? false,

                        'swimming_pool' =>
                            $facilities['swimming_pool']
                                ?? false,

                        'elevator' =>
                            $facilities['elevator']
                                ?? false,
                    ]
                );

            // Update available floors
            $property
                ->availableFloors()
                ->delete();

            if (
                in_array(
                    $propertyType,
                    ['room', 'apartment']
                )
            ) {
                foreach (
                    $validated['available_floors']
                    as $floor
                ) {
                    $property
                        ->availableFloors()
                        ->create([
                            'floor_number' =>
                                $floor,
                        ]);
                }
            }

            // Replace property images only if new images are sent
            if (
                $request->hasFile(
                    'property_images'
                )
            ) {
                $oldImagePaths =
                    $property
                        ->images()
                        ->pluck(
                            'image_path'
                        )
                        ->toArray();

                $property
                    ->images()
                    ->delete();

                foreach (
                    $request->file(
                        'property_images'
                    ) as $index => $image
                ) {
                    $path =
                        $image->store(
                            'property_images',
                            'public'
                        );

                    $property
                        ->images()
                        ->create([
                            'image_path' =>
                                $path,

                            'is_cover' =>
                                $index === 0,

                            'sort_order' =>
                                $index + 1,
                        ]);
                }
            }

            // Replace ownership document only if new one is sent
            if (
                $request->hasFile(
                    'ownership_document'
                )
            ) {
                $oldDocument =
                    $property
                        ->document()
                        ->first();

                if ($oldDocument) {
                    $oldDocumentPath =
                        $oldDocument
                            ->ownership_document_path;
                }

                $newDocumentPath =
                    $request
                        ->file(
                            'ownership_document'
                        )
                        ->store(
                            'property_documents'
                        );

                $property
                    ->document()
                    ->updateOrCreate(
                        [],
                        [
                            'ownership_document_path' =>
                                $newDocumentPath,
                        ]
                    );
            }
        });

        // Delete old public image files
        foreach (
            $oldImagePaths
            as $oldImagePath
        ) {
            Storage::disk('public')
                ->delete(
                    $oldImagePath
                );
        }

        // Delete old private ownership document
        if ($oldDocumentPath) {
            Storage::delete(
                $oldDocumentPath
            );
        }

        $property->load([
            'images',
            'facilities',
            'availableFloors',
            'document',
            'payment',
        ]);

        $property->can_edit = true;

        return response()->json([
            'success' => true,

            'message' =>
                'Property updated successfully and submitted for admin review',

            'property' =>
                $property,
        ]);
    }
}