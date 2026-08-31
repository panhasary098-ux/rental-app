import 'dart:developer';

import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/view/house_owner/post_property/post_apart_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_house_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_room_step2.dart';
import 'package:final_project/view/house_owner/post_property/post_step1.dart';
import 'package:final_project/widget/stepNumber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Postpropertyscreen extends StatelessWidget {
  Postpropertyscreen({super.key});

  final PostPropertyController controller = Get.put(PostPropertyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 247, 252),

      appBar: AppBar(
        title: const Text(
          "Post Your Property",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 239, 247, 252),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: StepNumber(currentStep: controller.currentStep.value),
              ),
            ),
            SizedBox(height: 30),

            //Expanded(child: Obx(() => changeSteps(1))),
            Expanded(
              child: Obx(() => changeSteps(controller.currentStep.value)),
            ),

            Container(
              height: 60,
              width: double.infinity,

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: TextButton(
                onPressed: () {
                  log("Selected index: ${controller.selectIndex.value}");
                  // Step 1
                  if (controller.currentStep.value == 1) {
                    if (controller.selectIndex.value == null) {
                      Get.snackbar(
                        "Property type required",
                        "Please select the property type first",
                        colorText: Colors.black,
                        backgroundColor: Colors.white,
                      );

                      return;
                    }

                    controller.currentStep.value = 2;
                  }
                  // Step 2
                  else if (controller.currentStep.value == 2) {
                    controller.currentStep.value = 3;
                  }
                },

                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),

            //change by step
          ],
        ),
      ),
    );
  }

  Widget changeSteps(int step) {
    switch (step) {
      case 1:
        return PostStep1(key: ValueKey(1));

      case 2:
        return changeType(controller.selectIndex.value);

      // case 3:
      //   return const Step3Review(
      //     key: ValueKey(3),
      //   );

      default:
        return const SizedBox();
    }
  }

  Widget changeType(int? typeIndex) {
    switch (typeIndex) {
      case 0:
        return PostHouseStep2();
      case 1:
        return PostApartStep2();
      case 2:
        return PostRoomStep2();
      default:
        return SizedBox();
    }
  }
}
