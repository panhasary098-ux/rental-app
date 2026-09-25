import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:final_project/view/renter/owner_profile_screen.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color lightSecondaryColor = Color(0xFFE6F9FC);
const Color borderColor = Color(0xFFF0F1F5);
const Color mutedTextColor = Color(0xFF85899B);
const Color imagePlaceholderColor = Color(0xFFF2F3F7);

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
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
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
      ),

      body: SafeArea(
        top: false,

        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          slivers: [
            // Sticky search bar
            SliverAppBar(
              pinned: true,
              primary: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 1,
              toolbarHeight: 74,
              titleSpacing: 0,

              title: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Row(
                  children: [
                    Expanded(child: buildSearchBox()),

                    const SizedBox(width: 12),

                    buildFilterButton(),
                  ],
                ),
              ),
            ),

            // Property type filters and result count scroll with the page
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
                child: Column(
                  children: [
                    buildTypeFilters(),

                    const SizedBox(height: 17),

                    buildResultHeader(properties.length),

                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),

            if (properties.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: buildEmptyState(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 25),

                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return buildPropertyCard(properties[index]);
                  }, childCount: properties.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F1F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => FilterScreen(properties: widget.properties));
          },
          child: const Center(
            child: Icon(Icons.tune_rounded, color: primaryColor, size: 23),
          ),
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
                color: Colors.white,

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

  // Open Owner Summary
  Future<void> openOwnerSummary(Property property) async {
    final int? ownerId = property.ownerId;

    if (ownerId == null || ownerId <= 0) {
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
        padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: FutureBuilder(
            future: propertyService.getOwnerProfile(ownerId: ownerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 230,
                  child: Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              String ownerName = property.ownerName;

              String profileImage = property.ownerProfileImage;

              String memberSince = property.ownerMemberSince;

              int totalProperties = 0;

              int availableProperties = 0;

              if (snapshot.hasData) {
                try {
                  final dynamic decoded = jsonDecode(snapshot.data!.body);

                  if (snapshot.data!.statusCode == 200 &&
                      decoded["success"] == true) {
                    final dynamic owner = decoded["owner"];

                    if (owner is Map) {
                      ownerName = owner["name"]?.toString() ?? ownerName;

                      profileImage = fixOwnerImageUrl(
                        owner["profile_image"]?.toString() ?? profileImage,
                      );

                      memberSince =
                          owner["member_since"]?.toString() ?? memberSince;

                      totalProperties =
                          int.tryParse(
                            owner["total_properties"]?.toString() ?? "0",
                          ) ??
                          0;

                      availableProperties =
                          int.tryParse(
                            owner["available_properties"]?.toString() ?? "0",
                          ) ??
                          0;
                    }
                  }
                } catch (e) {
                  print("OWNER PROFILE PARSE ERROR: $e");
                }
              }

              if (ownerName.trim().isEmpty) {
                ownerName = "House Owner";
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E4EA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  SizedBox(height: 22),

                  buildOwnerAvatar(
                    ownerName: ownerName,
                    profileImage: profileImage,
                    size: 76,
                    fontSize: 28,
                  ),

                  SizedBox(height: 12),

                  Text(
                    ownerName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "House Owner",
                    style: TextStyle(
                      color: mutedTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  if (memberSince.isNotEmpty) ...[
                    SizedBox(height: 5),

                    Text(
                      "Member since ${formatMemberSince(memberSince)}",
                      style: TextStyle(color: mutedTextColor, fontSize: 11),
                    ),
                  ],

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: buildOwnerStat(
                          value: totalProperties.toString(),
                          label: "Listings",
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: buildOwnerStat(
                          value: availableProperties.toString(),
                          label: "Available",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        final List<Property> ownerProperties = widget.properties
                            .where((item) => item.ownerId == ownerId)
                            .toList();

                        Get.back();

                        Get.to(
                          () => OwnerProfileScreen(
                            ownerId: ownerId,
                            ownerName: ownerName,
                            ownerProfileImage: profileImage,
                            ownerProperties: ownerProperties,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "View Owner Profile",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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
      backgroundColor: Colors.transparent,
    );
  }

  // Owner Avatar
  Widget buildOwnerAvatar({
    required String ownerName,
    required String profileImage,
    double size = 42,
    double fontSize = 16,
  }) {
    final String cleanName = ownerName.trim();

    final String initial = cleanName.isNotEmpty
        ? cleanName[0].toUpperCase()
        : "O";

    final String cleanImage = fixOwnerImageUrl(profileImage);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xFFF0F1F8),
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFFE7E8F0)),
      ),
      child: ClipOval(
        child: cleanImage.isNotEmpty
            ? Image.network(
                cleanImage,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  initial,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
      ),
    );
  }

  // Owner Stat
  Widget buildOwnerStat({required String value, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Owner Image URL
  String fixOwnerImageUrl(String url) {
    if (url.isEmpty) {
      return "";
    }

    return url
        .replaceFirst("http://localhost:8000", "http://10.0.2.2:8000")
        .replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");
  }

  // Member Since
  String formatMemberSince(String value) {
    final DateTime? date = DateTime.tryParse(value);

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
  Widget buildPropertyCard(Property property) {
    final int? propertyId = property.id;

    final bool isFavorite =
        propertyId != null && favoritePropertyIds.contains(propertyId);

    final bool isLoading =
        propertyId != null && favoriteLoadingIds.contains(propertyId);

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: borderColor),

        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Colors.black.withOpacity(0.055),
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: InkWell(
        onTap: () async {
          await Get.to(() => PropertyDetailScreen(property: property));

          await loadFavorites();
        },

        borderRadius: BorderRadius.circular(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),

                  child: buildPropertyImage(property),
                ),

                // Favorite
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
                      width: 38,
                      height: 38,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 7,
                          ),
                        ],
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

                // Status
                Positioned(
                  top: 10,
                  left: 10,

                  child: buildStatusBadge(property.status),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 12, 15, 14),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Owner
                  InkWell(
                    onTap: () {
                      openOwnerSummary(property);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          buildOwnerAvatar(
                            ownerName: property.ownerName,
                            profileImage: property.ownerProfileImage,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  property.ownerName.trim().isNotEmpty
                                      ? property.ownerName
                                      : "House Owner",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 2),

                                Text(
                                  "House Owner",
                                  style: TextStyle(
                                    color: mutedTextColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.chevron_right_rounded,
                            color: Color(0xFFB3B6C2),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 11),

                  Divider(height: 1, color: borderColor),

                  SizedBox(height: 11),

                  Text(
                    property.name,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: primaryColor,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          property.location.address ?? "Unknown location",

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: mutedTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

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

  // Property Image
  Widget buildPropertyImage(Property property) {
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
      errorBuilder: (context, error, stackTrace) {
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

  // Status Badge
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
        color: Colors.white,
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
