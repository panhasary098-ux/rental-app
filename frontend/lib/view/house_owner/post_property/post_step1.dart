import 'package:final_project/controller/post_properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color backgroundColor = Color(0xFFF8FAFC);
const Color textColor = Color(0xFF111827);
const Color secondaryTextColor = Color(0xFF7D8990);
const Color borderColor = Color(0xFFE5E7EB);
const Color selectedAccent = Color(0xFF03045E);

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
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),

            const Text(
              "What type of property are you submitting?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.25,
                letterSpacing: -0.25,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              "Choose the property type that best matches your property.",
              style: TextStyle(
                fontSize: 13.5,
                color: secondaryTextColor,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 28),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: types.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item = types[index];

                  return Obx(() {
                    final bool isSelected =
                        controller.selectIndex.value == index;

                    return _buildPropertyTypeCard(
                      icon: item["icon"] as IconData,
                      title: item["name"].toString(),
                      description: item["description"].toString(),
                      isSelected: isSelected,
                      onTap: () {
                        controller.selectIndex.value = index;
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 104,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFBFDFF) : Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: isSelected ? const Color(0xFFC7D7FE) : borderColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isSelected ? 0.055 : 0.035),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Stack(
              children: [
                if (isSelected)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: selectedAccent),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 18, 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: Center(
                          child: Icon(icon, size: 32, color: textColor),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? selectedAccent
                                : const Color(0xFFAEB6C2),
                            width: isSelected ? 2 : 1.8,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 11,
                                  height: 11,
                                  decoration: const BoxDecoration(
                                    color: selectedAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
