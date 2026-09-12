import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class AdminService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String baseUrl = "http://10.0.2.2:8000/api";

  // Get current Firebase admin token
  Future<String> _getToken() async {
    User? firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw Exception("Admin is not logged in");
    }

    String? token = await firebaseUser.getIdToken();

    if (token == null || token.isEmpty) {
      throw Exception("Unable to get authentication token");
    }

    return token;
  }

  // Get all properties waiting for verification
  Future<List<Map<String, dynamic>>> getPendingProperties() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/properties/pending"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> properties = data["properties"] ?? [];

      return properties
          .map((property) => Map<String, dynamic>.from(property))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load pending properties");
  }

  // Approve a pending property
  Future<bool> approveProperty(int propertyId) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/admin/properties/$propertyId/approve"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return true;
    }

    throw Exception(data["message"] ?? "Unable to approve property");
  }

  // Reject a pending property
  Future<bool> rejectProperty({
    required int propertyId,
    required String reason,
    String? note,
  }) async {
    final String token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/admin/properties/$propertyId/reject"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"reason": reason, "note": note}),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return true;
    }

    throw Exception(data["message"] ?? "Unable to reject property");
  }

  // Get approved properties for admin management
  Future<List<Map<String, dynamic>>> getManagedProperties() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/properties"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> properties = data["properties"] ?? [];

      return properties
          .map((property) => Map<String, dynamic>.from(property))
          .toList();
    }

    throw Exception(data["message"] ?? "Unable to load properties");
  }

  // Change property post status
  Future<bool> updatePropertyPostStatus({
    required int propertyId,
    required String postStatus,
  }) async {
    final String token = await _getToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/admin/properties/$propertyId/post-status"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"post_status": postStatus}),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return true;
    }

    throw Exception(data["message"] ?? "Unable to update property status");
  }

  // Get real renters and house owners
  Future<List<Map<String, dynamic>>> getUsers() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/users"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> users = data["users"] ?? [];

      return users.map((user) => Map<String, dynamic>.from(user)).toList();
    }

    throw Exception(data["message"] ?? "Unable to load users");
  }

  // Suspend or restore user account
  Future<bool> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    final String token = await _getToken();

    final response = await http.patch(
      Uri.parse("$baseUrl/admin/users/$userId/status"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status": status}),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return true;
    }

    throw Exception(data["message"] ?? "Unable to update user status");
  }

  // Get admin dashboard summary
  Future<Map<String, dynamic>> getDashboardSummary() async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/dashboard"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data;
    }

    throw Exception(data["message"] ?? "Unable to load dashboard");
  }

  // Get private ownership document image
  Future<Uint8List> getOwnershipDocument(int propertyId) async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/properties/$propertyId/ownership-document"),
      headers: {"Accept": "image/*", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    String message = "Unable to load ownership document";

    try {
      final Map<String, dynamic> data = jsonDecode(response.body);

      message = data["message"] ?? message;
    } catch (_) {}

    throw Exception(message);
  }

  // Get private payment proof image
  Future<Uint8List> getPaymentProof(int propertyId) async {
    final String token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/admin/properties/$propertyId/payment-proof"),
      headers: {"Accept": "image/*", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }

    String message = "Unable to load payment proof";

    try {
      final Map<String, dynamic> data = jsonDecode(response.body);

      message = data["message"] ?? message;
    } catch (_) {}

    throw Exception(message);
  }
}
