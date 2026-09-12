import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class FavorithScreen extends StatefulWidget {
  const FavorithScreen({super.key});

  @override
  State<FavorithScreen> createState() => _FavorithScreenState();
}

class _FavorithScreenState extends State<FavorithScreen> {
  final PropertyService propertyService = PropertyService();

  final TextEditingController searchController = TextEditingController();

  List<Property> favoriteProperties = [];

  final Set<int> removingPropertyIds = {};

  bool isLoading = true;

  String? errorMessage;

  String searchText = "";

  @override
  void initState() {
    super.initState();

    loadFavorites();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // Load favorites from Laravel
  Future<void> loadFavorites() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response = await propertyService.getFavorites();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List<dynamic> propertyData = decoded["properties"] ?? [];

        final List<Property> loadedFavorites = propertyData.map((item) {
          return Property.fromJson(Map<String, dynamic>.from(item));
        }).toList();

        if (!mounted) {
          return;
        }

        setState(() {
          favoriteProperties = loadedFavorites;

          isLoading = false;
          errorMessage = null;
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage =
              decoded["message"] ?? "Failed to load saved properties";

          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = "Unable to load saved properties";

        isLoading = false;
      });

      print("LOAD FAVORITES ERROR: $e");
    }
  }

  // Remove favorite from database
  Future<void> removeFavorite(Property property) async {
    final int? propertyId = property.id;

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    if (removingPropertyIds.contains(propertyId)) {
      return;
    }

    setState(() {
      removingPropertyIds.add(propertyId);
    });

    try {
      final response = await propertyService.removeFavorite(
        propertyId: propertyId,
      );

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        if (!mounted) {
          return;
        }

        setState(() {
          favoriteProperties.removeWhere((item) => item.id == propertyId);

          removingPropertyIds.remove(propertyId);
        });

        Get.snackbar(
          "Removed",
          "Property removed from saved properties",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          removingPropertyIds.remove(propertyId);
        });

        Get.snackbar(
          "Error",
          decoded["message"] ?? "Unable to remove property",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        removingPropertyIds.remove(propertyId);
      });

      Get.snackbar(
        "Error",
        "Unable to remove property",
        snackPosition: SnackPosition.BOTTOM,
      );

      print("REMOVE FAVORITE ERROR: $e");
    }
  }

  // Search saved properties
  List<Property> get displayedProperties {
    final String query = searchText.trim().toLowerCase();

    if (query.isEmpty) {
      return favoriteProperties;
    }

    return favoriteProperties.where((property) {
      final String name = property.name.toLowerCase();

      final String location = (property.location.address ?? "").toLowerCase();

      return name.contains(query) || location.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),

            buildSearchBox(),

            const SizedBox(height: 12),

            Expanded(child: buildBody()),
          ],
        ),
      ),
    );
  }

  // Header
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),

      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Saved Properties",

              style: TextStyle(
                color: primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

            decoration: BoxDecoration(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              "${favoriteProperties.length} saved",

              style: const TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Search box
  Widget buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),

          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.07),

              blurRadius: 8,

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

          style: const TextStyle(color: primaryColor, fontSize: 14),

          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search_rounded, color: primaryColor),

            hintText: "Search saved properties...",

            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),

            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderSide: BorderSide.none,

              borderRadius: BorderRadius.circular(12),
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
          ),
        ),
      ),
    );
  }

  // Main body
  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (errorMessage != null) {
      return buildErrorState();
    }

    final List<Property> properties = displayedProperties;

    if (properties.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadFavorites,

        color: primaryColor,

        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),

          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,

              child: buildEmptyState(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadFavorites,

      color: primaryColor,

      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(18, 5, 18, 25),

        itemCount: properties.length,

        separatorBuilder: (context, index) {
          return const SizedBox(height: 13);
        },

        itemBuilder: (context, index) {
          return buildPropertyCard(properties[index]);
        },
      ),
    );
  }

  // Property card
  Widget buildPropertyCard(Property property) {
    final int? propertyId = property.id;

    final bool isRemoving =
        propertyId != null && removingPropertyIds.contains(propertyId);

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: isRemoving
            ? null
            : () async {
                await Get.to(() => PropertyDetailScreen(property: property));

                // Reload favorites after returning
                // in case the user removed it in detail screen.
                await loadFavorites();
              },
        borderRadius: BorderRadius.circular(16),

        child: Container(
          height: 145,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(16),

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
              buildPropertyImage(property),

              Expanded(child: buildPropertyInformation(property, isRemoving)),
            ],
          ),
        ),
      ),
    );
  }

  // Property image
  Widget buildPropertyImage(Property property) {
    return Padding(
      padding: const EdgeInsets.all(9),

      child: SizedBox(
        width: 125,
        height: double.infinity,

        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: property.images.isEmpty
                  ? Container(
                      width: double.infinity,

                      height: double.infinity,

                      color: lightSecondaryColor,

                      child: const Icon(
                        Icons.home_work_outlined,

                        size: 35,

                        color: primaryColor,
                      ),
                    )
                  : Image.network(
                      property.images.first,

                      width: double.infinity,

                      height: double.infinity,

                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: lightSecondaryColor,

                          child: const Icon(
                            Icons.home_work_outlined,

                            size: 35,

                            color: primaryColor,
                          ),
                        );
                      },
                    ),
            ),

            Positioned(
              top: 7,
              left: 7,

              child: buildStatusBadge(property.status),
            ),
          ],
        ),
      ),
    );
  }

  // Property information
  Widget buildPropertyInformation(Property property, bool isRemoving) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 11, 10, 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  property.name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: primaryColor,

                    fontWeight: FontWeight.w700,

                    fontSize: 16,
                  ),
                ),
              ),

              InkWell(
                onTap: isRemoving
                    ? null
                    : () {
                        removeFavorite(property);
                      },

                borderRadius: BorderRadius.circular(30),

                child: Container(
                  width: 32,
                  height: 32,

                  decoration: const BoxDecoration(
                    color: lightSecondaryColor,

                    shape: BoxShape.circle,
                  ),

                  child: isRemoving
                      ? const Padding(
                          padding: EdgeInsets.all(8),

                          child: CircularProgressIndicator(
                            strokeWidth: 2,

                            color: primaryColor,
                          ),
                        )
                      : const Icon(
                          Icons.favorite_rounded,

                          color: primaryColor,

                          size: 19,
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),

                child: Icon(
                  Icons.location_on_outlined,

                  size: 16,

                  color: primaryColor,
                ),
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
              Text(
                "\$${property.price.toStringAsFixed(0)}",

                style: const TextStyle(
                  color: primaryColor,

                  fontWeight: FontWeight.w900,

                  fontSize: 17,
                ),
              ),

              const SizedBox(width: 3),

              const Padding(
                padding: EdgeInsets.only(bottom: 2),

                child: Text(
                  "/ month",

                  style: TextStyle(
                    color: Colors.black54,

                    fontWeight: FontWeight.w500,

                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Status badge
  Widget buildStatusBadge(String status) {
    final String value = status.toLowerCase();

    Color color;

    if (value == "available" || value == "available now") {
      color = const Color(0xFF16A34A);
    } else if (value == "rented") {
      color = const Color(0xFFDC2626);
    } else {
      color = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),

            blurRadius: 4,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 6,
            height: 6,

            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 4),

          Text(
            status,

            style: TextStyle(
              color: color,

              fontSize: 9,

              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Empty state
  Widget buildEmptyState() {
    final bool searching = searchText.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 82,
              height: 82,

              decoration: const BoxDecoration(
                color: lightSecondaryColor,

                shape: BoxShape.circle,
              ),

              child: Icon(
                searching
                    ? Icons.search_off_rounded
                    : Icons.favorite_border_rounded,

                color: primaryColor,

                size: 38,
              ),
            ),

            const SizedBox(height: 17),

            Text(
              searching
                  ? "No saved properties found"
                  : "No saved properties yet",

              style: const TextStyle(
                color: primaryColor,

                fontSize: 17,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              searching
                  ? "Try searching with another property name or location."
                  : "Properties you save will appear here.",

              textAlign: TextAlign.center,

              style: const TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Error state
  Widget buildErrorState() {
    return RefreshIndicator(
      onRefresh: loadFavorites,

      color: primaryColor,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,

            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(30),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Icon(
                      Icons.error_outline_rounded,

                      color: primaryColor,

                      size: 48,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Unable to load saved properties",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: primaryColor,

                        fontSize: 17,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      errorMessage ?? "",

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.black54,

                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: loadFavorites,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,

                        foregroundColor: Colors.white,
                      ),

                      icon: const Icon(Icons.refresh_rounded),

                      label: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
