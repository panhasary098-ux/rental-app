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

  // Used to rebuild My Properties after a new post
  int propertiesRefreshKey = 0;

  final AuthService authService = AuthService();

  bool isCheckingNationalId = false;

  Future<void> changePage(int index) async {
    // Post tab
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

      final bool hasNationalId = await authService.checkNationalIdStatus();

      if (!mounted) {
        return;
      }

      if (hasNationalId) {
        final dynamic result = await Get.to(() => const Postpropertyscreen());

        if (!mounted) {
          return;
        }

        // Property submitted successfully
        if (result == true) {
          setState(() {
            // Select My Properties
            selectedIndex = 1;

            // Force My Properties to reload from Laravel
            propertiesRefreshKey++;
          });
        }

        return;
      }

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
          OwnerHomeScreen(
            onSeeAll: () {
              changePage(1);
            },

            onPostProperty: () {
              openPostProperty();
            },
          ),

          // My Properties
          OwnerPropertiesScreen(key: ValueKey(propertiesRefreshKey)),

          // Post opens separately
          const SizedBox(),

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
