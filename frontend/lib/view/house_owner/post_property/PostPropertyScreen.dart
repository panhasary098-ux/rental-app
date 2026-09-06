import 'dart:developer';

import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/view/house_owner/post_property/post_apart_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_house_step2.dart';
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

class Postpropertyscreen extends StatelessWidget {
  Postpropertyscreen({super.key});

  final PostPropertyController controller = Get.put(PostPropertyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        title: const Text(
          "Post Your Property",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),

        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,

        iconTheme: const IconThemeData(color: primaryColor),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),

        child: Column(
          children: [
            // ==================================================
            // STEP INDICATOR
            // ==================================================
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),

                child: StepNumber(currentStep: controller.currentStep.value),
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // STEP CONTENT
            // ==================================================
            Expanded(
              child: Obx(() => changeSteps(controller.currentStep.value)),
            ),

            // ==================================================
            // BOTTOM BUTTONS
            // ==================================================
            Obx(() {
              final int step = controller.currentStep.value;

              final bool isStep1 = step == 1;

              final bool hasSelectedType = controller.selectIndex.value != null;

              final bool canContinue = !isStep1 || hasSelectedType;

              // ==================================================
              // STEP 3
              // ==================================================

              if (step == 3) {
                return Row(
                  children: [
                    // ============================================
                    // EDIT BUTTON
                    // ============================================
                    Expanded(
                      child: SizedBox(
                        height: 50,

                        child: OutlinedButton(
                          onPressed: () {
                            controller.currentStep.value = 2;
                          },

                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: primaryColor,
                              width: 1.5,
                            ),

                            foregroundColor: primaryColor,

                            backgroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ============================================
                    // SUBMIT BUTTON
                    // ============================================
                    Expanded(
                      child: SizedBox(
                        height: 50,

                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Publish property
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
                            "Submit for Review",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              // ==================================================
              // STEP 1 & STEP 2
              // ==================================================

              return SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: canContinue
                      ? () {
                          controller.currentStep.value++;
                        }
                      : null,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    // Disabled button
                    disabledBackgroundColor: secondaryColor.withOpacity(0.55),

                    foregroundColor: Colors.white,

                    disabledForegroundColor: primaryColor.withOpacity(0.45),

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // CHANGE STEP
  // ======================================================

  Widget changeSteps(int step) {
    switch (step) {
      case 1:
        return PostStep1(key: ValueKey(1));

      case 2:
        return changeType(controller.selectIndex.value);

      case 3:
        return const PostReviewStep3(key: ValueKey(3));

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
        return PostHouseStep2();

      case 1:
        return PostApartStep2();

      case 2:
        return PostRoomStep2();

      default:
        return const SizedBox();
    }
  }
}
