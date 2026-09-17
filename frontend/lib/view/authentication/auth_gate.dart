import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:final_project/widget/admin_bottom_nav.dart';
import 'package:final_project/widget/bottom_nav.dart';
import 'package:final_project/widget/owner_bottom_nav.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  AuthGate({
    super.key,
  });

  @override
  State<AuthGate> createState() {
    return _AuthGateState();
  }
}

class _AuthGateState extends State<AuthGate> {
  final AuthService authService = AuthService();

  Widget? nextScreen;

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {
    try {
      // Check if Laravel token exists
      final bool hasToken =
          await authService.hasToken();

      if (!hasToken) {
        if (!mounted) {
          return;
        }

        setState(() {
          nextScreen = LoginScreen();
        });

        return;
      }

      // Token exists.
      // Ask Laravel for current user.
      final Map<String, dynamic> user =
          await authService.getMe();

      if (!mounted) {
        return;
      }

      final String role =
          user["role"]?.toString() ?? "";

      final String status =
          user["status"]?.toString() ?? "";

      print("RESTORED USER: ${user["email"]}");
      print("RESTORED ROLE: $role");
      print("RESTORED STATUS: $status");

      // Suspended account
      if (status == "suspended") {
        await authService.deleteToken();

        if (!mounted) {
          return;
        }

        setState(() {
          nextScreen = LoginScreen();
        });

        return;
      }

      // Renter
      if (role == "renter") {
        setState(() {
          nextScreen = BottomNav();
        });

        return;
      }

      // House Owner
      if (role == "house_owner") {
        setState(() {
          nextScreen = OwnerBottomNav();
        });

        return;
      }

      // Admin
      if (role == "admin") {
        setState(() {
          nextScreen = AdminBottomNav();
        });

        return;
      }

      // Unknown role
      await authService.deleteToken();

      if (!mounted) {
        return;
      }

      setState(() {
        nextScreen = LoginScreen();
      });
    } catch (e) {
      print("AUTH GATE ERROR: $e");

      if (!mounted) {
        return;
      }

      setState(() {
        nextScreen = LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Still checking authentication
    if (nextScreen == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF03045E),
          ),
        ),
      );
    }

    return nextScreen!;
  }
}