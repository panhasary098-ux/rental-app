import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/ai_screen/ai_chat_screen.dart';
import 'package:final_project/view/renter/home_screen.dart';
import 'package:final_project/view/renter/interested_sent_screen.dart';
import 'package:final_project/view/renter/map_screen.dart';
import 'package:final_project/view/renter/renter_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Colors
const Color primaryColor = Color(0xFF03045E);
const Color backgroundColor = Colors.white;
const Color inactiveColor = Color(0xFF9698B8);

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() {
    return _BottomNavState();
  }
}

class _BottomNavState extends State<BottomNav> {
  final PropertyService propertyService = PropertyService();

  int selectedIndex = 0;

  bool isLoading = true;

  String? errorMessage;

  List<Property> properties = [];

  @override
  void initState() {
    super.initState();

    loadProperties();
  }

  // Load Properties
  Future<void> loadProperties() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response = await propertyService.getRenterProperties();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List<dynamic> propertyData = decoded["properties"] ?? [];

        final List<Property> loadedProperties = propertyData.map((item) {
          return Property.fromJson(Map<String, dynamic>.from(item));
        }).toList();

        if (!mounted) {
          return;
        }

        setState(() {
          properties = loadedProperties;

          isLoading = false;
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage = decoded["message"] ?? "Failed to load properties";

          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = "Unable to load properties";

        isLoading = false;
      });

      print("RENTER PROPERTY LOAD ERROR: $e");
    }
  }

  // Change Page
  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Open AI
  void openAi() {
    Get.to(() => AiChatScreen());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      buildHomeScreen(),

      const MapScreen(),

      // AI opens separately
      const SizedBox(),

      const FavorithScreen(),

      RenterAccountScreen(
        onSavedPropertiesTap: () {
          changePage(3);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      body: IndexedStack(index: selectedIndex, children: screens),

      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // Bottom Navigation
  Widget buildBottomNavigation() {
    return SafeArea(
      top: false,

      child: SizedBox(
        height: 62,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            // Home
            buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: "Home",
            ),

            // Map
            buildNavItem(
              index: 1,
              icon: Icons.map_outlined,
              selectedIcon: Icons.map_rounded,
              label: "Map",
            ),

            // AI
            buildAiNavItem(),

            // Saved
            buildNavItem(
              index: 3,
              icon: Icons.favorite_border_rounded,
              selectedIcon: Icons.favorite_rounded,
              label: "Saved",
            ),

            // Account
            buildNavItem(
              index: 4,
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }

  // Navigation Item
  Widget buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          changePage(index);
        },

        borderRadius: BorderRadius.circular(16),

        child: Container(
          height: 56,

          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1F2FA) : Colors.transparent,

            borderRadius: BorderRadius.circular(16),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Icon(
                isSelected ? selectedIcon : icon,

                color: isSelected ? primaryColor : inactiveColor,

                size: 24,
              ),

              const SizedBox(height: 4),

              Text(
                label,

                style: TextStyle(
                  color: isSelected ? primaryColor : inactiveColor,

                  fontSize: 11,

                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AI Navigation Item
  Widget buildAiNavItem() {
    return Expanded(
      child: InkWell(
        onTap: openAi,

        borderRadius: BorderRadius.circular(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: primaryColor,

                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(height: 2),

            const Text(
              "AI",

              style: TextStyle(
                color: primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Home Screen
  Widget buildHomeScreen() {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: backgroundColor,

        body: SafeArea(
          child: Center(child: CircularProgressIndicator(color: primaryColor)),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: backgroundColor,

        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: primaryColor,
                    size: 50,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Unable to load properties",

                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    errorMessage!,

                    textAlign: TextAlign.center,

                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: loadProperties,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    icon: const Icon(Icons.refresh_rounded),

                    label: const Text("Try Again"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return HomeScreen(properties: properties);
  }
}
