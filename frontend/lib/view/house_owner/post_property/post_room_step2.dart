import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/model/location.dart';
import 'package:final_project/view/house_owner/post_property/select_location_screen.dart';
import 'package:final_project/widget/post_properties/customDescriptionTFF.dart';
import 'package:final_project/widget/post_properties/customFacilitiesSelector.dart';
import 'package:final_project/widget/post_properties/customFurnishedSelector.dart';
import 'package:final_project/widget/post_properties/customImagePicker.dart';
import 'package:final_project/widget/post_properties/customLocationPicker.dart';
import 'package:final_project/widget/post_properties/customRoomDetail.dart';
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

class PostRoomStep2 extends StatelessWidget {
  PostRoomStep2({super.key});

  final PostPropertyController controller =
      Get.find<PostPropertyController>();

  final String storageBaseUrl =
      "http://10.0.2.2:8000/storage";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool isEditMode =
            controller.isEditMode.value;

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
                    // ==============================================
                    // EDIT MODE
                    // ==============================================

                    if (isEditMode) {
                      Get.back();
                      return;
                    }

                    // ==============================================
                    // CREATE MODE
                    // ==============================================

                    controller.currentStep.value = 1;
                  },

                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: primaryColor,
                    size: 20,
                  ),
                ),

                Text(
                  isEditMode
                      ? "Edit Room"
                      : "Room",

                  style: const TextStyle(
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
                    Text(
                      isEditMode
                          ? "Update your room information"
                          : "Input your room information",

                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black45,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // NAME
                    // ==================================================

                    customInputTitle(
                      title: "Name",
                    ),

                    const SizedBox(height: 5),

                    CustomTextFormField(
                      hintText:
                          "Enter room name",

                      controller:
                          controller.nameController,

                      prefixIcon:
                          Icons.home_outlined,
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // SIZE
                    // ==================================================

                    customInputTitle(
                      title: "Size",
                    ),

                    const SizedBox(height: 5),

                    CustomTextFormField(
                      hintText:
                          "Enter room size",

                      controller:
                          controller.sizeController,

                      keyboardType:
                          TextInputType.number,

                      prefixIcon:
                          Icons.square_foot,

                      suffixText: "m²",
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // LOCATION
                    // ==================================================

                    customInputTitle(
                      title: "Location",
                    ),

                    const SizedBox(height: 5),

                    PropertyLocationPicker(
                      address:
                          controller.address.value,

                      onTap: () async {
                        final PropertyLocation?
                            location =
                            await Get.to<
                                PropertyLocation>(
                          () =>
                              const SelectLocationScreen(),
                        );

                        if (location != null) {
                          controller.address.value =
                              location.address;

                          controller.latitude.value =
                              location.latitude;

                          controller.longitude.value =
                              location.longitude;
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // PRICE
                    // ==================================================

                    customInputTitle(
                      title: "Price",
                    ),

                    const SizedBox(height: 5),

                    CustomTextFormField(
                      hintText:
                          "Enter rent price",

                      controller:
                          controller.priceController,

                      keyboardType:
                          TextInputType.number,

                      prefixIcon:
                          Icons.attach_money,
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================

                    customInputTitle(
                      title: "Description",
                    ),

                    const SizedBox(height: 5),

                    CustomDescriptionField(
                      hintText:
                          "Describe your room...",

                      controller: controller
                          .descriptionController,
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // STATUS
                    // ==================================================

                    customInputTitle(
                      title: "Status",
                    ),

                    const SizedBox(height: 5),

                    CustomStatusDropdown(
                      value:
                          controller.status.value,

                      onChanged: (value) {
                        controller.status.value =
                            value;
                      },
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // CONTACT
                    // ==================================================

                    customInputTitle(
                      title: "Contact",
                    ),

                    const SizedBox(height: 5),

                    CustomTextFormField(
                      hintText:
                          "Enter contact number",

                      controller:
                          controller.contactController,

                      keyboardType:
                          TextInputType.phone,

                      prefixIcon:
                          Icons.phone_outlined,
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // ROOM DETAIL TITLE
                    // ==================================================

                    CustomRoomDetailTitle(),

                    const SizedBox(height: 10),

                    // ==================================================
                    // ROOM DETAILS
                    // ==================================================

                    RoomDetail(
                      totalFloor:
                          controller
                              .roomTotalFloor
                              .value,

                      availableFloors:
                          controller
                              .roomAvailableFloors,

                      // Total floor +
                      onFloorIncrease: () {
                        controller
                            .roomTotalFloor
                            .value++;
                      },

                      // Total floor -
                      onFloorDecrease: () {
                        if (controller
                                .roomTotalFloor
                                .value >
                            1) {
                          controller
                              .roomTotalFloor
                              .value--;

                          // Remove selected floors that
                          // are now higher than total floors.
                          controller
                              .roomAvailableFloors
                              .removeWhere(
                            (floor) =>
                                floor >
                                controller
                                    .roomTotalFloor
                                    .value,
                          );
                        }
                      },

                      // ==============================================
                      // AVAILABLE FLOORS
                      // ==============================================

                      onAvailableFloorsTap: () {
                        Get.bottomSheet(
                          Container(
                            padding:
                                const EdgeInsets.all(
                              20,
                            ),

                            decoration:
                                const BoxDecoration(
                              color:
                                  backgroundColor,

                              borderRadius:
                                  BorderRadius.vertical(
                                top:
                                    Radius.circular(
                                  20,
                                ),
                              ),
                            ),

                            child: Obx(
                              () =>
                                  SingleChildScrollView(
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    const Text(
                                      "Select Available Floors",

                                      style:
                                          TextStyle(
                                        color:
                                            primaryColor,

                                        fontSize: 18,

                                        fontWeight:
                                            FontWeight
                                                .w700,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 15,
                                    ),

                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,

                                      children:
                                          List.generate(
                                        controller
                                            .roomTotalFloor
                                            .value,

                                        (index) {
                                          final int
                                              floor =
                                              index + 1;

                                          final bool
                                              isSelected =
                                              controller
                                                  .roomAvailableFloors
                                                  .contains(
                                            floor,
                                          );

                                          return ChoiceChip(
                                            label: Text(
                                              "Floor $floor",
                                            ),

                                            selected:
                                                isSelected,

                                            onSelected:
                                                (selected) {
                                              if (selected) {
                                                if (!controller
                                                    .roomAvailableFloors
                                                    .contains(
                                                  floor,
                                                )) {
                                                  controller
                                                      .roomAvailableFloors
                                                      .add(
                                                    floor,
                                                  );

                                                  controller
                                                      .roomAvailableFloors
                                                      .sort();
                                                }
                                              } else {
                                                controller
                                                    .roomAvailableFloors
                                                    .remove(
                                                  floor,
                                                );
                                              }
                                            },

                                            selectedColor:
                                                secondaryColor,

                                            backgroundColor:
                                                Colors
                                                    .white,

                                            side:
                                                BorderSide(
                                              color:
                                                  isSelected
                                                      ? primaryColor
                                                      : secondaryColor.withOpacity(
                                                          0.7,
                                                        ),

                                              width:
                                                  isSelected
                                                      ? 1.3
                                                      : 1,
                                            ),

                                            labelStyle:
                                                TextStyle(
                                              color:
                                                  primaryColor,

                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                            ),

                                            checkmarkColor:
                                                primaryColor,

                                            shape:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    SizedBox(
                                      width:
                                          double.infinity,

                                      height: 48,

                                      child:
                                          ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },

                                        style:
                                            ElevatedButton.styleFrom(
                                          backgroundColor:
                                              primaryColor,

                                          foregroundColor:
                                              Colors.white,

                                          elevation: 0,

                                          shape:
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),

                                        child:
                                            const Text(
                                          "Done",

                                          style:
                                              TextStyle(
                                            fontSize:
                                                15,

                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          isScrollControlled: true,
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // FURNISHED
                    // ==================================================

                    customInputTitle(
                      title: "Furnished",
                    ),

                    const SizedBox(height: 5),

                    FurnishedSelector(
                      value:
                          controller
                              .furnished
                              .value,

                      onChanged: (value) {
                        controller
                            .furnished
                            .value = value;
                      },
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // FACILITIES
                    // ==================================================

                    customInputTitle(
                      title:
                          "Choose facilities",
                    ),

                    const SizedBox(height: 5),

                    FacilitiesSelector(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // VERIFICATION
                    // ==================================================

                    VerificationTitle(),

                    const SizedBox(height: 15),

                    // ==================================================
                    // PROPERTY IMAGES
                    // ==================================================

                    customInputTitle(
                      title: "Property Images",
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // EXISTING IMAGES
                    // ==================================================

                    if (isEditMode &&
                        controller
                            .selectedImages
                            .isEmpty &&
                        controller
                            .existingImagePaths
                            .isNotEmpty) ...[
                      buildExistingImages(),

                      const SizedBox(height: 10),

                      buildInformationBox(
                        icon:
                            Icons.info_outline,

                        text:
                            "These are your current property photos. "
                            "If you select new photos, all current photos "
                            "will be replaced.",
                      ),

                      const SizedBox(height: 12),
                    ],

                    // ==================================================
                    // NEW IMAGES NOTICE
                    // ==================================================

                    if (isEditMode &&
                        controller
                            .selectedImages
                            .isNotEmpty) ...[
                      buildInformationBox(
                        icon: Icons
                            .swap_horiz_rounded,

                        text:
                            "The new photos below will replace your current property photos when you save changes.",
                      ),

                      const SizedBox(height: 10),
                    ],

                    // ==================================================
                    // IMAGE PICKER
                    // ==================================================

                    Imagepicker(
                      title: isEditMode
                          ? "Select New Property Photos"
                          : "Add property photos",

                      subtitle: isEditMode
                          ? "Optional — leave empty to keep current photos"
                          : "Tap to select property images",

                      icon: Icons
                          .add_photo_alternate_outlined,

                      images: controller
                          .selectedImages
                          .toList(),

                      onRemove: (index) {
                        controller
                            .removeImage(index);
                      },

                      onTap: () {
                        controller.pickImages();
                      },
                    ),

                    const SizedBox(height: 15),

                    // ==================================================
                    // OWNERSHIP DOCUMENT
                    // ==================================================

                    customInputTitle(
                      title:
                          "Ownership Document",
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // EXISTING DOCUMENT
                    // ==================================================

                    if (isEditMode &&
                        controller
                            .hasExistingOwnershipDocument
                            .value) ...[
                      buildExistingDocumentBox(),

                      const SizedBox(height: 10),
                    ],

                    // ==================================================
                    // OWNERSHIP PICKER
                    // ==================================================

                    SingleImagePicker(
                      title: isEditMode
                          ? controller
                                      .ownershipDocumentImage
                                      .value ==
                                  null
                              ? "Replace Ownership Document"
                              : "New Ownership Document"
                          : "Upload Ownership Document",

                      subtitle: isEditMode
                          ? controller
                                      .ownershipDocumentImage
                                      .value ==
                                  null
                              ? "Optional — current document will be kept"
                              : "New document selected"
                          : "Tap to select proof of ownership",

                      icon:
                          Icons.description_outlined,

                      image: controller
                          .ownershipDocumentImage
                          .value,

                      onTap: () {
                        controller
                            .pickOwnershipDocumentImage();
                      },

                      onRemove: () {
                        controller
                            .removeOwnershipDocumentImage();
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // EXISTING PROPERTY IMAGES
  // ======================================================

  Widget buildExistingImages() {
    return SizedBox(
      height: 105,

      child: ListView.separated(
        scrollDirection:
            Axis.horizontal,

        itemCount:
            controller.existingImagePaths.length,

        separatorBuilder: (
          context,
          index,
        ) {
          return const SizedBox(
            width: 10,
          );
        },

        itemBuilder: (
          context,
          index,
        ) {
          final String path =
              controller
                  .existingImagePaths[index];

          final String imageUrl =
              path.startsWith("http")
              ? path
              : "$storageBaseUrl/$path";

          return ClipRRect(
            borderRadius:
                BorderRadius.circular(12),

            child: Container(
              width: 130,
              height: 105,

              color:
                  lightSecondaryColor,

              child: Image.network(
                imageUrl,

                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons
                          .broken_image_outlined,

                      size: 35,

                      color: primaryColor,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // ======================================================
  // EXISTING OWNERSHIP DOCUMENT
  // ======================================================

  Widget buildExistingDocumentBox() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: const Color(
          0xFFECFDF3,
        ),

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: const Color(
            0xFF16A34A,
          ).withOpacity(0.30),
        ),
      ),

      child: const Row(
        children: [
          Icon(
            Icons
                .check_circle_outline_rounded,

            color:
                Color(0xFF16A34A),

            size: 22,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "Ownership document uploaded",

                  style: TextStyle(
                    fontSize: 13,

                    fontWeight:
                        FontWeight.w700,

                    color:
                        primaryColor,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  "Your current document will remain unless you select a new one.",

                  style: TextStyle(
                    fontSize: 11,

                    color:
                        Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // INFORMATION BOX
  // ======================================================

  Widget buildInformationBox({
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(11),

      decoration: BoxDecoration(
        color:
            secondaryColor.withOpacity(
          0.12,
        ),

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color:
              secondaryColor.withOpacity(
            0.40,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 18,
            color: primaryColor,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 11,

                color:
                    Color(0xFF667085),

                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// ROOM DETAIL TITLE
// ======================================================

Widget CustomRoomDetailTitle() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color:
              secondaryColor.withOpacity(
            0.8,
          ),
          thickness: 1,
        ),
      ),

      const Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 12,
        ),

        child: Text(
          "ROOM DETAIL",

          style: TextStyle(
            color: primaryColor,
            fontSize: 13,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      Expanded(
        child: Divider(
          color:
              secondaryColor.withOpacity(
            0.8,
          ),
          thickness: 1,
        ),
      ),
    ],
  );
}

// ======================================================
// VERIFICATION DOCUMENT TITLE
// ======================================================

Widget VerificationTitle() {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color:
              secondaryColor.withOpacity(
            0.8,
          ),
          thickness: 1,
        ),
      ),

      const Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 12,
        ),

        child: Text(
          "VERIFICATION DOCUMENTS",

          style: TextStyle(
            color: primaryColor,
            fontSize: 13,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      Expanded(
        child: Divider(
          color:
              secondaryColor.withOpacity(
            0.8,
          ),
          thickness: 1,
        ),
      ),
    ],
  );
}