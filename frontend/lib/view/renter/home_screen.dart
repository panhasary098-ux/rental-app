import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/all_properties_screen.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:final_project/view/renter/propertiesFound_screen.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color.fromARGB(255, 242, 242, 242);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class HomeScreen extends StatefulWidget {
  final List<Property> properties;

  const HomeScreen({super.key, required this.properties});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

  Future<void> loadFavorites() async {
    try {
      final response = await propertyService.getFavorites();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List<dynamic> data = decoded["properties"] ?? [];

        final Set<int> ids = {};

        for (final item in data) {
          final dynamic id = item["id"];

          if (id != null) {
            ids.add(int.parse(id.toString()));
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
      print("HOME FAVORITES LOAD ERROR: $e");
    }
  }

  Future<void> toggleFavorite(Property property) async {
    final int? propertyId = property.id;

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (favoriteLoadingIds.contains(propertyId)) {
      return;
    }

    final bool isFavorite = favoritePropertyIds.contains(propertyId);

    setState(() {
      favoriteLoadingIds.add(propertyId);
    });

    try {
      final response = isFavorite
          ? await propertyService.removeFavorite(propertyId: propertyId)
          : await propertyService.addFavorite(propertyId: propertyId);

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        if (!mounted) {
          return;
        }

        setState(() {
          if (isFavorite) {
            favoritePropertyIds.remove(propertyId);
          } else {
            favoritePropertyIds.add(propertyId);
          }

          favoriteLoadingIds.remove(propertyId);
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          favoriteLoadingIds.remove(propertyId);
        });

        Get.snackbar(
          "Error",
          decoded["message"] ?? "Unable to update saved property",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        favoriteLoadingIds.remove(propertyId);
      });

      Get.snackbar(
        "Error",
        "Unable to update saved property",
        snackPosition: SnackPosition.BOTTOM,
      );

      print("HOME FAVORITE ERROR: $e");
    }
  }

  // Quick filter: Student Budget $70 - $150
  void openStudentBudgetProperties() {
    final List<Property> results = widget.properties.where((property) {
      return property.price >= 70 && property.price <= 150;
    }).toList();

    Get.to(
      () => const PropertiesfoundScreen(),
      arguments: {"properties": results, "search": ""},
    );
  }

  // Quick filter: Room
  void openPopularRoomProperties() {
    final List<Property> results = widget.properties.where((property) {
      final String type = property.runtimeType.toString().toLowerCase();

      return type.contains("room");
    }).toList();

    Get.to(
      () => const PropertiesfoundScreen(),
      arguments: {"properties": results, "search": ""},
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Property> recommendedProperties = widget.properties
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 27,
                      color: primaryColor,
                    ),
                  ),

                  appName(),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 27,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              headline(),

              const SizedBox(height: 20),

              searchBox(widget.properties),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: studentBudgetCard(
                      onTap: openStudentBudgetProperties,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: popularTypeCard(onTap: openPopularRoomProperties),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    "Recommended for you",

                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      await Get.to(
                        () =>
                            AllPropertiesScreen(properties: widget.properties),
                      );

                      await loadFavorites();
                    },

                    child: const Text(
                      "See all",

                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              if (recommendedProperties.isEmpty)
                buildEmptyPropertyState()
              else
                ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: recommendedProperties.length,

                  itemBuilder: (context, index) {
                    final Property property = recommendedProperties[index];

                    return buildPropertyCard(property);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPropertyCard(Property property) {
    final int? propertyId = property.id;

    final bool isFavorite =
        propertyId != null && favoritePropertyIds.contains(propertyId);

    final bool isLoading =
        propertyId != null && favoriteLoadingIds.contains(propertyId);

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            blurRadius: 12,

            color: primaryColor.withOpacity(0.08),

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: InkWell(
        onTap: () async {
          await Get.to(() => PropertyDetailScreen(property: property));

          await loadFavorites();
        },

        borderRadius: BorderRadius.circular(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),

                  child: buildPropertyImage(property),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: InkWell(
                    onTap: isLoading
                        ? null
                        : () {
                            toggleFavorite(property);
                          },

                    borderRadius: BorderRadius.circular(30),

                    child: Container(
                      width: 36,
                      height: 36,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(9),

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor,
                              ),
                            )
                          : Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,

                              color: isFavorite ? Colors.red : primaryColor,

                              size: 22,
                            ),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,

                  child: buildStatusBadge(property.status),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    property.name,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: primaryColor,
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          property.location.address ?? "Unknown location",

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "\$${property.price.toInt()} / month",

                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
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
}

Widget buildPropertyImage(Property property) {
  if (property.images.isEmpty) {
    return Container(
      height: 190,
      width: double.infinity,
      color: lightSecondaryColor,

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

    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 190,
        width: double.infinity,
        color: lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,
          size: 45,
          color: primaryColor,
        ),
      );
    },
  );
}

Widget buildEmptyPropertyState() {
  return Container(
    width: double.infinity,

    padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(18),

      border: Border.all(color: primaryColor.withOpacity(0.08)),
    ),

    child: const Column(
      children: [
        Icon(Icons.home_work_outlined, size: 44, color: primaryColor),

        SizedBox(height: 12),

        Text(
          "No properties available",

          style: TextStyle(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 5),

        Text(
          "New rental properties will appear here.",

          textAlign: TextAlign.center,

          style: TextStyle(color: Color(0xFF7D8990), fontSize: 12),
        ),
      ],
    ),
  );
}

Widget buildStatusBadge(String status) {
  Color statusColor;

  final String value = status.toLowerCase();

  if (value == "available" || value == "available now") {
    statusColor = const Color(0xFF16A34A);
  } else if (value == "rented") {
    statusColor = const Color(0xFFDC2626);
  } else {
    statusColor = const Color(0xFFF59E0B);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),

      borderRadius: BorderRadius.circular(20),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

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

Widget appName() {
  return RichText(
    text: const TextSpan(
      children: [
        TextSpan(
          text: "Joul",

          style: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextSpan(
          text: "Now",

          style: TextStyle(
            color: Color.fromARGB(255, 2, 216, 253),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget headline() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      Text(
        "Find a place",

        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),

      Row(
        children: [
          Text(
            "near your ",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          Text(
            "school",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 216, 253),
            ),
          ),

          Text(
            " or ",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          Text(
            "work",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 216, 253),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget searchBox(List<Property> properties) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(12),

      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.08),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: TextFormField(
      style: const TextStyle(color: primaryColor),

      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: primaryColor),

        hintText: 'Search Property name....',

        hintStyle: const TextStyle(color: Colors.black38),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderSide: BorderSide.none,

          borderRadius: BorderRadius.circular(12),
        ),

        suffixIcon: Padding(
          padding: const EdgeInsets.all(7),

          child: Tooltip(
            message: "Filter",

            child: Material(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(9),

              child: InkWell(
                borderRadius: BorderRadius.circular(9),

                onTap: () {
                  Get.to(() => FilterScreen(properties: properties));
                },

                child: const SizedBox(
                  width: 40,
                  height: 40,

                  child: Icon(
                    Icons.tune_rounded,
                    color: primaryColor,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget studentBudgetCard({required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,

    borderRadius: BorderRadius.circular(17),

    child: Container(
      height: 72,

      padding: const EdgeInsets.symmetric(horizontal: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(17),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.account_balance_wallet_outlined,
              size: 22,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Student Budget",

                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "\$70 - \$150",

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
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

Widget popularTypeCard({required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,

    borderRadius: BorderRadius.circular(17),

    child: Container(
      height: 72,

      padding: const EdgeInsets.symmetric(horizontal: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(17),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.bed_outlined,
              size: 23,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 9),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Popular Type",

                  style: TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Room",

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
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
