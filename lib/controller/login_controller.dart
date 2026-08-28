import 'package:final_project/model/property.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/house_owner/owner_home_screen.dart';
import 'package:final_project/view/renter/home_screen.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
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

    UserCredential userCredential =
        await authService.loginWithEamil(
      email: email,
      password: password,
    );

    User? firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception("Firebase user not found");
    }

    Map<String, dynamic> userData =
        await authService.getUserFromLaravel(
      firebaseUser.uid,
    );

    String role = userData["role"];
    String status = userData["status"];

    print("UID: ${firebaseUser.uid}");
    print("Role: $role");
    print("Status: $status");

    if (status == "suspended") {
      await authService.logout();

      Get.snackbar(
        "Account Suspended",
        "Your account has been suspended",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return;
    }

    Get.snackbar(
      "Success",
      "Login successful",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    if (role == "admin") {
      Get.offAll(
        () => AdminBottomNav(),
      );
    } else if (role == "house_owner") {
      Get.offAll(
        () => OwnerHomeScreen(),
      );
    } else if (role == "renter") {
      Get.offAll(
        () => HomeScreen(properties: propertyList,),
      );
    } else {
      await authService.logout();

      Get.snackbar(
        "Role Error",
        "User role is not recognized",
      );
    }
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

    Get.snackbar(
      "Login Failed",
      message,
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  } finally {
    isLoading.value = false;
  }
}

// Google
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await authService.loginWithGoogle();
      Get.snackbar(
        "Success",
        "Google login succesful",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      print("UID: ${userCredential.user?.uid}");
      print("Name: ${userCredential.user?.displayName}");
      print("Email: ${userCredential.user?.email}");
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Google Login Failed",
        e.message ?? "Unable to login with google",
      );
    } catch (e) {
      Get.snackbar("Google Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFacebook() async {
  try {
    isLoading.value = true;

    UserCredential userCredential =
        await authService.loginWithFacebook();

    Get.snackbar(
      "Success",
      "Facebook login successful",
      snackPosition: SnackPosition.TOP,
    );

    print("UID: ${userCredential.user?.uid}");
    print("Name: ${userCredential.user?.displayName}");
    print("Email: ${userCredential.user?.email}");

  } on FirebaseAuthException catch (e) {
    Get.snackbar(
      "Facebook Login Failed",
      e.message ?? "Unable to login with Facebook",
      snackPosition: SnackPosition.TOP,
    );
  } catch (e) {
    Get.snackbar(
      "Facebook Login Failed",
      e.toString(),
      snackPosition: SnackPosition.TOP,
    );
  } finally {
    isLoading.value = false;
  }
}

// Forgot password
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
