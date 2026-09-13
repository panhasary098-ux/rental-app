import 'dart:convert';

import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
Color backgroundColor = Color.fromARGB(255, 242, 242, 242);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() =>
      _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState
    extends State<OwnerPropertiesScreen> {
  final PropertyService propertyService =
      PropertyService();

  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = "All";
  String searchQuery = "";

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> properties = [];

  final String storageBaseUrl =
      "http://10.0.2.2:8000/storage";

  @override
  void initState() {
    super.initState();

    loadProperties();

    searchController.addListener(() {
      setState(() {
        searchQuery =
            searchController.text
                .trim()
                .toLowerCase();
      });
    });
  }

  Future<void> loadProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response =
          await propertyService
              .getMyProperties();

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {
        final List<dynamic> propertyList =
            data["properties"] ?? [];

        if (!mounted) {
          return;
        }

        setState(() {
          properties =
              propertyList
                  .map(
                    (item) =>
                        Map<String, dynamic>.from(
                          item,
                        ),
                  )
                  .toList();
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          errorMessage =
              data["message"] ??
              "Unable to load properties.";
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

  List<Map<String, dynamic>>
  get filteredProperties {
    return properties.where((property) {
      final String rentalStatus =
          (property["rental_status"] ?? "")
              .toString()
              .toLowerCase();

      final String verificationStatus =
          (property["verification_status"] ?? "")
              .toString()
              .toLowerCase();

      bool matchesFilter = true;

      if (selectedFilter ==
          "Available") {
        matchesFilter =
            rentalStatus == "available";
      } else if (selectedFilter ==
          "Rented") {
        matchesFilter =
            rentalStatus == "rented";
      } else if (selectedFilter ==
          "Pending") {
        matchesFilter =
            verificationStatus == "pending";
      }

      final String name =
          (property["name"] ?? "")
              .toString()
              .toLowerCase();

      final String address =
          (property["address"] ?? "")
              .toString()
              .toLowerCase();

      final bool matchesSearch =
          searchQuery.isEmpty ||
          name.contains(searchQuery) ||
          address.contains(searchQuery);

      return matchesFilter &&
          matchesSearch;
    }).toList();
  }

  String? getPropertyImage(
    Map<String, dynamic> property,
  ) {
    final dynamic path =
        property["cover_image_path"];

    if (path == null ||
        path.toString().trim().isEmpty) {
      return null;
    }

    return buildStorageUrl(
      path.toString(),
    );
  }

  String buildStorageUrl(
    String path,
  ) {
    if (path.isEmpty) {
      return "";
    }

    if (path.startsWith("http://") ||
        path.startsWith("https://")) {
      return path
          .replaceFirst(
            "http://localhost:8000",
            "http://10.0.2.2:8000",
          )
          .replaceFirst(
            "http://127.0.0.1:8000",
            "http://10.0.2.2:8000",
          );
    }

    String cleanPath = path;

    if (cleanPath.startsWith("/")) {
      cleanPath =
          cleanPath.substring(1);
    }

    if (cleanPath.startsWith(
      "storage/",
    )) {
      return "http://10.0.2.2:8000/$cleanPath";
    }

    return "http://10.0.2.2:8000/storage/$cleanPath";
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return "";
    }

    return text[0].toUpperCase() +
        text
            .substring(1)
            .toLowerCase();
  }

  String getPrice(
    Map<String, dynamic> property,
  ) {
    final dynamic rawPrice =
        property["price"];

    final double? price =
        double.tryParse(
      rawPrice.toString(),
    );

    if (price == null) {
      return "\$${rawPrice ?? 0} / month";
    }

    if (price ==
        price.roundToDouble()) {
      return "\$${price.toInt()} / month";
    }

    return "\$${price.toStringAsFixed(2)} / month";
  }

  bool canEdit(
    Map<String, dynamic> property,
  ) {
    if (property["can_edit"] is bool) {
      return property["can_edit"];
    }

    final String verificationStatus =
        (property["verification_status"] ?? "")
            .toString()
            .toLowerCase();

    return verificationStatus !=
        "approved";
  }

  Future<void> updatePropertyStatus(
    Map<String, dynamic> property,
    String newStatus,
  ) async {
    try {
      final dynamic rawId =
          property["id"];

      final int? propertyId =
          int.tryParse(
        rawId.toString(),
      );

      if (propertyId == null) {
        Get.snackbar(
          "Error",
          "Invalid property ID.",
          snackPosition:
              SnackPosition.TOP,
        );

        return;
      }

      final response =
          await propertyService
              .updateRentalStatus(
        propertyId: propertyId,
        rentalStatus: newStatus,
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {
        setState(() {
          property["rental_status"] =
              newStatus;
        });

        Get.back();

        Get.snackbar(
          "Status Updated",
          "${property["name"]} is now ${capitalize(newStatus)}",
          snackPosition:
              SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: primaryColor,
        );
      } else {
        Get.snackbar(
          "Update Failed",
          data["message"] ??
              "Unable to update property status.",
          snackPosition:
              SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition:
            SnackPosition.TOP,
      );
    }
  }

  Future<void> handleEditProperty(
    Map<String, dynamic> property,
  ) async {
    if (!canEdit(property)) {
      Get.snackbar(
        "Edit Not Available",
        "Approved properties cannot be edited.",
        snackPosition:
            SnackPosition.TOP,
      );

      return;
    }

    final dynamic result =
        await Get.to(
      () => Postpropertyscreen(
        propertyToEdit: property,
      ),
    );

    if (result == true) {
      await loadProperties();
    }
  }

  void handleViewDetails(
    Map<String, dynamic> property,
  ) {
    Get.to(
      () =>
          OwnerPropertyDetailScreen(
        property: property,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final List<Map<String, dynamic>>
    currentProperties =
        filteredProperties;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 242),

      appBar: AppBar(
        automaticallyImplyLeading:
            false,
        backgroundColor:
            backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: const Text(
          "My Properties",
          style: TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            Container(
              color: backgroundColor,

              padding:
                  const EdgeInsets
                      .fromLTRB(
                18,
                10,
                18,
                16,
              ),

              child: Column(
                children: [
                  Container(
                    height: 50,

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        15,
                      ),

                      border:
                          Border.all(
                        color: Colors.grey
                            .withOpacity(
                          0.20,
                        ),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                            0.03,
                          ),
                          blurRadius: 8,
                          offset:
                              const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller:
                          searchController,

                      decoration:
                          const InputDecoration(
                        hintText:
                            "Search your properties",

                        hintStyle:
                            TextStyle(
                          fontSize: 13,
                          color:
                              Color(
                            0xFF98A2B3,
                          ),
                        ),

                        prefixIcon:
                            Icon(
                          Icons
                              .search_rounded,
                          color:
                              Color(
                            0xFF667085,
                          ),
                        ),

                        border:
                            InputBorder.none,

                        contentPadding:
                            EdgeInsets
                                .symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal,

                    child: Row(
                      children: [
                        buildFilterChip(
                          "All",
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        buildFilterChip(
                          "Available",
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        buildFilterChip(
                          "Rented",
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        buildFilterChip(
                          "Pending",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (isLoading)
              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        primaryColor,
                  ),
                ),
              )
            else if (errorMessage !=
                null)
              Expanded(
                child:
                    buildErrorState(),
              )
            else ...[
              Padding(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  18,
                  18,
                  18,
                  10,
                ),

                child: Row(
                  children: [
                    Text(
                      "${currentProperties.length} Properties",

                      style:
                          const TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            primaryColor,
                      ),
                    ),

                    const Spacer(),

                    const Text(
                      "Manage your listings",

                      style:
                          TextStyle(
                        fontSize: 11,
                        color:
                            Color(
                          0xFF7D8990,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child:
                    currentProperties
                            .isEmpty
                        ? buildEmptyState()
                        : RefreshIndicator(
                            color:
                                primaryColor,

                            onRefresh:
                                loadProperties,

                            child:
                                ListView
                                    .separated(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),

                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                18,
                                4,
                                18,
                                28,
                              ),

                              itemCount:
                                  currentProperties
                                      .length,

                              separatorBuilder:
                                  (
                                    context,
                                    index,
                                  ) {
                                return const SizedBox(
                                  height:
                                      16,
                                );
                              },

                              itemBuilder:
                                  (
                                    context,
                                    index,
                                  ) {
                                return buildPropertyCard(
                                  currentProperties[index],
                                );
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

  Widget buildFilterChip(
    String title,
  ) {
    final bool selected =
        selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius:
          BorderRadius.circular(30),

      child: Container(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 17,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected
              ? primaryColor
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            30,
          ),

          border: Border.all(
            color: selected
                ? primaryColor
                : Colors.grey
                    .withOpacity(
                  0.25,
                ),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,

            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.w500,

            color: selected
                ? Colors.white
                : const Color(
                    0xFF667085,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    final String rentalStatus =
        capitalize(
      (property["rental_status"] ??
              "")
          .toString(),
    );

    final String verificationStatus =
        capitalize(
      (property["verification_status"] ??
              "")
          .toString(),
    );

    final String? imageUrl =
        getPropertyImage(property);

    final bool editable =
        canEdit(property);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey
              .withOpacity(0.18),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius
                        .vertical(
                  top: Radius.circular(
                    18,
                  ),
                ),

                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width:
                            double.infinity,
                        height: 190,
                        fit: BoxFit.cover,

                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return buildImagePlaceholder();
                        },
                      )
                    : buildImagePlaceholder(),
              ),

              Positioned(
                left: 10,
                top: 10,

                child:
                    buildRentalBadge(
                  rentalStatus,

                  rentalStatus ==
                          "Available"
                      ? const Color(
                          0xFF16A34A,
                        )
                      : const Color(
                          0xFFDC2626,
                        ),
                ),
              ),

              Positioned(
                right: 10,
                top: 10,

                child: Container(
                  width: 38,
                  height: 38,

                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.94,
                    ),
                    shape:
                        BoxShape.circle,
                  ),

                  child:
                      PopupMenuButton<
                          String>(
                    padding:
                        EdgeInsets.zero,

                    icon:
                        const Icon(
                      Icons
                          .more_vert_rounded,
                      size: 20,
                      color:
                          primaryColor,
                    ),

                    itemBuilder:
                        (context) {
                      return [
                        PopupMenuItem(
                          value: "edit",

                          enabled:
                              editable,

                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .edit_outlined,
                                size: 19,

                                color: editable
                                    ? null
                                    : Colors
                                        .grey,
                              ),

                              const SizedBox(
                                width: 10,
                              ),

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
                              Icon(
                                Icons
                                    .visibility_outlined,
                                size: 19,
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Text(
                                "View Details",
                              ),
                            ],
                          ),
                        ),
                      ];
                    },

                    onSelected:
                        (value) {
                      if (value ==
                          "edit") {
                        handleEditProperty(
                          property,
                        );
                      }

                      if (value ==
                          "view") {
                        handleViewDetails(
                          property,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding:
                const EdgeInsets
                    .fromLTRB(
              14,
              12,
              14,
              14,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  property["name"] ??
                      "Unnamed Property",

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        primaryColor,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons
                          .location_on_outlined,
                      size: 14,
                      color:
                          Color(
                        0xFF7D8990,
                      ),
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    Expanded(
                      child: Text(
                        property[
                                "address"] ??
                            "No location",

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(
                          fontSize: 11,
                          color:
                              Color(
                            0xFF7D8990,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  getPrice(property),

                  style:
                      const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        primaryColor,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                buildVerificationBadge(
                  verificationStatus,
                ),

                const SizedBox(
                  height: 14,
                ),

                Divider(
                  height: 1,
                  color: Colors.grey
                      .withOpacity(
                    0.20,
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                Row(
                  children: [
                    Expanded(
                      child:
                          OutlinedButton
                              .icon(
                        onPressed: editable
                            ? () {
                                handleEditProperty(
                                  property,
                                );
                              }
                            : null,

                        icon:
                            const Icon(
                          Icons
                              .edit_outlined,
                          size: 17,
                        ),

                        label: Text(
                          editable
                              ? "Edit"
                              : "Locked",

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .w600,
                            fontSize:
                                12,
                          ),
                        ),

                        style:
                            OutlinedButton
                                .styleFrom(
                          foregroundColor:
                              primaryColor,

                          disabledForegroundColor:
                              Colors.grey,

                          side:
                              BorderSide(
                            color: editable
                                ? Colors
                                    .grey
                                    .withOpacity(
                                    0.35,
                                  )
                                : Colors
                                    .grey
                                    .withOpacity(
                                    0.20,
                                  ),
                          ),

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      flex: 2,

                      child:
                          ElevatedButton
                              .icon(
                        onPressed: () {
                          showStatusBottomSheet(
                            property,
                          );
                        },

                        icon:
                            const Icon(
                          Icons
                              .swap_horiz_rounded,
                          size: 18,
                        ),

                        label:
                            const Text(
                          "Change Status",

                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .w600,
                            fontSize:
                                12,
                          ),
                        ),

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              primaryColor,

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 12,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
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

  Widget buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 190,

      color: secondaryColor
          .withOpacity(0.18),

      child: const Icon(
        Icons.home_work_outlined,
        size: 55,
        color: primaryColor,
      ),
    );
  }

  Widget buildVerificationBadge(
    String status,
  ) {
    Color color;
    IconData icon;

    if (status == "Approved") {
      color =
          const Color(0xFF2563EB);
      icon =
          Icons.verified_rounded;
    } else if (status ==
        "Pending") {
      color =
          const Color(0xFFF59E0B);
      icon =
          Icons.schedule_rounded;
    } else {
      color =
          const Color(0xFFDC2626);
      icon =
          Icons.cancel_outlined;
    }

    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color:
            color.withOpacity(0.10),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            status,

            style: TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRentalBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.white
            .withOpacity(0.94),

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.08),
            blurRadius: 5,
          ),
        ],
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration:
                BoxDecoration(
              color: color,
              shape:
                  BoxShape.circle,
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            text,

            style: TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void showStatusBottomSheet(
    Map<String, dynamic> property,
  ) {
    final String currentStatus =
        (property["rental_status"] ?? "")
            .toString()
            .toLowerCase();

    Get.bottomSheet(
      Container(
        padding:
            const EdgeInsets
                .fromLTRB(
          20,
          12,
          20,
          28,
        ),

        decoration:
            const BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              24,
            ),
          ),
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,

                decoration:
                    BoxDecoration(
                  color: Colors.grey
                      .withOpacity(
                    0.30,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "Change Availability",

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color:
                    primaryColor,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              property["name"] ?? "",

              style:
                  const TextStyle(
                fontSize: 12,
                color:
                    Color(
                  0xFF7D8990,
                ),
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            const Text(
              "Choose the current rental status of this property.",

              style: TextStyle(
                fontSize: 12,
                color:
                    Color(
                  0xFF98A2B3,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            buildStatusOption(
              icon:
                  Icons
                      .check_circle_outline_rounded,

              title: "Available",

              subtitle:
                  "Property is currently open for rent",

              color:
                  const Color(
                0xFF16A34A,
              ),

              selected:
                  currentStatus ==
                      "available",

              onTap: () {
                if (currentStatus ==
                    "available") {
                  Get.back();

                  return;
                }

                updatePropertyStatus(
                  property,
                  "available",
                );
              },
            ),

            const SizedBox(
              height: 12,
            ),

            buildStatusOption(
              icon:
                  Icons.key_rounded,

              title: "Rented",

              subtitle:
                  "Property is currently occupied",

              color:
                  const Color(
                0xFFDC2626,
              ),

              selected:
                  currentStatus ==
                      "rented",

              onTap: () {
                if (currentStatus ==
                    "rented") {
                  Get.back();

                  return;
                }

                updatePropertyStatus(
                  property,
                  "rented",
                );
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

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

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        padding:
            const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(
                  0.08,
                )
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          border: Border.all(
            color: selected
                ? color
                : Colors.grey
                    .withOpacity(
                  0.30,
                ),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration:
                  BoxDecoration(
                color:
                    color.withOpacity(
                  0.10,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              ),

              child: Icon(
                icon,
                color: color,
                size: 23,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight
                              .bold,
                      color:
                          primaryColor,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    subtitle,

                    style:
                        const TextStyle(
                      fontSize: 11,
                      color:
                          Color(
                        0xFF7D8990,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              Icon(
                Icons
                    .check_circle_rounded,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return const Center(
      child: Padding(
        padding:
            EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons.home_work_outlined,
              size: 55,
              color: secondaryColor,
            ),

            SizedBox(height: 18),

            Text(
              "No properties found",

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    primaryColor,
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Your properties matching this filter will appear here.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 12,
                color:
                    Color(
                  0xFF7D8990,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons
                  .error_outline_rounded,
              size: 55,
              color:
                  Color(
                0xFFDC2626,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            const Text(
              "Unable to load properties",

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color:
                    primaryColor,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              errorMessage ?? "",

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                fontSize: 12,
                color:
                    Color(
                  0xFF7D8990,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            ElevatedButton.icon(
              onPressed:
                  loadProperties,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label:
                  const Text("Retry"),

              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    primaryColor,

                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}

class OwnerPropertyDetailScreen
    extends StatefulWidget {
  final Map<String, dynamic> property;

  const OwnerPropertyDetailScreen({
    super.key,
    required this.property,
  });

  @override
  State<OwnerPropertyDetailScreen>
  createState() =>
      _OwnerPropertyDetailScreenState();
}

class _OwnerPropertyDetailScreenState
    extends State<
      OwnerPropertyDetailScreen
    > {
  int currentImageIndex = 0;

  Map<String, dynamic>
  get property => widget.property;

  String buildStorageUrl(
    String path,
  ) {
    if (path.isEmpty) {
      return "";
    }

    if (path.startsWith("http://") ||
        path.startsWith("https://")) {
      return path
          .replaceFirst(
            "http://localhost:8000",
            "http://10.0.2.2:8000",
          )
          .replaceFirst(
            "http://127.0.0.1:8000",
            "http://10.0.2.2:8000",
          );
    }

    String cleanPath = path;

    if (cleanPath.startsWith("/")) {
      cleanPath =
          cleanPath.substring(1);
    }

    if (cleanPath.startsWith(
      "storage/",
    )) {
      return "http://10.0.2.2:8000/$cleanPath";
    }

    return "http://10.0.2.2:8000/storage/$cleanPath";
  }

  List<String> get images {
    final List<String> result = [];

    final dynamic rawImages =
        property["images"];

    if (rawImages is List) {
      for (final dynamic image
          in rawImages) {
        if (image is Map) {
          final dynamic imageUrl =
              image["image_url"];

          final dynamic imagePath =
              image["image_path"];

          if (imageUrl != null &&
              imageUrl
                  .toString()
                  .isNotEmpty) {
            final String url =
                buildStorageUrl(
              imageUrl.toString(),
            );

            if (!result.contains(url)) {
              result.add(url);
            }
          } else if (imagePath !=
                  null &&
              imagePath
                  .toString()
                  .isNotEmpty) {
            final String url =
                buildStorageUrl(
              imagePath.toString(),
            );

            if (!result.contains(url)) {
              result.add(url);
            }
          }
        }
      }
    }

    final dynamic coverPath =
        property["cover_image_path"];

    if (result.isEmpty &&
        coverPath != null &&
        coverPath
            .toString()
            .isNotEmpty) {
      result.add(
        buildStorageUrl(
          coverPath.toString(),
        ),
      );
    }

    return result;
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return "";
    }

    return text[0].toUpperCase() +
        text
            .substring(1)
            .toLowerCase();
  }

  String get price {
    final double? value =
        double.tryParse(
      property["price"]
              ?.toString() ??
          "0",
    );

    if (value == null) {
      return "\$0 / month";
    }

    if (value ==
        value.roundToDouble()) {
      return "\$${value.toInt()} / month";
    }

    return "\$${value.toStringAsFixed(2)} / month";
  }

  String get propertyType {
    final String value =
        (property["property_type"] ?? "")
            .toString()
            .toLowerCase();

    if (value == "apartment") {
      return "Apartment/Flat";
    }

    return capitalize(value);
  }

  String get furnishedText {
    final dynamic raw =
        property["furnished"];

    final bool furnished =
        raw == true ||
        raw == 1 ||
        raw == "1" ||
        raw.toString().toLowerCase() ==
            "true";

    return furnished
        ? "Furnished"
        : "Not Furnished";
  }

  List<int> get availableFloors {
    final List<int> result = [];

    final dynamic raw =
        property["available_floors"];

    if (raw is List) {
      for (final dynamic item in raw) {
        if (item is Map) {
          final dynamic floor =
              item["floor_number"];

          final int? value =
              int.tryParse(
            floor?.toString() ?? "",
          );

          if (value != null) {
            result.add(value);
          }
        } else {
          final int? value =
              int.tryParse(
            item.toString(),
          );

          if (value != null) {
            result.add(value);
          }
        }
      }
    }

    result.sort();

    return result;
  }

  List<Map<String, dynamic>>
  get activeFacilities {
    final dynamic raw =
        property["facilities"];

    if (raw is! Map) {
      return [];
    }

    final List<Map<String, dynamic>>
    facilityData = [
      {
        "key": "wifi",
        "label": "WiFi",
        "icon": Icons.wifi_rounded,
      },
      {
        "key": "parking",
        "label": "Parking",
        "icon":
            Icons.local_parking_rounded,
      },
      {
        "key": "air_conditioning",
        "label": "Air Conditioner",
        "icon": Icons.ac_unit_rounded,
      },
      {
        "key": "pet_allowed",
        "label": "Pet Allowed",
        "icon": Icons.pets_outlined,
      },
      {
        "key": "balcony",
        "label": "Balcony",
        "icon": Icons.balcony_outlined,
      },
      {
        "key": "kitchen",
        "label": "Kitchen",
        "icon": Icons.kitchen_outlined,
      },
      {
        "key": "swimming_pool",
        "label": "Swimming Pool",
        "icon": Icons.pool_outlined,
      },
      {
        "key": "elevator",
        "label": "Elevator",
        "icon": Icons.elevator_outlined,
      },
    ];

    return facilityData.where((item) {
      final dynamic value =
          raw[item["key"]];

      return value == true ||
          value == 1 ||
          value == "1" ||
          value
                  ?.toString()
                  .toLowerCase() ==
              "true";
    }).toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final String rentalStatus =
        capitalize(
      property["rental_status"]
              ?.toString() ??
          "",
    );

    final String verificationStatus =
        capitalize(
      property["verification_status"]
              ?.toString() ??
          "",
    );

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor:
            backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons
                .arrow_back_ios_new_rounded,
            size: 20,
            color: primaryColor,
          ),
        ),

        title: const Text(
          "Property Details",

          style: TextStyle(
            color: primaryColor,
            fontSize: 19,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(
          bottom: 30,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            buildImages(),

            Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                18,
                18,
                18,
                0,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Expanded(
                        child: Text(
                          property[
                                  "name"]
                              ?.toString() ??
                              "Property",

                          style:
                              const TextStyle(
                            color:
                                primaryColor,
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      buildRentalStatus(
                        rentalStatus,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Icon(
                        Icons
                            .location_on_outlined,
                        color:
                            Color(
                          0xFF7D8990,
                        ),
                        size: 18,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Expanded(
                        child: Text(
                          property[
                                  "address"]
                              ?.toString() ??
                              "No location",

                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFF7D8990,
                            ),
                            fontSize:
                                13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    price,

                    style:
                        const TextStyle(
                      color:
                          primaryColor,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(
                      14,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        15,
                      ),

                      border:
                          Border.all(
                        color: Colors
                            .grey
                            .withOpacity(
                          0.15,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        const Text(
                          "Verification",

                          style:
                              TextStyle(
                            color:
                                Color(
                              0xFF667085,
                            ),
                            fontSize:
                                12,
                          ),
                        ),

                        const Spacer(),

                        buildVerificationStatus(
                          verificationStatus,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  const Text(
                    "Property Information",

                    style:
                        TextStyle(
                      color:
                          primaryColor,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: [
                      buildInfoItem(
                        icon: Icons
                            .home_work_outlined,
                        title: "Type",
                        value:
                            propertyType,
                      ),

                      buildInfoItem(
                        icon: Icons
                            .square_foot_rounded,
                        title: "Size",
                        value:
                            "${property["size"] ?? "-"} m²",
                      ),

                      if (property[
                              "bedrooms"] !=
                          null)
                        buildInfoItem(
                          icon: Icons
                              .bed_outlined,
                          title:
                              "Bedrooms",
                          value: property[
                                  "bedrooms"]
                              .toString(),
                        ),

                      if (property[
                              "bathrooms"] !=
                          null)
                        buildInfoItem(
                          icon: Icons
                              .bathtub_outlined,
                          title:
                              "Bathrooms",
                          value: property[
                                  "bathrooms"]
                              .toString(),
                        ),

                      buildInfoItem(
                        icon: Icons
                            .layers_outlined,
                        title:
                            "Total Floor",
                        value: property[
                                    "total_floor"]
                                ?.toString() ??
                            "-",
                      ),

                      buildInfoItem(
                        icon: Icons
                            .chair_outlined,
                        title:
                            "Furnished",
                        value:
                            furnishedText,
                      ),
                    ],
                  ),

                  if (availableFloors
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 22,
                    ),

                    const Text(
                      "Available Floors",

                      style:
                          TextStyle(
                        color:
                            primaryColor,
                        fontSize: 17,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children:
                          availableFloors
                              .map(
                                (
                                  floor,
                                ) =>
                                    Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        12,
                                    vertical:
                                        7,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        lightSecondaryColor,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                  ),

                                  child:
                                      Text(
                                    "Floor $floor",

                                    style:
                                        const TextStyle(
                                      color:
                                          primaryColor,
                                      fontSize:
                                          11,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],

                  const SizedBox(
                    height: 22,
                  ),

                  const Text(
                    "About this place",

                    style:
                        TextStyle(
                      color:
                          primaryColor,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    property[
                            "description"]
                        ?.toString() ??
                        "No description.",

                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFF667085,
                      ),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),

                  const Text(
                    "Facilities",

                    style:
                        TextStyle(
                      color:
                          primaryColor,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  if (activeFacilities
                      .isEmpty)
                    const Text(
                      "No facilities listed.",

                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF7D8990,
                        ),
                        fontSize: 12,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children:
                          activeFacilities
                              .map(
                                (
                                  facility,
                                ) =>
                                    buildFacilityItem(
                                  icon:
                                      facility[
                                              "icon"]
                                          as IconData,
                                  label:
                                      facility[
                                              "label"]
                                          .toString(),
                                ),
                              )
                              .toList(),
                    ),

                  const SizedBox(
                    height: 22,
                  ),

                  const Text(
                    "Contact",

                    style:
                        TextStyle(
                      color:
                          primaryColor,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(
                      14,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),

                      border:
                          Border.all(
                        color: Colors
                            .grey
                            .withOpacity(
                          0.15,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,

                          decoration:
                              BoxDecoration(
                            color:
                                lightSecondaryColor,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                          ),

                          child:
                              const Icon(
                            Icons
                                .phone_outlined,
                            color:
                                primaryColor,
                            size: 20,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            property[
                                    "contact"]
                                ?.toString() ??
                                "-",

                            style:
                                const TextStyle(
                              color:
                                  primaryColor,
                              fontSize:
                                  14,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),
                      ],
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

  Widget buildImages() {
    if (images.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color:
            lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,
          size: 60,
          color: primaryColor,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,

          child: PageView.builder(
            itemCount: images.length,

            onPageChanged: (index) {
              setState(() {
                currentImageIndex =
                    index;
              });
            },

            itemBuilder:
                (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,

                errorBuilder:
                    (
                      context,
                      error,
                      stackTrace,
                    ) {
                  return Container(
                    color:
                        lightSecondaryColor,

                    child:
                        const Icon(
                      Icons
                          .home_work_outlined,
                      size: 60,
                      color:
                          primaryColor,
                    ),
                  );
                },
              );
            },
          ),
        ),

        if (images.length > 1)
          Padding(
            padding:
                const EdgeInsets.only(
              top: 10,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children:
                  List.generate(
                images.length,

                (index) =>
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 200,
                  ),

                  margin:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 3,
                  ),

                  width: index ==
                          currentImageIndex
                      ? 18
                      : 7,

                  height: 7,

                  decoration:
                      BoxDecoration(
                    color: index ==
                            currentImageIndex
                        ? primaryColor
                        : Colors.grey
                            .withOpacity(
                            0.35,
                          ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final double width =
        (MediaQuery.of(context)
                    .size
                    .width -
                46) /
            2;

    return Container(
      width: width,

      padding:
          const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey
              .withOpacity(0.14),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,

            decoration:
                BoxDecoration(
              color:
                  lightSecondaryColor,

              borderRadius:
                  BorderRadius.circular(
                9,
              ),
            ),

            child: Icon(
              icon,
              size: 19,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF7D8990,
                    ),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  value,

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    color:
                        primaryColor,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFacilityItem({
    required IconData icon,
    required String label,
  }) {
    return Container(
      width:
          (MediaQuery.of(context)
                      .size
                      .width -
                  46) /
              2,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(13),

        border: Border.all(
          color: Colors.grey
              .withOpacity(0.15),
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: primaryColor,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              label,

              maxLines: 1,

              overflow:
                  TextOverflow.ellipsis,

              style:
                  const TextStyle(
                color:
                    primaryColor,
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRentalStatus(
    String status,
  ) {
    final Color color =
        status == "Available"
            ? const Color(
                0xFF16A34A,
              )
            : const Color(
                0xFFDC2626,
              );

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color:
            color.withOpacity(0.10),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration:
                BoxDecoration(
              color: color,
              shape:
                  BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            status,

            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVerificationStatus(
    String status,
  ) {
    Color color;
    IconData icon;

    if (status == "Approved") {
      color =
          const Color(0xFF2563EB);
      icon =
          Icons.verified_rounded;
    } else if (status ==
        "Pending") {
      color =
          const Color(0xFFF59E0B);
      icon =
          Icons.schedule_rounded;
    } else {
      color =
          const Color(0xFFDC2626);
      icon =
          Icons.cancel_outlined;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color:
            color.withOpacity(0.10),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),

          const SizedBox(width: 5),

          Text(
            status,

            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}