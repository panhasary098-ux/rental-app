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
const Color inactiveColor = Color(0xFF8D90A0);

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
      final response =
          await propertyService.getRenterProperties();

      final dynamic decoded =
          jsonDecode(response.body);

      if (
          response.statusCode == 200 &&
          decoded["success"] == true
      ) {
        final List<dynamic> propertyData =
            decoded["properties"] ?? [];

        final List<Property> loadedProperties =
            propertyData.map(
          (item) {
            return Property.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            );
          },
        ).toList();

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
          errorMessage =
              decoded["message"] ??
                  "Failed to load properties";

          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage =
            "Unable to load properties";

        isLoading = false;
      });

      print(
        "RENTER PROPERTY LOAD ERROR: $e",
      );
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
    Get.to(
      () => AiChatScreen(),
    );
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
      backgroundColor: Color(
        0xFFF7F7F9,
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar:
          buildBottomNavigation(),
    );
  }

  // Bottom Navigation
  Widget buildBottomNavigation() {
    return Container(
      color: Colors.white,

      child: SafeArea(
        top: false,

        child: Container(
          height: 72,

          margin: EdgeInsets.fromLTRB(
            12,
            7,
            12,
            8,
          ),

          padding: EdgeInsets.symmetric(
            horizontal: 5,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              22,
            ),

            border: Border.all(
              color: Color(
                0xFFE9E9EF,
              ),
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(
                  0.06,
                ),
                blurRadius: 20,
                offset: Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,

            children: [
              // Home
              buildNavItem(
                index: 0,
                icon:
                    Icons.home_outlined,
                selectedIcon:
                    Icons.home_rounded,
                label: "Home",
              ),

              // Map
              buildNavItem(
                index: 1,
                icon:
                    Icons.map_outlined,
                selectedIcon:
                    Icons.map_rounded,
                label: "Map",
              ),

              // AI
              buildAiNavItem(),

              // Saved
              buildNavItem(
                index: 3,
                icon: Icons
                    .favorite_border_rounded,
                selectedIcon:
                    Icons.favorite_rounded,
                label: "Saved",
              ),

              // Account
              buildNavItem(
                index: 4,
                icon: Icons
                    .person_outline_rounded,
                selectedIcon:
                    Icons.person_rounded,
                label: "Account",
              ),
            ],
          ),
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
    final bool isSelected =
        selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          changePage(index);
        },

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        child: SizedBox(
          height: 62,

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              AnimatedContainer(
                duration:
                    Duration(
                  milliseconds: 180,
                ),

                width: isSelected
                    ? 42
                    : 34,

                height: 31,

                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(
                          0xFFF0F0F8,
                        )
                      : Colors.transparent,

                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),

                child: Icon(
                  isSelected
                      ? selectedIcon
                      : icon,

                  color: isSelected
                      ? primaryColor
                      : inactiveColor,

                  size: isSelected
                      ? 22
                      : 21,
                ),
              ),

              SizedBox(
                height: 3,
              ),

              Text(
                label,

                style: TextStyle(
                  color: isSelected
                      ? primaryColor
                      : inactiveColor,

                  fontSize: 10,

                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
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

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        child: SizedBox(
          height: 70,

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Transform.translate(
                offset: Offset(
                  0,
                  -5,
                ),

                child: Container(
                  width: 47,
                  height: 47,

                  decoration: BoxDecoration(
                    color: primaryColor,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor
                            .withOpacity(
                          0.22,
                        ),
                        blurRadius: 13,
                        offset: Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(
                  0,
                  -4,
                ),

                child: Text(
                  "AI",

                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Home Screen
  Widget buildHomeScreen() {
    if (isLoading) {
      return Scaffold(
        backgroundColor:
            backgroundColor,

        body: SafeArea(
          child: Center(
            child:
                CircularProgressIndicator(
              color: primaryColor,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor:
            backgroundColor,

        body: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.all(
                25,
              ),

              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Container(
                    width: 64,
                    height: 64,

                    decoration:
                        BoxDecoration(
                      color: Color(
                        0xFFF1F1F7,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Icon(
                      Icons
                          .wifi_off_rounded,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  Text(
                    "Unable to load properties",

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color: Color(
                        0xFF181820,
                      ),
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  SizedBox(
                    height: 7,
                  ),

                  Text(
                    errorMessage!,

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color: Color(
                        0xFF8B8D99,
                      ),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(
                    height: 22,
                  ),

                  ElevatedButton.icon(
                    onPressed:
                        loadProperties,

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          primaryColor,

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 13,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    icon: Icon(
                      Icons
                          .refresh_rounded,
                      size: 19,
                    ),

                    label: Text(
                      "Try Again",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return HomeScreen(
      properties: properties,
    );
  }
}