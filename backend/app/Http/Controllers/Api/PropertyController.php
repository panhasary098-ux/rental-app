<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Property;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class PropertyController extends Controller
{
    // ======================================================
    // SUBMIT PROPERTY
    // ======================================================

    public function store(Request $request)
    {
        $user = $request->user();

        // ======================================================
        // ONLY HOUSE OWNER CAN SUBMIT
        // ======================================================

        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' => 'Only house owners can submit properties',
            ], 403);
        }


        // ======================================================
        // NATIONAL ID REQUIRED
        // ======================================================

        if (empty($user->national_id_path)) {
            return response()->json([
                'success' => false,
                'code' => 'national_id_required',
                'message' =>
                'Please upload your National ID before submitting a property.',
            ], 403);
        }

        // ======================================================
        // VALIDATION
        // ======================================================

        $validated = $request->validate([

            // --------------------------------------------------
            // MAIN PROPERTY INFORMATION
            // --------------------------------------------------

            'name' => 'required|string|max:255',

            'property_type' =>
            'required|in:house,room,apartment',

            'size' => 'required|numeric|min:0.01',

            'price' => 'required|numeric|min:0.01',

            'description' => 'required|string',

            'contact' => 'required|string|max:255',

            'furnished' => 'required|boolean',

            // --------------------------------------------------
            // LOCATION
            // --------------------------------------------------

            'address' => 'required|string|max:255',

            'latitude' =>
            'required|numeric|between:-90,90',

            'longitude' =>
            'required|numeric|between:-180,180',

            // --------------------------------------------------
            // PROPERTY DETAILS
            // --------------------------------------------------

            'bedrooms' =>
            'nullable|integer|min:0',

            'bathrooms' =>
            'nullable|integer|min:0',

            'total_floor' =>
            'required|integer|min:1',

            'rental_status' =>
            'required|in:available,rented',

            // --------------------------------------------------
            // FACILITIES
            // --------------------------------------------------

            'facilities' => 'nullable|array',

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

            // --------------------------------------------------
            // AVAILABLE FLOORS
            // --------------------------------------------------

            'available_floors' =>
            'nullable|array',

            'available_floors.*' =>
            'integer|min:1',

            // --------------------------------------------------
            // PROPERTY IMAGES
            // --------------------------------------------------

            'property_images' =>
            'required|array|min:1',

            'property_images.*' =>
            'image|mimes:jpg,jpeg,png,webp|max:5120',

            // --------------------------------------------------
            // OWNERSHIP DOCUMENT
            // --------------------------------------------------

            'ownership_document' =>
            'required|image|mimes:jpg,jpeg,png,webp|max:5120',

            // --------------------------------------------------
            // PAYMENT
            // --------------------------------------------------

            'transaction_reference' =>
            'nullable|string|max:255',

            'payment_proof' =>
            'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        // ======================================================
        // VALIDATE AVAILABLE FLOORS
        // ======================================================

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

            // Remove duplicates
            $validated['available_floors'] =
                array_values(
                    array_unique($availableFloors)
                );
        }

        // ======================================================
        // PAYMENT AMOUNT
        // ======================================================

        $paymentAmount = match ($validated['property_type']) {
            'house' => 50.00,
            'apartment' => 40.00,
            'room' => 30.00,
        };

        // ======================================================
        // DATABASE TRANSACTION
        // ======================================================

        $property = DB::transaction(function () use (
            $validated,
            $request,
            $user,
            $paymentAmount
        ) {

            // ==================================================
            // 1. CREATE PROPERTY
            // ==================================================

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

                // Waiting for admin
                'verification_status' =>
                'pending',

                // Not visible to renter yet
                'post_status' =>
                'unpublished',
            ]);

            // ==================================================
            // 2. CREATE FACILITIES
            // ==================================================

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

            // ==================================================
            // 3. CREATE AVAILABLE FLOORS
            // ==================================================

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

            // ==================================================
            // 4. STORE PROPERTY IMAGES
            // ==================================================

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

                    // First image = cover
                    'is_cover' =>
                    $index === 0,

                    'sort_order' =>
                    $index + 1,
                ]);
            }

            // ==================================================
            // 5. STORE OWNERSHIP DOCUMENT
            // ==================================================

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

            // ==================================================
            // 6. STORE PAYMENT PROOF
            // ==================================================

            $paymentProofPath =
                $request
                ->file('payment_proof')
                ->store(
                    'payment_proofs'
                );

            // ==================================================
            // 7. CREATE PAYMENT
            // ==================================================

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

        // ======================================================
        // LOAD RELATIONSHIPS
        // ======================================================

        $property->load([
            'images',
            'facilities',
            'availableFloors',
            'document',
            'payment',
        ]);

        // ======================================================
        // RESPONSE
        // ======================================================

        return response()->json([
            'success' => true,

            'message' =>
            'Property submitted successfully and is waiting for admin review',

            'property' =>
            $property,

        ], 201);
    }

    // ======================================================
    // GET LOGGED-IN OWNER PROPERTIES
    // ======================================================

    public function myProperties(Request $request)
    {
        $user = $request->user();

        // ==================================================
        // ONLY HOUSE OWNER
        // ==================================================

        if (!$user || $user->role !== 'house_owner') {
            return response()->json([
                'success' => false,
                'message' =>
                'Only house owners can view their properties',
            ], 403);
        }

        // ==================================================
        // GET OWNER PROPERTIES
        // ==================================================

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

        // ==================================================
        // ADD INFORMATION FOR FLUTTER
        // ==================================================

        $properties->each(function ($property) {

            // --------------------------------------------------
            // COVER IMAGE
            // --------------------------------------------------

            $coverImage =
                $property->images
                ->firstWhere(
                    'is_cover',
                    true
                );

            // If somehow no cover exists,
            // use first image.
            if (!$coverImage) {
                $coverImage =
                    $property->images->first();
            }

            $property->cover_image_path =
                $coverImage
                ? $coverImage->image_path
                : null;

            // --------------------------------------------------
            // EDIT PERMISSION
            // --------------------------------------------------
            //
            // Pending  = editable
            // Rejected = editable
            // Approved = NOT editable
            //

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

    // ======================================================
    // UPDATE RENTAL STATUS
    // ======================================================

    public function updateRentalStatus(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        // ==================================================
        // USER CHECK
        // ==================================================

        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // ==================================================
        // OWNER CHECK
        // ==================================================

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

        // ==================================================
        // VALIDATE STATUS
        // ==================================================

        $validated =
            $request->validate([
                'rental_status' =>
                'required|in:available,rented',
            ]);

        // ==================================================
        // UPDATE
        // ==================================================

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
    // ======================================================
    // UPDATE PROPERTY
    // ======================================================

    public function updateProperty(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        // ==================================================
        // ONLY HOUSE OWNER
        // ==================================================

        if (
            !$user ||
            $user->role !== 'house_owner'
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        // ==================================================
        // OWNER CHECK
        // ==================================================

        if ($property->owner_id !== $user->id) {
            return response()->json([
                'success' => false,
                'message' =>
                'You do not own this property',
            ], 403);
        }

        // ==================================================
        // APPROVED PROPERTY CANNOT BE EDITED
        // ==================================================

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

        // ==================================================
        // VALIDATION
        // ==================================================

        $validated = $request->validate([

            // --------------------------------------------------
            // MAIN INFORMATION
            // --------------------------------------------------

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

            // --------------------------------------------------
            // LOCATION
            // --------------------------------------------------

            'address' =>
            'required|string|max:255',

            'latitude' =>
            'required|numeric|between:-90,90',

            'longitude' =>
            'required|numeric|between:-180,180',

            // --------------------------------------------------
            // PROPERTY DETAILS
            // --------------------------------------------------

            'bedrooms' =>
            'nullable|integer|min:0',

            'bathrooms' =>
            'nullable|integer|min:0',

            'total_floor' =>
            'required|integer|min:1',

            'rental_status' =>
            'required|in:available,rented',

            // --------------------------------------------------
            // FACILITIES
            // --------------------------------------------------

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

            // --------------------------------------------------
            // AVAILABLE FLOORS
            // --------------------------------------------------

            'available_floors' =>
            'nullable|array',

            'available_floors.*' =>
            'integer|min:1',

            // --------------------------------------------------
            // NEW PROPERTY IMAGES
            //
            // Optional during edit.
            // If owner does not select new images,
            // existing images remain.
            // --------------------------------------------------

            'property_images' =>
            'nullable|array|min:1',

            'property_images.*' =>
            'image|mimes:jpg,jpeg,png,webp|max:5120',

            // --------------------------------------------------
            // NEW OWNERSHIP DOCUMENT
            //
            // Optional during edit.
            // Existing document remains if no new one is sent.
            // --------------------------------------------------

            'ownership_document' =>
            'nullable|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        // ==================================================
        // PROPERTY TYPE
        // ==================================================
        //
        // Property type cannot be changed during edit.
        //
        // House stays House
        // Apartment stays Apartment
        // Room stays Room
        //

        $propertyType =
            $property->property_type;

        // ==================================================
        // VALIDATE AVAILABLE FLOORS
        // ==================================================

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

        // ==================================================
        // KEEP OLD FILE PATHS
        // ==================================================

        $oldImagePaths = [];

        $oldDocumentPath = null;

        // ==================================================
        // DATABASE TRANSACTION
        // ==================================================

        DB::transaction(function () use (
            $validated,
            $request,
            $property,
            $propertyType,
            &$oldImagePaths,
            &$oldDocumentPath
        ) {

            // ==================================================
            // 1. UPDATE PROPERTY
            // ==================================================

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

                // ==================================================
                // RESUBMIT FOR ADMIN REVIEW
                // ==================================================
                //
                // Pending property stays pending.
                //
                // Rejected property becomes pending again.
                //

                'verification_status' =>
                'pending',

                'post_status' =>
                'unpublished',
            ]);

            // ==================================================
            // 2. UPDATE FACILITIES
            // ==================================================

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
                        $facilities['air_conditioning'] ?? false,

                        'pet_allowed' =>
                        $facilities['pet_allowed'] ?? false,

                        'balcony' =>
                        $facilities['balcony']
                            ?? false,

                        'kitchen' =>
                        $facilities['kitchen']
                            ?? false,

                        'swimming_pool' =>
                        $facilities['swimming_pool'] ?? false,

                        'elevator' =>
                        $facilities['elevator']
                            ?? false,
                    ]
                );

            // ==================================================
            // 3. UPDATE AVAILABLE FLOORS
            // ==================================================

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
                    $validated['available_floors'] as $floor
                ) {
                    $property
                        ->availableFloors()
                        ->create([
                            'floor_number' =>
                            $floor,
                        ]);
                }
            }

            // ==================================================
            // 4. REPLACE PROPERTY IMAGES
            // ==================================================
            //
            // Only replace images when owner selects
            // new property images.
            //

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

                // Delete old image records
                $property
                    ->images()
                    ->delete();

                // Store new images
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

            // ==================================================
            // 5. REPLACE OWNERSHIP DOCUMENT
            // ==================================================

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

        // ==================================================
        // DELETE OLD PROPERTY IMAGE FILES
        // ==================================================

        foreach (
            $oldImagePaths as $oldImagePath
        ) {
            Storage::disk('public')
                ->delete(
                    $oldImagePath
                );
        }

        // ==================================================
        // DELETE OLD OWNERSHIP DOCUMENT FILE
        // ==================================================

        if ($oldDocumentPath) {
            Storage::delete(
                $oldDocumentPath
            );
        }

        // ==================================================
        // LOAD UPDATED PROPERTY
        // ==================================================

        $property->load([
            'images',
            'facilities',
            'availableFloors',
            'document',
            'payment',
        ]);

        // Still editable because it is pending
        $property->can_edit = true;

        // ==================================================
        // RESPONSE
        // ==================================================

        return response()->json([
            'success' => true,

            'message' =>
            'Property updated successfully and submitted for admin review',

            'property' =>
            $property,
        ]);
    }
}
