import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase for Google Login
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // Authentication Check
      home: AuthCheckScreen(),
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() =>
      _AuthCheckScreenState();
}

class _AuthCheckScreenState
    extends State<AuthCheckScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();

    checkAuthentication();
  }

  // Check Login
  Future<void> checkAuthentication() async {
    try {
      // Get Stored Token
      String? token = await authService.getToken();

      // No Token
      if (token == null || token.isEmpty) {
        goToLogin();
        return;
      }

      // Validate Token
      Map<String, dynamic> user =
          await authService.getCurrentUserFromLaravel();

      String role =
          user["role"]?.toString() ?? "";

      String status =
          user["status"]?.toString() ?? "";

      // Suspended
      if (status == "suspended") {
        await authService.logout();

        goToLogin();

        return;
      }

      // Role Routing
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

      // Invalid Role
      await authService.logout();

      goToLogin();
    } catch (e) {
      // Invalid Token
      await authService.deleteToken();

      goToLogin();
    }
  }

  // Login
  void goToLogin() {
    Get.offAll(
      () => LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF03045E),
        ),
      ),
    );
  }
}