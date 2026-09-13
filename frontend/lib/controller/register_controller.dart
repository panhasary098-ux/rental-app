import 'package:final_project/service/auth_service.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxString selectedRole = "Renter".obs;

  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

  final AuthService authService = AuthService();

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  void toggleConfirmPassword() {
    hideConfirmPassword.value = !hideConfirmPassword.value;
  }

  void showSuccessNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFE5E7EB),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],

      icon: Container(
        width: 36,
        height: 36,

        decoration: const BoxDecoration(
          color: Color(0xFFEAF7EE),
          shape: BoxShape.circle,
        ),

        child: const Icon(
          Icons.check_rounded,
          color: Color(0xFF15803D),
          size: 20,
        ),
      ),

      titleText: Text(
        title,

        style: const TextStyle(
          color: Color(0xFF15803D),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),

      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },

        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  void showErrorNotification({required String title, required String message}) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFF3D2D2),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],

      icon: Container(
        width: 36,
        height: 36,

        decoration: const BoxDecoration(
          color: Color(0xFFFDECEC),
          shape: BoxShape.circle,
        ),

        child: const Icon(
          Icons.priority_high_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
      ),

      titleText: Text(
        title,

        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),

      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },

        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  Future<void> register() async {
    final String name = nameController.text.trim();

    final String email = emailController.text.trim();

    final String phone = phoneController.text.trim();

    final String password = passwordController.text.trim();

    final String confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showErrorNotification(
        title: "Missing Information",
        message: "Please fill in all fields.",
      );

      return;
    }

    if (password != confirmPassword) {
      showErrorNotification(
        title: "Password Error",
        message: "Passwords do not match.",
      );

      return;
    }

    if (password.length < 6) {
      showErrorNotification(
        title: "Password Error",
        message: "Password must contain at least 6 characters.",
      );

      return;
    }

    try {
      isLoading.value = true;

      final UserCredential userCredential = await authService.registerWithEmail(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw Exception("Firebase user was not created");
      }

      await user.updateDisplayName(name);

      final String role = selectedRole.value == "Renter"
          ? "renter"
          : "house_owner";

      await authService.saveUserToLaravel(
        firebaseUid: user.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
      );

      showSuccessNotification(
        title: "Account Created",
        message: "Your account was created successfully.",
      );

      if (selectedRole.value == "Renter") {
        Get.offAll(() => BottomNav());
      } else if (selectedRole.value == "House Owner") {
        Get.offAll(() => OwnerBottomNav());
      }

      print("Firebase UID: ${user.uid}");
      print("Name: $name");
      print("Email: $email");
      print("Phone: $phone");
      print("Role: $role");
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed.";

      if (e.code == "email-already-in-use") {
        message = "This email is already registered.";
      } else if (e.code == "invalid-email") {
        message = "Please enter a valid email.";
      } else if (e.code == "weak-password") {
        message = "Your password is too weak.";
      } else {
        message = e.message ?? "Registration failed.";
      }

      showErrorNotification(title: "Registration Failed", message: message);
    } catch (e) {
      showErrorNotification(
        title: "Registration Failed",
        message: e.toString(),
      );
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
