<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AiChatConversation;
use App\Models\AiChatMessage;
use App\Models\Property;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class AiChatController extends Controller
{
    // Chat
    public function chat(Request $request)
    {
        $request->validate([
            'conversation_id' =>
                'required|integer',

            'message' =>
                'required|string|max:1000',

            'history' =>
                'nullable|array',

            'history.*.role' =>
                'required|string|in:user,model',

            'history.*.text' =>
                'required|string|max:2000',
        ]);

        $conversation =
            AiChatConversation::find(
                $request->conversation_id
            );

        if (!$conversation) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Conversation not found.',
            ], 404);
        }

        // Owner Check
        if (
            $conversation->user_id
            !== $request->user()->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Unauthorized conversation.',
            ], 403);
        }

        $userMessage =
            trim(
                $request->message
            );

        $history =
            $request->history ?? [];

        // Search Real Properties
        $propertySearch =
            $this->getPropertySearch(
                $userMessage
            );

        $propertyContext =
            $propertySearch['context'];

        $matchedProperties =
            $propertySearch['properties'];

        $systemPrompt = <<<PROMPT
Identity:
- You are the JoulNow Rental Assistant.
- You were created for the JoulNow rental platform by the JoulNow development team.
- If the user asks who made you, who created you, or who developed you, say:
  "I was created by the JoulNow development team to help users with rental questions and guidance."
- Do not mention Google, Gemini, or the underlying AI provider unless the user specifically asks about the technology powering you.

Your purpose is to help renters understand renting, safely navigate the rental process, and help them find properties available on JoulNow.

You can help with:
- Rental documents
- Rental agreements and contracts
- Security deposits
- Monthly rent
- Utility payments
- Property inspections
- Moving in and moving out
- Tenant responsibilities
- House owner responsibilities
- Questions renters should ask owners
- General rental safety
- How to use JoulNow
- Finding available JoulNow properties

About JoulNow:
JoulNow is a verified rental property platform.

Properties are reviewed before they become publicly available.

House owners may provide:
- Property ownership or authorization documents
- National identification

Property search rules:
1. When property information is provided below, it comes from the real JoulNow property database.
2. Only recommend properties contained in the provided JoulNow property information.
3. Never invent a property.
4. Never invent a property name, price, address, type, availability, bedroom count, bathroom count, or furnished status.
5. If no matching JoulNow property is provided, clearly tell the user that no matching property was found.
6. Do not claim that a property matches a requirement unless the provided property information supports it.
7. Keep property recommendations concise and easy to read on a mobile screen.
8. When recommending properties, do not repeat every property detail because JoulNow will display property cards below your response.
9. When matching properties are available, briefly tell the user that matching properties were found and that they can view them below.

General rules:
1. Give clear and simple answers.
2. Keep answers useful for students and workers.
3. Do not invent laws.
4. Do not claim something is legally required unless certain.
5. For legal questions, explain that laws may vary and recommend checking an official authority or legal professional.
6. Do not invent properties, prices, owners, availability, or verification status.
7. Do not pretend you have access to information you were not given.
8. Stay mainly focused on renting, housing, contracts, documents, and JoulNow.
9. Keep answers concise and practical.
10. If the user asks something unrelated to renting or JoulNow, politely explain that you mainly assist with rental-related questions.

Formatting rules:
- Do not use Markdown.
- Do not use #, ##, ###, *, **, or Markdown tables.
- Use simple numbered lists when needed.
- Keep answers short and easy to read on a mobile screen.
- Prefer 3 to 5 useful points.
- Keep most answers under 120 words unless the user asks for more detail.
- Avoid long introductions before the answer.

JoulNow property information for the current request:
$propertyContext
PROMPT;

        try {
            $apiKey =
                config(
                    'services.gemini.key'
                );

            $primaryModel =
                config(
                    'services.gemini.model'
                );

            $fallbackModel =
                config(
                    'services.gemini.fallback_model'
                );

            if (
                $apiKey == null ||
                $apiKey == ''
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Gemini API key is missing.',
                ], 500);
            }

            if (
                $primaryModel == null ||
                $primaryModel == ''
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'Primary Gemini model is missing.',
                ], 500);
            }

            // Build Conversation
            $contents = [];

            foreach (
                $history
                as $historyMessage
            ) {
                $role =
                    $historyMessage['role']
                    ?? null;

                $text =
                    trim(
                        $historyMessage['text']
                        ?? ''
                    );

                if (
                    !in_array(
                        $role,
                        [
                            'user',
                            'model',
                        ]
                    ) ||
                    $text == ''
                ) {
                    continue;
                }

                $contents[] = [
                    'role' => $role,

                    'parts' => [
                        [
                            'text' =>
                                $text,
                        ],
                    ],
                ];
            }

            // Current Message
            $contents[] = [
                'role' => 'user',

                'parts' => [
                    [
                        'text' =>
                            $userMessage,
                    ],
                ],
            ];

            // Save User Message
            AiChatMessage::create([
                'user_id' =>
                    $request->user()->id,

                'conversation_id' =>
                    $conversation->id,

                'role' =>
                    'user',

                'message' =>
                    $userMessage,
            ]);

            // Update Conversation Title
            if (
                $conversation->title == null ||
                trim(
                    $conversation->title
                ) == ''
            ) {
                $title =
                    $this->createConversationTitle(
                        $userMessage
                    );

                $conversation->update([
                    'title' =>
                        $title,
                ]);
            }

            // Primary Model
            $response = null;

            $usedModel =
                $primaryModel;

            try {
                $response =
                    $this->sendGeminiRequest(
                        $primaryModel,
                        $apiKey,
                        $systemPrompt,
                        $contents
                    );
            } catch (
                ConnectionException $e
            ) {
                $response = null;
            }

            // Use Fallback
            $useFallback =
                $response == null ||
                $this->shouldUseFallback(
                    $response
                );

            if (
                $useFallback &&
                $fallbackModel != null &&
                $fallbackModel != '' &&
                $fallbackModel !=
                    $primaryModel
            ) {
                try {
                    $response =
                        $this->sendGeminiRequest(
                            $fallbackModel,
                            $apiKey,
                            $systemPrompt,
                            $contents
                        );

                    $usedModel =
                        $fallbackModel;
                } catch (
                    ConnectionException $e
                ) {
                    $response = null;
                }
            }

            // Timeout
            if ($response == null) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'The AI assistant is taking too long to respond. Please try again.',
                ], 503);
            }

            // Request Failed
            if ($response->failed()) {
                $error =
                    $response->json();

                $status =
                    $response->status();

                $errorStatus =
                    $error['error']['status']
                    ?? null;

                if (
                    $status == 503 ||
                    $errorStatus ==
                        'UNAVAILABLE'
                ) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'The AI assistant is busy right now. Please try again in a moment.',
                    ], 503);
                }

                if (
                    $status == 429 ||
                    $errorStatus ==
                        'RESOURCE_EXHAUSTED'
                ) {
                    return response()->json([
                        'success' => false,
                        'message' =>
                            'The AI assistant has reached its temporary usage limit. Please try again later.',
                    ], 429);
                }

                return response()->json([
                    'success' => false,
                    'message' =>
                        'AI service request failed.',
                    'error' =>
                        $error,
                ], 500);
            }

            $data =
                $response->json();

            $reply =
                $data['candidates'][0]
                     ['content']
                     ['parts'][0]
                     ['text']
                ?? null;

            if (
                $reply == null ||
                trim($reply) == ''
            ) {
                return response()->json([
                    'success' => false,
                    'message' =>
                        'AI did not return a response.',
                ], 500);
            }

            $reply =
                trim(
                    $reply
                );

            // Save AI Message
            AiChatMessage::create([
                'user_id' =>
                    $request->user()->id,

                'conversation_id' =>
                    $conversation->id,

                'role' =>
                    'assistant',

                'message' =>
                    $reply,
            ]);

            $conversation->touch();

            return response()->json([
                'success' => true,

                'reply' =>
                    $reply,

                'properties' =>
                    $matchedProperties,

                'conversation_id' =>
                    $conversation->id,

                'conversation_title' =>
                    $conversation->title,

                // Temporary For Testing
                'model' =>
                    $usedModel,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,

                'message' =>
                    'Unable to contact AI service.',

                'error' =>
                    $e->getMessage(),
            ], 500);
        }
    }

    // Create Conversation
    public function createConversation(
        Request $request
    ) {
        $conversation =
            AiChatConversation::create([
                'user_id' =>
                    $request->user()->id,

                'title' =>
                    null,
            ]);

        return response()->json([
            'success' => true,

            'message' =>
                'New conversation created successfully.',

            'conversation' =>
                $conversation,
        ], 201);
    }

    // Get Conversations
    public function conversations(
        Request $request
    ) {
        $conversations =
            AiChatConversation::where(
                'user_id',
                $request->user()->id
            )
                ->withCount(
                    'messages'
                )
                ->orderBy(
                    'updated_at',
                    'desc'
                )
                ->get();

        return response()->json([
            'success' => true,

            'conversations' =>
                $conversations,
        ]);
    }

    // Get Conversation
    public function conversation(
        Request $request,
        AiChatConversation $conversation
    ) {
        // Owner Check
        if (
            $conversation->user_id
            !== $request->user()->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Unauthorized conversation.',
            ], 403);
        }

        $messages =
            $conversation
                ->messages()
                ->orderBy(
                    'created_at',
                    'asc'
                )
                ->get();

        return response()->json([
            'success' => true,

            'conversation' => [
                'id' =>
                    $conversation->id,

                'title' =>
                    $conversation->title,

                'created_at' =>
                    $conversation->created_at,

                'updated_at' =>
                    $conversation->updated_at,
            ],

            'messages' =>
                $messages,
        ]);
    }

    // Clear Conversation
    public function clearConversation(
        Request $request,
        AiChatConversation $conversation
    ) {
        // Owner Check
        if (
            $conversation->user_id
            !== $request->user()->id
        ) {
            return response()->json([
                'success' => false,
                'message' =>
                    'Unauthorized conversation.',
            ], 403);
        }

        $conversation->delete();

        return response()->json([
            'success' => true,

            'message' =>
                'Conversation deleted successfully.',
        ]);
    }

    // Create Conversation Title
    private function createConversationTitle(
        string $message
    ): string {
        $message =
            trim(
                preg_replace(
                    '/\s+/',
                    ' ',
                    $message
                )
            );

        if (
            mb_strlen(
                $message
            ) <= 45
        ) {
            return $message;
        }

        return
            mb_substr(
                $message,
                0,
                42
            )
            . '...';
    }

    // Get Property Search
    private function getPropertySearch(
        string $userMessage
    ): array {
        $message =
            strtolower(
                $userMessage
            );

        // Detect Property Search
        $searchWords = [
            'find',
            'search',
            'show',
            'looking for',
            'need a',
            'need an',
            'property',
            'properties',
            'room',
            'house',
            'apartment',
            'bedroom',
            'bedrooms',
            'bathroom',
            'bathrooms',
            'furnished',
            'unfurnished',
        ];

        $isPropertySearch = false;

        foreach (
            $searchWords
            as $word
        ) {
            if (
                str_contains(
                    $message,
                    $word
                )
            ) {
                $isPropertySearch = true;
                break;
            }
        }

        if (!$isPropertySearch) {
            return [
                'context' =>
                    'No property database search was required for this question.',

                'properties' =>
                    [],
            ];
        }

        // Public Properties
        $query =
            Property::query()
                ->with([
                    'images',
                    'facilities',
                    'owner',
                ])
                ->where(
                    'rental_status',
                    'available'
                )
                ->where(
                    'verification_status',
                    'approved'
                )
                ->where(
                    'post_status',
                    'active'
                );

        // Property Type
        if (
            preg_match(
                '/\bapartments?\b/i',
                $message
            )
        ) {
            $query->where(
                'property_type',
                'apartment'
            );
        } elseif (
            preg_match(
                '/\bhouses?\b/i',
                $message
            )
        ) {
            $query->where(
                'property_type',
                'house'
            );
        } elseif (
            preg_match(
                '/\brooms?\b/i',
                $message
            )
        ) {
            $query->where(
                'property_type',
                'room'
            );
        }

        // Furnished
        if (
            preg_match(
                '/\bunfurnished\b/i',
                $message
            ) ||
            preg_match(
                '/\bnot\s+furnished\b/i',
                $message
            )
        ) {
            $query->where(
                'furnished',
                false
            );
        } elseif (
            preg_match(
                '/\bfurnished\b/i',
                $message
            )
        ) {
            $query->where(
                'furnished',
                true
            );
        }

        // Bedrooms
        $bedrooms =
            $this->extractBedrooms(
                $message
            );

        if ($bedrooms != null) {
            $query->where(
                'bedrooms',
                $bedrooms
            );
        }

        // Bathrooms
        $bathrooms =
            $this->extractBathrooms(
                $message
            );

        if ($bathrooms != null) {
            $query->where(
                'bathrooms',
                $bathrooms
            );
        }

        // Price Range
        $priceRange =
            $this->extractPriceRange(
                $message
            );

        if ($priceRange != null) {
            $query->where(
                'price',
                '>=',
                $priceRange['min']
            );

            $query->where(
                'price',
                '<=',
                $priceRange['max']
            );
        } else {
            // Maximum Budget
            $maxPrice =
                $this->extractMaximumPrice(
                    $message
                );

            if ($maxPrice != null) {
                $query->where(
                    'price',
                    '<=',
                    $maxPrice
                );
            }
        }

        // Get Matching Properties
        $properties =
            $query
                ->orderBy(
                    'price',
                    'asc'
                )
                ->limit(5)
                ->get();

        if ($properties->isEmpty()) {
            return [
                'context' =>
                    'A real JoulNow property database search was performed, but no matching available properties were found.',

                'properties' =>
                    [],
            ];
        }

        $propertyLines = [];

        foreach (
            $properties
            as $property
        ) {
            $propertyLines[] =
                'Property ID: '
                . $property->id
                . "\n"
                . 'Name: '
                . $property->name
                . "\n"
                . 'Type: '
                . $property->property_type
                . "\n"
                . 'Price: $'
                . number_format(
                    $property->price,
                    2
                )
                . ' per month'
                . "\n"
                . 'Address: '
                . (
                    $property->address
                    ?? 'Not provided'
                )
                . "\n"
                . 'Furnished: '
                . (
                    $property->furnished
                    ? 'Yes'
                    : 'No'
                )
                . "\n"
                . 'Bedrooms: '
                . (
                    $property->bedrooms
                    ?? 'Not provided'
                )
                . "\n"
                . 'Bathrooms: '
                . (
                    $property->bathrooms
                    ?? 'Not provided'
                )
                . "\n"
                . 'Rental Status: '
                . $property->rental_status;
        }

        $formattedProperties = [];

        foreach (
            $properties
            as $property
        ) {
            $images = [];

            foreach (
                $property->images
                as $image
            ) {
                $imagePath =
                    $image->image_path
                    ?? null;

                if (
                    $imagePath != null &&
                    trim($imagePath) != ''
                ) {
                    $images[] = [
                        'image_path' =>
                            $imagePath,

                        'image_url' =>
                            asset(
                                'storage/' .
                                ltrim(
                                    $imagePath,
                                    '/'
                                )
                            ),
                    ];
                }
            }

            $facilities = null;

            if ($property->facilities) {
                $facilities = [
                    'wifi' =>
                        (bool) $property->facilities->wifi,

                    'parking' =>
                        (bool) $property->facilities->parking,

                    'air_conditioning' =>
                        (bool) $property->facilities->air_conditioning,

                    'pet_allowed' =>
                        (bool) $property->facilities->pet_allowed,

                    'balcony' =>
                        (bool) $property->facilities->balcony,

                    'kitchen' =>
                        (bool) $property->facilities->kitchen,

                    'swimming_pool' =>
                        (bool) $property->facilities->swimming_pool,

                    'elevator' =>
                        (bool) $property->facilities->elevator,
                ];
            }

            $owner = null;

            if ($property->owner) {
                $profileImage =
                    $property->owner->profile_image
                    ?? '';

                if (
                    $profileImage != null &&
                    trim($profileImage) != ''
                ) {
                    $profileImage =
                        asset(
                            'storage/' .
                            ltrim(
                                $profileImage,
                                '/'
                            )
                        );
                } else {
                    $profileImage = '';
                }

                $owner = [
                    'id' =>
                        $property->owner->id,

                    'name' =>
                        $property->owner->name,

                    'profile_image' =>
                        $profileImage,

                    'member_since' =>
                        optional(
                            $property->owner->created_at
                        )->format(
                            'M Y'
                        ),
                ];
            }

            $formattedProperties[] = [
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
                    $property->description
                    ?? '',

                'contact' =>
                    $property->contact
                    ?? '',

                'owner_phone' =>
                    $property->owner->phone
                    ?? '',

                'owner' =>
                    $owner,

                'address' =>
                    $property->address,

                'latitude' =>
                    $property->latitude,

                'longitude' =>
                    $property->longitude,

                'furnished' =>
                    (bool) $property->furnished,

                'bedrooms' =>
                    $property->bedrooms,

                'bathrooms' =>
                    $property->bathrooms,

                'total_floor' =>
                    $property->total_floor,

                'available_floors' =>
                    $property->available_floors
                    ?? [],

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
            ];
        }

        return [
            'context' =>
                "The following properties were retrieved from the real JoulNow database:\n\n"
                . implode(
                    "\n\n",
                    $propertyLines
                ),

            'properties' =>
                $formattedProperties,
        ];
    }

    // Extract Price Range
    private function extractPriceRange(
        string $message
    ): ?array {
        $patterns = [
            '/between\s*\$?\s*(\d+(?:\.\d+)?)\s*(?:and|-)\s*\$?\s*(\d+(?:\.\d+)?)/i',
            '/from\s*\$?\s*(\d+(?:\.\d+)?)\s*(?:to|-)\s*\$?\s*(\d+(?:\.\d+)?)/i',
            '/\$?\s*(\d+(?:\.\d+)?)\s*(?:-|to)\s*\$?\s*(\d+(?:\.\d+)?)/i',
        ];

        foreach (
            $patterns
            as $pattern
        ) {
            if (
                preg_match(
                    $pattern,
                    $message,
                    $matches
                )
            ) {
                $firstPrice =
                    (float) $matches[1];

                $secondPrice =
                    (float) $matches[2];

                return [
                    'min' =>
                        min(
                            $firstPrice,
                            $secondPrice
                        ),

                    'max' =>
                        max(
                            $firstPrice,
                            $secondPrice
                        ),
                ];
            }
        }

        return null;
    }

    // Extract Maximum Price
    private function extractMaximumPrice(
        string $message
    ): ?float {
        $patterns = [
            '/(?:under|below|less than|max|maximum|up to)\s*\$?\s*(\d+(?:\.\d+)?)/i',
            '/\$\s*(\d+(?:\.\d+)?)\s*(?:or less|maximum|max)/i',
        ];

        foreach (
            $patterns
            as $pattern
        ) {
            if (
                preg_match(
                    $pattern,
                    $message,
                    $matches
                )
            ) {
                return
                    (float) $matches[1];
            }
        }

        return null;
    }

    // Extract Bedrooms
    private function extractBedrooms(
        string $message
    ): ?int {
        $patterns = [
            '/(\d+)\s*bedrooms?/i',
            '/(\d+)\s*bedroom/i',
            '/(\d+)\s*bed\b/i',
        ];

        foreach (
            $patterns
            as $pattern
        ) {
            if (
                preg_match(
                    $pattern,
                    $message,
                    $matches
                )
            ) {
                return
                    (int) $matches[1];
            }
        }

        return null;
    }

    // Extract Bathrooms
    private function extractBathrooms(
        string $message
    ): ?int {
        $patterns = [
            '/(\d+)\s*bathrooms?/i',
            '/(\d+)\s*bathroom/i',
            '/(\d+)\s*bath\b/i',
        ];

        foreach (
            $patterns
            as $pattern
        ) {
            if (
                preg_match(
                    $pattern,
                    $message,
                    $matches
                )
            ) {
                return
                    (int) $matches[1];
            }
        }

        return null;
    }

    // Gemini Request
    private function sendGeminiRequest(
        string $model,
        string $apiKey,
        string $systemPrompt,
        array $contents
    ) {
        $url =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            . $model
            . ":generateContent?key="
            . $apiKey;

        return
            Http::acceptJson()
                ->connectTimeout(5)
                ->timeout(10)
                ->post(
                    $url,
                    [
                        'systemInstruction' => [
                            'parts' => [
                                [
                                    'text' =>
                                        $systemPrompt,
                                ],
                            ],
                        ],

                        'contents' =>
                            $contents,

                        'generationConfig' => [
                            'maxOutputTokens' =>
                                1200,
                        ],
                    ]
                );
    }

    // Fallback Check
    private function shouldUseFallback(
        $response
    ): bool {
        if (
            $response->status()
            == 503
        ) {
            return true;
        }

        if (
            $response->status()
            == 429
        ) {
            return true;
        }

        $error =
            $response->json();

        $errorStatus =
            $error['error']['status']
            ?? null;

        return in_array(
            $errorStatus,
            [
                'UNAVAILABLE',
                'RESOURCE_EXHAUSTED',
            ]
        );
    }
}