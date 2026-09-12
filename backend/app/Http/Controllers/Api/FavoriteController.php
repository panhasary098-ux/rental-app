<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Favorite;
use App\Models\Property;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    // Get renter favorites
    public function index(Request $request)
    {
        $user = $request->user();

        if (!$user || $user->role !== 'renter') {
            return response()->json([
                'success' => false,
                'message' => 'Only renters can view favorites',
            ], 403);
        }

        // Get saved property IDs
        $favoritePropertyIds = Favorite::where(
            'user_id',
            $user->id
        )
            ->latest()
            ->pluck('property_id');

        // Only show properties that are still visible to renters
        $properties = Property::whereIn(
            'id',
            $favoritePropertyIds
        )
            ->where(
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
            ->get();

        $formattedProperties =
            $properties->map(
                function ($property) {
                    return $this
                        ->formatProperty(
                            $property
                        );
                }
            );

        return response()->json([
            'success' => true,

            'count' =>
                $formattedProperties->count(),

            'properties' =>
                $formattedProperties,
        ]);
    }

    // Add property to favorites
    public function store(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        if (!$user || $user->role !== 'renter') {
            return response()->json([
                'success' => false,
                'message' => 'Only renters can save properties',
            ], 403);
        }

        // Renter can only favorite visible properties
        if (
            $property->verification_status
                !== 'approved' ||
            $property->post_status
                !== 'active'
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'This property is not available to renters',
            ], 403);
        }

        $favorite =
            Favorite::firstOrCreate([
                'user_id' =>
                    $user->id,

                'property_id' =>
                    $property->id,
            ]);

        return response()->json([
            'success' => true,

            'message' =>
                $favorite->wasRecentlyCreated
                    ? 'Property added to favorites'
                    : 'Property is already in favorites',

            'property_id' =>
                $property->id,
        ]);
    }

    // Remove property from favorites
    public function destroy(
        Request $request,
        Property $property
    ) {
        $user = $request->user();

        if (!$user || $user->role !== 'renter') {
            return response()->json([
                'success' => false,
                'message' => 'Only renters can remove favorites',
            ], 403);
        }

        Favorite::where(
            'user_id',
            $user->id
        )
            ->where(
                'property_id',
                $property->id
            )
            ->delete();

        return response()->json([
            'success' => true,

            'message' =>
                'Property removed from favorites',

            'property_id' =>
                $property->id,
        ]);
    }

    // Format property for Flutter
    private function formatProperty(
        Property $property
    ) {
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
}