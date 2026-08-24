import 'package:final_project/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool hidePassword = true.obs;
  RxBool isLoading = false.obs;

  AuthService authService = AuthService();

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please enter your email and password",
      );
      return;
    }
    try {
      isLoading.value = true;
      UserCredential userCredential = await authService.loginWithEamil(
        email: email,
        password: password,
      );
      Get.snackbar(
        "Sucess",
        "Login succesful",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      if (e.code == "invalid-email") {
        message = "Please enter a valid email";
      } else if (e.code == "user-not-found") {
        message = "No account found with this email";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password";
      } else if (e.code == "invalid-credential") {
        message = "Incorrect email or password";
      } else if (e.code == "user-disabled") {
        message = "This account has been disabled";
      } else {
        message = e.message ?? "Unable to login";
      }

      Get.snackbar("Login Failed", message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Email required", "Please enter your email first");
      return;
    }
    try {
      await authService.resetPassword(email);
      Get.snackbar(
        "Email sent",
        "Check your email to reset your password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Unable to send reset email");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
