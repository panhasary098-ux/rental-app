import 'package:final_project/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  RxString selectedRole = "Renter".obs;

  RxBool hidePassword = true.obs;
  RxBool hideConfirmPassword = true.obs;
  RxBool isLoading = false.obs;

  AuthService authService = AuthService();

  void selectRole(String role) {
    selectedRole.value = role;
  }


  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  Future<void> register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Missing Information", "Please fill in all fields");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Password Error", "Passwords do not match");
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "Password Error",
        "Password must contain at least 6 characters",
      );
      return;
    }

    try {
      isLoading.value = true;

      UserCredential userCredential = await authService.registerWithEmail(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        throw Exception("Firebase user was not created");
      }

      await user.updateDisplayName(name);

      String role = selectedRole.value == "Renter" ? "renter" : "house_owner";

      await authService.saveUserToLaravel(
        firebaseUid: user.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
      );

      print("Firebase UID: ${user.uid}");
      print("Name: $name");
      print("Email: $email");
      print("Phone: $phone");
      print("Role: $role");

      Get.snackbar(
        "Success",
        "Account created successfully",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";

      if (e.code == "email-already-in-use") {
        message = "This email is already registered";
      } else if (e.code == "invalid-email") {
        message = "Please enter a valid email";
      } else if (e.code == "weak-password") {
        message = "Your password is too weak";
      } else {
        message = e.message ?? "Registration failed";
      }

      Get.snackbar("Registration Failed", message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
