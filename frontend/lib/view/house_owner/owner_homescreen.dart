import 'dart:convert';

import 'package:final_project/service/auth_service.dart';
import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color ownerPrimaryColor = Color(0xFF03045E);
const Color ownerBackgroundColor = Color(0xFFF4FCFE);
const Color ownerLightSecondaryColor = Color(0xFFE6F9FC);

class OwnerHomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAll;
  final VoidCallback? onPostProperty;

  const OwnerHomeScreen({super.key, this.onSeeAll, this.onPostProperty});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final AuthService authService = AuthService();
  final PropertyService propertyService = PropertyService();

  Map<String, dynamic>? owner;

  List<Map<String, dynamic>> properties = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadHomeData();
  }

  // Load owner and property information
  Future<void> loadHomeData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get logged-in owner information
      final Map<String, dynamic> ownerData = await authService
          .getCurrentUserFromLaravel();

      // Get owner's properties
      final response = await propertyService.getMyProperties();

      if (response.statusCode != 200) {
        throw Exception("Failed to load properties: ${response.body}");
      }

      final dynamic decoded = jsonDecode(response.body);

      List<dynamic> rawProperties = [];

      if (decoded is Map<String, dynamic>) {
        final dynamic propertyList = decoded["properties"];

        if (propertyList is List) {
          rawProperties = propertyList;
        }
      }

      final List<Map<String, dynamic>> propertyData = rawProperties.map((
        property,
      ) {
        return Map<String, dynamic>.from(property);
      }).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        owner = ownerData;
        properties = propertyData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      setState(() {
        isLoading = false;
        errorMessage = message;
      });
    }
  }

  // Update rental status
  Future<void> updatePropertyRentalStatus({
    required Map<String, dynamic> property,
    required String newStatus,
  }) async {
    final int? propertyId = int.tryParse(property["id"]?.toString() ?? "");

    if (propertyId == null) {
      Get.snackbar(
        "Update Failed",
        "Property ID is missing.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    final String currentStatus =
        property["rental_status"]?.toString().toLowerCase() ?? "";

    // Do nothing when status is already selected
    if (currentStatus == newStatus) {
      Get.back();
      return;
    }

    // Close status bottom sheet
    Get.back();

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: ownerPrimaryColor)),
      barrierDismissible: false,
    );

    try {
      final response = await propertyService.updateRentalStatus(
        propertyId: propertyId,
        rentalStatus: newStatus,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) {
          return;
        }

        setState(() {
          for (final item in properties) {
            if (item["id"].toString() == propertyId.toString()) {
              item["rental_status"] = newStatus;
              break;
            }
          }
        });

        Get.snackbar(
          "Status Updated",
          newStatus == "available"
              ? "Property is now available."
              : "Property is now rented.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE6F7EE),
          colorText: const Color(0xFF166534),
        );

        return;
      }

      String message = "Unable to update property status.";

      if (decoded is Map && decoded["message"] != null) {
        message = decoded["message"].toString();
      }

      Get.snackbar(
        "Update Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      Get.snackbar(
        "Update Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Total property count
  int get totalProperties {
    return properties.length;
  }

  // Pending property count
  int get pendingProperties {
    return properties.where((property) {
      final String status =
          property["verification_status"]?.toString().toLowerCase() ?? "";

      return status == "pending";
    }).length;
  }

  // Available property count
  int get availableProperties {
    return properties.where((property) {
      final String status =
          property["rental_status"]?.toString().toLowerCase() ?? "";

      return status == "available";
    }).length;
  }

  // Rented property count
  int get rentedProperties {
    return properties.where((property) {
      final String status =
          property["rental_status"]?.toString().toLowerCase() ?? "";

      return status == "rented";
    }).length;
  }

  // Latest 3 properties
  List<Map<String, dynamic>> get recentProperties {
    final List<Map<String, dynamic>> result = List<Map<String, dynamic>>.from(
      properties,
    );

    result.sort((a, b) {
      final DateTime? dateA = DateTime.tryParse(
        a["created_at"]?.toString() ?? "",
      );

      final DateTime? dateB = DateTime.tryParse(
        b["created_at"]?.toString() ?? "",
      );

      if (dateA == null && dateB == null) {
        return 0;
      }

      if (dateA == null) {
        return 1;
      }

      if (dateB == null) {
        return -1;
      }

      return dateB.compareTo(dateA);
    });

    return result.take(3).toList();
  }

  // Get property cover image
  String getPropertyImage(Map<String, dynamic> property) {
    final dynamic coverPath = property["cover_image_path"];

    if (coverPath != null && coverPath.toString().isNotEmpty) {
      return buildStorageUrl(coverPath.toString());
    }

    final dynamic images = property["images"];

    if (images is List && images.isNotEmpty) {
      Map<String, dynamic>? coverImage;

      for (final dynamic image in images) {
        if (image is Map) {
          final bool isCover =
              image["is_cover"] == true ||
              image["is_cover"] == 1 ||
              image["is_cover"] == "1";

          if (isCover) {
            coverImage = Map<String, dynamic>.from(image);

            break;
          }
        }
      }

      if (coverImage == null && images.first is Map) {
        coverImage = Map<String, dynamic>.from(images.first);
      }

      final dynamic imagePath = coverImage?["image_path"];

      if (imagePath != null && imagePath.toString().isNotEmpty) {
        return buildStorageUrl(imagePath.toString());
      }
    }

    return "";
  }

  // Convert Laravel storage path to emulator URL
  String buildStorageUrl(String path) {
    if (path.isEmpty) {
      return "";
    }

    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path
          .replaceFirst("http://localhost:8000", "http://10.0.2.2:8000")
          .replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");
    }

    String cleanPath = path;

    if (cleanPath.startsWith("/")) {
      cleanPath = cleanPath.substring(1);
    }

    if (cleanPath.startsWith("storage/")) {
      return "http://10.0.2.2:8000/$cleanPath";
    }

    return "http://10.0.2.2:8000/storage/$cleanPath";
  }

  // Owner initials
  String getOwnerInitials() {
    final String name = owner?["name"]?.toString().trim() ?? "";

    if (name.isEmpty) {
      return "O";
    }

    final List<String> parts = name
        .split(" ")
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return "O";
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}"
        .toUpperCase();
  }

  // Format verification status
  String formatVerificationStatus(dynamic value) {
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "approved") {
      return "Approved";
    }

    if (status == "rejected") {
      return "Rejected";
    }

    return "Pending";
  }

  // Format rental status
  String formatRentalStatus(dynamic value) {
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "rented") {
      return "Rented";
    }

    return "Available";
  }

  // Format property price
  String formatPrice(dynamic value) {
    if (value == null) {
      return "\$0 / month";
    }

    final double? price = double.tryParse(value.toString());

    if (price == null) {
      return "\$${value.toString()} / month";
    }

    if (price == price.roundToDouble()) {
      return "\$${price.toInt()} / month";
    }

    return "\$${price.toStringAsFixed(2)} / month";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ownerBackgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          color: ownerPrimaryColor,

          onRefresh: loadHomeData,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),

            child: buildBody(),
          ),
        ),
      ),
    );
  }

  // Main content
  Widget buildBody() {
    if (isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,

        child: const Center(
          child: CircularProgressIndicator(color: ownerPrimaryColor),
        ),
      );
    }

    if (errorMessage != null) {
      return buildErrorState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        buildHeader(),

        const SizedBox(height: 22),

        buildHeroCard(),

        const SizedBox(height: 20),

        buildSummarySection(),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text(
              "Recent Properties",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ownerPrimaryColor,
              ),
            ),

            TextButton(
              onPressed: () {
                widget.onSeeAll?.call();
              },

              child: const Text(
                "See all",

                style: TextStyle(
                  color: ownerPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (recentProperties.isEmpty)
          buildEmptyProperties()
        else
          ...recentProperties.map((property) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),

              child: buildPropertyCard(property: property),
            );
          }),
      ],
    );
  }

  // Header
  Widget buildHeader() {
    final String name = owner?["name"]?.toString() ?? "Owner";

    final String? profileImage = owner?["profile_image"]?.toString();

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,

          clipBehavior: Clip.antiAlias,

          alignment: Alignment.center,

          decoration: const BoxDecoration(
            color: ownerLightSecondaryColor,
            shape: BoxShape.circle,
          ),

          child: profileImage != null && profileImage.isNotEmpty
              ? Image.network(
                  buildStorageUrl(profileImage),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        getOwnerInitials(),

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ownerPrimaryColor,
                        ),
                      ),
                    );
                  },
                )
              : Text(
                  getOwnerInitials(),

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ownerPrimaryColor,
                  ),
                ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Hello, $name",

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ownerPrimaryColor,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                "House Owner",

                style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(13),

            border: Border.all(color: Colors.grey.withOpacity(0.25)),
          ),

          child: const Icon(
            Icons.notifications_none_rounded,
            color: ownerPrimaryColor,
          ),
        ),
      ],
    );
  }

  // Hero card
  Widget buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 235,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
          ),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: LinearGradient(
            begin: Alignment.centerLeft,

            end: Alignment.centerRight,

            colors: [
              ownerPrimaryColor.withOpacity(0.95),

              ownerPrimaryColor.withOpacity(0.60),

              Colors.transparent,
            ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "Manage Your\nProperties with\nEase",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: 230,

              child: Text(
                "Post, track and manage your rental properties all in one place.",

                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.35,
                ),
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: () {
                widget.onPostProperty?.call();
              },

              borderRadius: BorderRadius.circular(30),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(Icons.add_rounded, size: 20, color: ownerPrimaryColor),

                    SizedBox(width: 6),

                    Text(
                      "Post a New Property",

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ownerPrimaryColor,
                      ),
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

  // Summary section
  Widget buildSummarySection() {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      crossAxisSpacing: 12,

      mainAxisSpacing: 12,

      childAspectRatio: 2.15,

      children: [
        buildSummaryCard(
          icon: Icons.home_rounded,
          number: totalProperties.toString(),
          title: "Total",
          iconBackground: const Color(0xFFE6F0FF),
          iconColor: const Color(0xFF2563EB),
        ),

        buildSummaryCard(
          icon: Icons.schedule_rounded,
          number: pendingProperties.toString(),
          title: "Pending",
          iconBackground: const Color(0xFFFFF1D6),
          iconColor: const Color(0xFFF59E0B),
        ),

        buildSummaryCard(
          icon: Icons.check_circle_rounded,
          number: availableProperties.toString(),
          title: "Available",
          iconBackground: const Color(0xFFE6F7EE),
          iconColor: const Color(0xFF16A34A),
        ),

        buildSummaryCard(
          icon: Icons.key_rounded,
          number: rentedProperties.toString(),
          title: "Rented",
          iconBackground: const Color(0xFFFFE8E8),
          iconColor: const Color(0xFFDC2626),
        ),
      ],
    );
  }

  // Summary card
  Widget buildSummaryCard({
    required IconData icon,
    required String number,
    required String title,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.18)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 8,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: iconBackground,

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, size: 24, color: iconColor),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  number,

                  style: const TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.w800,

                    color: ownerPrimaryColor,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  title,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11.5,

                    fontWeight: FontWeight.w500,

                    color: Color(0xFF7D8990),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Property card
  Widget buildPropertyCard({required Map<String, dynamic> property}) {
    final String image = getPropertyImage(property);

    final String title = property["name"]?.toString() ?? "Property";

    final String location = property["address"]?.toString() ?? "-";

    final String price = formatPrice(property["price"]);

    final String rentalStatus = formatRentalStatus(property["rental_status"]);

    final String verificationStatus = formatVerificationStatus(
      property["verification_status"],
    );

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.22)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),

                child: image.isEmpty
                    ? buildPropertyImagePlaceholder()
                    : Image.network(
                        image,

                        width: 115,
                        height: 120,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return buildPropertyImagePlaceholder();
                        },
                      ),
              ),

              Positioned(
                left: 7,
                top: 7,

                child: buildBadge(
                  rentalStatus,

                  rentalStatus == "Available"
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.bold,

                          color: ownerPrimaryColor,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.more_vert_rounded,

                      size: 20,

                      color: Color(0xFF667085),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,

                      size: 14,

                      color: Color(0xFF7D8990),
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,

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

                const SizedBox(height: 7),

                Text(
                  price,

                  style: const TextStyle(
                    fontSize: 15,

                    fontWeight: FontWeight.bold,

                    color: ownerPrimaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    buildBadge(
                      verificationStatus,

                      getVerificationColor(verificationStatus),
                    ),

                    const Spacer(),

                    InkWell(
                      onTap: () {
                        showStatusBottomSheet(property, rentalStatus);
                      },

                      borderRadius: BorderRadius.circular(10),

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          border: Border.all(color: const Color(0xFF2563EB)),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.swap_horiz_rounded,

                              size: 15,

                              color: Color(0xFF2563EB),
                            ),

                            SizedBox(width: 3),

                            Text(
                              "Status",

                              style: TextStyle(
                                fontSize: 9.5,

                                fontWeight: FontWeight.w600,

                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
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

  // Verification badge color
  Color getVerificationColor(String status) {
    if (status == "Approved") {
      return const Color(0xFF2563EB);
    }

    if (status == "Rejected") {
      return const Color(0xFFDC2626);
    }

    return const Color(0xFFF59E0B);
  }

  // Property image placeholder
  Widget buildPropertyImagePlaceholder() {
    return Container(
      width: 115,
      height: 120,

      color: ownerLightSecondaryColor,

      child: const Icon(
        Icons.home_work_outlined,

        size: 40,

        color: ownerPrimaryColor,
      ),
    );
  }

  // Badge
  Widget buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 9,

          fontWeight: FontWeight.w600,

          color: color,
        ),
      ),
    );
  }

  // Empty property state
  Widget buildEmptyProperties() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.18)),
      ),

      child: const Column(
        children: [
          Icon(Icons.home_work_outlined, size: 46, color: ownerPrimaryColor),

          SizedBox(height: 12),

          Text(
            "No properties yet",

            style: TextStyle(
              fontSize: 16,

              fontWeight: FontWeight.bold,

              color: ownerPrimaryColor,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Your recently submitted properties will appear here.",

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
          ),
        ],
      ),
    );
  }

  // Error state
  Widget buildErrorState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline_rounded,

              size: 48,

              color: Color(0xFFDC2626),
            ),

            const SizedBox(height: 12),

            const Text(
              "Unable to load home",

              style: TextStyle(
                fontSize: 16,

                fontWeight: FontWeight.bold,

                color: ownerPrimaryColor,
              ),
            ),

            const SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Text(
                errorMessage ?? "Something went wrong.",

                textAlign: TextAlign.center,

                style: const TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: loadHomeData,

              icon: const Icon(Icons.refresh_rounded),

              label: const Text("Retry"),

              style: ElevatedButton.styleFrom(
                backgroundColor: ownerPrimaryColor,

                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Change availability
  void showStatusBottomSheet(
    Map<String, dynamic> property,
    String currentStatus,
  ) {
    final String propertyName = property["name"]?.toString() ?? "Property";

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

                color: ownerPrimaryColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              propertyName,

              style: const TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),

            const SizedBox(height: 20),

            buildStatusOption(
              icon: Icons.check_circle_outline_rounded,

              title: "Available",

              subtitle: "This property is currently open for rent",

              color: const Color(0xFF16A34A),

              selected: currentStatus == "Available",

              onTap: () {
                updatePropertyRentalStatus(
                  property: property,
                  newStatus: "available",
                );
              },
            ),

            const SizedBox(height: 12),

            buildStatusOption(
              icon: Icons.key_rounded,

              title: "Rented",

              subtitle: "This property is currently occupied",

              color: const Color(0xFFDC2626),

              selected: currentStatus == "Rented",

              onTap: () {
                updatePropertyRentalStatus(
                  property: property,
                  newStatus: "rented",
                );
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Status option
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
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(0.10),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 22),
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

                      color: ownerPrimaryColor,
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
}
