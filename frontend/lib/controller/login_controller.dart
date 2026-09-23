import 'package:final_project/service/auth_service.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final RxBool hidePassword = true.obs;
  final RxBool isLoading = false.obs;

  final AuthService authService = AuthService();

  String? googleAccessToken;
  String socialProvider = "";

  // Password
  void togglePassword() {
    hidePassword.value =
        !hidePassword.value;
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
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      borderRadius: 18,
      borderColor: Color(0xFFE5E7EB),
      borderWidth: 1,
      duration: Duration(seconds: 3),

      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],

      icon: Container(
        width: 36,
        height: 36,

        decoration: BoxDecoration(
          color: Color(0xFFEAF7EE),
          shape: BoxShape.circle,
        ),

        child: Icon(
          Icons.check_rounded,
          color: Color(0xFF15803D),
          size: 20,
        ),
      ),

      titleText: Text(
        title,

        style: TextStyle(
          color: Color(0xFF15803D),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),

      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },

        child: Icon(
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
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      borderRadius: 18,
      borderColor: Color(0xFFF3D2D2),
      borderWidth: 1,
      duration: Duration(seconds: 3),

      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],

      icon: Container(
        width: 36,
        height: 36,

        decoration: BoxDecoration(
          color: Color(0xFFFDECEC),
          shape: BoxShape.circle,
        ),

        child: Icon(
          Icons.priority_high_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
      ),

      titleText: Text(
        title,

        style: TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),

      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },

        child: Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  // Login
  Future<void> login() async {
    if (isLoading.value) {
      return;
    }

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text.trim();

    // Validation
    if (email.isEmpty ||
        password.isEmpty) {
      showErrorNotification(
        title: "Missing Information",
        message:
            "Please enter your email and password.",
      );

      return;
    }

    if (!GetUtils.isEmail(email)) {
      showErrorNotification(
        title: "Invalid Email",
        message:
            "Please enter a valid email address.",
      );

      return;
    }

    try {
      isLoading.value = true;

      // Laravel Login
      final Map<String, dynamic> userData =
          await authService.loginWithEamil(
        email: email,
        password: password,
      );

      final String role =
          userData["role"]?.toString() ?? "";

      final String status =
          userData["status"]?.toString() ?? "";

      print("Laravel user ID: ${userData["id"]}");
      print("Role: $role");
      print("Status: $status");

      // Status
      if (status == "suspended") {
        await authService.logout();

        showErrorNotification(
          title: "Account Suspended",
          message:
              "Your account has been suspended.",
        );

        return;
      }

      showSuccessNotification(
        title: "Welcome Back!",
        message:
            "You have successfully logged in.",
      );

      // Role Routing
      routeUser(role);
    } catch (e) {
      String message = e.toString();

      if (message.startsWith(
        "Exception: ",
      )) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      showErrorNotification(
        title: "Login Failed",
        message: message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Role Routing
  void routeUser(String role) {
    if (role == "admin") {
      Get.offAll(
        () => AdminBottomNav(),
      );

      return;
    }

    if (role == "house_owner") {
      Get.offAll(
        () => OwnerBottomNav(),
      );

      return;
    }

    if (role == "renter") {
      Get.offAll(
        () => BottomNav(),
      );

      return;
    }

    authService.logout();

    showErrorNotification(
      title: "Role Error",
      message:
          "User role is not recognized.",
    );
  }

  // Google Login
  Future<void> loginWithGoogle() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> result =
          await authService.loginWithGoogle();

      final bool needsRegistration =
          result["needs_registration"] == true;

      // New Google User
      if (needsRegistration) {
        googleAccessToken =
            result["google_access_token"]
                ?.toString();

        if (googleAccessToken == null ||
            googleAccessToken!.isEmpty) {
          throw Exception(
            "Google access token not found",
          );
        }

        socialProvider = "google";

        isLoading.value = false;

        showSocialRoleDialog();

        return;
      }

      // Existing Google User
      if (result["user"] == null) {
        throw Exception(
          "Google user data not found",
        );
      }

      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(
        result["user"],
      );

      final String role =
          userData["role"]?.toString() ?? "";

      final String status =
          userData["status"]?.toString() ?? "";

      print(
        "Laravel user ID: ${userData["id"]}",
      );

      print("Google Login");
      print("Role: $role");
      print("Status: $status");

      if (status == "suspended") {
        await authService.logout();

        showErrorNotification(
          title: "Account Suspended",
          message:
              "Your account has been suspended.",
        );

        return;
      }

      showSuccessNotification(
        title: "Welcome Back!",
        message:
            "You have successfully logged in.",
      );

      routeUser(role);
    } catch (e) {
      String message = e.toString();

      if (message.startsWith(
        "Exception: ",
      )) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      showErrorNotification(
        title: "Google Login Failed",
        message: message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Facebook Login
  Future<void> loginWithFacebook() async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final UserCredential userCredential =
          await authService
              .loginWithFacebook();

      final User? firebaseUser =
          userCredential.user;

      if (firebaseUser == null) {
        throw Exception(
          "Firebase user not found",
        );
      }

      final Map<String, dynamic> result =
          await authService
              .checkSocialUser();

      final bool exists =
          result["exists"] == true;

      if (exists) {
        final Map<String, dynamic> userData =
            Map<String, dynamic>.from(
          result["user"],
        );

        final String role =
            userData["role"]?.toString() ??
                "";

        final String status =
            userData["status"]?.toString() ??
                "";

        print(
          "Firebase UID: ${firebaseUser.uid}",
        );

        print("Role: $role");
        print("Status: $status");

        if (status == "suspended") {
          await authService.logout();

          showErrorNotification(
            title: "Account Suspended",
            message:
                "Your account has been suspended.",
          );

          return;
        }

        showSuccessNotification(
          title: "Welcome Back!",
          message:
              "You have successfully logged in.",
        );

        routeUser(role);

        return;
      }

      // New Social User
      socialProvider = "facebook";

      showSocialRoleDialog();
    } on FirebaseAuthException catch (e) {
      showErrorNotification(
        title: "Facebook Login Failed",
        message:
            e.message ??
                "Unable to login with Facebook.",
      );
    } catch (e) {
      String message = e.toString();

      if (message.startsWith(
        "Exception: ",
      )) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      showErrorNotification(
        title: "Facebook Login Failed",
        message: message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Social Role Dialog
  void showSocialRoleDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        title: Text(
          "Choose Account Type",
          textAlign: TextAlign.center,
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Text(
              "How would you like to use Rental App?",
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Renter
            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole(
                  "renter",
                );
              },

              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              child: Container(
                width: double.infinity,

                padding:
                    EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  border: Border.all(
                    color:
                        Colors.grey.shade300,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color:
                          Color(0xFF03045E),
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            "Renter",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Text(
                            "Find a property to rent",

                            style: TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            // House Owner
            InkWell(
              onTap: () async {
                Get.back();

                await registerSocialRole(
                  "house_owner",
                );
              },

              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              child: Container(
                width: double.infinity,

                padding:
                    EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  border: Border.all(
                    color:
                        Colors.grey.shade300,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [
                    Icon(
                      Icons
                          .home_work_outlined,
                      color:
                          Color(0xFF03045E),
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Text(
                            "House Owner",

                            style: TextStyle(
                              fontSize: 16,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Text(
                            "List and manage your properties",

                            style: TextStyle(
                              color:
                                  Colors.grey,
                            ),
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

              googleAccessToken = null;
              socialProvider = "";

              await authService.logout();
            },

            child: Text(
              "Cancel",

              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),

      barrierDismissible: false,
    );
  }

  // Register Social Role
  Future<void> registerSocialRole(
    String role,
  ) async {
    try {
      isLoading.value = true;

      Map<String, dynamic> userData;

      // Google Registration
      if (socialProvider == "google") {
        if (googleAccessToken == null ||
            googleAccessToken!.isEmpty) {
          throw Exception(
            "Google access token not found",
          );
        }

        userData =
            await authService
                .registerWithGoogle(
          accessToken:
              googleAccessToken!,
          role: role,
        );
      }

      // Facebook Registration
      else {
        userData =
            await authService
                .createSocialUser(
          role,
        );
      }

      final String userRole =
          userData["role"]?.toString() ??
              "";

      print(
        "Social account created",
      );

      print(
        "Role: $userRole",
      );

      googleAccessToken = null;
      socialProvider = "";

      showSuccessNotification(
        title: "Account Created",
        message:
            "Your account was created successfully.",
      );

      routeUser(userRole);
    } catch (e) {
      googleAccessToken = null;
      socialProvider = "";

      await authService.logout();

      String message = e.toString();

      if (message.startsWith(
        "Exception: ",
      )) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      showErrorNotification(
        title:
            "Account Creation Failed",
        message: message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot Password
  Future<void> forgotPassword() async {
    final String email =
        emailController.text.trim();

    if (email.isEmpty) {
      showErrorNotification(
        title: "Email Required",
        message:
            "Please enter your email first.",
      );

      return;
    }

    showErrorNotification(
      title: "Coming Soon",
      message:
          "Laravel password reset will be connected next.",
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}