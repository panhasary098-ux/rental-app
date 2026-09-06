import 'package:final_project/controller/post_properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class FacilitiesSelector extends StatelessWidget {
  FacilitiesSelector({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  final List<Map<String, dynamic>> facilities = [
    {"icon": Icons.wifi, "text": "WiFi", "key": "wifi"},
    {"icon": Icons.local_parking_outlined, "text": "Parking", "key": "parking"},
    {"icon": Icons.ac_unit, "text": "Air Con", "key": "airConditioning"},
    {"icon": Icons.pets_outlined, "text": "Pet Allowed", "key": "petAllowed"},
    {"icon": Icons.balcony_outlined, "text": "Balcony", "key": "balcony"},
    {
      "icon": Icons.pool_outlined,
      "text": "Swimming Pool",
      "key": "swimmingPool",
    },
    {"icon": Icons.kitchen_outlined, "text": "Kitchen", "key": "kitchen"},
    {"icon": Icons.elevator_outlined, "text": "Elevator", "key": "elevator"},
  ];

  // ======================================================
  // GET SELECTED VALUE
  // ======================================================

  bool getSelectedValue(String key) {
    switch (key) {
      case "wifi":
        return controller.wifi.value;

      case "parking":
        return controller.parking.value;

      case "airConditioning":
        return controller.airConditioning.value;

      case "petAllowed":
        return controller.petAllowed.value;

      case "balcony":
        return controller.balcony.value;

      case "swimmingPool":
        return controller.swimmingPool.value;

      case "kitchen":
        return controller.kitchen.value;

      case "elevator":
        return controller.elevator.value;

      default:
        return false;
    }
  }

  // ======================================================
  // TOGGLE FACILITY
  // ======================================================

  void toggleFacility(String key) {
    switch (key) {
      case "wifi":
        controller.wifi.toggle();
        break;

      case "parking":
        controller.parking.toggle();
        break;

      case "airConditioning":
        controller.airConditioning.toggle();
        break;

      case "petAllowed":
        controller.petAllowed.toggle();
        break;

      case "balcony":
        controller.balcony.toggle();
        break;

      case "swimmingPool":
        controller.swimmingPool.toggle();
        break;

      case "kitchen":
        controller.kitchen.toggle();
        break;

      case "elevator":
        controller.elevator.toggle();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      itemCount: facilities.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.8,
      ),

      itemBuilder: (context, index) {
        final facility = facilities[index];

        final String text = facility["text"];
        final String key = facility["key"];
        final IconData icon = facility["icon"];

        return Obx(() {
          final bool isSelected = getSelectedValue(key);

          return InkWell(
            borderRadius: BorderRadius.circular(12),

            onTap: () {
              toggleFacility(key);
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),

              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

              decoration: BoxDecoration(
                // Selected = soft cyan
                // Unselected = white
                color: isSelected ? lightSecondaryColor : Colors.white,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : secondaryColor.withOpacity(0.30),
                  width: isSelected ? 1.5 : 1,
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Row(
                children: [
                  // ==================================================
                  // ICON
                  // ==================================================
                  Icon(icon, size: 21, color: primaryColor),

                  const SizedBox(width: 10),

                  // ==================================================
                  // TEXT
                  // ==================================================
                  Expanded(
                    child: Text(
                      text,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 15,

                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,

                        color: isSelected ? primaryColor : Colors.black87,
                      ),
                    ),
                  ),

                  // ==================================================
                  // SELECTED CHECK
                  // ==================================================
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
