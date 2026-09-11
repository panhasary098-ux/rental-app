import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AdminService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String baseUrl = "http://10.0.2.2:8000/api";

  // Get all properties waiting for verification
  Future<List<Map<String, dynamic>>> getPendingProperties() async {
    User? firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw Exception(
        "Admin is not logged in",
      );
    }

    String? token =
        await firebaseUser.getIdToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Unable to get authentication token",
      );
    }

    final response = await http.get(
      Uri.parse(
        "$baseUrl/admin/properties/pending",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["success"] == true) {
      final List<dynamic> properties =
          data["properties"] ?? [];

      return properties
          .map(
            (property) =>
                Map<String, dynamic>.from(
              property,
            ),
          )
          .toList();
    }

    throw Exception(
      data["message"] ??
          "Unable to load pending properties",
    );
  }

  // Approve a pending property
Future<bool> approveProperty(int propertyId) async {
  User? firebaseUser = auth.currentUser;

  if (firebaseUser == null) {
    throw Exception("Admin is not logged in");
  }

  String? token = await firebaseUser.getIdToken();

  if (token == null || token.isEmpty) {
    throw Exception("Unable to get authentication token");
  }

  final response = await http.post(
    Uri.parse(
      "$baseUrl/admin/properties/$propertyId/approve",
    ),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  final Map<String, dynamic> data =
      jsonDecode(response.body);

  if (response.statusCode == 200 &&
      data["success"] == true) {
    return true;
  }

  throw Exception(
    data["message"] ??
        "Unable to approve property",
  );
}


// Reject a pending property
Future<bool> rejectProperty({
  required int propertyId,
  required String reason,
  String? note,
}) async {
  User? firebaseUser = auth.currentUser;

  if (firebaseUser == null) {
    throw Exception("Admin is not logged in");
  }

  String? token = await firebaseUser.getIdToken();

  if (token == null || token.isEmpty) {
    throw Exception("Unable to get authentication token");
  }

  final response = await http.post(
    Uri.parse(
      "$baseUrl/admin/properties/$propertyId/reject",
    ),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "reason": reason,
      "note": note,
    }),
  );

  final Map<String, dynamic> data =
      jsonDecode(response.body);

  if (response.statusCode == 200 &&
      data["success"] == true) {
    return true;
  }

  throw Exception(
    data["message"] ??
        "Unable to reject property",
  );
}
}