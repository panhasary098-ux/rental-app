import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _primaryColor = Color(0xFF03045E);
const Color _secondaryColor = Color(0xFF90E0EF);
const Color _backgroundColor =Colors.white;
const Color _lightSecondaryColor = Color(0xFFE6F9FC);

class OwnerPropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const OwnerPropertyDetailScreen({super.key, required this.property});

  @override
  State<OwnerPropertyDetailScreen> createState() =>
      _OwnerPropertyDetailScreenState();
}

class _OwnerPropertyDetailScreenState extends State<OwnerPropertyDetailScreen> {
  int currentImageIndex = 0;

  Map<String, dynamic> get property => widget.property;

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

  List<String> get images {
    final List<String> result = [];

    final dynamic rawImages = property["images"];

    if (rawImages is List) {
      for (final dynamic image in rawImages) {
        if (image is Map) {
          final dynamic imageUrl = image["image_url"];

          final dynamic imagePath = image["image_path"];

          if (imageUrl != null && imageUrl.toString().isNotEmpty) {
            final String url = buildStorageUrl(imageUrl.toString());

            if (!result.contains(url)) {
              result.add(url);
            }
          } else if (imagePath != null && imagePath.toString().isNotEmpty) {
            final String url = buildStorageUrl(imagePath.toString());

            if (!result.contains(url)) {
              result.add(url);
            }
          }
        }
      }
    }

    final dynamic coverPath = property["cover_image_path"];

    if (result.isEmpty &&
        coverPath != null &&
        coverPath.toString().isNotEmpty) {
      result.add(buildStorageUrl(coverPath.toString()));
    }

    return result;
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return "";
    }

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String get price {
    final double? value = double.tryParse(property["price"]?.toString() ?? "0");

    if (value == null) {
      return "\$0 / month";
    }

    if (value == value.roundToDouble()) {
      return "\$${value.toInt()} / month";
    }

    return "\$${value.toStringAsFixed(2)} / month";
  }

  String get propertyType {
    final String value = (property["property_type"] ?? "")
        .toString()
        .toLowerCase();

    if (value == "apartment") {
      return "Apartment/Flat";
    }

    return capitalize(value);
  }

  String get furnishedText {
    final dynamic raw = property["furnished"];

    final bool furnished =
        raw == true ||
        raw == 1 ||
        raw == "1" ||
        raw.toString().toLowerCase() == "true";

    return furnished ? "Furnished" : "Not Furnished";
  }

  String get telegramUsername {
    String username = (property["contact"] ?? "").toString().trim();

    if (username.startsWith("@")) {
      username = username.substring(1);
    }

    return username.trim();
  }

  List<int> get availableFloors {
    final List<int> result = [];

    final dynamic raw = property["available_floors"];

    if (raw is List) {
      for (final dynamic item in raw) {
        if (item is Map) {
          final dynamic floor = item["floor_number"];

          final int? value = int.tryParse(floor?.toString() ?? "");

          if (value != null) {
            result.add(value);
          }
        } else {
          final int? value = int.tryParse(item.toString());

          if (value != null) {
            result.add(value);
          }
        }
      }
    }

    result.sort();

    return result;
  }

  List<Map<String, dynamic>> get activeFacilities {
    final dynamic raw = property["facilities"];

    if (raw is! Map) {
      return [];
    }

    final List<Map<String, dynamic>> facilityData = [
      {"key": "wifi", "label": "WiFi", "icon": Icons.wifi_rounded},
      {
        "key": "parking",
        "label": "Parking",
        "icon": Icons.local_parking_rounded,
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
      {"key": "balcony", "label": "Balcony", "icon": Icons.balcony_outlined},
      {"key": "kitchen", "label": "Kitchen", "icon": Icons.kitchen_outlined},
      {
        "key": "swimming_pool",
        "label": "Swimming Pool",
        "icon": Icons.pool_outlined,
      },
      {"key": "elevator", "label": "Elevator", "icon": Icons.elevator_outlined},
    ];

    return facilityData.where((item) {
      final dynamic value = raw[item["key"]];

      return value == true ||
          value == 1 ||
          value == "1" ||
          value?.toString().toLowerCase() == "true";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final String rentalStatus = capitalize(
      property["rental_status"]?.toString() ?? "",
    );

    final String verificationStatus = capitalize(
      property["verification_status"]?.toString() ?? "",
    );

    return Scaffold(
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: _primaryColor,
          ),
        ),

        title: const Text(
          "Property Details",

          style: TextStyle(
            color: _primaryColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            buildImages(),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          property["name"]?.toString() ?? "Property",

                          style: const TextStyle(
                            color: _primaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      buildRentalStatus(rentalStatus),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF7D8990),
                        size: 18,
                      ),

                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          property["address"]?.toString() ?? "No location",

                          style: const TextStyle(
                            color: Color(0xFF7D8990),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    price,

                    style: const TextStyle(
                      color: _primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(15),

                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    ),

                    child: Row(
                      children: [
                        const Text(
                          "Verification",

                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                          ),
                        ),

                        const Spacer(),

                        buildVerificationStatus(verificationStatus),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Property Information",

                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: [
                      buildInfoItem(
                        icon: Icons.home_work_outlined,
                        title: "Type",
                        value: propertyType,
                      ),

                      buildInfoItem(
                        icon: Icons.square_foot_rounded,
                        title: "Size",
                        value: "${property["size"] ?? "-"} m²",
                      ),

                      if (property["bedrooms"] != null)
                        buildInfoItem(
                          icon: Icons.bed_outlined,
                          title: "Bedrooms",
                          value: property["bedrooms"].toString(),
                        ),

                      if (property["bathrooms"] != null)
                        buildInfoItem(
                          icon: Icons.bathtub_outlined,
                          title: "Bathrooms",
                          value: property["bathrooms"].toString(),
                        ),

                      buildInfoItem(
                        icon: Icons.layers_outlined,
                        title: "Total Floor",
                        value: property["total_floor"]?.toString() ?? "-",
                      ),

                      buildInfoItem(
                        icon: Icons.chair_outlined,
                        title: "Furnished",
                        value: furnishedText,
                      ),
                    ],
                  ),

                  if (availableFloors.isNotEmpty) ...[
                    const SizedBox(height: 22),

                    const Text(
                      "Available Floors",

                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: availableFloors
                          .map(
                            (floor) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                "Floor $floor",

                                style: const TextStyle(
                                  color: _primaryColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 22),

                  const Text(
                    "About this place",

                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    property["description"]?.toString() ?? "No description.",

                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Facilities",

                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (activeFacilities.isEmpty)
                    const Text(
                      "No facilities listed.",

                      style: TextStyle(color: Color(0xFF7D8990), fontSize: 12),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,

                      children: activeFacilities
                          .map(
                            (facility) => buildFacilityItem(
                              icon: facility["icon"] as IconData,
                              label: facility["label"].toString(),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 22),

                  const Text(
                    "Contact",

                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  buildContactCard(
                    icon: Icons.phone_outlined,
                    label: "Phone Number",
                    value:
                        (property["owner_phone"] ?? "")
                            .toString()
                            .trim()
                            .isNotEmpty
                        ? property["owner_phone"].toString()
                        : "Not available",
                  ),

                  const SizedBox(height: 12),

                  buildContactCard(
                    icon: Icons.send_rounded,
                    iconColor: const Color(0xFF229ED9),
                    label: "Telegram",
                    value: telegramUsername.isNotEmpty
                        ? "@$telegramUsername"
                        : "Not available",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = _primaryColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _lightSecondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF7D8990),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImages() {
    if (images.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: _lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,
          size: 60,
          color: _primaryColor,
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
                currentImageIndex = index;
              });
            },

            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: _lightSecondaryColor,

                    child: const Icon(
                      Icons.home_work_outlined,
                      size: 60,
                      color: _primaryColor,
                    ),
                  );
                },
              );
            },
          ),
        ),

        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(
                images.length,

                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  margin: const EdgeInsets.symmetric(horizontal: 3),

                  width: index == currentImageIndex ? 18 : 7,

                  height: 7,

                  decoration: BoxDecoration(
                    color: index == currentImageIndex
                        ? _primaryColor
                        : Colors.grey.withOpacity(0.35),

                    borderRadius: BorderRadius.circular(10),
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
    final double width = (MediaQuery.of(context).size.width - 46) / 2;

    return Container(
      width: width,

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.grey.withOpacity(0.14)),
      ),

      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,

            decoration: BoxDecoration(
              color: _lightSecondaryColor,

              borderRadius: BorderRadius.circular(9),
            ),

            child: Icon(icon, size: 19, color: _primaryColor),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: Color(0xFF7D8990),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: _primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFacilityItem({required IconData icon, required String label}) {
    return Container(
      width: (MediaQuery.of(context).size.width - 46) / 2,

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),

      child: Row(
        children: [
          Icon(icon, size: 20, color: _primaryColor),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              label,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                color: _primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRentalStatus(String status) {
    final Color color = status == "Available"
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),
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
            status,

            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVerificationStatus(String status) {
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 14, color: color),

          const SizedBox(width: 5),

          Text(
            status,

            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
