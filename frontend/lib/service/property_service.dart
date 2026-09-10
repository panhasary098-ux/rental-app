import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PropertyService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String baseUrl = "http://10.0.2.2:8000/api";

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

    required double paymentAmount,

    String? transactionReference,

    required File paymentProof,
  }) async {
    // ====================================================
    // FIREBASE USER
    // ====================================================

    final User? firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw Exception("User is not logged in");
    }

    // ====================================================
    // FIREBASE TOKEN
    // ====================================================

    final String? token = await firebaseUser.getIdToken();

    if (token == null || token.isEmpty) {
      throw Exception("Unable to get authentication token");
    }

    // ====================================================
    // MULTIPART REQUEST
    // ====================================================

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/properties"),
    );

    // ====================================================
    // HEADERS
    // ====================================================

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
    // PAYMENT
    // ====================================================

    // Amount comes automatically from PostPropertyController:
    //
    // House       = $50
    // Apartment   = $40
    // Room        = $30

    request.fields["payment_amount"] = paymentAmount.toStringAsFixed(2);

    // Optional transaction reference
    if (transactionReference != null &&
        transactionReference.trim().isNotEmpty) {
      request.fields["transaction_reference"] = transactionReference.trim();
    }

    // Payment proof
    request.files.add(
      await http.MultipartFile.fromPath("payment_proof", paymentProof.path),
    );

    // ====================================================
    // SEND REQUEST
    // ====================================================

    final streamedResponse = await request.send();

    // ====================================================
    // CONVERT RESPONSE
    // ====================================================

    return http.Response.fromStream(streamedResponse);
  }
}
