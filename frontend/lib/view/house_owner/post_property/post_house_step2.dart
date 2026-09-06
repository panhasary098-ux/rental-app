import 'dart:io';

import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/model/location.dart';
import 'package:final_project/view/house_owner/post_property/select_location_screen.dart';
import 'package:final_project/widget/post_properties/customDescriptionTFF.dart';
import 'package:final_project/widget/post_properties/customFacilitiesSelector.dart';
import 'package:final_project/widget/post_properties/customFurnishedSelector.dart';
import 'package:final_project/widget/post_properties/customHouseDetail.dart';
import 'package:final_project/widget/post_properties/customImagePicker.dart';
import 'package:final_project/widget/post_properties/customLocationPicker.dart';
import 'package:final_project/widget/post_properties/customSingleImagePicker.dart';
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

class PostHouseStep2 extends StatelessWidget {
  PostHouseStep2({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              "House",
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
                  "Input your house information",
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // NAME
                // ==================================================
                customInputTitle(title: "Name"),

                const SizedBox(height: 5),

                CustomTextFormField(
                  hintText: "Enter house name",
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
                  hintText: "Enter house size",
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

                    onTap: () async {
                      final PropertyLocation? location =
                          await Get.to<PropertyLocation>(
                            () => const SelectLocationScreen(),
                          );

                      if (location != null) {
                        controller.address.value = location.address;

                        controller.latitude.value = location.latitude;

                        controller.longitude.value = location.longitude;
                      }
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
                  hintText: "Describe your house...",
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
                // HOUSE DETAILS TITLE
                // ==================================================
                CustomHousedetail(),

                const SizedBox(height: 10),

                // ==================================================
                // HOUSE DETAILS
                // ==================================================
                Obx(
                  () => HouseDetailsCard(
                    bedrooms: controller.houseBedrooms.value,

                    bathrooms: controller.houseBathrooms.value,

                    totalFloor: controller.houseTotalFloor.value,

                    onBedroomIncrease: () {
                      controller.houseBedrooms.value++;
                    },

                    onBedroomDecrease: () {
                      if (controller.houseBedrooms.value > 0) {
                        controller.houseBedrooms.value--;
                      }
                    },

                    onBathroomIncrease: () {
                      controller.houseBathrooms.value++;
                    },

                    onBathroomDecrease: () {
                      if (controller.houseBathrooms.value > 0) {
                        controller.houseBathrooms.value--;
                      }
                    },

                    onFloorIncrease: () {
                      controller.houseTotalFloor.value++;
                    },

                    onFloorDecrease: () {
                      if (controller.houseTotalFloor.value > 1) {
                        controller.houseTotalFloor.value--;
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

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
                VerificationTitle(),
                // ==================================================
                // PROPERTY IMAGES
                // ==================================================
                customInputTitle(title: "Property Images"),

                const SizedBox(height: 5),

                Obx(
                  () => Imagepicker(
                    title: "Add property photos",
                    subtitle: "Tap to select property images",
                    icon: Icons.add_photo_alternate_outlined,

                    images: controller.selectedImages.toList(),

                    onRemove: (index) {
                      controller.removeImage(index);
                    },

                    onTap: () {
                      controller.pickImages();
                    },
                  ),
                ),

                const SizedBox(height: 15),
                customInputTitle(title: "National ID"),
                const SizedBox(height: 5),

                // const SizedBox(height: 5),
                Obx(
                  () => SingleImagePicker(
                    title: "Upload National ID",
                    subtitle: "Tap to select your National ID",
                    icon: Icons.badge_outlined,
                    image: controller.nationalIdImage.value,
                    onTap: () {
                      controller.pickNationalIdImage();
                    },
                    onRemove: () {
                      controller.removeNationalIdImage();
                    },
                  ),
                ),

                const SizedBox(height: 15),

                customInputTitle(title: "Ownership Document"),

                const SizedBox(height: 5),

                Obx(
                  () => SingleImagePicker(
                    title: "Upload Ownership Document",
                    subtitle: "Tap to select proof of ownership",
                    icon: Icons.description_outlined,
                    image: controller.ownershipDocumentImage.value,
                    onTap: () {
                      controller.pickOwnershipDocumentImage();
                    },
                    onRemove: () {
                      controller.removeOwnershipDocumentImage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ======================================================
// HOUSE DETAILS SECTION TITLE
// ======================================================

Widget CustomHousedetail() {
  return Row(
    children: [
      Expanded(
        child: Divider(color: secondaryColor.withOpacity(0.8), thickness: 1),
      ),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),

        child: Text(
          "HOUSE DETAILS",
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

// ======================================================
// VERIFICATION DOCUMENT SECTION TITLE
// ======================================================

Widget VerificationTitle() {
  return Row(
    children: [
      Expanded(
        child: Divider(color: secondaryColor.withOpacity(0.8), thickness: 1),
      ),

      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),

        child: Text(
          "VERIFICATION DOCUMENTS",
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
