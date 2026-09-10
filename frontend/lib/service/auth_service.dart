import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn.instance;

  String baseUrl = "http://10.0.2.2:8000/api";

  // Register
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  //Save user to Laravel/postgreSQL
  Future<void> saveUserToLaravel({
    required String firebaseUid,
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "firebase_uid": firebaseUid,
          "name": name,
          "email": email,
          "phone": phone,
          "role": role,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception("Failed to save user: ${response.body}");
      }
    } catch (e) {
      throw Exception("Laravel connection failed: $e");
    }
  }

  // Login
  Future<UserCredential> loginWithEamil({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  //Get user from Laravel by firebase UID
  Future<Map<String, dynamic>> getUserFromLaravel(String firebaseUid) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/users/firebase/$firebaseUid"),

        headers: {"Accept": "application/json"},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return data["user"];
      }
      throw Exception("User not found: ${response.body}");
    } catch (e) {
      throw Exception("Failed to get user from Laravel: $e");
    }
  }

  // Forgot password
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  //Google login
  Future<UserCredential> loginWithGoogle() async {
    await googleSignIn.initialize();

    GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    GoogleSignInAuthentication googleAuth = googleUser.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await auth.signInWithCredential(credential);
  }

  // Facebook login
  Future<UserCredential> loginWithFacebook() async {
    LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ["email", "public_profile"],
    );

    if (loginResult.status != LoginStatus.success) {
      throw Exception(loginResult.message ?? "Facebook login failed");
    }

    AccessToken? accessToken = loginResult.accessToken;

    if (accessToken == null) {
      throw Exception("Facebook access token not found");
    }

    OAuthCredential credential = FacebookAuthProvider.credential(
      accessToken.tokenString,
    );

    return await auth.signInWithCredential(credential);
  }

  Future<Map<String, dynamic>> getMe() async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception("Firebase user not found");
    }

    String? token = await user.getIdToken();

    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["user"];
    }

    if (response.statusCode == 403) {
      final data = jsonDecode(response.body);

      throw Exception(data["message"] ?? "Access forbidden");
    }

    if (response.statusCode == 401) {
      final data = jsonDecode(response.body);

      throw Exception(data["message"] ?? "Unauthorized");
    }

    throw Exception("Failed to get user: ${response.body}");
  }

  Future<Map<String, dynamic>> checkSocialUser() async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception("Firebase user not found");
    }

    String? token = await user.getIdToken();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/social-sync"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data["message"] ?? "Failed to check social user");
  }

  Future<Map<String, dynamic>> createSocialUser(String role) async {
    User? user = auth.currentUser;

    if (user == null) {
      throw Exception("Firebase user not found");
    }

    String? token = await user.getIdToken();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/social-register"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"role": role}),
    );

    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data["user"];
    }

    throw Exception(data["message"] ?? "Failed to create social user");
  }

  Future<Map<String, dynamic>> getCurrentUserFromLaravel() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      throw Exception("User is not logged in");
    }

    String? token = await firebaseUser.getIdToken();


    final response = await http.get(
      Uri.parse("$baseUrl/me"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["user"];
    } else {
      throw Exception("Failed to get user: ${response.body}");
    }
  }

  Future<String?> uploadProfileImage(File image) async {
    User? firebaseUser = auth.currentUser;

    if (firebaseUser == null) {
      throw Exception("User is not logged in");
    }

    String? token = await firebaseUser.getIdToken();

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/profile-image"),
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    request.files.add(
      await http.MultipartFile.fromPath("profile_image", image.path),
    );

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["profile_image"];
    } else {
      throw Exception("Failed to upload profile image: ${response.body}");
    }
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }

  // Current user
  User? getCurrentUser() {
    return auth.currentUser;
  }
}
