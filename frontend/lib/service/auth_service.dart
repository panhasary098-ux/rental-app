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

  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }

  // Current user
  User? getCurrentUser() {
    return auth.currentUser;
  }
}
