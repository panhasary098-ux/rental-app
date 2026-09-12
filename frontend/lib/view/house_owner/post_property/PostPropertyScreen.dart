import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/view/house_owner/post_property/post_apart_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_house_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_payment_step4.dart';
import 'package:final_project/view/house_owner/post_property/post_review_step3.dart';
import 'package:final_project/view/house_owner/post_property/post_room_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_step1.dart';
import 'package:final_project/widget/stepNumber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class Postpropertyscreen extends StatefulWidget {
  final Map<String, dynamic>? propertyToEdit;

  const Postpropertyscreen({super.key, this.propertyToEdit});

  @override
  State<Postpropertyscreen> createState() => _PostpropertyscreenState();
}

class _PostpropertyscreenState extends State<Postpropertyscreen> {
  late final PostPropertyController controller;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<PostPropertyController>()) {
      controller = Get.find<PostPropertyController>();
    } else {
      controller = Get.put(PostPropertyController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (widget.propertyToEdit != null) {
        controller.loadPropertyForEdit(widget.propertyToEdit!);
      } else {
        controller.resetForCreateMode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isEditMode = controller.isEditMode.value;

      return Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: Text(
            isEditMode ? "Edit Property" : "Submit Your Property",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),

          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          iconTheme: const IconThemeData(color: primaryColor),
        ),

        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),

                child: StepNumber(currentStep: controller.currentStep.value),
              ),

              const SizedBox(height: 10),

              Expanded(child: changeSteps(controller.currentStep.value)),

              const SizedBox(height: 10),

              buildBottomButtons(),
            ],
          ),
        ),
      );
    });
  }

  Widget buildBottomButtons() {
    final int step = controller.currentStep.value;

    final bool isEditMode = controller.isEditMode.value;

    final bool hasSelectedType = controller.selectIndex.value != null;

    // Edit mode - Step 3
    if (isEditMode && step == 3) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,

              child: OutlinedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () {
                        controller.currentStep.value = 2;
                      },

                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,

                  side: const BorderSide(color: primaryColor, width: 1.5),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,

            child: SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () async {
                        final bool success = await controller.updateProperty();

                        if (!mounted) {
                          return;
                        }

                        if (success) {
                          // Return to My Properties
                          // and tell it to reload.
                          Navigator.of(context).pop(true);

                          // Show success message after
                          // returning to My Properties.
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Get.snackbar(
                              "Property Updated",
                              "Your property changes were saved successfully.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: primaryColor,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              borderRadius: 12,
                              duration: const Duration(seconds: 3),
                              icon: const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            );
                          });
                        }
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,

                  foregroundColor: Colors.white,

                  disabledBackgroundColor: secondaryColor.withOpacity(0.55),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,

                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        getEditSubmitText(),
                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    }

    // Create mode - Step 4
    if (!isEditMode && step == 4) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,

              child: OutlinedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () {
                        controller.currentStep.value = 3;
                      },

                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,

                  side: const BorderSide(color: primaryColor, width: 1.5),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Back",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Final submit
          Expanded(
            child: SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () async {
                        final bool success = await controller.submitProperty();

                        if (!mounted) {
                          return;
                        }

                        if (success) {
                          // Return true to OwnerBottomNav
                          // so it can select My Properties.
                          Navigator.of(context).pop(true);

                          // Clear all posting data after
                          // the Post screen starts closing.
                          Future.microtask(() {
                            controller.resetForCreateMode();
                          });
                        }
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,

                  foregroundColor: Colors.white,

                  disabledBackgroundColor: secondaryColor.withOpacity(0.55),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,

                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Submit Property",
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ],
      );
    }

    // Create mode - Step 3
    if (!isEditMode && step == 3) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,

              child: OutlinedButton(
                onPressed: () {
                  controller.currentStep.value = 2;
                },

                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor, width: 1.5),

                  foregroundColor: primaryColor,

                  backgroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Edit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  controller.currentStep.value = 4;
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
                  "Continue to Payment",
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Step 1 / Step 2
    return SizedBox(
      width: double.infinity,
      height: 50,

      child: ElevatedButton(
        onPressed: step == 1 && !hasSelectedType
            ? null
            : () {
                // Step 1 -> Step 2
                if (step == 1) {
                  controller.currentStep.value = 2;

                  return;
                }

                // Step 2 -> Step 3
                if (step == 2) {
                  final bool isValid = controller.validateStep2();

                  if (isValid) {
                    controller.currentStep.value = 3;
                  }

                  return;
                }
              },

        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,

          disabledBackgroundColor: secondaryColor.withOpacity(0.55),

          foregroundColor: Colors.white,

          disabledForegroundColor: primaryColor.withOpacity(0.45),

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: Text(
          isEditMode && step == 2 ? "Continue to Review" : "Continue",

          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String getEditSubmitText() {
    final String verificationStatus =
        controller.originalVerificationStatus.value?.toLowerCase() ?? "";

    if (verificationStatus == "rejected") {
      return "Resubmit for Review";
    }

    return "Save Changes";
  }

  Widget changeSteps(int step) {
    switch (step) {
      case 1:
        if (controller.isEditMode.value) {
          return changeType(controller.selectIndex.value);
        }

        return PostStep1(key: const ValueKey(1));

      case 2:
        return changeType(controller.selectIndex.value);

      case 3:
        return PostReviewStep3(key: const ValueKey(3));

      case 4:
        if (controller.isEditMode.value) {
          return PostReviewStep3(key: const ValueKey("edit_review"));
        }

        return PostPaymentStep4(key: const ValueKey(4));

      default:
        return const SizedBox();
    }
  }

  Widget changeType(int? typeIndex) {
    switch (typeIndex) {
      case 0:
        return PostHouseStep2(key: const ValueKey("house"));

      case 1:
        return PostApartStep2(key: const ValueKey("apartment"));

      case 2:
        return PostRoomStep2(key: const ValueKey("room"));

      default:
        return const SizedBox();
    }
  }
}
