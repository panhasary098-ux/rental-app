import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

const Color _primaryColor = Color(0xFF03045E);
const Color _secondaryColor = Colors.black12;
const Color _backgroundColor = Colors.white;
const Color _lightSecondaryColor = Colors.white12;

class AdminPropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  final VoidCallback onManagePost;

  const AdminPropertyDetailScreen({
    super.key,
    required this.property,
    required this.onManagePost,
  });

  @override
  State<AdminPropertyDetailScreen> createState() =>
      _AdminPropertyDetailScreenState();
}

class _AdminPropertyDetailScreenState extends State<AdminPropertyDetailScreen> {
  bool showFloor = false;

  Map<String, dynamic> get property => widget.property;

  String get propertyType =>
      property["property_type"]?.toString().toLowerCase() ?? "";

  bool get hasAvailableFloorList {
    return propertyType == "room" || propertyType == "apartment";
  }

  int get totalFloor {
    return int.tryParse(property["total_floor"]?.toString() ?? "0") ?? 0;
  }

  List<int> get availableFloors {
    final dynamic value = property["available_floors"];

    if (value is! List) {
      return [];
    }

    return value
        .map((item) => int.tryParse(item.toString()) ?? 0)
        .where((floor) => floor > 0)
        .toList();
  }

  bool getBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String text = value?.toString().toLowerCase() ?? "";

    return text == "true" || text == "1";
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

  List<String> get images {
    final List<String> result = [];

    final dynamic rawImages = property["images"];

    if (rawImages is List) {
      for (final item in rawImages) {
        if (item is Map) {
          final dynamic url = item["image_url"];

          if (url != null) {
            result.add(getImageUrl(url));
          }
        }
      }
    }

    if (result.isEmpty && property["image"] != null) {
      result.add(getImageUrl(property["image"]));
    }

    return result;
  }

  String get rentalStatus {
    final String value =
        property["rental_status"]?.toString().toLowerCase() ?? "";

    if (value == "rented") {
      return "Rented";
    }

    return "Available";
  }

  String get price {
    final dynamic raw = property["raw_price"];

    final double? value = double.tryParse(raw?.toString() ?? "");

    if (value == null) {
      return "-";
    }

    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String get size {
    final double? value = double.tryParse(property["size"]?.toString() ?? "");

    if (value == null) {
      return "-";
    }

    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  List<Map<String, dynamic>> get mainInfo {
    final List<Map<String, dynamic>> result = [];

    if (propertyType == "house" || propertyType == "apartment") {
      if (property["bedrooms"] != null) {
        result.add({
          "icon": Icons.bed_outlined,

          "text": "${property["bedrooms"]} Bedrooms",
        });
      }

      if (property["bathrooms"] != null) {
        result.add({
          "icon": Icons.bathtub_outlined,

          "text": "${property["bathrooms"]} Bath",
        });
      }
    }

    result.add({"icon": Icons.square_foot, "text": "$size m²"});

    result.add({
      "icon": Icons.chair_outlined,

      "text": getBool(property["furnished"]) ? "Furnished" : "Unfurnished",
    });

    return result;
  }

  List<Map<String, dynamic>> get facilities {
    final dynamic raw = property["facilities"];

    if (raw is! Map) {
      return [];
    }

    final Map<String, dynamic> data = Map<String, dynamic>.from(raw);

    final List<Map<String, dynamic>> result = [];

    if (getBool(data["wifi"])) {
      result.add({"icon": Icons.wifi, "text": "WiFi"});
    }

    if (getBool(data["parking"])) {
      result.add({"icon": Icons.local_parking_outlined, "text": "Parking"});
    }

    if (getBool(data["air_conditioning"])) {
      result.add({"icon": Icons.ac_unit, "text": "Air Con"});
    }

    if (getBool(data["pet_allowed"])) {
      result.add({"icon": Icons.pets_outlined, "text": "Pet Allowed"});
    }

    if (getBool(data["balcony"])) {
      result.add({"icon": Icons.balcony_outlined, "text": "Balcony"});
    }

    if (getBool(data["kitchen"])) {
      result.add({"icon": Icons.kitchen_outlined, "text": "Kitchen"});
    }

    if (getBool(data["swimming_pool"])) {
      result.add({"icon": Icons.pool_outlined, "text": "Swimming Pool"});
    }

    if (getBool(data["elevator"])) {
      result.add({"icon": Icons.elevator_outlined, "text": "Elevator"});
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        backgroundColor: _backgroundColor,

        elevation: 0,

        centerTitle: true,

        scrolledUnderElevation: 0,

        iconTheme: const IconThemeData(color: _primaryColor),

        title: const Text(
          "Property Post",

          style: TextStyle(
            fontSize: 20,

            fontWeight: FontWeight.w600,

            color: _primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,

            child: buildImageSlideshow(),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),

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
                            fontSize: 22,

                            fontWeight: FontWeight.w900,

                            color: _primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      buildRentalStatusBadge(),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Icon(
                              Icons.location_on_outlined,

                              size: 20,

                              color: _primaryColor,
                            ),

                            const SizedBox(width: 3),

                            Expanded(
                              child: Text(
                                property["location"]?.toString() ?? "-",

                                style: TextStyle(
                                  fontSize: 13,

                                  color: Colors.black.withOpacity(0.65),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Text(
                            "\$$price",

                            style: const TextStyle(
                              fontSize: 23,

                              fontWeight: FontWeight.w800,

                              color: _primaryColor,
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.only(bottom: 3),

                            child: Text(
                              "/Month",

                              style: TextStyle(
                                fontSize: 13,

                                fontWeight: FontWeight.w600,

                                color: _primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 1,

                    width: double.infinity,

                    color: _secondaryColor.withOpacity(0.6),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),

                    child: Wrap(
                      spacing: 18,
                      runSpacing: 10,

                      children: mainInfo.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(item["icon"], size: 17, color: _primaryColor),

                            const SizedBox(width: 5),

                            Text(
                              item["text"],

                              style: const TextStyle(
                                fontSize: 13,

                                color: _primaryColor,

                                fontWeight: FontWeight.w500,
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

                    color: _secondaryColor.withOpacity(0.6),
                  ),

                  const SizedBox(height: 10),

                  buildFloorSection(),

                  const SizedBox(height: 15),

                  const Text(
                    "About this place",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.w800,

                      color: _primaryColor,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    property["description"]?.toString() ?? "-",

                    style: const TextStyle(
                      fontSize: 13,

                      height: 1.5,

                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Facilities",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.w800,

                      color: _primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildFacilities(),

                  const SizedBox(height: 26),

                  const Text(
                    "Admin Management",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight: FontWeight.w800,

                      color: _primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: _lightSecondaryColor,

                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(color: _secondaryColor),
                    ),

                    child: Column(
                      children: [
                        adminInfoRow(
                          Icons.person_outline_rounded,

                          "Property Owner",

                          property["owner"]?.toString() ?? "-",
                        ),

                        const SizedBox(height: 12),

                        adminInfoRow(
                          Icons.visibility_outlined,

                          "Post Status",

                          formatPostStatus(property["post_status"]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,

                    height: 50,

                    child: ElevatedButton.icon(
                      onPressed: widget.onManagePost,

                      icon: const Icon(Icons.settings_outlined),

                      label: const Text(
                        "Manage Post",

                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,

                        foregroundColor: Colors.white,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget buildImageSlideshow() {
    if (images.isEmpty) {
      return Container(
        color: _lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,

          size: 60,

          color: _primaryColor,
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,

      height: 300,

      initialPage: 0,

      indicatorColor: _primaryColor,

      indicatorBackgroundColor: Colors.white70,

      autoPlayInterval: images.length > 1 ? 3000 : 0,

      isLoop: images.length > 1,

      children: images.map((image) {
        return Image.network(
          image,

          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: _lightSecondaryColor,

              child: const Icon(
                Icons.home_work_outlined,

                size: 55,

                color: _primaryColor,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildRentalStatusBadge() {
    final bool available = rentalStatus == "Available";

    final Color statusColor = available
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

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
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            rentalStatus,
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
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
        children: [
          Row(
            children: [
              const Text(
                "Floor",

                style: TextStyle(
                  fontSize: 17,

                  fontWeight: FontWeight.w800,

                  color: _primaryColor,
                ),
              ),

              const Spacer(),

              Text(
                "$totalFloor Floors",

                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    showFloor = !showFloor;
                  });
                },

                icon: Icon(
                  showFloor
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,

                  color: _primaryColor,
                ),
              ),
            ],
          ),

          Visibility(
            visible: showFloor,

            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: _secondaryColor.withOpacity(0.5)),
              ),

              child: ListView.separated(
                shrinkWrap: true,

                padding: EdgeInsets.zero,

                itemCount: totalFloor,

                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,

                    color: _secondaryColor.withOpacity(0.4),
                  );
                },

                itemBuilder: (context, index) {
                  final int floor = index + 1;

                  final bool available = availableFloors.contains(floor);

                  return Padding(
                    padding: const EdgeInsets.all(10),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.apartment,

                          color: _primaryColor,

                          size: 20,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "Floor $floor",

                          style: const TextStyle(
                            color: _primaryColor,

                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          available ? "Available" : "Not available",

                          style: TextStyle(
                            color: available
                                ? const Color(0xFF16A34A)
                                : Colors.black45,

                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

            fontWeight: FontWeight.w800,

            color: _primaryColor,
          ),
        ),

        const Spacer(),

        const Icon(Icons.layers_outlined, color: _primaryColor, size: 19),

        const SizedBox(width: 5),

        Text(
          "$totalFloor ${totalFloor == 1 ? "Floor" : "Floors"}",

          style: const TextStyle(
            color: _primaryColor,

            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFacilities() {
    if (facilities.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: _secondaryColor.withOpacity(0.4)),
        ),

        child: const Text(
          "No facilities listed",

          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
      );
    }

    return SizedBox(
      height: 70,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: facilities.length,

        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },

        itemBuilder: (context, index) {
          final item = facilities[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 13),

            decoration: BoxDecoration(
              color: _lightSecondaryColor,

              borderRadius: BorderRadius.circular(13),

              border: Border.all(color: _secondaryColor),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(item["icon"], size: 20, color: _primaryColor),

                const SizedBox(height: 4),

                Text(
                  item["text"],

                  style: const TextStyle(
                    fontSize: 12,

                    color: _primaryColor,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget adminInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _primaryColor),

        const SizedBox(width: 10),

        Text(
          "$title:",

          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            value,

            textAlign: TextAlign.end,

            style: const TextStyle(
              fontSize: 13,

              fontWeight: FontWeight.w700,

              color: _primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
