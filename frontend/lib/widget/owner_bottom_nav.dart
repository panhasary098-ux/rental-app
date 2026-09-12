import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/house_owner/house_owner_account_screen.dart';
import 'package:final_project/view/house_owner/my_property.dart';
import 'package:final_project/view/house_owner/owner_homescreen.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';
import 'package:final_project/view/house_owner/verify_identity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerBottomNav extends StatefulWidget {
  OwnerBottomNav({super.key});

  @override
  State<OwnerBottomNav> createState() => _OwnerBottomNavState();
}

class _OwnerBottomNavState extends State<OwnerBottomNav> {
  int selectedIndex = 0;

  // Service used to check the owner's National ID
  final AuthService authService = AuthService();

  // Prevent multiple Post requests at the same time
  bool isCheckingNationalId = false;

  // Change bottom navigation page
  Future<void> changePage(int index) async {
    // Post needs to check National ID first
    if (index == 2) {
      await openPostProperty();
      return;
    }

    setState(() {
      selectedIndex = index;
    });
  }

  // Check National ID before opening Post Property
  Future<void> openPostProperty() async {
    if (isCheckingNationalId) {
      return;
    }

    try {
      setState(() {
        isCheckingNationalId = true;
      });

      // Check if the owner already uploaded a National ID
      final bool hasNationalId = await authService.checkNationalIdStatus();

      if (!mounted) {
        return;
      }

      // National ID already exists
      if (hasNationalId) {
        await Get.to(() => const Postpropertyscreen());

        return;
      }

      // National ID does not exist
      await Get.to(() => const VerifyIdentityScreen());
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      Get.snackbar(
        "Unable to Continue",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isCheckingNationalId = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FCFE),

      body: IndexedStack(
        index: selectedIndex,

        children: [
          // Home
          OwnerHomeScreen(
            // Open My Properties tab
            onSeeAll: () {
              changePage(1);
            },

            // Use the same National ID check as Post tab
            onPostProperty: () {
              openPostProperty();
            },
          ),

          // My Properties
          OwnerPropertiesScreen(),

          // Post is opened separately after checking National ID
          const SizedBox(),

          // Account
          OwnerAccountScreen(),
        ],
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFF03045E),

          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white, size: 25);
            }

            return IconThemeData(
              color: const Color(0xFF03045E).withOpacity(0.45),
              size: 24,
            );
          }),

          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: Color(0xFF03045E),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              );
            }

            return TextStyle(
              color: const Color(0xFF03045E).withOpacity(0.50),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            );
          }),
        ),

        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          elevation: 5,

          selectedIndex: selectedIndex,

          onDestinationSelected: changePage,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Icon(Icons.home_work_outlined),
              selectedIcon: Icon(Icons.home_work_rounded),
              label: 'Properties',
            ),

            NavigationDestination(
              icon: Icon(Icons.add_home_work_outlined),
              selectedIcon: Icon(Icons.add_home_work_rounded),
              label: 'Post',
            ),

            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
