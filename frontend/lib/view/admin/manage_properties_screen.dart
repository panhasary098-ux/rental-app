import 'package:final_project/service/admin_service.dart';
import 'package:final_project/view/admin/admin_property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _primaryColor = Color(0xFF03045E);
const Color _secondaryColor = Color(0xFF90E0EF);
const Color _backgroundColor = Color(0xFFF4FCFE);
const Color _lightSecondaryColor = Color(0xFFE6F9FC);

class ManagePropertiesScreen extends StatefulWidget {
  const ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() => _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState extends State<ManagePropertiesScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> properties = [];

  @override
  void initState() {
    super.initState();

    loadProperties();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  Future<void> loadProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await adminService.getManagedProperties();

      if (!mounted) {
        return;
      }

      setState(() {
        properties = result;
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

  List<Map<String, dynamic>> get filteredProperties {
    final String query = searchController.text.trim().toLowerCase();

    return properties.where((property) {
      final String title = property["title"]?.toString().toLowerCase() ?? "";

      final String owner = property["owner"]?.toString().toLowerCase() ?? "";

      final String location =
          property["location"]?.toString().toLowerCase() ?? "";

      final String postStatus =
          property["post_status"]?.toString().toLowerCase() ?? "";

      final bool matchesSearch =
          query.isEmpty ||
          title.contains(query) ||
          owner.contains(query) ||
          location.contains(query);

      bool matchesFilter = true;

      if (selectedFilter == "Active") {
        matchesFilter = postStatus == "active";
      }

      if (selectedFilter == "Removed") {
        matchesFilter = postStatus == "removed";
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString();

    url = url.replaceFirst("http://localhost:8000", "http://10.0.2.2:8000");

    url = url.replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");

    return url;
  }

  String formatPostStatus(dynamic value) {
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "active") {
      return "Active";
    }

    if (status == "removed") {
      return "Removed";
    }

    return status.isEmpty ? "-" : status;
  }

  String formatRentalStatus(dynamic value) {
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "available") {
      return "Available";
    }

    if (status == "rented") {
      return "Rented";
    }

    return status.isEmpty ? "-" : status;
  }

  String getPrice(Map<String, dynamic> property) {
    final dynamic price = property["price"];

    if (price != null && price.toString().isNotEmpty) {
      return price.toString();
    }

    final dynamic rawPrice = property["raw_price"];

    if (rawPrice != null) {
      return "\$$rawPrice / month";
    }

    return "-";
  }

  @override
  Widget build(BuildContext context) {
    final displayedProperties = filteredProperties;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAF8),

        elevation: 0,

        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,

            color: Color(0xFF1F2923),
          ),
        ),

        title: const Text(
          "Manage Properties",

          style: TextStyle(
            fontSize: 20,

            fontWeight: FontWeight.bold,

            color: Color(0xFF1F2923),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),

              child: TextField(
                controller: searchController,

                decoration: InputDecoration(
                  hintText: "Search properties...",

                  hintStyle: const TextStyle(
                    color: Color(0xFF94A099),

                    fontSize: 14,
                  ),

                  prefixIcon: const Icon(
                    Icons.search_rounded,

                    color: Color(0xFF68756D),
                  ),

                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: searchController.clear,

                          icon: const Icon(
                            Icons.close_rounded,

                            color: _primaryColor,
                          ),
                        ),

                  filled: true,

                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.symmetric(vertical: 14),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: const BorderSide(
                      color: _primaryColor,

                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 18),

              child: Row(
                children: [
                  buildFilterChip("All"),

                  const SizedBox(width: 8),

                  buildFilterChip("Active"),

                  const SizedBox(width: 8),

                  buildFilterChip("Removed"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(child: buildContent(displayedProperties)),
          ],
        ),
      ),
    );
  }

  Widget buildContent(List<Map<String, dynamic>> displayedProperties) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _primaryColor),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

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
                "Unable to load properties",

                style: TextStyle(
                  fontSize: 16,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFF1F2923),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                errorMessage!,

                textAlign: TextAlign.center,

                style: const TextStyle(fontSize: 13, color: Color(0xFF68756D)),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: loadProperties,

                icon: const Icon(Icons.refresh_rounded),

                label: const Text("Try Again"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,

                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color: _secondaryColor.withOpacity(0.25),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.home_work_outlined,

                color: _primaryColor,

                size: 32,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "No properties found",

              style: TextStyle(
                fontSize: 16,

                fontWeight: FontWeight.bold,

                color: Color(0xFF1F2923),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "There are no properties in this category.",

              style: TextStyle(fontSize: 12, color: Color(0xFF68756D)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _primaryColor,

      onRefresh: loadProperties,

      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 25),

        itemCount: displayedProperties.length,

        separatorBuilder: (context, index) {
          return const SizedBox(height: 14);
        },

        itemBuilder: (context, index) {
          return buildPropertyCard(displayedProperties[index]);
        },
      ),
    );
  }

  Widget buildFilterChip(String title) {
    final bool isSelected = selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius: BorderRadius.circular(20),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),

        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey.withOpacity(0.4),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,

            fontWeight: FontWeight.w600,

            color: isSelected ? Colors.white : const Color(0xFF68756D),
          ),
        ),
      ),
    );
  }

  Widget buildPropertyCard(Map<String, dynamic> property) {
    final String imageUrl = getImageUrl(property["image"]);

    final String postStatus = formatPostStatus(property["post_status"]);

    final String rentalStatus = formatRentalStatus(property["rental_status"]);

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.4)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),

                child: imageUrl.isEmpty
                    ? buildImagePlaceholder()
                    : Image.network(
                        imageUrl,

                        width: 105,

                        height: 105,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return buildImagePlaceholder();
                        },
                      ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            property["title"]?.toString() ?? "Property",

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 16,

                              height: 1.3,

                              fontWeight: FontWeight.bold,

                              color: Color(0xFF1F2923),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        buildPostStatusBadge(postStatus),
                      ],
                    ),

                    const SizedBox(height: 9),

                    Text(
                      getPrice(property),

                      style: const TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,

                        color: _primaryColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.circle,

                          size: 9,

                          color: rentalStatus == "Available"
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                        ),

                        const SizedBox(width: 6),

                        Text(
                          rentalStatus,

                          style: TextStyle(
                            fontSize: 12,

                            fontWeight: FontWeight.w600,

                            color: rentalStatus == "Available"
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_rounded,

                          size: 16,

                          color: Color(0xFF68756D),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            property["owner"]?.toString() ?? "Unknown Owner",

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 12,

                              color: Color(0xFF68756D),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,

                          size: 16,

                          color: Color(0xFF68756D),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            property["location"]?.toString() ?? "-",

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 12,

                              color: Color(0xFF68756D),
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

          const SizedBox(height: 16),

          Divider(height: 1, color: Colors.grey.withOpacity(0.25)),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      showPropertyPost(property);
                    },

                    icon: const Icon(Icons.visibility_outlined, size: 20),

                    label: const Text(
                      "View Post",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 70,
                height: 50,

                child: OutlinedButton(
                  onPressed: () {
                    showManagePostSheet(property);
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF68756D),

                    side: BorderSide(color: Colors.grey.withOpacity(0.4)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  child: const Icon(Icons.more_horiz_rounded, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      width: 105,
      height: 105,

      color: _secondaryColor.withOpacity(0.25),

      child: const Icon(
        Icons.home_work_outlined,

        color: _primaryColor,

        size: 32,
      ),
    );
  }

  Widget buildPostStatusBadge(String status) {
    final bool active = status == "Active";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: active
            ? _secondaryColor.withOpacity(0.25)
            : const Color(0xFFFEF2F2),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 10,

          fontWeight: FontWeight.bold,

          color: active ? _primaryColor : const Color(0xFFDC2626),
        ),
      ),
    );
  }

  void showPropertyPost(Map<String, dynamic> property) {
    Get.to(
      () => AdminPropertyDetailScreen(
        property: property,

        onManagePost: () {
          showManagePostSheet(property);
        },
      ),
    );
  }

  void showManagePostSheet(Map<String, dynamic> property) {
    final String postStatus = formatPostStatus(property["post_status"]);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 4,

                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E0DB),

                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Manage Post",

                style: TextStyle(
                  fontSize: 19,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFF1F2923),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                property["title"]?.toString() ?? "Property",

                style: const TextStyle(fontSize: 13, color: Color(0xFF68756D)),
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: () {
                  Get.back();

                  if (postStatus != "Active") {
                    updatePostStatus(property: property, postStatus: "active");
                  }
                },

                borderRadius: BorderRadius.circular(14),

                child: Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(14),

                    border: Border.all(color: _secondaryColor),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: _lightSecondaryColor,

                          borderRadius: BorderRadius.circular(11),
                        ),

                        child: const Icon(
                          Icons.check_circle_outline_rounded,

                          color: _primaryColor,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Keep Post",

                              style: TextStyle(
                                fontWeight: FontWeight.w600,

                                color: _primaryColor,
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Keep this property visible to renters.",

                              style: TextStyle(
                                fontSize: 11,

                                color: Color(0xFF68756D),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (postStatus == "Active")
                        const Icon(
                          Icons.check_circle_rounded,

                          color: _primaryColor,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: () {
                  Get.back();

                  if (postStatus != "Removed") {
                    showRemoveConfirmation(property);
                  }
                },

                borderRadius: BorderRadius.circular(14),

                child: Container(
                  padding: const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),

                    borderRadius: BorderRadius.circular(14),

                    border: Border.all(
                      color: const Color(0xFFDC2626).withOpacity(0.20),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626).withOpacity(0.08),

                          borderRadius: BorderRadius.circular(11),
                        ),

                        child: const Icon(
                          Icons.delete_outline_rounded,

                          color: Color(0xFFDC2626),
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Remove Post",

                              style: TextStyle(
                                fontWeight: FontWeight.w600,

                                color: Color(0xFFDC2626),
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Remove this property from public listings.",

                              style: TextStyle(
                                fontSize: 11,

                                color: Color(0xFF68756D),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (postStatus == "Removed")
                        const Icon(
                          Icons.check_circle_rounded,

                          color: Color(0xFFDC2626),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  void showRemoveConfirmation(Map<String, dynamic> property) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: const Text(
          "Remove Post",

          style: TextStyle(
            fontWeight: FontWeight.bold,

            color: Color(0xFFDC2626),
          ),
        ),

        content: const Text(
          "Are you sure you want to remove this property from public listings?",
        ),

        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),

          ElevatedButton(
            onPressed: () {
              Get.back();

              updatePostStatus(property: property, postStatus: "removed");
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),

              foregroundColor: Colors.white,
            ),

            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Future<void> updatePostStatus({
    required Map<String, dynamic> property,

    required String postStatus,
  }) async {
    final int? propertyId = int.tryParse(property["id"].toString());

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing.",

        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: _primaryColor)),

        barrierDismissible: false,
      );

      final bool success = await adminService.updatePropertyPostStatus(
        propertyId: propertyId,

        postStatus: postStatus,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          property["post_status"] = postStatus;
        });

        Get.snackbar(
          postStatus == "active" ? "Post Activated" : "Post Removed",

          postStatus == "active"
              ? "The property is visible to renters again."
              : "The property has been removed from public listings.",

          snackPosition: SnackPosition.TOP,

          backgroundColor: postStatus == "active"
              ? _primaryColor
              : const Color(0xFFDC2626),

          colorText: Colors.white,
        );
      }
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

        snackPosition: SnackPosition.TOP,

        backgroundColor: const Color(0xFFDC2626),

        colorText: Colors.white,
      );
    }
  }
}
