import 'dart:io';

import 'package:final_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);

class VerifyIdentityScreen extends StatefulWidget {
  const VerifyIdentityScreen({super.key});

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  final AuthService authService = AuthService();

  final ImagePicker imagePicker = ImagePicker();

  File? selectedNationalId;

  bool isUploading = false;

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
      showErrorNotification(
        title: "Unable to Select Image",
        message: "Unable to select your National ID image.",
      );
    }
  }

  void removeNationalId() {
    setState(() {
      selectedNationalId = null;
    });
  }

  Future<void> uploadNationalId() async {
    if (selectedNationalId == null) {
      showWarningNotification(
        title: "National ID Required",
        message: "Please select your National ID first.",
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
        showSuccessNotification(
          title: "Identity Verified",
          message: "Your National ID was uploaded successfully.",
        );

        Get.off(() => Postpropertyscreen());
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      showErrorNotification(title: "Upload Failed", message: message);
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  void showSuccessNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFD1FAE5),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFECFDF5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Color(0xFF16A34A),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF16A34A),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  void showWarningNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFFDE68A),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF7ED),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFF59E0B),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFD97706),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  void showErrorNotification({required String title, required String message}) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFF3D2D2),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFFDECEC),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.priority_high_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
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

              const Text(
                "National ID",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 10),

              selectedNationalId == null
                  ? buildUploadBox()
                  : buildSelectedImage(),

              const SizedBox(height: 18),

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
