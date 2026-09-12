import 'dart:convert';

import 'package:final_project/model/apartmentFlat.dart';
import 'package:final_project/model/house.dart';
import 'package:final_project/model/property.dart';
import 'package:final_project/model/room.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertyDetailScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final PropertyService propertyService = PropertyService();

  bool showFloor = false;

  bool isFavorite = false;
  bool favoriteLoading = false;

  @override
  void initState() {
    super.initState();

    loadFavoriteStatus();
  }

  // Check if this property is already saved
  Future<void> loadFavoriteStatus() async {
    final int? propertyId = widget.property.id;

    if (propertyId == null) {
      return;
    }

    try {
      final response = await propertyService.getFavorites();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List<dynamic> favorites = decoded["properties"] ?? [];

        final bool saved = favorites.any((item) {
          return item["id"]?.toString() == propertyId.toString();
        });

        if (!mounted) {
          return;
        }

        setState(() {
          isFavorite = saved;
        });
      }
    } catch (e) {
      print("DETAIL FAVORITE STATUS ERROR: $e");
    }
  }

  // Add or remove favorite
  Future<void> toggleFavorite() async {
    final int? propertyId = widget.property.id;

    if (propertyId == null || favoriteLoading) {
      return;
    }

    setState(() {
      favoriteLoading = true;
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
          isFavorite = !isFavorite;
          favoriteLoading = false;
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          favoriteLoading = false;
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
        favoriteLoading = false;
      });

      Get.snackbar(
        "Error",
        "Unable to update saved property",
        snackPosition: SnackPosition.BOTTOM,
      );

      print("DETAIL FAVORITE ERROR: $e");
    }
  }

  void floorList() {
    setState(() {
      showFloor = !showFloor;
    });
  }

  // Main property information
  List<Map<String, dynamic>> get mainInfo {
    final Property property = widget.property;

    final List<Map<String, dynamic>> information = [];

    if (property is House) {
      information.addAll([
        {"icon": Icons.bed_outlined, "text": "${property.bedrooms} Bedrooms"},
        {"icon": Icons.bathtub_outlined, "text": "${property.bathrooms} Bath"},
      ]);
    }

    if (property is ApartmentFlat) {
      information.addAll([
        {"icon": Icons.bed_outlined, "text": "${property.bedrooms} Bedrooms"},
        {"icon": Icons.bathtub_outlined, "text": "${property.bathrooms} Bath"},
      ]);
    }

    information.add({
      "icon": Icons.square_foot,
      "text": "${property.size.toStringAsFixed(0)} m²",
    });

    information.add({
      "icon": Icons.chair_outlined,
      "text": property.furnished ? "Furnished" : "Unfurnished",
    });

    return information;
  }

  // Facilities that are available
  List<Map<String, dynamic>> get availableFacilities {
    final facilities = widget.property.facilities;

    final List<Map<String, dynamic>> result = [];

    if (facilities.wifi) {
      result.add({"icon": Icons.wifi, "text": "WiFi"});
    }

    if (facilities.parking) {
      result.add({"icon": Icons.local_parking_outlined, "text": "Parking"});
    }

    if (facilities.airConditioning) {
      result.add({"icon": Icons.ac_unit, "text": "Air Con"});
    }

    if (facilities.petAllowed) {
      result.add({"icon": Icons.pets_outlined, "text": "Pet Allowed"});
    }

    if (facilities.balcony) {
      result.add({"icon": Icons.balcony_outlined, "text": "Balcony"});
    }

    if (facilities.swimmingPool) {
      result.add({"icon": Icons.pool_outlined, "text": "Swimming Pool"});
    }

    if (facilities.kitchen) {
      result.add({"icon": Icons.kitchen_outlined, "text": "Kitchen"});
    }

    if (facilities.elevator) {
      result.add({"icon": Icons.elevator_outlined, "text": "Elevator"});
    }

    return result;
  }

  int get totalFloor {
    final Property property = widget.property;

    if (property is House) {
      return property.totalFloor;
    }

    if (property is ApartmentFlat) {
      return property.totalFloor;
    }

    if (property is Room) {
      return property.totalFloor;
    }

    return 0;
  }

  List<int> get availableFloors {
    final Property property = widget.property;

    if (property is ApartmentFlat) {
      return property.availableFloors;
    }

    if (property is Room) {
      return property.availableFloors;
    }

    return [];
  }

  bool get hasAvailableFloorList {
    return widget.property is ApartmentFlat || widget.property is Room;
  }

  @override
  Widget build(BuildContext context) {
    final Property property = widget.property;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(color: primaryColor),

        title: const Text(
          "View detail info",

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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),

            child: Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,

                  child: buildImageSlideshow(),
                ),

                // Favorite
                Positioned(
                  top: 10,
                  right: 10,

                  child: InkWell(
                    onTap: favoriteLoading ? null : toggleFavorite,

                    borderRadius: BorderRadius.circular(30),

                    child: Container(
                      width: 40,
                      height: 40,

                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: favoriteLoading
                          ? const Padding(
                              padding: EdgeInsets.all(10),

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
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),

                    // Name + status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            property.name,

                            maxLines: 2,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 22,
                              color: primaryColor,

                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        buildStatusBadge(property.status),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location + price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Icon(
                                Icons.location_on_outlined,

                                color: primaryColor,

                                size: 20,
                              ),

                              const SizedBox(width: 3),

                              Expanded(
                                child: Text(
                                  property.location.address ??
                                      "Unknown location",

                                  style: TextStyle(
                                    fontSize: 15,

                                    color: Colors.black.withOpacity(0.65),

                                    fontWeight: FontWeight.w700,
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
                              "\$${property.price.toStringAsFixed(0)}",

                              style: const TextStyle(
                                fontSize: 23,

                                fontWeight: FontWeight.w800,

                                color: primaryColor,
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(bottom: 3),

                              child: Text(
                                "/Month",

                                style: TextStyle(
                                  fontSize: 13,

                                  fontWeight: FontWeight.w600,

                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Main info
                    Container(
                      height: 1,
                      width: double.infinity,

                      color: secondaryColor.withOpacity(0.6),
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
                              Icon(item["icon"], size: 17, color: primaryColor),

                              const SizedBox(width: 5),

                              Text(
                                item["text"],

                                style: const TextStyle(
                                  fontSize: 13,

                                  color: primaryColor,

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

                        fontWeight: FontWeight.w800,

                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      property.description,

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

                        fontWeight: FontWeight.w800,

                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    buildFacilities(),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: buildBottomButtons(),
    );
  }

  Widget buildImageSlideshow() {
    final List<String> images = widget.property.images;

    if (images.isEmpty) {
      return Container(
        color: lightSecondaryColor,

        child: const Center(
          child: Icon(Icons.home_work_outlined, size: 60, color: primaryColor),
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,
      height: 300,

      initialPage: 0,

      indicatorColor: primaryColor,
      indicatorBackgroundColor: Colors.white70,

      autoPlayInterval: images.length > 1 ? 3000 : 0,

      isLoop: images.length > 1,

      children: images.map((image) {
        return Image.network(
          image,

          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) {
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

  Widget buildStatusBadge(String status) {
    final String value = status.toLowerCase();

    Color color;
    IconData icon;

    if (value == "available" || value == "available now") {
      color = const Color(0xFF16A34A);

      icon = Icons.check_circle_rounded;
    } else if (value == "rented") {
      color = const Color(0xFFDC2626);

      icon = Icons.cancel_rounded;
    } else {
      color = const Color(0xFFF59E0B);

      icon = Icons.access_time_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: Colors.white, size: 15),

          const SizedBox(width: 4),

          Text(
            status,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloorSection() {
    // Apartment and Room have
    // available-floor information.
    if (hasAvailableFloorList) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Text(
                "Floor",

                style: TextStyle(
                  fontSize: 17,

                  fontWeight: FontWeight.w800,

                  color: primaryColor,
                ),
              ),

              const Spacer(),

              Text(
                "$totalFloor Floors",

                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),

              IconButton(
                onPressed: floorList,

                icon: Icon(
                  showFloor
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,

                  size: 25,

                  color: primaryColor,
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

                border: Border.all(color: secondaryColor.withOpacity(0.5)),
              ),

              child: ListView.separated(
                shrinkWrap: true,

                padding: EdgeInsets.zero,

                itemCount: totalFloor,

                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,

                    color: secondaryColor.withOpacity(0.4),
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

                          size: 20,

                          color: primaryColor,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          "Floor $floor",

                          style: const TextStyle(
                            fontSize: 14,

                            color: primaryColor,

                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          available ? "Available" : "Not available",

                          style: TextStyle(
                            fontSize: 13,

                            fontWeight: available
                                ? FontWeight.w600
                                : FontWeight.w400,

                            color: available
                                ? const Color(0xFF16A34A)
                                : Colors.black45,
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

    // House only has total floor count.
    return Row(
      children: [
        const Text(
          "Floor",

          style: TextStyle(
            fontSize: 17,

            fontWeight: FontWeight.w800,

            color: primaryColor,
          ),
        ),

        const Spacer(),

        const Icon(Icons.layers_outlined, color: primaryColor, size: 19),

        const SizedBox(width: 5),

        Text(
          "$totalFloor ${totalFloor == 1 ? "Floor" : "Floors"}",

          style: const TextStyle(
            color: primaryColor,

            fontSize: 14,

            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFacilities() {
    final facilities = availableFacilities;

    if (facilities.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: secondaryColor.withOpacity(0.4)),
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

        itemBuilder: (context, index) {
          final item = facilities[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 13),

            decoration: BoxDecoration(
              color: lightSecondaryColor,

              borderRadius: BorderRadius.circular(13),

              border: Border.all(color: secondaryColor),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(item["icon"], size: 20, color: primaryColor),

                const SizedBox(height: 4),

                Text(
                  item["text"],

                  style: const TextStyle(
                    fontSize: 12,

                    color: primaryColor,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },

        separatorBuilder: (context, index) {
          return const SizedBox(width: 12);
        },
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
            color: primaryColor.withOpacity(0.10),

            blurRadius: 10,

            spreadRadius: 1,

            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),

        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.to(() => MapScreen(initialProperty: widget.property));
                },

                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,

                  backgroundColor: lightSecondaryColor,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.map_outlined, size: 23),

                    SizedBox(width: 5),

                    Text(
                      "View in map",

                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(22),

                      decoration: const BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                      ),

                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Owner Contact",

                              style: TextStyle(
                                color: primaryColor,

                                fontSize: 18,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,

                                  color: primaryColor,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    widget.property.contact,

                                    style: const TextStyle(
                                      color: primaryColor,

                                      fontSize: 16,

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },

                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,

                  backgroundColor: primaryColor,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.person_outline_rounded, size: 23),

                    SizedBox(width: 5),

                    Text(
                      "Contact",

                      style: TextStyle(fontWeight: FontWeight.w800),
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
}
