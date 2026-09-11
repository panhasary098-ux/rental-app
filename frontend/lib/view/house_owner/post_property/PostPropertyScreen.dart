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

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class Postpropertyscreen extends StatefulWidget {
  // ======================================================
  // EDIT PROPERTY
  // ======================================================
  //
  // null:
  // normal new-property flow
  //
  // not null:
  // edit existing property
  //

  final Map<String, dynamic>? propertyToEdit;

  const Postpropertyscreen({super.key, this.propertyToEdit});

  @override
  State<Postpropertyscreen> createState() => _PostpropertyscreenState();
}

class _PostpropertyscreenState extends State<Postpropertyscreen> {
  late final PostPropertyController controller;

  // ======================================================
  // INITIALIZE
  // ======================================================

  @override
  void initState() {
    super.initState();

    // ====================================================
    // GET / CREATE CONTROLLER
    // ====================================================

    if (Get.isRegistered<PostPropertyController>()) {
      controller = Get.find<PostPropertyController>();
    } else {
      controller = Get.put(PostPropertyController());
    }

    // ====================================================
    // EDIT MODE
    // ====================================================

    if (widget.propertyToEdit != null) {
      controller.loadPropertyForEdit(widget.propertyToEdit!);
    }
    // ====================================================
    // CREATE MODE
    // ====================================================
    else {
      controller.resetForCreateMode();
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isEditMode = controller.isEditMode.value;

      return Scaffold(
        backgroundColor: Colors.white,

        // ==================================================
        // APP BAR
        // ==================================================
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

        // ==================================================
        // BODY
        // ==================================================
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),

          child: Column(
            children: [
              // ==============================================
              // STEP INDICATOR
              // ==============================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),

                child: StepNumber(currentStep: controller.currentStep.value),
              ),

              const SizedBox(height: 10),

              // ==============================================
              // STEP CONTENT
              // ==============================================
              Expanded(child: changeSteps(controller.currentStep.value)),

              const SizedBox(height: 10),

              // ==============================================
              // BOTTOM BUTTONS
              // ==============================================
              buildBottomButtons(),
            ],
          ),
        ),
      );
    });
  }

  // ======================================================
  // BOTTOM BUTTONS
  // ======================================================

  Widget buildBottomButtons() {
    final int step = controller.currentStep.value;

    final bool isEditMode = controller.isEditMode.value;

    final bool hasSelectedType = controller.selectIndex.value != null;

    // ======================================================
    // EDIT MODE - STEP 3
    // ======================================================

    if (isEditMode && step == 3) {
      return Row(
        children: [
          // ==================================================
          // BACK TO STEP 2
          // ==================================================
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

          // ==================================================
          // SAVE / RESUBMIT
          // ==================================================
          Expanded(
            flex: 2,

            child: SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () async {
                        final bool success = await controller.updateProperty();

                        if (success) {
                          // Return true so My Properties
                          // can refresh the property list.
                          Get.back(result: true);
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

    // ======================================================
    // CREATE MODE - STEP 4 PAYMENT
    // ======================================================

    if (!isEditMode && step == 4) {
      return Row(
        children: [
          // ==================================================
          // BACK
          // ==================================================
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

          // ==================================================
          // FINAL SUBMIT
          // ==================================================
          Expanded(
            child: SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () async {
                        final bool success = await controller.submitProperty();

                        if (success) {
                          Get.back(result: true);
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

    // ======================================================
    // STEP 3
    // CREATE MODE ONLY
    // ======================================================

    if (!isEditMode && step == 3) {
      return Row(
        children: [
          // ==================================================
          // EDIT INFORMATION
          // ==================================================
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

          // ==================================================
          // CONTINUE TO PAYMENT
          // ==================================================
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

    // ======================================================
    // STEP 1 / STEP 2
    // ======================================================

    return SizedBox(
      width: double.infinity,
      height: 50,

      child: ElevatedButton(
        onPressed: step == 1 && !hasSelectedType
            ? null
            : () {
                // ============================================
                // STEP 1 → STEP 2
                // ============================================

                if (step == 1) {
                  controller.currentStep.value = 2;

                  return;
                }

                // ============================================
                // STEP 2 → STEP 3
                // ============================================

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

  // ======================================================
  // EDIT FINAL BUTTON TEXT
  // ======================================================

  String getEditSubmitText() {
    final String verificationStatus =
        controller.originalVerificationStatus.value?.toLowerCase() ?? "";

    if (verificationStatus == "rejected") {
      return "Resubmit for Review";
    }

    return "Save Changes";
  }

  // ======================================================
  // CHANGE STEP
  // ======================================================

  Widget changeSteps(int step) {
    switch (step) {
      case 1:
        // Edit mode should never reach Step 1.
        if (controller.isEditMode.value) {
          return changeType(controller.selectIndex.value);
        }

        return PostStep1(key: const ValueKey(1));

      case 2:
        return changeType(controller.selectIndex.value);

      case 3:
        return PostReviewStep3(key: const ValueKey(3));

      case 4:
        // Edit mode never goes to payment.
        if (controller.isEditMode.value) {
          return PostReviewStep3(key: const ValueKey("edit_review"));
        }

        return PostPaymentStep4(key: const ValueKey(4));

      default:
        return const SizedBox();
    }
  }

  // ======================================================
  // CHANGE PROPERTY TYPE
  // ======================================================

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
