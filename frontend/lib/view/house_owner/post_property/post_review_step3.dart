import 'dart:io';

import 'package:final_project/controller/post_properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PostReviewStep3 extends StatelessWidget {
  PostReviewStep3({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  // ======================================================
  // PROPERTY TYPE LABEL
  // ======================================================

  String getPropertyTypeLabel() {
    switch (controller.selectIndex.value) {
      case 0:
        return "House";

      case 1:
        return "Apartment/Flat";

      case 2:
        return "Room";

      default:
        return "";
    }
  }

  // ======================================================
  // FACILITIES
  // ======================================================

  List<Map<String, dynamic>> getSelectedFacilities() {
    final List<Map<String, dynamic>> facilities = [];

    if (controller.wifi.value) {
      facilities.add({"icon": Icons.wifi, "text": "WiFi"});
    }

    if (controller.parking.value) {
      facilities.add({"icon": Icons.local_parking_outlined, "text": "Parking"});
    }

    if (controller.airConditioning.value) {
      facilities.add({"icon": Icons.ac_unit, "text": "Air Con"});
    }

    if (controller.petAllowed.value) {
      facilities.add({"icon": Icons.pets_outlined, "text": "Pet Allowed"});
    }

    if (controller.balcony.value) {
      facilities.add({"icon": Icons.balcony_outlined, "text": "Balcony"});
    }

    if (controller.kitchen.value) {
      facilities.add({"icon": Icons.kitchen_outlined, "text": "Kitchen"});
    }

    if (controller.swimmingPool.value) {
      facilities.add({"icon": Icons.pool_outlined, "text": "Swimming Pool"});
    }

    if (controller.elevator.value) {
      facilities.add({"icon": Icons.elevator_outlined, "text": "Elevator"});
    }

    return facilities;
  }

  // ======================================================
  // AVAILABLE FLOORS TEXT
  // ======================================================

  String getAvailableFloorsText() {
    if (controller.selectIndex.value == 1) {
      final floors = controller.apartmentAvailableFloors.toList()..sort();

      return floors.map((floor) => "Floor $floor").join(", ");
    }

    if (controller.selectIndex.value == 2) {
      final floors = controller.roomAvailableFloors.toList()..sort();

      return floors.map((floor) => "Floor $floor").join(", ");
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final facilities = getSelectedFacilities();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // ======================================================
          // TITLE
          // ======================================================
          const Text(
            "Review Your Property",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Check the details below before continuing to payment.",
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // MAIN REVIEW CARD
          // ======================================================
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: secondaryColor.withOpacity(0.35)),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // PROPERTY IMAGE
                // ==================================================
                if (controller.selectedImages.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),

                    child: Image.file(
                      File(controller.selectedImages.first.path),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================================
                      // NAME
                      // ============================================
                      Text(
                        controller.nameController.text.trim(),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // LOCATION
                      // ============================================
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: primaryColor,
                          ),

                          const SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              controller.address.value ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // PRICE
                      // ============================================
                      Text(
                        "\$${controller.priceController.text.trim()} / month",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${controller.selectedImages.length} property photo(s)",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Divider(color: secondaryColor.withOpacity(0.55)),

                      const SizedBox(height: 8),

                      // ============================================
                      // COMMON INFORMATION
                      // ============================================
                      reviewRow(
                        title: "Property Type",
                        value: getPropertyTypeLabel(),
                      ),

                      reviewRow(
                        title: "Size",
                        value: "${controller.sizeController.text.trim()} m²",
                      ),

                      reviewRow(
                        title: "Furnished",
                        value: controller.furnished.value ? "Yes" : "No",
                      ),

                      reviewRow(
                        title: "Status",
                        value: controller.status.value == "available"
                            ? "Available"
                            : "Rented",
                      ),

                      reviewRow(
                        title: "Contact",
                        value: controller.contactController.text.trim(),
                      ),

                      // ============================================
                      // HOUSE
                      // ============================================
                      if (controller.selectIndex.value == 0) ...[
                        reviewRow(
                          title: "Bedrooms",
                          value: controller.houseBedrooms.value.toString(),
                        ),

                        reviewRow(
                          title: "Bathrooms",
                          value: controller.houseBathrooms.value.toString(),
                        ),

                        reviewRow(
                          title: "Total Floors",
                          value: controller.houseTotalFloor.value.toString(),
                        ),
                      ],

                      // ============================================
                      // APARTMENT
                      // ============================================
                      if (controller.selectIndex.value == 1) ...[
                        reviewRow(
                          title: "Bedrooms",
                          value: controller.apartmentBedrooms.value.toString(),
                        ),

                        reviewRow(
                          title: "Bathrooms",
                          value: controller.apartmentBathrooms.value.toString(),
                        ),

                        reviewRow(
                          title: "Total Floors",
                          value: controller.apartmentTotalFloor.value
                              .toString(),
                        ),

                        reviewRow(
                          title: "Available Floors",
                          value: getAvailableFloorsText(),
                        ),
                      ],

                      // ============================================
                      // ROOM
                      // ============================================
                      if (controller.selectIndex.value == 2) ...[
                        reviewRow(
                          title: "Total Floors",
                          value: controller.roomTotalFloor.value.toString(),
                        ),

                        reviewRow(
                          title: "Available Floors",
                          value: getAvailableFloorsText(),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // ============================================
                      // FACILITIES
                      // ============================================
                      const Text(
                        "Facilities",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (facilities.isEmpty)
                        const Text(
                          "No facilities selected",
                          style: TextStyle(fontSize: 13, color: Colors.black45),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,

                          children: facilities.map((facility) {
                            return FacilityChip(
                              icon: facility["icon"],
                              text: facility["text"],
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 16),

                      Divider(color: secondaryColor.withOpacity(0.55)),

                      const SizedBox(height: 8),

                      // ============================================
                      // DESCRIPTION
                      // ============================================
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        controller.descriptionController.text.trim(),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Divider(color: secondaryColor.withOpacity(0.55)),

                      const SizedBox(height: 8),

                      // ============================================
                      // OWNERSHIP DOCUMENT
                      // ============================================
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            color: primaryColor,
                            size: 20,
                          ),

                          const SizedBox(width: 8),

                          const Expanded(
                            child: Text(
                              "Ownership Document",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),

                          Text(
                            controller.ownershipDocumentImage.value != null
                                ? "Uploaded"
                                : "Not uploaded",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ======================================================
// REVIEW ROW
// ======================================================

Widget reviewRow({required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

// ======================================================
// FACILITY CHIP
// ======================================================

class FacilityChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const FacilityChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

      decoration: BoxDecoration(
        color: lightSecondaryColor,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: secondaryColor),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primaryColor),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
