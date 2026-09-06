import 'package:final_project/model/property.dart';
import 'package:final_project/view/renter/home_screen.dart';
import 'package:final_project/view/renter/interested_sent_screen.dart';
import 'package:final_project/view/renter/map_screen.dart';
import 'package:final_project/view/renter/properties_detail_screen.dart';
import 'package:final_project/view/renter/renter_account_screen.dart';
import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color highlightColor = const Color.fromARGB(255, 2, 216, 253);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class BottomNav extends StatefulWidget {
  final List<Property> properties;

  const BottomNav({super.key, required this.properties});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(properties: widget.properties),
      const MapScreen(),
      const FavorithScreen(),
      RenterAccountScreen(),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      body: screens[selectedIndex],

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Selected icon background
          indicatorColor: secondaryColor,

          // Navigation icons
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryColor, size: 25);
            }

            return IconThemeData(
              color: primaryColor.withOpacity(0.45),
              size: 24,
            );
          }),

          // Navigation text
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              );
            }

            return TextStyle(
              color: primaryColor.withOpacity(0.50),
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

          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },

          destinations: const [
            // ==================================================
            // HOME
            // ==================================================
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),

            // ==================================================
            // MAP
            // ==================================================
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Map',
            ),

            // ==================================================
            // SAVE
            // ==================================================
            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Save',
            ),

            // ==================================================
            // ACCOUNT
            // ==================================================
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
