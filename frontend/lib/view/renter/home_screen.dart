import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/ai_screen/ai_chat_screen.dart';
import 'package:final_project/view/renter/all_properties_screen.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:final_project/view/renter/propertiesFound_screen.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:final_project/view/renter/owner_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Colors
// Colors
const Color primaryColor = Color(0xFF080B78);
const Color accentColor = Color(0xFF00B8F0);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color cardColor = Colors.white;
const Color borderColor = Color(0xFFF0F1F5);
const Color mutedTextColor = Color(0xFF85899B);
const Color imagePlaceholderColor = Color(0xFFF2F3F7);

class HomeScreen extends StatefulWidget {
  final List<Property> properties;

  const HomeScreen({
    super.key,
    required this.properties,
  });

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final PropertyService propertyService = PropertyService();

  final Set<int> favoritePropertyIds = {};

  final Set<int> favoriteLoadingIds = {};

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  // Load Favorites
  Future<void> loadFavorites() async {
    try {
      final response = await propertyService.getFavorites();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded["success"] == true) {
        final List<dynamic> data =
            decoded["properties"] ?? [];

        final Set<int> ids = {};

        for (final item in data) {
          final dynamic id = item["id"];

          if (id != null) {
            ids.add(
              int.parse(
                id.toString(),
              ),
            );
          }
        }

        if (!mounted) {
          return;
        }

        setState(() {
          favoritePropertyIds
            ..clear()
            ..addAll(ids);
        });
      }
    } catch (e) {
      print(
        "HOME FAVORITES LOAD ERROR: $e",
      );
    }
  }

  // Toggle Favorite
  Future<void> toggleFavorite(
    Property property,
  ) async {
    final int? propertyId = property.id;

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (favoriteLoadingIds.contains(
      propertyId,
    )) {
      return;
    }

    final bool isFavorite =
        favoritePropertyIds.contains(
      propertyId,
    );

    setState(() {
      favoriteLoadingIds.add(
        propertyId,
      );
    });

    try {
      final response = isFavorite
          ? await propertyService.removeFavorite(
              propertyId: propertyId,
            )
          : await propertyService.addFavorite(
              propertyId: propertyId,
            );

      final dynamic decoded =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded["success"] == true) {
        if (!mounted) {
          return;
        }

        setState(() {
          if (isFavorite) {
            favoritePropertyIds.remove(
              propertyId,
            );
          } else {
            favoritePropertyIds.add(
              propertyId,
            );
          }

          favoriteLoadingIds.remove(
            propertyId,
          );
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          favoriteLoadingIds.remove(
            propertyId,
          );
        });

        Get.snackbar(
          "Error",
          decoded["message"] ??
              "Unable to update saved property",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        favoriteLoadingIds.remove(
          propertyId,
        );
      });

      Get.snackbar(
        "Error",
        "Unable to update saved property",
        snackPosition: SnackPosition.BOTTOM,
      );

      print(
        "HOME FAVORITE ERROR: $e",
      );
    }
  }

  // Open Student Budget
  void openStudentBudgetProperties() {
    final List<Property> results =
        widget.properties.where(
      (property) {
        return property.price >= 70 &&
            property.price <= 150;
      },
    ).toList();

    Get.to(
      () => const PropertiesfoundScreen(),
      arguments: {
        "properties": results,
        "search": "",
      },
    );
  }

  // Open Popular Rooms
  void openPopularRoomProperties() {
    final List<Property> results =
        widget.properties.where(
      (property) {
        final String type =
            property.runtimeType
                .toString()
                .toLowerCase();

        return type.contains(
          "room",
        );
      },
    ).toList();

    Get.to(
      () => const PropertiesfoundScreen(),
      arguments: {
        "properties": results,
        "search": "",
      },
    );
  }

  // Open AI Assistant
  void openAiAssistant() {
    Get.to(
      () => AiChatScreen(),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final List<Property> recommendedProperties =
        widget.properties
            .take(3)
            .toList();

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            24,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // Header
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 28,
                      color: primaryColor,
                    ),
                  ),

                  appName(),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // Headline
              headline(),

              const SizedBox(
                height: 18,
              ),

              // Search
              searchBox(
                widget.properties,
              ),

              const SizedBox(
                height: 16,
              ),

              // Quick Filters
              Row(
                children: [
                  Expanded(
                    child: studentBudgetCard(
                      onTap:
                          openStudentBudgetProperties,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: popularTypeCard(
                      onTap:
                          openPopularRoomProperties,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 24,
              ),

              // Recommended Header
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Recommended for you",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      await Get.to(
                        () => AllPropertiesScreen(
                          properties:
                              widget.properties,
                        ),
                      );

                      await loadFavorites();
                    },

                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 5,
              ),

              // Properties
              if (recommendedProperties.isEmpty)
                buildEmptyPropertyState()
              else
                ListView.builder(
                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount:
                      recommendedProperties.length,

                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final Property property =
                        recommendedProperties[index];

                    return buildPropertyCard(
                      property,
                    );
                  },
                ),

              const SizedBox(
                height: 6,
              ),

              // AI Assistant
              buildAiAssistantButton(),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Open Owner Summary
  Future<void> openOwnerSummary(
    Property property,
  ) async {
    final int? ownerId =
        property.ownerId;

    if (ownerId == null ||
        ownerId <= 0) {
      Get.snackbar(
        "Owner unavailable",
        "Owner information is not available for this property.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          28,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              28,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: FutureBuilder(
            future: propertyService.getOwnerProfile(
              ownerId: ownerId,
            ),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return SizedBox(
                  height: 230,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                );
              }

              String ownerName =
                  property.ownerName;

              String profileImage =
                  property.ownerProfileImage;

              String memberSince =
                  property.ownerMemberSince;

              int totalProperties = 0;

              int availableProperties = 0;

              if (snapshot.hasData) {
                try {
                  final dynamic decoded =
                      jsonDecode(
                    snapshot.data!.body,
                  );

                  if (snapshot.data!.statusCode ==
                          200 &&
                      decoded["success"] ==
                          true) {
                    final dynamic owner =
                        decoded["owner"];

                    if (owner is Map) {
                      ownerName =
                          owner["name"]
                                  ?.toString() ??
                              ownerName;

                      profileImage =
                          fixOwnerImageUrl(
                        owner["profile_image"]
                                ?.toString() ??
                            profileImage,
                      );

                      memberSince =
                          owner["member_since"]
                                  ?.toString() ??
                              memberSince;

                      totalProperties =
                          int.tryParse(
                                owner["total_properties"]
                                        ?.toString() ??
                                    "0",
                              ) ??
                              0;

                      availableProperties =
                          int.tryParse(
                                owner["available_properties"]
                                        ?.toString() ??
                                    "0",
                              ) ??
                              0;
                    }
                  }
                } catch (e) {
                  print(
                    "OWNER PROFILE PARSE ERROR: $e",
                  );
                }
              }

              if (ownerName.trim().isEmpty) {
                ownerName =
                    "House Owner";
              }

              return Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          Color(0xFFE2E4EA),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 22,
                  ),

                  buildOwnerAvatar(
                    ownerName: ownerName,
                    profileImage:
                        profileImage,
                    size: 76,
                    fontSize: 28,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  Text(
                    ownerName,
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Text(
                    "House Owner",
                    style: TextStyle(
                      color:
                          mutedTextColor,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  if (memberSince
                      .isNotEmpty) ...[
                    SizedBox(
                      height: 5,
                    ),

                    Text(
                      "Member since ${formatMemberSince(memberSince)}",
                      style: TextStyle(
                        color:
                            mutedTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child:
                            buildOwnerStat(
                          value:
                              totalProperties
                                  .toString(),
                          label:
                              "Listings",
                        ),
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child:
                            buildOwnerStat(
                          value:
                              availableProperties
                                  .toString(),
                          label:
                              "Available",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 18,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 52,
                    child:
                        ElevatedButton(
                      onPressed: () {
                        final List<Property>
                            ownerProperties =
                            widget.properties
                                .where(
                          (item) =>
                              item.ownerId ==
                              ownerId,
                        )
                                .toList();

                        Get.back();

                        Get.to(
                          () =>
                              OwnerProfileScreen(
                            ownerId:
                                ownerId,
                            ownerName:
                                ownerName,
                            ownerProfileImage:
                                profileImage,
                            ownerProperties:
                                ownerProperties,
                          ),
                        );
                      },
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            primaryColor,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                        ),
                      ),
                      child: Text(
                        "View Owner Profile",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent,
    );
  }

  // Owner Avatar
  Widget buildOwnerAvatar({
    required String ownerName,
    required String profileImage,
    double size = 42,
    double fontSize = 16,
  }) {
    final String cleanName =
        ownerName.trim();

    final String initial =
        cleanName.isNotEmpty
            ? cleanName[0]
                .toUpperCase()
            : "O";

    final String cleanImage =
        fixOwnerImageUrl(
      profileImage,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFF0F1F8),
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(0xFFE7E8F0),
        ),
      ),
      child: ClipOval(
        child: cleanImage.isNotEmpty
            ? Image.network(
                cleanImage,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color:
                            primaryColor,
                        fontSize:
                            fontSize,
                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color:
                        primaryColor,
                    fontSize:
                        fontSize,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
      ),
    );
  }

  // Owner Stat
  Widget buildOwnerStat({
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FB),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 3,
          ),

          Text(
            label,
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Owner Image URL
  String fixOwnerImageUrl(
    String url,
  ) {
    if (url.isEmpty) {
      return "";
    }

    return url
        .replaceFirst(
          "http://localhost:8000",
          "http://10.0.2.2:8000",
        )
        .replaceFirst(
          "http://127.0.0.1:8000",
          "http://10.0.2.2:8000",
        );
  }

  // Member Since
  String formatMemberSince(
    String value,
  ) {
    final DateTime? date =
        DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${months[date.month - 1]} ${date.year}";
  }

  // Property Card
  Widget buildPropertyCard(
    Property property,
  ) {
    final int? propertyId =
        property.id;

    final bool isFavorite =
        propertyId != null &&
        favoritePropertyIds.contains(
          propertyId,
        );

    final bool isLoading =
        propertyId != null &&
        favoriteLoadingIds.contains(
          propertyId,
        );

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 16,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black.withOpacity(
              0.055,
            ),
            offset: const Offset(
              0,
              5,
            ),
          ),
        ],
      ),

      child: InkWell(
        onTap: () async {
          await Get.to(
            () => PropertyDetailScreen(
              property: property,
            ),
          );

          await loadFavorites();
        },

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(
                      20,
                    ),
                  ),

                  child: buildPropertyImage(
                    property,
                  ),
                ),

                // Favorite
                Positioned(
                  top: 10,
                  right: 10,

                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                            toggleFavorite(
                              property,
                            );
                          },

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    child: Container(
                      width: 38,
                      height: 38,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              0.10,
                            ),
                            blurRadius: 7,
                          ),
                        ],
                      ),

                      child: isLoading
                          ? const Padding(
                              padding:
                                  EdgeInsets.all(
                                9,
                              ),

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor,
                              ),
                            )
                          : Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,

                              color: isFavorite
                                  ? Colors.red
                                  : primaryColor,

                              size: 22,
                            ),
                    ),
                  ),
                ),

                // Status
                Positioned(
                  top: 10,
                  left: 10,

                  child: buildStatusBadge(
                    property.status,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                15,
                12,
                15,
                14,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // Owner
                  InkWell(
                    onTap: () {
                      openOwnerSummary(
                        property,
                      );
                    },
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          buildOwnerAvatar(
                            ownerName:
                                property.ownerName,
                            profileImage:
                                property.ownerProfileImage,
                          ),

                          SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.ownerName
                                          .trim()
                                          .isNotEmpty
                                      ? property.ownerName
                                      : "House Owner",
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style:
                                      TextStyle(
                                    color:
                                        primaryColor,
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),

                                SizedBox(
                                  height: 2,
                                ),

                                Text(
                                  "House Owner",
                                  style:
                                      TextStyle(
                                    color:
                                        mutedTextColor,
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.chevron_right_rounded,
                            color:
                                Color(0xFFB3B6C2),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 11,
                  ),

                  Divider(
                    height: 1,
                    color: borderColor,
                  ),

                  SizedBox(
                    height: 11,
                  ),

                  Text(
                    property.name,

                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: primaryColor,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Expanded(
                        child: Text(
                          property.location.address ??
                              "Unknown location",

                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: mutedTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    "\$${property.price.toInt()} / month",

                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AI Assistant
  Widget buildAiAssistantButton() {
    return Align(
      alignment: Alignment.centerRight,

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: openAiAssistant,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          child: Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),

            decoration: BoxDecoration(
              color: primaryColor,

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(
                    0.20,
                  ),
                  blurRadius: 14,
                  offset: const Offset(
                    0,
                    5,
                  ),
                ),
              ],
            ),

            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                // Robot Icon
                Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 22,
                ),

                SizedBox(
                  width: 8,
                ),

                Text(
                  "AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Property Image
Widget buildPropertyImage(
  Property property,
) {
  if (property.images.isEmpty) {
    return Container(
      height: 190,
      width: double.infinity,
      color: imagePlaceholderColor,

      child: const Icon(
        Icons.home_work_outlined,
        size: 45,
        color: primaryColor,
      ),
    );
  }

  return Image.network(
    property.images.first,

    height: 190,
    width: double.infinity,
    fit: BoxFit.cover,

    errorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      return Container(
        height: 190,
        width: double.infinity,
        color: imagePlaceholderColor,

        child: const Icon(
          Icons.home_work_outlined,
          size: 45,
          color: primaryColor,
        ),
      );
    },
  );
}

// Empty Property
Widget buildEmptyPropertyState() {
  return Container(
    width: double.infinity,

    padding: const EdgeInsets.symmetric(
      vertical: 35,
      horizontal: 20,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        20,
      ),

      border: Border.all(
        color: borderColor,
      ),
    ),

    child: const Column(
      children: [
        Icon(
          Icons.home_work_outlined,
          size: 44,
          color: primaryColor,
        ),

        SizedBox(
          height: 12,
        ),

        Text(
          "No properties available",
          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(
          height: 5,
        ),

        Text(
          "New rental properties will appear here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: mutedTextColor,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

// Status Badge
Widget buildStatusBadge(
  String status,
) {
  Color statusColor;

  final String value =
      status.toLowerCase();

  if (value == "available" ||
      value == "available now") {
    statusColor =
        const Color(0xFF16A34A);
  } else if (value == "rented") {
    statusColor =
        const Color(0xFFDC2626);
  } else {
    statusColor =
        const Color(0xFFF59E0B);
  }

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 9,
      vertical: 5,
    ),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        20,
      ),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            0.08,
          ),
          blurRadius: 5,
          offset: const Offset(
            0,
            2,
          ),
        ),
      ],
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(
          width: 5,
        ),

        Text(
          status,

          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

// App Name
Widget appName() {
  return RichText(
    text: const TextSpan(
      children: [
        TextSpan(
          text: "Joul",

          style: TextStyle(
            color: primaryColor,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),

        TextSpan(
          text: "Now",

          style: TextStyle(
            color: accentColor,
            fontSize: 23,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

// Headline
// Headline
Widget headline() {
  return Container(
    width: double.infinity,
    height: 130,
    padding: const EdgeInsets.fromLTRB(
      20,
      16,
      20,
      15,
    ),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.16),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 25,
                  height: 1.22,
                  fontWeight: FontWeight.w800,
                ),
                children: [
                  TextSpan(
                    text: "Find a place\n",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "near your ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "school",
                    style: TextStyle(
                      color: Color(0xFF49CFF4),
                    ),
                  ),
                  TextSpan(
                    text: " or ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "work",
                    style: TextStyle(
                      color: Color(0xFF49CFF4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Comfortable spaces. Brighter tomorrows.",
              style: TextStyle(
                color: Color(0xFFD2D5EC),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Positioned(
          right: 0,
          bottom: -3,
          child: Icon(
            Icons.holiday_village_rounded,
            size: 62,
            color: Colors.white.withOpacity(0.18),
          ),
        ),
      ],
    ),
  );
}

// Search And Filter
Widget searchBox(
  List<Property> properties,
) {
  return Row(
    children: [
      // Search
      Expanded(
        child: Container(
          height: 58,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(
              16,
            ),

            border: Border.all(
              color: borderColor,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.055,
                ),
                blurRadius: 12,
                offset: const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child: TextFormField(
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
            ),

            decoration:
                const InputDecoration(
              prefixIcon: Icon(
                Icons.search_rounded,
                color: primaryColor,
                size: 24,
              ),

              hintText:
                  "Search Property name....",

              hintStyle: TextStyle(
                color: Color(0xFF9B9DA4),
                fontSize: 14,
              ),

              border: InputBorder.none,

              contentPadding:
                  EdgeInsets.symmetric(
                vertical: 19,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(
        width: 12,
      ),

      // Filter
      Container(
        width: 58,
        height: 58,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          border: Border.all(
            color: borderColor,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.055,
              ),
              blurRadius: 12,
              offset: const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius:
                BorderRadius.circular(
              16,
            ),

            onTap: () {
              Get.to(
                () => FilterScreen(
                  properties: properties,
                ),
              );
            },

            child: const Center(
              child: Icon(
                Icons.tune_rounded,
                color: primaryColor,
                size: 23,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// Student Budget
Widget studentBudgetCard({
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,

    borderRadius:
        BorderRadius.circular(
      18,
    ),

    child: Container(
      height: 78,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.045,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: const Row(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 27,
            color: primaryColor,
          ),

          SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "Student Budget",
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                Text(
                  "\$70 - \$150",
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight:
                        FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Popular Type
Widget popularTypeCard({
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,

    borderRadius:
        BorderRadius.circular(
      18,
    ),

    child: Container(
      height: 78,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.045,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: const Row(
        children: [
          Icon(
            Icons.bed_outlined,
            size: 28,
            color: primaryColor,
          ),

          SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "Popular Type",
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedTextColor,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                Text(
                  "Room",
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight:
                        FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}