import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/home_screen.dart';
import 'package:final_project/view/renter/interested_sent_screen.dart';
import 'package:final_project/view/renter/map_screen.dart';
import 'package:final_project/view/renter/renter_account_screen.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF03045E);
const Color highlightColor = Color.fromARGB(255, 2, 216, 253);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
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

  // Load real renter properties from Laravel
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      buildHomeScreen(),
      const MapScreen(),
      const FavorithScreen(),
      RenterAccountScreen(),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

      body: screens[selectedIndex],

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white,

          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: primaryColor, size: 25);
            }

            return IconThemeData(
              color: primaryColor.withOpacity(0.45),
              size: 24,
            );
          }),

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
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Map',
            ),

            NavigationDestination(
              icon: Icon(Icons.favorite_border_rounded),
              selectedIcon: Icon(Icons.favorite_rounded),
              label: 'Save',
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

  // Home screen state
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

                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
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
