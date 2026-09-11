import 'dart:convert';

import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen> {
  final PropertyService propertyService = PropertyService();

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";
  String searchQuery = "";

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> properties = [];

  // Laravel public storage
  final String storageBaseUrl = "http://10.0.2.2:8000/storage";

  @override
  void initState() {
    super.initState();

    loadProperties();

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim().toLowerCase();
      });
    });
  }

  // =========================================================
  // LOAD OWNER PROPERTIES
  // =========================================================

  Future<void> loadProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await propertyService.getMyProperties();

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final List<dynamic> propertyList = data["properties"] ?? [];

        if (!mounted) {
          return;
        }

        setState(() {
          properties = propertyList
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage = data["message"] ?? "Unable to load properties.";
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // FILTERED PROPERTIES
  // =========================================================

  List<Map<String, dynamic>> get filteredProperties {
    return properties.where((property) {
      final String rentalStatus = (property["rental_status"] ?? "")
          .toString()
          .toLowerCase();

      final String verificationStatus = (property["verification_status"] ?? "")
          .toString()
          .toLowerCase();

      // =====================================================
      // FILTER
      // =====================================================

      bool matchesFilter = true;

      if (selectedFilter == "Available") {
        matchesFilter = rentalStatus == "available";
      } else if (selectedFilter == "Rented") {
        matchesFilter = rentalStatus == "rented";
      } else if (selectedFilter == "Pending") {
        matchesFilter = verificationStatus == "pending";
      }

      // =====================================================
      // SEARCH
      // =====================================================

      final String name = (property["name"] ?? "").toString().toLowerCase();

      final String address = (property["address"] ?? "")
          .toString()
          .toLowerCase();

      final bool matchesSearch =
          searchQuery.isEmpty ||
          name.contains(searchQuery) ||
          address.contains(searchQuery);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  // =========================================================
  // IMAGE URL
  // =========================================================

  String? getPropertyImage(Map<String, dynamic> property) {
    final dynamic path = property["cover_image_path"];

    if (path == null || path.toString().trim().isEmpty) {
      return null;
    }

    final String imagePath = path.toString();

    if (imagePath.startsWith("http")) {
      return imagePath;
    }

    return "$storageBaseUrl/$imagePath";
  }

  // =========================================================
  // CAPITALIZE STATUS
  // =========================================================

  String capitalize(String text) {
    if (text.isEmpty) {
      return "";
    }

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // =========================================================
  // PRICE
  // =========================================================

  String getPrice(Map<String, dynamic> property) {
    final dynamic rawPrice = property["price"];

    final double? price = double.tryParse(rawPrice.toString());

    if (price == null) {
      return "\$${rawPrice ?? 0} / month";
    }

    if (price == price.roundToDouble()) {
      return "\$${price.toInt()} / month";
    }

    return "\$${price.toStringAsFixed(2)} / month";
  }

  // =========================================================
  // CAN EDIT
  // =========================================================

  bool canEdit(Map<String, dynamic> property) {
    // Prefer backend can_edit
    if (property["can_edit"] is bool) {
      return property["can_edit"];
    }

    // Backup rule
    final String verificationStatus = (property["verification_status"] ?? "")
        .toString()
        .toLowerCase();

    return verificationStatus != "approved";
  }

  // =========================================================
  // UPDATE RENTAL STATUS
  // =========================================================

  Future<void> updatePropertyStatus(
    Map<String, dynamic> property,
    String newStatus,
  ) async {
    try {
      final dynamic rawId = property["id"];

      final int? propertyId = int.tryParse(rawId.toString());

      if (propertyId == null) {
        Get.snackbar(
          "Error",
          "Invalid property ID.",
          snackPosition: SnackPosition.TOP,
        );

        return;
      }

      final response = await propertyService.updateRentalStatus(
        propertyId: propertyId,
        rentalStatus: newStatus,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        setState(() {
          property["rental_status"] = newStatus;
        });

        Get.back();

        Get.snackbar(
          "Status Updated",
          "${property["name"]} is now ${capitalize(newStatus)}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: primaryColor,
        );
      } else {
        Get.snackbar(
          "Update Failed",
          data["message"] ?? "Unable to update property status.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.TOP);
    }
  }

  // =========================================================
  // EDIT PROPERTY
  // =========================================================

  Future<void> handleEditProperty(Map<String, dynamic> property) async {
    // =====================================================
    // APPROVED PROPERTY CANNOT EDIT
    // =====================================================

    if (!canEdit(property)) {
      Get.snackbar(
        "Edit Not Available",
        "Approved properties cannot be edited.",
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    // =====================================================
    // OPEN POST PROPERTY SCREEN IN EDIT MODE
    // =====================================================

    final dynamic result = await Get.to(
      () => Postpropertyscreen(propertyToEdit: property),
    );

    // =====================================================
    // REFRESH AFTER SUCCESSFUL UPDATE
    // =====================================================
    //
    // PostPropertyScreen returns:
    //
    // Get.back(result: true)
    //
    // after updateProperty() succeeds.
    //

    if (result == true) {
      await loadProperties();
    }
  }

  // =========================================================
  // VIEW DETAILS
  // =========================================================

  void handleViewDetails(Map<String, dynamic> property) {
    Get.snackbar(
      "View Details",
      "Property details screen will be connected later.",
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> currentProperties = filteredProperties;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: const Text(
          "My Properties",

          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            // =====================================================
            // SEARCH + FILTER
            // =====================================================
            Container(
              color: backgroundColor,

              padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),

              child: Column(
                children: [
                  // =================================================
                  // SEARCH
                  // =================================================
                  Container(
                    height: 50,

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(15),

                      border: Border.all(color: Colors.grey.withOpacity(0.20)),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: searchController,

                      decoration: const InputDecoration(
                        hintText: "Search your properties",

                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF98A2B3),
                        ),

                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF667085),
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // FILTERS
                  // =================================================
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: [
                        buildFilterChip("All"),

                        const SizedBox(width: 8),

                        buildFilterChip("Available"),

                        const SizedBox(width: 8),

                        buildFilterChip("Rented"),

                        const SizedBox(width: 8),

                        buildFilterChip("Pending"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // LOADING
            // =====================================================
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              )
            // =====================================================
            // ERROR
            // =====================================================
            else if (errorMessage != null)
              Expanded(child: buildErrorState())
            // =====================================================
            // DATA
            // =====================================================
            else ...[
              // =================================================
              // PROPERTY COUNT
              // =================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),

                child: Row(
                  children: [
                    Text(
                      "${currentProperties.length} Properties",

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      "Manage your listings",

                      style: TextStyle(fontSize: 11, color: Color(0xFF7D8990)),
                    ),
                  ],
                ),
              ),

              // =================================================
              // PROPERTY LIST
              // =================================================
              Expanded(
                child: currentProperties.isEmpty
                    ? buildEmptyState()
                    : RefreshIndicator(
                        color: primaryColor,

                        onRefresh: loadProperties,

                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),

                          padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),

                          itemCount: currentProperties.length,

                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 16);
                          },

                          itemBuilder: (context, index) {
                            return buildPropertyCard(currentProperties[index]);
                          },
                        ),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FILTER CHIP
  // =========================================================

  Widget buildFilterChip(String title) {
    final bool selected = selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius: BorderRadius.circular(30),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),

        decoration: BoxDecoration(
          color: selected ? secondaryColor : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: selected
                ? primaryColor.withOpacity(0.20)
                : Colors.grey.withOpacity(0.25),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,

            fontWeight: selected ? FontWeight.bold : FontWeight.w500,

            color: selected ? primaryColor : const Color(0xFF667085),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PROPERTY CARD
  // =========================================================

  Widget buildPropertyCard(Map<String, dynamic> property) {
    final String rentalStatus = capitalize(
      (property["rental_status"] ?? "").toString(),
    );

    final String verificationStatus = capitalize(
      (property["verification_status"] ?? "").toString(),
    );

    final String? imageUrl = getPropertyImage(property);

    final bool editable = canEdit(property);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.18)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =====================================================
          // IMAGE
          // =====================================================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),

                child: imageUrl != null
                    ? Image.network(
                        imageUrl,

                        width: double.infinity,

                        height: 190,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return buildImagePlaceholder();
                        },
                      )
                    : buildImagePlaceholder(),
              ),

              // =================================================
              // RENTAL STATUS
              // =================================================
              Positioned(
                left: 10,
                top: 10,

                child: buildRentalBadge(
                  rentalStatus,

                  rentalStatus == "Available"
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),

              // =================================================
              // MENU
              // =================================================
              Positioned(
                right: 10,
                top: 10,

                child: Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.94),

                    shape: BoxShape.circle,
                  ),

                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,

                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: primaryColor,
                    ),

                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: "edit",

                          enabled: editable,

                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 19,

                                color: editable ? null : Colors.grey,
                              ),

                              const SizedBox(width: 10),

                              Text(
                                editable
                                    ? "Edit Property"
                                    : "Edit Not Available",
                              ),
                            ],
                          ),
                        ),

                        const PopupMenuItem(
                          value: "view",

                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined, size: 19),

                              SizedBox(width: 10),

                              Text("View Details"),
                            ],
                          ),
                        ),
                      ];
                    },

                    onSelected: (value) {
                      if (value == "edit") {
                        handleEditProperty(property);
                      }

                      if (value == "view") {
                        handleViewDetails(property);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // =====================================================
          // PROPERTY INFORMATION
          // =====================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // =================================================
                // NAME
                // =================================================
                Text(
                  property["name"] ?? "Unnamed Property",

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 6),

                // =================================================
                // LOCATION
                // =================================================
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF7D8990),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        property["address"] ?? "No location",

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7D8990),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // =================================================
                // PRICE
                // =================================================
                Text(
                  getPrice(property),

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 10),

                // =================================================
                // VERIFICATION
                // =================================================
                buildVerificationBadge(verificationStatus),

                const SizedBox(height: 14),

                Divider(height: 1, color: Colors.grey.withOpacity(0.20)),

                const SizedBox(height: 14),

                // =================================================
                // ACTIONS
                // =================================================
                Row(
                  children: [
                    // =============================================
                    // EDIT
                    // =============================================
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: editable
                            ? () {
                                handleEditProperty(property);
                              }
                            : null,

                        icon: const Icon(Icons.edit_outlined, size: 17),

                        label: Text(
                          editable ? "Edit" : "Locked",

                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryColor,

                          disabledForegroundColor: Colors.grey,

                          side: BorderSide(
                            color: editable
                                ? Colors.grey.withOpacity(0.35)
                                : Colors.grey.withOpacity(0.20),
                          ),

                          padding: const EdgeInsets.symmetric(vertical: 12),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // =============================================
                    // CHANGE STATUS
                    // =============================================
                    Expanded(
                      flex: 2,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          showStatusBottomSheet(property);
                        },

                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),

                        label: const Text(
                          "Change Status",

                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,

                          foregroundColor: Colors.white,

                          elevation: 0,

                          padding: const EdgeInsets.symmetric(vertical: 12),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // IMAGE PLACEHOLDER
  // =========================================================

  Widget buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 190,

      color: secondaryColor.withOpacity(0.18),

      child: const Icon(
        Icons.home_work_outlined,
        size: 55,
        color: primaryColor,
      ),
    );
  }

  // =========================================================
  // VERIFICATION BADGE
  // =========================================================

  Widget buildVerificationBadge(String status) {
    Color color;
    IconData icon;

    if (status == "Approved") {
      color = const Color(0xFF2563EB);

      icon = Icons.verified_rounded;
    } else if (status == "Pending") {
      color = const Color(0xFFF59E0B);

      icon = Icons.schedule_rounded;
    } else {
      color = const Color(0xFFDC2626);

      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 13, color: color),

          const SizedBox(width: 4),

          Text(
            status,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RENTAL STATUS BADGE
  // =========================================================

  Widget buildRentalBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 5),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          const SizedBox(width: 5),

          Text(
            text,

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CHANGE STATUS BOTTOM SHEET
  // =========================================================

  void showStatusBottomSheet(Map<String, dynamic> property) {
    final String currentStatus = (property["rental_status"] ?? "")
        .toString()
        .toLowerCase();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.30),

                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Change Availability",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              property["name"] ?? "",

              style: const TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),

            const SizedBox(height: 6),

            const Text(
              "Choose the current rental status of this property.",

              style: TextStyle(fontSize: 12, color: Color(0xFF98A2B3)),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // AVAILABLE
            // =====================================================
            buildStatusOption(
              icon: Icons.check_circle_outline_rounded,

              title: "Available",

              subtitle: "Property is currently open for rent",

              color: const Color(0xFF16A34A),

              selected: currentStatus == "available",

              onTap: () {
                if (currentStatus == "available") {
                  Get.back();

                  return;
                }

                updatePropertyStatus(property, "available");
              },
            ),

            const SizedBox(height: 12),

            // =====================================================
            // RENTED
            // =====================================================
            buildStatusOption(
              icon: Icons.key_rounded,

              title: "Rented",

              subtitle: "Property is currently occupied",

              color: const Color(0xFFDC2626),

              selected: currentStatus == "rented",

              onTap: () {
                if (currentStatus == "rented") {
                  Get.back();

                  return;
                }

                updatePropertyStatus(property, "rented");
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // =========================================================
  // STATUS OPTION
  // =========================================================

  Widget buildStatusOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected ? color : Colors.grey.withOpacity(0.30),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: color.withOpacity(0.10),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 23),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7D8990),
                    ),
                  ),
                ],
              ),
            ),

            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.home_work_outlined, size: 55, color: secondaryColor),

            SizedBox(height: 18),

            Text(
              "No properties found",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Your properties matching this filter will appear here.",

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 55,
              color: Color(0xFFDC2626),
            ),

            const SizedBox(height: 15),

            const Text(
              "Unable to load properties",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage ?? "",

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: loadProperties,

              icon: const Icon(Icons.refresh_rounded),

              label: const Text("Retry"),

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,

                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}
