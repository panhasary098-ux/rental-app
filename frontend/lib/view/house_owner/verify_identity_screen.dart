import 'dart:io';

import 'package:final_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';

// ======================================================
// COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);

class VerifyIdentityScreen extends StatefulWidget {
  const VerifyIdentityScreen({super.key});

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  // ======================================================
  // SERVICE
  // ======================================================

  final AuthService authService = AuthService();

  // ======================================================
  // IMAGE PICKER
  // ======================================================

  final ImagePicker imagePicker = ImagePicker();

  File? selectedNationalId;

  // ======================================================
  // LOADING
  // ======================================================

  bool isUploading = false;

  // ======================================================
  // PICK NATIONAL ID
  // ======================================================

  Future<void> pickNationalId() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      setState(() {
        selectedNationalId = File(image.path);
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unable to select image.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ======================================================
  // REMOVE SELECTED IMAGE
  // ======================================================

  void removeNationalId() {
    setState(() {
      selectedNationalId = null;
    });
  }

  // ======================================================
  // UPLOAD NATIONAL ID
  // ======================================================

  Future<void> uploadNationalId() async {
    if (selectedNationalId == null) {
      Get.snackbar(
        "National ID Required",
        "Please select your National ID first.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      final bool success = await authService.uploadNationalId(
        selectedNationalId!,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        Get.snackbar(
          "Success",
          "National ID uploaded successfully.",
          snackPosition: SnackPosition.TOP,
        );
        Get.off(() => const Postpropertyscreen());
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      Get.snackbar(
        "Upload Failed",
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  // ======================================================
  // BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ==================================================
      // APP BAR
      // ==================================================
      appBar: AppBar(
        title: const Text(
          "Verify Your Identity",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ============================================
              // HEADER ICON
              // ============================================
              Center(
                child: Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 44,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================
              // TITLE
              // ============================================
              const Center(
                child: Text(
                  "Identity Verification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ============================================
              // DESCRIPTION
              // ============================================
              const Center(
                child: Text(
                  "Before posting a property, please upload your National ID to verify your identity.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ============================================
              // LABEL
              // ============================================
              const Text(
                "National ID",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              // ============================================
              // IMAGE AREA
              // ============================================
              selectedNationalId == null
                  ? buildUploadBox()
                  : buildSelectedImage(),

              const SizedBox(height: 18),

              // ============================================
              // PRIVACY INFO
              // ============================================
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secondaryColor.withOpacity(0.7)),
                ),

                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(Icons.lock_outline, color: primaryColor, size: 21),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        "Your National ID is used for identity verification and is stored privately.",
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============================================
              // CONTINUE BUTTON
              // ============================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: isUploading ? null : uploadNationalId,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,

                    disabledBackgroundColor: secondaryColor,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Upload & Continue",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // UPLOAD BOX
  // ======================================================

  Widget buildUploadBox() {
    return InkWell(
      onTap: pickNationalId,

      borderRadius: BorderRadius.circular(14),

      child: Container(
        width: double.infinity,
        height: 190,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: secondaryColor, width: 1.5),
        ),

        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 45,
              color: primaryColor,
            ),

            SizedBox(height: 12),

            Text(
              "Upload National ID",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
            ),

            SizedBox(height: 6),

            Text(
              "JPG, JPEG, PNG or WEBP",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // SELECTED IMAGE
  // ======================================================

  Widget buildSelectedImage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: secondaryColor),
      ),

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.file(
              selectedNationalId!,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  "National ID selected",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),

              TextButton.icon(
                onPressed: isUploading ? null : removeNationalId,
                icon: const Icon(Icons.delete_outline, size: 19),
                label: const Text("Remove"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
