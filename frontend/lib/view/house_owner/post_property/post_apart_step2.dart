import 'dart:io';

import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/widget/post_properties/customApartDetail.dart';
import 'package:final_project/widget/post_properties/customDescriptionTFF.dart';
import 'package:final_project/widget/post_properties/customFacilitiesSelector.dart';
import 'package:final_project/widget/post_properties/customFurnishedSelector.dart';
import 'package:final_project/widget/post_properties/customImagePicker.dart';
import 'package:final_project/widget/post_properties/customLocationPicker.dart';
import 'package:final_project/widget/post_properties/customStatusDropdown.dart';
import 'package:final_project/widget/post_properties/customTextFormField.dart';
import 'package:final_project/widget/post_properties/inputTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PostApartStep2 extends StatelessWidget {
  PostApartStep2({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ======================================================
        // HEADER
        // ======================================================
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.currentStep.value = 1;
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryColor,
                size: 20,
              ),
            ),

            const Text(
              "Apartment/Flat",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ],
        ),

        // ======================================================
        // FORM
        // ======================================================
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Input your Apartment/Flat information:",
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // NAME
                // ==================================================
                customInputTitle(title: "Name"),

                const SizedBox(height: 5),

                CustomTextFormField(
                  hintText: "Enter apartment/flat name",
                  controller: controller.nameController,
                  prefixIcon: Icons.home_outlined,
                ),

                const SizedBox(height: 10),

                // ==================================================
                // SIZE
                // ==================================================
                customInputTitle(title: "Size"),

                const SizedBox(height: 5),

                CustomTextFormField(
                  hintText: "Enter apartment/flat size",
                  controller: controller.sizeController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.square_foot,
                  suffixText: "m²",
                ),

                const SizedBox(height: 10),

                // ==================================================
                // LOCATION
                // ==================================================
                customInputTitle(title: "Location"),

                const SizedBox(height: 5),

                Obx(
                  () => PropertyLocationPicker(
                    address: controller.address.value,

                    onTap: () {
                      // Later: open map screen
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // PRICE
                // ==================================================
                customInputTitle(title: "Price"),

                const SizedBox(height: 5),

                CustomTextFormField(
                  hintText: "Enter rent price",
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                ),

                const SizedBox(height: 10),

                // ==================================================
                // DESCRIPTION
                // ==================================================
                customInputTitle(title: "Description"),

                const SizedBox(height: 5),

                CustomDescriptionField(
                  hintText: "Describe your apartment/flat...",
                  controller: controller.descriptionController,
                ),

                const SizedBox(height: 10),

                // ==================================================
                // STATUS
                // ==================================================
                customInputTitle(title: "Status"),

                const SizedBox(height: 5),

                Obx(
                  () => CustomStatusDropdown(
                    value: controller.status.value,

                    onChanged: (value) {
                      controller.status.value = value;
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // CONTACT
                // ==================================================
                customInputTitle(title: "Contact"),

                const SizedBox(height: 5),

                CustomTextFormField(
                  hintText: "Enter contact number",
                  controller: controller.contactController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),

                const SizedBox(height: 15),

                // ==================================================
                // APARTMENT DETAILS TITLE
                // ==================================================
                CustomApartFlatdetail(),

                const SizedBox(height: 10),

                // ==================================================
                // APARTMENT DETAILS
                // ==================================================
                Obx(
                  () => ApartDetail(
                    bedrooms: controller.apartmentBedrooms.value,

                    bathrooms: controller.apartmentBathrooms.value,

                    totalFloor: controller.apartmentTotalFloor.value,

                    availableFloors: controller.apartmentAvailableFloors,

                    // Bedroom +
                    onBedroomIncrease: () {
                      controller.apartmentBedrooms.value++;
                    },

                    // Bedroom -
                    onBedroomDecrease: () {
                      if (controller.apartmentBedrooms.value > 0) {
                        controller.apartmentBedrooms.value--;
                      }
                    },

                    // Bathroom +
                    onBathroomIncrease: () {
                      controller.apartmentBathrooms.value++;
                    },

                    // Bathroom -
                    onBathroomDecrease: () {
                      if (controller.apartmentBathrooms.value > 0) {
                        controller.apartmentBathrooms.value--;
                      }
                    },

                    // Floor +
                    onFloorIncrease: () {
                      controller.apartmentTotalFloor.value++;
                    },

                    // Floor -
                    onFloorDecrease: () {
                      if (controller.apartmentTotalFloor.value > 1) {
                        controller.apartmentTotalFloor.value--;

                        // Remove selected floors that no longer exist
                        controller.apartmentAvailableFloors.removeWhere(
                          (floor) =>
                              floor > controller.apartmentTotalFloor.value,
                        );
                      }
                    },

                    // ==================================================
                    // AVAILABLE FLOORS BOTTOM SHEET
                    // ==================================================
                    onAvailableFloorsTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(20),

                          decoration: const BoxDecoration(
                            color: backgroundColor,

                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),

                          child: Obx(
                            () => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // Title
                                const Text(
                                  "Select Available Floors",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Floor selection
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,

                                  children: List.generate(
                                    controller.apartmentTotalFloor.value,
                                    (index) {
                                      final int floor = index + 1;

                                      final bool isSelected = controller
                                          .apartmentAvailableFloors
                                          .contains(floor);

                                      return ChoiceChip(
                                        label: Text("Floor $floor"),

                                        selected: isSelected,

                                        onSelected: (selected) {
                                          if (selected) {
                                            controller.apartmentAvailableFloors
                                                .add(floor);
                                          } else {
                                            controller.apartmentAvailableFloors
                                                .remove(floor);
                                          }
                                        },

                                        // ====================================
                                        // THEME
                                        // ====================================
                                        selectedColor: secondaryColor,

                                        backgroundColor: Colors.white,

                                        side: BorderSide(
                                          color: isSelected
                                              ? primaryColor
                                              : secondaryColor.withOpacity(0.7),
                                        ),

                                        labelStyle: TextStyle(
                                          color: primaryColor,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),

                                        showCheckmark: true,

                                        checkmarkColor: primaryColor,
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // ============================================
                                // DONE BUTTON
                                // ============================================
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,

                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),

                                    child: const Text(
                                      "Done",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
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
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // FURNISHED
                // ==================================================
                customInputTitle(title: "Furnished"),

                const SizedBox(height: 5),

                Obx(
                  () => FurnishedSelector(
                    value: controller.furnished.value,

                    onChanged: (value) {
                      controller.furnished.value = value;
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ==================================================
                // FACILITIES
                // ==================================================
                customInputTitle(title: "Choose facilities"),

                const SizedBox(height: 5),

                FacilitiesSelector(),

                const SizedBox(height: 15),

                // ==================================================
                // IMAGE
                // ==================================================
                customInputTitle(title: "Image"),

                const SizedBox(height: 5),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// APARTMENT / FLAT DETAILS TITLE
// ======================================================

Widget CustomApartFlatdetail() {
  return Row(
    children: [
      Expanded(
        child: Divider(color: secondaryColor.withOpacity(0.8), thickness: 1),
      ),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),

        child: Text(
          "APARTMENT/FLAT DETAILS",
          style: TextStyle(
            color: primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      Expanded(
        child: Divider(color: secondaryColor.withOpacity(0.8), thickness: 1),
      ),
    ],
  );
}
