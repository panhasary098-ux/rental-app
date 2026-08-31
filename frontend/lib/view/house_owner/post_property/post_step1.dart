import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/widget/post_properties/customTypeContainer.dart';
import 'package:final_project/widget/stepNumber.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/utils.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Column(
        children: [
          const Text(
            "What type of property are you posting?",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: ListView.separated(
              itemCount: types.length,

              itemBuilder: (context, index) {
                final item = types[index];

                return Obx(() {
                  final bool isSelected = controller.selectIndex.value == index;

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
    );
  }
}
