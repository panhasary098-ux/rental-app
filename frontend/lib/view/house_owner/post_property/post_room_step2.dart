import 'package:final_project/controller/post_properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class PostRoomStep2 extends StatelessWidget {
  PostRoomStep2({super.key});
  final PostPropertyController controller = Get.find<PostPropertyController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.currentStep.value = 1;
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 25,
                fontWeight: FontWeight.w900,
              ),
            ),

            Text(
              "Room ",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ],
    );
  }
}
