import 'dart:typed_data';

import 'package:final_project/service/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertyReviewScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const PropertyReviewScreen({
    super.key,
    required this.property,
  });

  @override
  State<PropertyReviewScreen> createState() =>
      _PropertyReviewScreenState();
}

class _PropertyReviewScreenState
    extends State<PropertyReviewScreen> {
  final AdminService adminService = AdminService();

  bool showFloor = false;

  Map<String, dynamic> get property => widget.property;

  String get propertyType =>
      property["property_type"]?.toString().toLowerCase() ?? "";

  bool get hasAvailableFloorList {
    return propertyType == "room" || propertyType == "apartment";
  }

  int get totalFloor {
    return int.tryParse(
          property["total_floor"]?.toString() ?? "0",
        ) ??
        0;
  }

  List<int> get availableFloors {
    final dynamic value = property["available_floors"];

    if (value is! List) {
      return [];
    }

    final List<int> floors = [];

    for (final dynamic item in value) {
      if (item is Map) {
        final int? floor = int.tryParse(
          item["floor_number"]?.toString() ?? "",
        );

        if (floor != null) {
          floors.add(floor);
        }
      } else {
        final int? floor = int.tryParse(
          item.toString(),
        );

        if (floor != null) {
          floors.add(floor);
        }
      }
    }

    return floors;
  }

  bool get hasFloorAvailabilityData {
    return property["available_floors"] is List;
  }

  List<Map<String, dynamic>> get mainInfo {
    final List<Map<String, dynamic>> information = [];

    if (propertyType == "house" ||
        propertyType == "apartment") {
      if (property["bedrooms"] != null) {
        information.add({
          "icon": Icons.bed_outlined,
          "text": "${property["bedrooms"]} Bedrooms",
        });
      }

      if (property["bathrooms"] != null) {
        information.add({
          "icon": Icons.bathtub_outlined,
          "text": "${property["bathrooms"]} Bath",
        });
      }
    }

    information.add({
      "icon": Icons.square_foot,
      "text": "${formatSize(property["size"])} m²",
    });

    information.add({
      "icon": Icons.chair_outlined,
      "text": getBool(property["furnished"])
          ? "Furnished"
          : "Unfurnished",
    });

    return information;
  }

  List<Map<String, dynamic>> get availableFacilities {
    final dynamic rawFacilities = property["facilities"];

    if (rawFacilities is! Map) {
      return [];
    }

    final Map<String, dynamic> facilities =
        Map<String, dynamic>.from(rawFacilities);

    final List<Map<String, dynamic>> result = [];

    if (getBool(facilities["wifi"])) {
      result.add({
        "icon": Icons.wifi,
        "text": "WiFi",
      });
    }

    if (getBool(facilities["parking"])) {
      result.add({
        "icon": Icons.local_parking_outlined,
        "text": "Parking",
      });
    }

    if (getBool(facilities["air_conditioning"])) {
      result.add({
        "icon": Icons.ac_unit,
        "text": "Air Con",
      });
    }

    if (getBool(facilities["pet_allowed"])) {
      result.add({
        "icon": Icons.pets_outlined,
        "text": "Pet Allowed",
      });
    }

    if (getBool(facilities["balcony"])) {
      result.add({
        "icon": Icons.balcony_outlined,
        "text": "Balcony",
      });
    }

    if (getBool(facilities["swimming_pool"])) {
      result.add({
        "icon": Icons.pool_outlined,
        "text": "Swimming Pool",
      });
    }

    if (getBool(facilities["kitchen"])) {
      result.add({
        "icon": Icons.kitchen_outlined,
        "text": "Kitchen",
      });
    }

    if (getBool(facilities["elevator"])) {
      result.add({
        "icon": Icons.elevator_outlined,
        "text": "Elevator",
      });
    }

    return result;
  }

  bool getBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String text = value?.toString().toLowerCase() ?? "";

    return text == "1" || text == "true";
  }

  String formatSize(dynamic value) {
    final double? size = double.tryParse(
      value?.toString() ?? "",
    );

    if (size == null) {
      return "-";
    }

    if (size == size.roundToDouble()) {
      return size.toStringAsFixed(0);
    }

    return size.toStringAsFixed(1);
  }

  String formatPropertyType() {
    switch (propertyType) {
      case "house":
        return "House";

      case "apartment":
        return "Apartment";

      case "room":
        return "Room";

      default:
        return "-";
    }
  }

  String formatRentalStatus() {
    final String status =
        property["rental_status"]?.toString().toLowerCase() ??
            "available";

    if (status == "rented") {
      return "Rented";
    }

    if (status == "available") {
      return "Available";
    }

    if (status.isEmpty) {
      return "Available";
    }

    return "${status[0].toUpperCase()}${status.substring(1)}";
  }

  String getPrice() {
    final dynamic rawPrice = property["raw_price"];

    if (rawPrice != null) {
      final double? value = double.tryParse(
        rawPrice.toString(),
      );

      if (value != null) {
        if (value == value.roundToDouble()) {
          return value.toStringAsFixed(0);
        }

        return value.toStringAsFixed(2);
      }
    }

    final String formatted =
        property["price"]?.toString() ?? "";

    final RegExpMatch? match =
        RegExp(r'[\d,.]+').firstMatch(formatted);

    if (match != null) {
      final String number =
          match.group(0)?.replaceAll(",", "") ?? "";

      final double? value = double.tryParse(number);

      if (value != null) {
        if (value == value.roundToDouble()) {
          return value.toStringAsFixed(0);
        }

        return value.toStringAsFixed(2);
      }
    }

    return "-";
  }

  List<String> getPropertyImages() {
    final List<String> images = [];

    final dynamic rawImages = property["images"];

    if (rawImages is List) {
      for (final dynamic item in rawImages) {
        if (item is Map) {
          final dynamic rawUrl =
              item["image_url"] ??
              item["image"] ??
              item["url"];

          if (rawUrl != null &&
              rawUrl.toString().isNotEmpty) {
            images.add(
              getImageUrl(rawUrl),
            );
          }
        } else if (item != null) {
          images.add(
            getImageUrl(item),
          );
        }
      }
    }

    if (images.isEmpty &&
        property["image"] != null &&
        property["image"].toString().isNotEmpty) {
      images.add(
        getImageUrl(property["image"]),
      );
    }

    return images;
  }

  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString();

    url = url.replaceFirst(
      "http://localhost:8000",
      "http://10.0.2.2:8000",
    );

    url = url.replaceFirst(
      "http://127.0.0.1:8000",
      "http://10.0.2.2:8000",
    );

    return url;
  }

  void floorList() {
    setState(() {
      showFloor = !showFloor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,

        iconTheme: const IconThemeData(
          color: primaryColor,
        ),

        title: const Text(
          "Review Submission",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          // Property images
          SizedBox(
            height: 300,
            width: double.infinity,
            child: buildImageSlideshow(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                30,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // Property name + rental status
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          property["title"]?.toString() ??
                              property["name"]?.toString() ??
                              "Property",

                          maxLines: 2,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 22,
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      buildStatusBadge(
                        formatRentalStatus(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Location + price
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: primaryColor,
                              size: 20,
                            ),

                            const SizedBox(width: 3),

                            Expanded(
                              child: Text(
                                property["location"]
                                        ?.toString() ??
                                    property["address"]
                                        ?.toString() ??
                                    "Unknown location",

                                style: TextStyle(
                                  fontSize: 15,

                                  color: Colors.black
                                      .withOpacity(0.65),

                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,

                        children: [
                          Text(
                            "\$${getPrice()}",

                            style: const TextStyle(
                              fontSize: 23,

                              fontWeight:
                                  FontWeight.w800,

                              color: primaryColor,
                            ),
                          ),

                          const Padding(
                            padding:
                                EdgeInsets.only(
                              bottom: 3,
                            ),

                            child: Text(
                              "/Month",

                              style: TextStyle(
                                fontSize: 13,

                                fontWeight:
                                    FontWeight.w600,

                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Compact property info
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: secondaryColor.withOpacity(0.6),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 13,
                    ),

                    child: Wrap(
                      spacing: 18,
                      runSpacing: 10,

                      children:
                          mainInfo.map((item) {
                        return Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            Icon(
                              item["icon"],
                              size: 17,
                              color: primaryColor,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              item["text"],

                              style:
                                  const TextStyle(
                                fontSize: 13,

                                color: primaryColor,

                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  Container(
                    height: 1,
                    width: double.infinity,
                    color: secondaryColor.withOpacity(0.6),
                  ),

                  const SizedBox(height: 10),

                  // Floor
                  buildFloorSection(),

                  const SizedBox(height: 15),

                  // Description
                  const Text(
                    "About this place",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight.w800,

                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    property["description"]
                            ?.toString() ??
                        "-",

                    style: const TextStyle(
                      fontSize: 13,

                      color: Colors.black87,

                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Facilities
                  const Text(
                    "Facilities",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight.w800,

                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildFacilities(),

                  const SizedBox(height: 28),

                  // Owner info
                  const Text(
                    "House Owner Information",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight.w800,

                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildOwnerInfoCard(),

                  const SizedBox(height: 28),

                  // Documents
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Verification Documents",

                          style: TextStyle(
                            fontSize: 17,

                            fontWeight:
                                FontWeight.w800,

                            color: primaryColor,
                          ),
                        ),
                      ),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: secondaryColor
                              .withOpacity(0.20),

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: const Text(
                          "3 documents",

                          style: TextStyle(
                            fontSize: 11,

                            fontWeight:
                                FontWeight.w600,

                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  buildDocumentCard(
                    title: "National ID",
                    subtitle:
                        "Owner identity verification",
                    icon: Icons.badge_outlined,
                    onTap:
                        showNationalIdPreview,
                  ),

                  const SizedBox(height: 12),

                  buildDocumentCard(
                    title:
                        "Property Ownership Document",
                    subtitle:
                        "Ownership / rental authorization evidence",
                    icon:
                        Icons.description_outlined,
                    onTap:
                        showOwnershipDocumentPreview,
                  ),

                  const SizedBox(height: 12),

                  buildDocumentCard(
                    title: "Payment Proof",
                    subtitle:
                        "Property posting fee payment evidence",
                    icon:
                        Icons.receipt_long_outlined,
                    onTap:
                        showPaymentProofPreview,
                  ),

                  const SizedBox(height: 28),

                  // Checklist
                  const Text(
                    "Verification Checklist",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight.w800,

                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Confirm each item before making a decision.",

                    style: TextStyle(
                      fontSize: 12,

                      color:
                          Colors.black.withOpacity(
                        0.45,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  buildChecklistItem(
                    "Owner identity matches submitted information",
                  ),

                  const SizedBox(height: 10),

                  buildChecklistItem(
                    "Ownership document matches property information",
                  ),

                  const SizedBox(height: 10),

                  buildChecklistItem(
                    "Payment proof appears valid",
                  ),

                  const SizedBox(height: 10),

                  buildChecklistItem(
                    "Property details appear valid and complete",
                  ),

                  const SizedBox(height: 10),

                  buildChecklistItem(
                    "Submitted property images are appropriate",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar:
          buildBottomButtons(),
    );
  }

  Widget buildImageSlideshow() {
    final List<String> images =
        getPropertyImages();

    if (images.isEmpty) {
      return Container(
        color: lightSecondaryColor,

        child: const Center(
          child: Icon(
            Icons.home_work_outlined,
            size: 60,
            color: primaryColor,
          ),
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,
      height: 300,

      initialPage: 0,

      indicatorColor: primaryColor,
      indicatorBackgroundColor:
          Colors.white70,

      autoPlayInterval:
          images.length > 1 ? 3000 : 0,

      isLoop: images.length > 1,

      children: images.map((image) {
        return Image.network(
          image,

          fit: BoxFit.cover,

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: lightSecondaryColor,

              child: const Icon(
                Icons.home_work_outlined,

                size: 55,

                color: primaryColor,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildStatusBadge(
    String status,
  ) {
    final String value =
        status.toLowerCase();

    Color color;
    IconData icon;

    if (value == "available" ||
        value == "available now") {
      color = const Color(
        0xFF16A34A,
      );

      icon =
          Icons.check_circle_rounded;
    } else if (value == "rented") {
      color = const Color(
        0xFFDC2626,
      );

      icon = Icons.cancel_rounded;
    } else {
      color = const Color(
        0xFFF59E0B,
      );

      icon =
          Icons.access_time_rounded;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color,

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),

          const SizedBox(width: 4),

          Text(
            status,

            style: const TextStyle(
              color: Colors.white,

              fontSize: 12,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloorSection() {
    if (totalFloor <= 0) {
      return const SizedBox.shrink();
    }

    if (hasAvailableFloorList) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Text(
                "Floor",

                style: TextStyle(
                  fontSize: 17,

                  fontWeight:
                      FontWeight.w800,

                  color: primaryColor,
                ),
              ),

              const Spacer(),

              Text(
                "$totalFloor Floors",

                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),

              IconButton(
                onPressed: floorList,

                icon: Icon(
                  showFloor
                      ? Icons
                          .keyboard_arrow_up
                      : Icons
                          .keyboard_arrow_down,

                  size: 25,

                  color: primaryColor,
                ),
              ),
            ],
          ),

          Visibility(
            visible: showFloor,

            child: hasFloorAvailabilityData
                ? Container(
                    constraints:
                        const BoxConstraints(
                      maxHeight: 220,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),

                      border: Border.all(
                        color:
                            secondaryColor
                                .withOpacity(
                          0.5,
                        ),
                      ),
                    ),

                    child:
                        ListView.separated(
                      shrinkWrap: true,

                      padding:
                          EdgeInsets.zero,

                      itemCount:
                          totalFloor,

                      separatorBuilder:
                          (
                        context,
                        index,
                      ) {
                        return Container(
                          height: 1,

                          color:
                              secondaryColor
                                  .withOpacity(
                            0.4,
                          ),
                        );
                      },

                      itemBuilder:
                          (context, index) {
                        final int floor =
                            index + 1;

                        final bool
                            available =
                            availableFloors
                                .contains(
                          floor,
                        );

                        return Padding(
                          padding:
                              const EdgeInsets
                                  .all(
                            10,
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .apartment,

                                size: 20,

                                color:
                                    primaryColor,
                              ),

                              const SizedBox(
                                width: 6,
                              ),

                              Text(
                                "Floor $floor",

                                style:
                                    const TextStyle(
                                  fontSize:
                                      14,

                                  color:
                                      primaryColor,

                                  fontWeight:
                                      FontWeight
                                          .w500,
                                ),
                              ),

                              const Spacer(),

                              Text(
                                available
                                    ? "Available"
                                    : "Not available",

                                style:
                                    TextStyle(
                                  fontSize:
                                      13,

                                  fontWeight:
                                      available
                                          ? FontWeight
                                              .w600
                                          : FontWeight
                                              .w400,

                                  color: available
                                      ? const Color(
                                          0xFF16A34A,
                                        )
                                      : Colors
                                          .black45,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: double.infinity,

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
                        12,
                      ),

                      border: Border.all(
                        color:
                            secondaryColor
                                .withOpacity(
                          0.5,
                        ),
                      ),
                    ),

                    child: const Text(
                      "Floor availability information is not available.",

                      style: TextStyle(
                        color:
                            Colors.black54,

                        fontSize: 13,
                      ),
                    ),
                  ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Text(
          "Floor",

          style: TextStyle(
            fontSize: 17,

            fontWeight:
                FontWeight.w800,

            color: primaryColor,
          ),
        ),

        const Spacer(),

        const Icon(
          Icons.layers_outlined,
          color: primaryColor,
          size: 19,
        ),

        const SizedBox(width: 5),

        Text(
          "$totalFloor ${totalFloor == 1 ? "Floor" : "Floors"}",

          style: const TextStyle(
            color: primaryColor,

            fontSize: 14,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFacilities() {
    final List<Map<String, dynamic>>
        facilities =
        availableFacilities;

    if (facilities.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            12,
          ),

          border: Border.all(
            color: secondaryColor
                .withOpacity(0.4),
          ),
        ),

        child: const Text(
          "No facilities listed",

          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
      );
    }

    return SizedBox(
      height: 70,

      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,

        itemCount:
            facilities.length,

        itemBuilder: (
          context,
          index,
        ) {
          final Map<String, dynamic> item =
              facilities[index];

          return Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 13,
            ),

            decoration: BoxDecoration(
              color:
                  lightSecondaryColor,

              borderRadius:
                  BorderRadius.circular(
                13,
              ),

              border: Border.all(
                color: secondaryColor,
              ),
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children: [
                Icon(
                  item["icon"],
                  size: 20,
                  color: primaryColor,
                ),

                const SizedBox(height: 4),

                Text(
                  item["text"],

                  style:
                      const TextStyle(
                    fontSize: 12,

                    color:
                        primaryColor,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },

        separatorBuilder: (
          context,
          index,
        ) {
          return const SizedBox(
            width: 12,
          );
        },
      ),
    );
  }

  Widget buildOwnerInfoCard() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: secondaryColor
              .withOpacity(0.4),
        ),
      ),

      child: Column(
        children: [
          buildOwnerRow(
            Icons.person_outline,
            "Owner Name",
            property["owner"]
                    ?.toString() ??
                "-",
          ),

          buildOwnerDivider(),

          buildOwnerRow(
            Icons.email_outlined,
            "Email",
            property["email"]
                    ?.toString() ??
                "-",
          ),

          buildOwnerDivider(),

          buildOwnerRow(
            Icons.phone_outlined,
            "Phone",
            property["phone"]
                    ?.toString() ??
                "-",
          ),

          buildOwnerDivider(),

          buildOwnerRow(
            Icons.home_work_outlined,
            "Property Type",
            formatPropertyType(),
          ),

          buildOwnerDivider(),

          buildOwnerRow(
            Icons
                .calendar_today_outlined,
            "Submitted",
            property["submitted"]
                    ?.toString() ??
                "-",
          ),
        ],
      ),
    );
  }

  Widget buildOwnerRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: lightSecondaryColor,

            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),

          child: Icon(
            icon,
            size: 20,
            color: primaryColor,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style:
                    const TextStyle(
                  fontSize: 12,

                  color:
                      Colors.black45,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,

                style:
                    const TextStyle(
                  fontSize: 14,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildOwnerDivider() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),

      child: Divider(
        height: 1,

        color:
            secondaryColor.withOpacity(
          0.35,
        ),
      ),
    );
  }

  Widget buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(14),

      child: Container(
        padding:
            const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            14,
          ),

          border: Border.all(
            color: secondaryColor
                .withOpacity(0.5),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color:
                    lightSecondaryColor,

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(
                icon,
                color: primaryColor,
              ),
            ),

            const SizedBox(width: 12),

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
                          FontWeight.bold,

                      color:
                          primaryColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style:
                        const TextStyle(
                      fontSize: 12,

                      height: 1.35,

                      color:
                          Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 36,
              height: 36,

              decoration:
                  const BoxDecoration(
                color:
                    lightSecondaryColor,

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .visibility_outlined,

                color: primaryColor,

                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChecklistItem(
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(14),

        border: Border.all(
          color: secondaryColor
              .withOpacity(0.4),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            decoration: const BoxDecoration(
              color:
                  lightSecondaryColor,

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.check_rounded,

              color: primaryColor,

              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,

              style:
                  const TextStyle(
                fontSize: 13,

                height: 1.35,

                color:
                    Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomButtons() {
    return Container(
      height: 90,

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: primaryColor
                .withOpacity(0.10),

            blurRadius: 10,

            spreadRadius: 1,

            offset:
                const Offset(0, -2),
          ),
        ],
      ),

      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          20,
        ),

        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed:
                    showRejectDialog,

                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      const Color(
                    0xFFDC2626,
                  ),

                  backgroundColor:
                      const Color(
                    0xFFFEF2F2,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    Icon(
                      Icons.close_rounded,
                      size: 23,
                    ),

                    SizedBox(width: 5),

                    Text(
                      "Reject",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextButton(
                onPressed:
                    showApproveDialog,

                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      Colors.white,

                  backgroundColor:
                      primaryColor,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      15,
                    ),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,

                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 23,
                    ),

                    SizedBox(width: 5),

                    Text(
                      "Approve",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w800,
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

  int? getPropertyId() {
    if (property["id"] == null) {
      return null;
    }

    return int.tryParse(
      property["id"].toString(),
    );
  }

  void showOwnershipDocumentPreview() {
    final int? propertyId =
        getPropertyId();

    if (propertyId == null) {
      showMissingPropertyId();
      return;
    }

    showPrivateDocumentPreview(
      title:
          "Property Ownership Document",

      icon:
          Icons.description_outlined,

      future:
          adminService.getOwnershipDocument(
        propertyId,
      ),
    );
  }

  void showPaymentProofPreview() {
    final int? propertyId =
        getPropertyId();

    if (propertyId == null) {
      showMissingPropertyId();
      return;
    }

    showPrivateDocumentPreview(
      title: "Payment Proof",

      icon:
          Icons.receipt_long_outlined,

      future:
          adminService.getPaymentProof(
        propertyId,
      ),
    );
  }

  void showMissingPropertyId() {
    Get.snackbar(
      "Unable to Open",
      "Property information is missing.",

      snackPosition:
          SnackPosition.TOP,
    );
  }

  void showPrivateDocumentPreview({
    required String title,
    required IconData icon,
    required Future<Uint8List> future,
  }) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
        ),

        padding:
            const EdgeInsets.all(20),

        decoration:
            const BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD1D9D4,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration:
                        BoxDecoration(
                      color:
                          lightSecondaryColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),

                    child: Icon(
                      icon,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,

                      style:
                          const TextStyle(
                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Flexible(
                child:
                    FutureBuilder<Uint8List>(
                  future: future,

                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return Container(
                        width:
                            double.infinity,

                        height: 280,

                        color:
                            backgroundColor,

                        child:
                            const Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                primaryColor,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError ||
                        snapshot.data ==
                            null) {
                      String message =
                          snapshot.error
                                  ?.toString() ??
                              "Document could not be loaded.";

                      if (message
                          .startsWith(
                        "Exception: ",
                      )) {
                        message =
                            message
                                .replaceFirst(
                          "Exception: ",
                          "",
                        );
                      }

                      return buildDocumentError(
                        message,
                      );
                    }

                    return Container(
                      width:
                          double.infinity,

                      constraints:
                          const BoxConstraints(
                        minHeight: 230,
                        maxHeight: 430,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            backgroundColor,

                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),

                        border:
                            Border.all(
                          color:
                              secondaryColor,
                        ),
                      ),

                      child: ClipRRect(
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),

                        child:
                            InteractiveViewer(
                          minScale: 1,

                          maxScale: 5,

                          child:
                              Image.memory(
                            snapshot.data!,

                            width:
                                double.infinity,

                            fit:
                                BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: Get.back,

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
                        13,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Close",

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
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

  void showNationalIdPreview() {
    final dynamic ownerId =
        property["owner_id"];

    if (ownerId == null) {
      Get.snackbar(
        "Unable to Open",
        "Owner information is missing.",

        snackPosition:
            SnackPosition.TOP,
      );

      return;
    }

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85,
        ),

        padding:
            const EdgeInsets.all(20),

        decoration:
            const BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: const Color(
                    0xFFD1D9D4,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration:
                        BoxDecoration(
                      color:
                          lightSecondaryColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),

                    child: const Icon(
                      Icons.badge_outlined,

                      color:
                          primaryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "National ID",

                      style: TextStyle(
                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Flexible(
                child:
                    FutureBuilder<String?>(
                  future: FirebaseAuth
                      .instance
                      .currentUser
                      ?.getIdToken(),

                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return Container(
                        width:
                            double.infinity,

                        height: 300,

                        color:
                            backgroundColor,

                        child:
                            const Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                primaryColor,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError ||
                        snapshot.data ==
                            null) {
                      return buildDocumentError(
                        "Unable to authenticate admin.",
                      );
                    }

                    final String token =
                        snapshot.data!;

                    final String url =
                        "http://10.0.2.2:8000/api/admin/users/$ownerId/national-id";

                    return ClipRRect(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),

                      child:
                          InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,

                        child:
                            Image.network(
                          url,

                          headers: {
                            "Authorization":
                                "Bearer $token",

                            "Accept":
                                "image/*",
                          },

                          width:
                              double.infinity,

                          height: 320,

                          fit:
                              BoxFit.contain,

                          loadingBuilder: (
                            context,
                            child,
                            loadingProgress,
                          ) {
                            if (loadingProgress ==
                                null) {
                              return child;
                            }

                            return Container(
                              width:
                                  double.infinity,

                              height: 320,

                              color:
                                  backgroundColor,

                              child:
                                  const Center(
                                child:
                                    CircularProgressIndicator(
                                  color:
                                      primaryColor,
                                ),
                              ),
                            );
                          },

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return buildDocumentError(
                              "National ID could not be loaded.",
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: Get.back,

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
                        13,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Close",

                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
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

  Widget buildDocumentError(
    String message,
  ) {
    return Container(
      width: double.infinity,
      height: 230,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: secondaryColor
              .withOpacity(0.5),
        ),
      ),

      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 42,
            color:
                Color(0xFFDC2626),
          ),

          const SizedBox(height: 10),

          Text(
            message,

            textAlign:
                TextAlign.center,

            style:
                const TextStyle(
              fontSize: 13,

              color:
                  Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void showApproveDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        title: const Text(
          "Approve Property",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,

            color: primaryColor,
          ),
        ),

        content: const Text(
          "Are you sure you want to approve this property submission?",
        ),

        actions: [
          TextButton(
            onPressed: Get.back,

            child: const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final int? propertyId =
                  getPropertyId();

              if (propertyId == null) {
                Get.snackbar(
                  "Error",
                  "Property ID is missing.",

                  snackPosition:
                      SnackPosition.TOP,
                );

                return;
              }

              Get.back();

              try {
                Get.dialog(
                  const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          primaryColor,
                    ),
                  ),

                  barrierDismissible:
                      false,
                );

                final bool success =
                    await adminService
                        .approveProperty(
                  propertyId,
                );

                if (Get.isDialogOpen ==
                    true) {
                  Get.back();
                }

                if (success) {
                  Get.snackbar(
                    "Approved",
                    "Property approved successfully.",

                    snackPosition:
                        SnackPosition.TOP,

                    backgroundColor:
                        primaryColor,

                    colorText:
                        Colors.white,
                  );

                  Get.back(
                    result: true,
                  );
                }
              } catch (e) {
                if (Get.isDialogOpen ==
                    true) {
                  Get.back();
                }

                String message =
                    e.toString();

                if (message.startsWith(
                  "Exception: ",
                )) {
                  message =
                      message.replaceFirst(
                    "Exception: ",
                    "",
                  );
                }

                Get.snackbar(
                  "Approval Failed",
                  message,

                  snackPosition:
                      SnackPosition.TOP,

                  backgroundColor:
                      const Color(
                    0xFFDC2626,
                  ),

                  colorText:
                      Colors.white,
                );
              }
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  primaryColor,

              foregroundColor:
                  Colors.white,
            ),

            child: const Text(
              "Approve",
            ),
          ),
        ],
      ),
    );
  }

  void showRejectDialog() {
    final TextEditingController
        reasonController =
        TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        title: const Text(
          "Reject Property",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFFDC2626),
          ),
        ),

        content: Column(
          mainAxisSize:
              MainAxisSize.min,

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              "Provide a reason for rejecting this submission.",
            ),

            const SizedBox(height: 14),

            TextField(
              controller:
                  reasonController,

              maxLines: 4,

              decoration:
                  InputDecoration(
                hintText:
                    "Enter rejection reason",

                filled: true,

                fillColor:
                    backgroundColor,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      const BorderSide(
                    color: Color(
                      0xFFDC2626,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: Get.back,

            child: const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final String reason =
                  reasonController.text
                      .trim();

              if (reason.isEmpty) {
                Get.snackbar(
                  "Reason Required",
                  "Please enter a rejection reason.",

                  snackPosition:
                      SnackPosition.TOP,
                );

                return;
              }

              final int? propertyId =
                  getPropertyId();

              if (propertyId == null) {
                Get.snackbar(
                  "Error",
                  "Property ID is missing.",

                  snackPosition:
                      SnackPosition.TOP,
                );

                return;
              }

              Get.back();

              try {
                Get.dialog(
                  const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          primaryColor,
                    ),
                  ),

                  barrierDismissible:
                      false,
                );

                final bool success =
                    await adminService
                        .rejectProperty(
                  propertyId: propertyId,
                  reason: reason,
                );

                if (Get.isDialogOpen ==
                    true) {
                  Get.back();
                }

                if (success) {
                  Get.snackbar(
                    "Rejected",
                    "Property submission rejected.",

                    snackPosition:
                        SnackPosition.TOP,

                    backgroundColor:
                        const Color(
                      0xFFDC2626,
                    ),

                    colorText:
                        Colors.white,
                  );

                  Get.back(
                    result: true,
                  );
                }
              } catch (e) {
                if (Get.isDialogOpen ==
                    true) {
                  Get.back();
                }

                String message =
                    e.toString();

                if (message.startsWith(
                  "Exception: ",
                )) {
                  message =
                      message.replaceFirst(
                    "Exception: ",
                    "",
                  );
                }

                Get.snackbar(
                  "Rejection Failed",
                  message,

                  snackPosition:
                      SnackPosition.TOP,

                  backgroundColor:
                      const Color(
                    0xFFDC2626,
                  ),

                  colorText:
                      Colors.white,
                );
              }
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                0xFFDC2626,
              ),

              foregroundColor:
                  Colors.white,
            ),

            child: const Text(
              "Reject",
            ),
          ),
        ],
      ),
    );
  }
}