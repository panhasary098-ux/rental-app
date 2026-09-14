import 'package:final_project/service/auth_service.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxString selectedRole = "Renter".obs;

  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;
  final RxBool isLoading = false.obs;

  final AuthService authService = AuthService();

  // Select Role
  void selectRole(String role) {
    selectedRole.value = role;
  }

  // Password
  void togglePassword() {
    hidePassword.value = !hidePassword.value;
  }

  // Confirm Password
  void toggleConfirmPassword() {
    hideConfirmPassword.value =
        !hideConfirmPassword.value;
  }

  // Success Notification
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
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
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

  // Error Notification
  void showErrorNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
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

  // Register
  Future<void> register() async {
    if (isLoading.value) {
      return;
    }

    final String name =
        nameController.text.trim();

    final String email =
        emailController.text.trim();

    final String phone =
        phoneController.text.trim();

    final String password =
        passwordController.text.trim();

    final String confirmPassword =
        confirmPasswordController.text.trim();

    // Validation
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

    if (!GetUtils.isEmail(email)) {
      showErrorNotification(
        title: "Invalid Email",
        message: "Please enter a valid email address.",
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
        message:
            "Password must contain at least 6 characters.",
      );

      return;
    }

    final String role =
        selectedRole.value == "Renter"
            ? "renter"
            : "house_owner";

    try {
      isLoading.value = true;

      // Laravel Register
      final Map<String, dynamic> userData =
          await authService.registerWithEmail(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: confirmPassword,
        role: role,
      );

      final String userRole =
          userData["role"]?.toString() ?? role;

      final String status =
          userData["status"]?.toString() ?? "active";

      print("Laravel user ID: ${userData["id"]}");
      print("Name: ${userData["name"]}");
      print("Email: ${userData["email"]}");
      print("Role: $userRole");
      print("Status: $status");

      showSuccessNotification(
        title: "Account Created",
        message:
            "Your account was created successfully.",
      );

      // Role Routing
      if (userRole == "renter") {
        Get.offAll(
          () => BottomNav(),
        );
      } else if (userRole == "house_owner") {
        Get.offAll(
          () => OwnerBottomNav(),
        );
      } else {
        await authService.logout();

        showErrorNotification(
          title: "Role Error",
          message: "User role is not recognized.",
        );
      }
    } catch (e) {
      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      showErrorNotification(
        title: "Registration Failed",
        message: message,
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