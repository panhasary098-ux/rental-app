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

class AllPropertiesScreen extends StatefulWidget {
  final List<Property> properties;

  const AllPropertiesScreen({super.key, required this.properties});

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends State<AllPropertiesScreen> {
  final PropertyService propertyService = PropertyService();

  final TextEditingController searchController = TextEditingController();

  String searchText = "";
  String selectedType = "All";
  String selectedSort = "Newest";

  final Set<int> favoritePropertyIds = {};
  final Set<int> favoriteLoadingIds = {};

  final List<String> propertyTypes = ["All", "House", "Apartment", "Room"];

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

  // Load saved property IDs
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
      print("ALL PROPERTIES FAVORITES LOAD ERROR: $e");
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

      print("ALL PROPERTIES FAVORITE ERROR: $e");
    }
  }

  // Search, filter and sort
  List<Property> get displayedProperties {
    List<Property> result = List<Property>.from(widget.properties);

    final String query = searchText.toLowerCase().trim();

    result = result.where((property) {
      final String name = property.name.toLowerCase();

      final String location = (property.location.address ?? "").toLowerCase();

      final String propertyType = getPropertyType(property);

      final bool matchesSearch =
          query.isEmpty || name.contains(query) || location.contains(query);

      final bool matchesType =
          selectedType == "All" || propertyType == selectedType;

      return matchesSearch && matchesType;
    }).toList();

    if (selectedSort == "Price: Low to High") {
      result.sort((a, b) => a.price.compareTo(b.price));
    }

    if (selectedSort == "Price: High to Low") {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  }

  String getPropertyType(Property property) {
    final String type = property.runtimeType.toString().toLowerCase();

    if (type.contains("house")) {
      return "House";
    }

    if (type.contains("apartment") || type.contains("flat")) {
      return "Apartment";
    }

    if (type.contains("room")) {
      return "Room";
    }

    return "Property";
  }

  @override
  Widget build(BuildContext context) {
    final List<Property> properties = displayedProperties;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: primaryColor,
          ),
        ),

        title: const Text(
          "All Properties",

          style: TextStyle(
            color: primaryColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.tune_rounded, color: primaryColor),
          ),

          const SizedBox(width: 5),
        ],
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),

              child: Column(
                children: [
                  buildSearchBox(),

                  const SizedBox(height: 15),

                  buildTypeFilters(),

                  const SizedBox(height: 17),

                  buildResultHeader(properties.length),
                ],
              ),
            ),

            Expanded(
              child: properties.isEmpty
                  ? buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 4, 18, 25),

                      itemCount: properties.length,

                      itemBuilder: (context, index) {
                        return buildPropertyCard(properties[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

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

        style: const TextStyle(color: primaryColor),

        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: primaryColor),

          hintText: "Search Property name....",

          hintStyle: const TextStyle(color: Colors.black38),

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderSide: BorderSide.none,

            borderRadius: BorderRadius.circular(10),
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
                    color: primaryColor,
                    size: 20,
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildTypeFilters() {
    return SizedBox(
      height: 40,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: propertyTypes.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 9);
        },

        itemBuilder: (context, index) {
          final String type = propertyTypes[index];

          final bool selected = selectedType == type;

          return InkWell(
            onTap: () {
              setState(() {
                selectedType = type;
              });
            },

            borderRadius: BorderRadius.circular(25),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              padding: const EdgeInsets.symmetric(horizontal: 19),

              alignment: Alignment.center,

              decoration: BoxDecoration(
                color: selected ? secondaryColor : Colors.white,

                borderRadius: BorderRadius.circular(25),

                border: Border.all(
                  color: selected
                      ? secondaryColor
                      : primaryColor.withOpacity(0.12),
                ),
              ),

              child: Text(
                type,

                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,

                  fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildResultHeader(int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "$count ${count == 1 ? "property" : "properties"} found",

            style: const TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        PopupMenuButton<String>(
          initialValue: selectedSort,

          onSelected: (value) {
            setState(() {
              selectedSort = value;
            });
          },

          color: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),

          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: "Newest", child: Text("Newest")),

              PopupMenuItem(
                value: "Price: Low to High",
                child: Text("Price: Low to High"),
              ),

              PopupMenuItem(
                value: "Price: High to Low",
                child: Text("Price: High to Low"),
              ),
            ];
          },

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),

              border: Border.all(color: primaryColor.withOpacity(0.12)),
            ),

            child: const Row(
              children: [
                Icon(Icons.swap_vert_rounded, size: 17, color: primaryColor),

                SizedBox(width: 5),

                Text(
                  "Sort",

                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(width: 2),

                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
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
        // Open real property detail
        onTap: () async {
          await Get.to(() => PropertyDetailScreen(property: property));

          // If favorite was changed inside detail,
          // refresh the heart when coming back.
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

                              color: primaryColor,
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
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),

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

            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
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

  Widget buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 78,
              height: 78,

              decoration: const BoxDecoration(
                color: lightSecondaryColor,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.search_off_rounded,
                size: 35,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No properties found",

              style: TextStyle(
                color: primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Try changing your search or property type.",

              textAlign: TextAlign.center,

              style: TextStyle(color: Color(0xFF7D8990), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
