import 'dart:convert';
import 'dart:io';

import 'package:final_project/service/auth_service.dart';
import 'package:http/http.dart' as http;

class PropertyService {
  final AuthService authService = AuthService();

  final String baseUrl = "http://10.0.2.2:8000/api";

  // Get Token
  Future<String> _getToken() async {
    final String? token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in");
    }

    return token;
  }

  // Submit Property
  Future<http.Response> submitProperty({
    required String name,
    required String propertyType,
    required double size,
    required double price,
    required String description,
    required String contact,
    required bool furnished,
    required String address,
    required double latitude,
    required double longitude,
    int? bedrooms,
    int? bathrooms,
    int? totalFloor,
    required String rentalStatus,
    required Map<String, bool> facilities,
    required List<int> availableFloors,
    required List<File> propertyImages,
    required File ownershipDocument,
  }) async {
    final String token = await _getToken();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/properties"),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    // Property
    request.fields["name"] = name;

    request.fields["property_type"] = propertyType;

    request.fields["size"] = size.toString();

    request.fields["price"] = price.toString();

    request.fields["description"] = description;

    request.fields["contact"] = contact;

    request.fields["furnished"] = furnished ? "1" : "0";

    // Location
    request.fields["address"] = address;

    request.fields["latitude"] = latitude.toString();

    request.fields["longitude"] = longitude.toString();

    // Details
    if (bedrooms != null) {
      request.fields["bedrooms"] = bedrooms.toString();
    }

    if (bathrooms != null) {
      request.fields["bathrooms"] = bathrooms.toString();
    }

    if (totalFloor != null) {
      request.fields["total_floor"] = totalFloor.toString();
    }

    request.fields["rental_status"] = rentalStatus;

    // Facilities
    facilities.forEach((key, value) {
      request.fields["facilities[$key]"] = value ? "1" : "0";
    });

    // Available Floors
    for (int i = 0; i < availableFloors.length; i++) {
      request.fields["available_floors[$i]"] =
          availableFloors[i].toString();
    }

    // Property Images
    for (final File image in propertyImages) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "property_images[]",
          image.path,
        ),
      );
    }

    // Ownership Document
    request.files.add(
      await http.MultipartFile.fromPath(
        "ownership_document",
        ownershipDocument.path,
      ),
    );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    print(
      "PROPERTY SUBMIT STATUS: ${response.statusCode}",
    );

    print(
      "PROPERTY SUBMIT RESPONSE: ${response.body}",
    );

    return response;
  }

  // Generate Bakong QR
  Future<http.Response> generateBakongQr({
    required int paymentId,
  }) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/payments/$paymentId/generate-qr",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "GENERATE BAKONG QR STATUS: ${response.statusCode}",
    );

    print(
      "GENERATE BAKONG QR RESPONSE: ${response.body}",
    );

    return response;
  }

  // Check Bakong Payment
  Future<http.Response> checkBakongPayment({
    required int paymentId,
    required String md5,
  }) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/payments/$paymentId/check",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "md5": md5,
      }),
    );

    print(
      "CHECK BAKONG PAYMENT STATUS: ${response.statusCode}",
    );

    print(
      "CHECK BAKONG PAYMENT RESPONSE: ${response.body}",
    );

    return response;
  }

  // Get My Properties
  Future<http.Response> getMyProperties() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/owner/properties"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "MY PROPERTIES STATUS: ${response.statusCode}",
    );

    print(
      "MY PROPERTIES RESPONSE: ${response.body}",
    );

    return response;
  }

  // Get Owner Admin Feedback Notifications
  Future<http.Response> getOwnerNotifications() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/owner/notifications"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "OWNER NOTIFICATIONS STATUS: ${response.statusCode}",
    );

    print(
      "OWNER NOTIFICATIONS RESPONSE: ${response.body}",
    );

    return response;
  }

  // Mark Owner Notifications As Seen
  Future<http.Response> markOwnerNotificationsSeen() async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/owner/notifications/mark-seen",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "MARK NOTIFICATIONS SEEN STATUS: ${response.statusCode}",
    );

    print(
      "MARK NOTIFICATIONS SEEN RESPONSE: ${response.body}",
    );

    return response;
  }

  // Get Renter Properties
  Future<http.Response> getRenterProperties() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/renter/properties"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "RENTER PROPERTIES STATUS: ${response.statusCode}",
    );

    print(
      "RENTER PROPERTIES RESPONSE: ${response.body}",
    );

    return response;
  }

  // Get Favorites
  Future<http.Response> getFavorites() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/renter/favorites"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "GET FAVORITES STATUS: ${response.statusCode}",
    );

    print(
      "GET FAVORITES RESPONSE: ${response.body}",
    );

    return response;
  }

  // Add Favorite
  Future<http.Response> addFavorite({
    required int propertyId,
  }) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/renter/favorites/$propertyId",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "ADD FAVORITE STATUS: ${response.statusCode}",
    );

    print(
      "ADD FAVORITE RESPONSE: ${response.body}",
    );

    return response;
  }

  // Remove Favorite
  Future<http.Response> removeFavorite({
    required int propertyId,
  }) async {
    final String token = await _getToken();

    final response = await http.delete(
      Uri.parse(
        "$baseUrl/renter/favorites/$propertyId",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print(
      "REMOVE FAVORITE STATUS: ${response.statusCode}",
    );

    print(
      "REMOVE FAVORITE RESPONSE: ${response.body}",
    );

    return response;
  }

  // Update Rental Status
  Future<http.Response> updateRentalStatus({
    required int propertyId,
    required String rentalStatus,
  }) async {
    final String token = await _getToken();

    final response = await http.patch(
      Uri.parse(
        "$baseUrl/properties/$propertyId/rental-status",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "rental_status": rentalStatus,
      }),
    );

    print(
      "UPDATE STATUS CODE: ${response.statusCode}",
    );

    print(
      "UPDATE STATUS RESPONSE: ${response.body}",
    );

    return response;
  }

  // Update Property / Resubmit For Review
  Future<http.Response> updateProperty({
    required int propertyId,
    required String name,
    required double size,
    required double price,
    required String description,
    required String contact,
    required bool furnished,
    required String address,
    required double latitude,
    required double longitude,
    int? bedrooms,
    int? bathrooms,
    required int totalFloor,
    required String rentalStatus,
    required Map<String, bool> facilities,
    required List<int> availableFloors,
    List<File>? propertyImages,
    File? ownershipDocument,
  }) async {
    final String token = await _getToken();

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "$baseUrl/properties/$propertyId",
      ),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    request.fields["_method"] = "PUT";

    // Property
    request.fields["name"] = name;

    request.fields["size"] = size.toString();

    request.fields["price"] = price.toString();

    request.fields["description"] = description;

    request.fields["contact"] = contact;

    request.fields["furnished"] = furnished ? "1" : "0";

    // Location
    request.fields["address"] = address;

    request.fields["latitude"] = latitude.toString();

    request.fields["longitude"] = longitude.toString();

    // Details
    if (bedrooms != null) {
      request.fields["bedrooms"] = bedrooms.toString();
    }

    if (bathrooms != null) {
      request.fields["bathrooms"] = bathrooms.toString();
    }

    request.fields["total_floor"] =
        totalFloor.toString();

    request.fields["rental_status"] =
        rentalStatus;

    // Facilities
    facilities.forEach((key, value) {
      request.fields["facilities[$key]"] =
          value ? "1" : "0";
    });

    // Available Floors
    for (
      int i = 0;
      i < availableFloors.length;
      i++
    ) {
      request.fields["available_floors[$i]"] =
          availableFloors[i].toString();
    }

    // Property Images
    if (
        propertyImages != null &&
        propertyImages.isNotEmpty
    ) {
      for (final File image in propertyImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "property_images[]",
            image.path,
          ),
        );
      }
    }

    // Ownership Document
    if (ownershipDocument != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "ownership_document",
          ownershipDocument.path,
        ),
      );
    }

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
      streamedResponse,
    );

    print(
      "PROPERTY UPDATE STATUS: ${response.statusCode}",
    );

    print(
      "PROPERTY UPDATE RESPONSE: ${response.body}",
    );

    return response;
  }
}