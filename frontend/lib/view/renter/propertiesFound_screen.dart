import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertiesfoundScreen extends StatefulWidget {
  const PropertiesfoundScreen({super.key});

  @override
  State<PropertiesfoundScreen> createState() => _PropertiesfoundScreenState();
}

class _PropertiesfoundScreenState extends State<PropertiesfoundScreen> {
  final PropertyService propertyService = PropertyService();

  final TextEditingController searchController = TextEditingController();

  final Set<int> favoritePropertyIds = {};

  final Set<int> favoriteLoadingIds = {};

  List<Property> filteredProperties = [];

  String searchText = "";

  @override
  void initState() {
    super.initState();

    loadFilterArguments();

    loadFavorites();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // Get filtered properties from FilterScreen
  void loadFilterArguments() {
    final dynamic arguments = Get.arguments;

    if (arguments is Map) {
      final dynamic properties = arguments["properties"];

      final dynamic search = arguments["search"];

      if (properties is List) {
        filteredProperties = properties.whereType<Property>().toList();
      }

      if (search != null && search.toString().trim().isNotEmpty) {
        searchText = search.toString().trim();

        searchController.text = searchText;
      }
    }
  }

  // Search inside filtered results
  List<Property> get displayedProperties {
    final String query = searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return filteredProperties;
    }

    return filteredProperties.where((property) {
      return property.name.toLowerCase().contains(query);
    }).toList();
  }

  // Load real saved property IDs
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
      print("FILTER RESULT FAVORITES LOAD ERROR: $e");
    }
  }

  // Add or remove favorite
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

      print("FILTER RESULT FAVORITE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Property> properties = displayedProperties;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
            size: 20,
          ),
        ),

        title: Padding(
          padding: const EdgeInsets.only(right: 10),

          child: SizedBox(
            height: 48,

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(11),

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
                controller: searchController,

                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },

                style: const TextStyle(fontSize: 14, color: primaryColor),

                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: primaryColor),

                  hintText: 'Search Property name....',

                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),

                  suffixIcon: searchText.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              searchText = "";
                            });
                          },

                          icon: const Icon(
                            Icons.close_rounded,
                            size: 19,
                            color: primaryColor,
                          ),
                        ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(11),
                  ),

                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),

              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${properties.length} "
                      "${properties.length == 1 ? "property" : "properties"} found",

                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: lightSecondaryColor,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Row(
                      children: [
                        Icon(Icons.tune_rounded, color: primaryColor, size: 15),

                        SizedBox(width: 4),

                        Text(
                          "Filtered",

                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: properties.isEmpty
                  ? buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 5, 18, 25),

                      itemCount: properties.length,

                      itemBuilder: (context, index) {
                        final Property property = properties[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),

                          child: buildPropertyCard(property),
                        );
                      },
                    ),
            ),
          ],
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
      height: 155,
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: InkWell(
        onTap: () async {
          await Get.to(() => PropertyDetailScreen(property: property));

          await loadFavorites();
        },

        borderRadius: BorderRadius.circular(16),

        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(9),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),

                child: SizedBox(
                  width: 135,
                  height: double.infinity,

                  child: Stack(
                    fit: StackFit.expand,

                    children: [
                      buildPropertyImage(property),

                      Positioned(
                        top: 7,
                        left: 7,

                        child: buildStatusBadge(property.status),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 12, 10, 10),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      property.name,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 16,
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            property.location.address ?? "Unknown location",

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "\$${property.price.toStringAsFixed(0)}",

                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                                ),

                                const TextSpan(
                                  text: " /Month",

                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: isLoading
                              ? null
                              : () {
                                  toggleFavorite(property);
                                },

                          borderRadius: BorderRadius.circular(30),

                          child: Container(
                            width: 34,
                            height: 34,

                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                              color: lightSecondaryColor,

                              shape: BoxShape.circle,
                            ),

                            child: isLoading
                                ? const SizedBox(
                                    width: 17,
                                    height: 17,

                                    child: CircularProgressIndicator(
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

                                    size: 21,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPropertyImage(Property property) {
    if (property.images.isEmpty) {
      return Container(
        color: lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,
          size: 38,
          color: primaryColor,
        ),
      );
    }

    return Image.network(
      property.images.first,
      fit: BoxFit.cover,

      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: lightSecondaryColor,

          child: const Icon(
            Icons.home_work_outlined,
            size: 38,
            color: primaryColor,
          ),
        );
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),

        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 6,
            height: 6,

            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 4),

          Text(
            status,

            style: TextStyle(
              color: statusColor,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: const BoxDecoration(
                color: lightSecondaryColor,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.search_off_rounded,
                size: 37,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No properties found",

              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Try changing your price range, property type, floor level, or facilities.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Color(0xFF7D8990),
                fontSize: 12,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: () {
                Get.back();
              },

              icon: const Icon(Icons.tune_rounded, size: 18),

              label: const Text("Change Filters"),

              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,

                side: const BorderSide(color: primaryColor),

                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
