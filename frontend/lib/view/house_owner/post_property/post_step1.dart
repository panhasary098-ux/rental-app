import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/widget/post_properties/customTypeContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PostStep1 extends StatelessWidget {
  PostStep1({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  final List<Map<String, dynamic>> types = [
    {
      "icon": Icons.house_outlined,
      "name": "House",
      "description": "Individual house or villa",
    },
    {
      "icon": Icons.apartment_outlined,
      "name": "Apartment/flat",
      "description": "Apartment room",
    },
    {
      "icon": Icons.bed_outlined,
      "name": "Room",
      "description": "A single room",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: Padding(
        padding: const EdgeInsets.all(8),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 50),

            // ======================================================
            // TITLE
            // ======================================================
            const Text(
              "What type of property are you posting?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose the property type that best matches your listing.",
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),

            const SizedBox(height: 30),

            // ======================================================
            // PROPERTY TYPES
            // ======================================================
            Expanded(
              child: ListView.separated(
                itemCount: types.length,

                itemBuilder: (context, index) {
                  final item = types[index];

                  return Obx(() {
                    final bool isSelected =
                        controller.selectIndex.value == index;

                    return customTypeContainer(
                      icon: item["icon"],
                      nameType: item["name"],
                      description: item["description"],
                      isSeleted: isSelected,

                      onPressed: () {
                        controller.selectIndex.value = index;
                      },
                    );
                  });
                },

                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
