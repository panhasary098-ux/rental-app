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
    if (isLoading.value) {
      return;
    }
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

      User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      Map<String, dynamic> userData = await authService.getMe();

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
        Get.offAll(() => AdminBottomNav());
      } else if (role == "house_owner") {
        Get.offAll(() => OwnerHomeScreen());
      } else if (role == "renter") {
        //Get.offAll(() => HomeScreen(properties: propertyList));
      } else {
        await authService.logout();

        Get.snackbar("Role Error", "User role is not recognized");
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

      Get.snackbar("Login Failed", message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
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

      UserCredential userCredential = await authService.loginWithGoogle();

      User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      Map<String, dynamic> result = await authService.checkSocialUser();

      bool exists = result["exists"];

      if (exists == true) {
        Map<String, dynamic> userData = result["user"];

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

        if (role == "admin") {
          Get.offAll(() => AdminBottomNav());
        } else if (role == "house_owner") {
          Get.offAll(() => OwnerHomeScreen());
        } else if (role == "renter") {
          Get.offAll(() => HomeScreen(properties: propertyList));
        } else {
          await authService.logout();

          Get.snackbar("Role Error", "User role is not recognized");
        }

        return;
      }
      showSocialRoleDialog();
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

  void showSocialRoleDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Choose Account Type", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "How would you like to use Rental App?",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole("renter");
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.green),

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

            SizedBox(height: 12),

            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole("house_owner");
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.home_work_outlined, color: Colors.green),

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
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> registerSocialRole(String role) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> userData = await authService.createSocialUser(role);

      String userRole = userData["role"];

      print("Social account created");
      print("Role: $userRole");

      Get.snackbar(
        "Success",
        "Account created successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (userRole == "house_owner") {
        Get.offAll(() => OwnerHomeScreen());
      } else if (userRole == "renter") {
        Get.offAll(() => HomeScreen(properties: propertyList));
      }
    } catch (e) {
      await authService.logout();

      Get.snackbar(
        "Account Creation Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
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

      UserCredential userCredential = await authService.loginWithFacebook();

      print("2. Facebook Firebase login successful");

      User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception("Firebase user not found");
      }

      print("3. Firebase UID: ${firebaseUser.uid}");
      print("4. Checking Laravel user");

      Map<String, dynamic> result = await authService.checkSocialUser();

      print("5. Laravel result: $result");

      bool exists = result["exists"];

      print("6. Exists: $exists");

      if (exists == true) {
        Map<String, dynamic> userData = result["user"];

        String role = userData["role"];
        String status = userData["status"];

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

        if (role == "admin") {
          Get.offAll(() => AdminBottomNav());
        } else if (role == "house_owner") {
          Get.offAll(() => OwnerHomeScreen());
        } else if (role == "renter") {
          Get.offAll(() => HomeScreen(properties: propertyList));
        }

        return;
      }

      print("7. New Facebook user");
      print("8. Showing role dialog");

      showSocialRoleDialog();
    } on FirebaseAuthException catch (e) {
      print("Firebase error: ${e.code}");
      print("Firebase message: ${e.message}");

      Get.snackbar(
        "Facebook Login Failed",
        e.message ?? "Unable to login with Facebook",
      );
    } catch (e) {
      print("Facebook flow error: $e");

      Get.snackbar("Facebook Login Failed", e.toString());
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
