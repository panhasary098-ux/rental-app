import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PropertyService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String baseUrl = "http://10.0.2.2:8000/api";

  // ======================================================
  // GET FIREBASE TOKEN
  // ======================================================

  Future<String> _getToken() async {
    final User? firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw Exception("User is not logged in");
    }

    final String? token = await firebaseUser.getIdToken();

    if (token == null || token.isEmpty) {
      throw Exception("Unable to get authentication token");
    }

    return token;
  }

  // ======================================================
  // SUBMIT PROPERTY
  // ======================================================

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

    String? transactionReference,

    required File paymentProof,
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

    // ====================================================
    // PROPERTY INFORMATION
    // ====================================================

    request.fields["name"] = name;
    request.fields["property_type"] = propertyType;
    request.fields["size"] = size.toString();
    request.fields["price"] = price.toString();
    request.fields["description"] = description;
    request.fields["contact"] = contact;
    request.fields["furnished"] = furnished ? "1" : "0";

    // ====================================================
    // LOCATION
    // ====================================================

    request.fields["address"] = address;
    request.fields["latitude"] = latitude.toString();
    request.fields["longitude"] = longitude.toString();

    // ====================================================
    // PROPERTY DETAILS
    // ====================================================

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

    // ====================================================
    // FACILITIES
    // ====================================================

    facilities.forEach((key, value) {
      request.fields["facilities[$key]"] = value ? "1" : "0";
    });

    // ====================================================
    // AVAILABLE FLOORS
    // ====================================================

    for (int i = 0; i < availableFloors.length; i++) {
      request.fields["available_floors[$i]"] = availableFloors[i].toString();
    }

    // ====================================================
    // PROPERTY IMAGES
    // ====================================================

    for (final File image in propertyImages) {
      request.files.add(
        await http.MultipartFile.fromPath("property_images[]", image.path),
      );
    }

    // ====================================================
    // OWNERSHIP DOCUMENT
    // ====================================================

    request.files.add(
      await http.MultipartFile.fromPath(
        "ownership_document",
        ownershipDocument.path,
      ),
    );

    // ====================================================
    // TRANSACTION REFERENCE
    // ====================================================

    if (transactionReference != null &&
        transactionReference.trim().isNotEmpty) {
      request.fields["transaction_reference"] = transactionReference.trim();
    }

    // ====================================================
    // PAYMENT PROOF
    // ====================================================

    request.files.add(
      await http.MultipartFile.fromPath("payment_proof", paymentProof.path),
    );

    // ====================================================
    // SEND REQUEST
    // ====================================================

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    print("PROPERTY SUBMIT STATUS: ${response.statusCode}");

    print("PROPERTY SUBMIT RESPONSE: ${response.body}");

    return response;
  }

  // ======================================================
  // GET OWNER PROPERTIES
  // ======================================================

  Future<http.Response> getMyProperties() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/owner/properties"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("MY PROPERTIES STATUS: ${response.statusCode}");

    print("MY PROPERTIES RESPONSE: ${response.body}");

    return response;
  }

  // ======================================================
  // UPDATE RENTAL STATUS
  // ======================================================

  Future<http.Response> updateRentalStatus({
    required int propertyId,
    required String rentalStatus,
  }) async {
    final String token = await _getToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/properties/$propertyId/rental-status"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"rental_status": rentalStatus}),
    );

    print("UPDATE STATUS CODE: ${response.statusCode}");

    print("UPDATE STATUS RESPONSE: ${response.body}");

    return response;
  }

  // ======================================================
  // UPDATE / EDIT PROPERTY
  // ======================================================

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

    // Optional during edit.
    // If empty, Laravel keeps the current images.
    List<File>? propertyImages,

    // Optional during edit.
    // If null, Laravel keeps the current document.
    File? ownershipDocument,
  }) async {
    final String token = await _getToken();

    // ====================================================
    // IMPORTANT
    // ====================================================
    //
    // We send POST + _method=PUT.
    //
    // This lets Laravel handle multipart image uploads
    // correctly while still matching our PUT route.
    //
    // Laravel treats this as:
    //
    // PUT /api/properties/{property}
    //
    // ====================================================

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/properties/$propertyId"),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    // Laravel method spoofing
    request.fields["_method"] = "PUT";

    // ====================================================
    // PROPERTY INFORMATION
    // ====================================================

    request.fields["name"] = name;
    request.fields["size"] = size.toString();
    request.fields["price"] = price.toString();
    request.fields["description"] = description;
    request.fields["contact"] = contact;

    request.fields["furnished"] = furnished ? "1" : "0";

    // ====================================================
    // LOCATION
    // ====================================================

    request.fields["address"] = address;

    request.fields["latitude"] = latitude.toString();

    request.fields["longitude"] = longitude.toString();

    // ====================================================
    // PROPERTY DETAILS
    // ====================================================

    if (bedrooms != null) {
      request.fields["bedrooms"] = bedrooms.toString();
    }

    if (bathrooms != null) {
      request.fields["bathrooms"] = bathrooms.toString();
    }

    request.fields["total_floor"] = totalFloor.toString();

    request.fields["rental_status"] = rentalStatus;

    // ====================================================
    // FACILITIES
    // ====================================================

    facilities.forEach((key, value) {
      request.fields["facilities[$key]"] = value ? "1" : "0";
    });

    // ====================================================
    // AVAILABLE FLOORS
    // ====================================================

    for (int i = 0; i < availableFloors.length; i++) {
      request.fields["available_floors[$i]"] = availableFloors[i].toString();
    }

    // ====================================================
    // NEW PROPERTY IMAGES
    // ====================================================
    //
    // Only send them when owner selected new images.
    //

    if (propertyImages != null && propertyImages.isNotEmpty) {
      for (final File image in propertyImages) {
        request.files.add(
          await http.MultipartFile.fromPath("property_images[]", image.path),
        );
      }
    }

    // ====================================================
    // NEW OWNERSHIP DOCUMENT
    // ====================================================

    if (ownershipDocument != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "ownership_document",
          ownershipDocument.path,
        ),
      );
    }

    // ====================================================
    // NO PAYMENT
    // ====================================================
    //
    // Editing does NOT send:
    //
    // payment_amount
    // payment_proof
    // transaction_reference
    //
    // Existing payment stays unchanged.
    //

    // ====================================================
    // SEND REQUEST
    // ====================================================

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    print("PROPERTY UPDATE STATUS: ${response.statusCode}");

    print("PROPERTY UPDATE RESPONSE: ${response.body}");

    return response;
  }
}
