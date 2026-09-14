import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

  FlutterSecureStorage storage = FlutterSecureStorage();

  String baseUrl = "http://10.0.2.2:8000/api";

  // Save Token
  Future<void> saveToken(String token) async {
    await storage.write(
      key: "auth_token",
      value: token,
    );
  }

  // Get Token
  Future<String?> getToken() async {
    return await storage.read(
      key: "auth_token",
    );
  }

  // Delete Token
  Future<void> deleteToken() async {
    await storage.delete(
      key: "auth_token",
    );
  }

  // Has Token
  Future<bool> hasToken() async {
    String? token = await getToken();

    return token != null && token.isNotEmpty;
  }

  // Auth Headers
  Future<Map<String, String>> getAuthHeaders() async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception("User is not logged in");
    }

    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // Register
  Future<Map<String, dynamic>> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "role": role,
      }),
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      String token = data["token"];

      // Save Token
      await saveToken(token);

      return Map<String, dynamic>.from(
        data["user"],
      );
    }

    throw Exception(
      data["message"] ?? "Registration failed",
    );
  }

  // Login
  Future<Map<String, dynamic>> loginWithEamil({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = data["token"];

      // Save Token
      await saveToken(token);

      return Map<String, dynamic>.from(
        data["user"],
      );
    }

    if (response.statusCode == 401) {
      throw Exception(
        data["message"] ?? "Invalid email or password",
      );
    }

    if (response.statusCode == 403) {
      throw Exception(
        data["message"] ?? "Account suspended",
      );
    }

    throw Exception(
      data["message"] ?? "Login failed",
    );
  }

  // Google Login
  Future<UserCredential> loginWithGoogle() async {
    await googleSignIn.initialize();

    GoogleSignInAccount googleUser =
        await googleSignIn.authenticate();

    GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    OAuthCredential credential =
        GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await auth.signInWithCredential(
      credential,
    );
  }

  // Facebook Login
  Future<UserCredential> loginWithFacebook() async {
    LoginResult loginResult =
        await FacebookAuth.instance.login(
      permissions: [
        "email",
        "public_profile",
      ],
    );

    if (loginResult.status !=
        LoginStatus.success) {
      throw Exception(
        loginResult.message ??
            "Facebook login failed",
      );
    }

    AccessToken? accessToken =
        loginResult.accessToken;

    if (accessToken == null) {
      throw Exception(
        "Facebook access token not found",
      );
    }

    OAuthCredential credential =
        FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    return await auth.signInWithCredential(
      credential,
    );
  }

  // Check Social User
  Future<Map<String, dynamic>>
      checkSocialUser() async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception(
        "Firebase social user not found",
      );
    }

    String? firebaseToken =
        await user.getIdToken();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/social-sync"),
      headers: {
        "Authorization":
            "Bearer $firebaseToken",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Laravel Token
      if (data["token"] != null) {
        await saveToken(data["token"]);
      }

      return data;
    }

    throw Exception(
      data["message"] ??
          "Failed to check social user",
    );
  }

  // Create Social User
  Future<Map<String, dynamic>>
      createSocialUser(String role) async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception(
        "Firebase social user not found",
      );
    }

    String? firebaseToken =
        await user.getIdToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/auth/social-register",
      ),
      headers: {
        "Authorization":
            "Bearer $firebaseToken",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "role": role,
      }),
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      // Laravel Token
      if (data["token"] != null) {
        await saveToken(data["token"]);
      }

      return Map<String, dynamic>.from(
        data["user"],
      );
    }

    throw Exception(
      data["message"] ??
          "Failed to create social user",
    );
  }

  // Current User
  Future<Map<String, dynamic>>
      getCurrentUserFromLaravel() async {
    Map<String, String> headers =
        await getAuthHeaders();

    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: headers,
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        data["user"],
      );
    }

    if (response.statusCode == 401) {
      // Invalid Token
      await deleteToken();

      throw Exception(
        data["message"] ?? "Unauthorized",
      );
    }

    if (response.statusCode == 403) {
      throw Exception(
        data["message"] ?? "Access forbidden",
      );
    }

    throw Exception(
      data["message"] ??
          "Failed to get user",
    );
  }

  // Get Me
  Future<Map<String, dynamic>> getMe() async {
    return await getCurrentUserFromLaravel();
  }

  // Update User
  Future<Map<String, dynamic>>
      updateCurrentUser({
    required String name,
    required String phone,
  }) async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "User is not logged in",
      );
    }

    final response = await http.put(
      Uri.parse("$baseUrl/me"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "name": name,
        "phone": phone,
      }),
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        data["user"],
      );
    }

    throw Exception(
      data["message"] ??
          "Unable to update profile",
    );
  }

  // Upload Profile Image
  Future<String?> uploadProfileImage(
    File image,
  ) async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "User is not logged in",
      );
    }

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/profile-image"),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "profile_image",
        image.path,
      ),
    );

    var streamedResponse =
        await request.send();

    var response =
        await http.Response.fromStream(
      streamedResponse,
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["profile_image"];
    }

    throw Exception(
      data["message"] ??
          "Failed to upload profile image",
    );
  }

  // Check National ID
  Future<bool> checkNationalIdStatus() async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "User is not logged in",
      );
    }

    final response = await http.get(
      Uri.parse(
        "$baseUrl/owner/national-id/status",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["success"] == true) {
      return data["has_national_id"] == true;
    }

    throw Exception(
      data["message"] ??
          "Unable to check National ID status",
    );
  }

  // Upload National ID
  Future<bool> uploadNationalId(
    File image,
  ) async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "User is not logged in",
      );
    }

    final request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "$baseUrl/owner/national-id",
      ),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "national_id",
        image.path,
      ),
    );

    final streamedResponse =
        await request.send();

    final response =
        await http.Response.fromStream(
      streamedResponse,
    );

    Map<String, dynamic> data =
        jsonDecode(response.body);

    if (response.statusCode == 200 &&
        data["success"] == true) {
      return true;
    }

    throw Exception(
      data["message"] ??
          "Unable to upload National ID",
    );
  }

  // Logout
  Future<void> logout() async {
    String? token = await getToken();

    if (token != null && token.isNotEmpty) {
      try {
        await http.post(
          Uri.parse("$baseUrl/logout"),
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      } catch (e) {
        // Continue Logout
      }
    }

    // Delete Laravel Token
    await deleteToken();

    // Firebase Social Logout
    await auth.signOut();
  }

  // Current Firebase User
  User? getCurrentUser() {
    return auth.currentUser;
  }
}