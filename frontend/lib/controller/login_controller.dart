import 'package:final_project/service/auth_service.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool hidePassword = true.obs;
  final RxBool isLoading = false.obs;

  final AuthService authService = AuthService();

  void togglePassword() {
    hidePassword.value = !hidePassword.value;
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

  Future<void> login() async {
    if (isLoading.value) {
      return;
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorNotification(
        title: "Missing Information",
        message: "Please enter your email and password.",
      );

      return;
    }

    try {
      isLoading.value = true;

      final UserCredential userCredential = await authService.loginWithEamil(
        email: email,
        password: password,
      );

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      final Map<String, dynamic> userData = await authService.getMe();

      final String role = userData["role"];
      final String status = userData["status"];

      print("UID: ${firebaseUser.uid}");
      print("Role: $role");
      print("Status: $status");

      if (status == "suspended") {
        await authService.logout();

        showErrorNotification(
          title: "Account Suspended",
          message: "Your account has been suspended.",
        );

        return;
      }

      showSuccessNotification(
        title: "Welcome Back!",
        message: "You have successfully logged in.",
      );

      if (role == "admin") {
        Get.offAll(() => AdminBottomNav());
      } else if (role == "house_owner") {
        Get.offAll(() => OwnerBottomNav());
      } else if (role == "renter") {
        Get.offAll(() => BottomNav());
      } else {
        await authService.logout();

        showErrorNotification(
          title: "Role Error",
          message: "User role is not recognized.",
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Unable to login.";

      if (e.code == "invalid-email") {
        message = "Please enter a valid email.";
      } else if (e.code == "user-not-found") {
        message = "No account found with this email.";
      } else if (e.code == "wrong-password") {
        message = "Incorrect password.";
      } else if (e.code == "invalid-credential") {
        message = "Incorrect email or password.";
      } else if (e.code == "user-disabled") {
        message = "This account has been disabled.";
      } else {
        message = e.message ?? "Unable to login.";
      }

      showErrorNotification(title: "Login Failed", message: message);
    } catch (e) {
      showErrorNotification(title: "Login Failed", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final UserCredential userCredential = await authService.loginWithGoogle();

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      final Map<String, dynamic> result = await authService.checkSocialUser();

      final bool exists = result["exists"];

      if (exists == true) {
        final Map<String, dynamic> userData = result["user"];

        final String role = userData["role"];
        final String status = userData["status"];

        print("UID: ${firebaseUser.uid}");
        print("Role: $role");
        print("Status: $status");

        if (status == "suspended") {
          await authService.logout();

          showErrorNotification(
            title: "Account Suspended",
            message: "Your account has been suspended.",
          );

          return;
        }

        showSuccessNotification(
          title: "Welcome Back!",
          message: "You have successfully logged in.",
        );

        if (role == "admin") {
          Get.offAll(() => AdminBottomNav());
        } else if (role == "house_owner") {
          Get.offAll(() => OwnerBottomNav());
        } else if (role == "renter") {
          Get.offAll(() => BottomNav());
        } else {
          await authService.logout();

          showErrorNotification(
            title: "Role Error",
            message: "User role is not recognized.",
          );
        }

        return;
      }

      showSocialRoleDialog();
    } on FirebaseAuthException catch (e) {
      showErrorNotification(
        title: "Google Login Failed",
        message: e.message ?? "Unable to login with Google.",
      );
    } catch (e) {
      showErrorNotification(
        title: "Google Login Failed",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showSocialRoleDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Choose Account Type", textAlign: TextAlign.center),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Text(
              "How would you like to use Rental App?",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole("renter");
              },

              borderRadius: BorderRadius.circular(12),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Row(
                  children: [
                    Icon(Icons.search, color: Color(0xFF03045E)),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Renter",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "Find a property to rent",

                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole("house_owner");
              },

              borderRadius: BorderRadius.circular(12),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Row(
                  children: [
                    Icon(Icons.home_work_outlined, color: Color(0xFF03045E)),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "House Owner",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            "List and manage your properties",

                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () async {
              Get.back();

              await authService.logout();
            },

            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),

      barrierDismissible: false,
    );
  }

  Future<void> registerSocialRole(String role) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> userData = await authService.createSocialUser(
        role,
      );

      final String userRole = userData["role"];

      print("Social account created");
      print("Role: $userRole");

      showSuccessNotification(
        title: "Account Created",
        message: "Your account was created successfully.",
      );

      if (userRole == "house_owner") {
        Get.offAll(() => OwnerBottomNav());
      } else if (userRole == "renter") {
        Get.offAll(() => BottomNav());
      }
    } catch (e) {
      await authService.logout();

      showErrorNotification(
        title: "Account Creation Failed",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFacebook() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      print("1. Starting Facebook login");

      final UserCredential userCredential = await authService
          .loginWithFacebook();

      print("2. Facebook Firebase login successful");

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      print("3. Firebase UID: ${firebaseUser.uid}");
      print("4. Checking Laravel user");

      final Map<String, dynamic> result = await authService.checkSocialUser();

      print("5. Laravel result: $result");

      final bool exists = result["exists"];

      print("6. Exists: $exists");

      if (exists == true) {
        final Map<String, dynamic> userData = result["user"];

        final String role = userData["role"];
        final String status = userData["status"];

        print("Role: $role");
        print("Status: $status");

        if (status == "suspended") {
          await authService.logout();

          showErrorNotification(
            title: "Account Suspended",
            message: "Your account has been suspended.",
          );

          return;
        }

        showSuccessNotification(
          title: "Welcome Back!",
          message: "You have successfully logged in.",
        );

        if (role == "admin") {
          Get.offAll(() => AdminBottomNav());
        } else if (role == "house_owner") {
          Get.offAll(() => OwnerBottomNav());
        } else if (role == "renter") {
          Get.offAll(() => BottomNav());
        } else {
          await authService.logout();

          showErrorNotification(
            title: "Role Error",
            message: "User role is not recognized.",
          );
        }

        return;
      }

      print("7. New Facebook user");
      print("8. Showing role dialog");

      showSocialRoleDialog();
    } on FirebaseAuthException catch (e) {
      print("Firebase error: ${e.code}");
      print("Firebase message: ${e.message}");

      showErrorNotification(
        title: "Facebook Login Failed",
        message: e.message ?? "Unable to login with Facebook.",
      );
    } catch (e) {
      print("Facebook flow error: $e");

      showErrorNotification(
        title: "Facebook Login Failed",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showErrorNotification(
        title: "Email Required",
        message: "Please enter your email first.",
      );

      return;
    }

    try {
      await authService.resetPassword(email);

      showSuccessNotification(
        title: "Email Sent",
        message: "Check your email to reset your password.",
      );
    } on FirebaseAuthException catch (e) {
      showErrorNotification(
        title: "Unable to Send Email",
        message: e.message ?? "Unable to send reset email.",
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
