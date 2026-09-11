import 'dart:io';

import 'package:final_project/service/auth_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OwnerAccountController extends GetxController {
  AuthService authService = AuthService();

  RxBool isLoading = true.obs;
  RxBool isUploadingImage = false.obs;

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString role = "".obs;
  RxString profileImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  // Load User
  Future<void> loadUser() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> user =
          await authService.getCurrentUserFromLaravel();

      name.value = user["name"] ?? "";
      email.value = user["email"] ?? "";
      phone.value = user["phone"] ?? "";
      role.value = user["role"] ?? "";
      profileImage.value = user["profile_image"] ?? "";
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick Profile Image
  Future<void> pickProfileImage() async {
    try {
      ImagePicker picker = ImagePicker();

      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      isUploadingImage.value = true;

      String? imageUrl = await authService.uploadProfileImage(
        File(image.path),
      );

      if (imageUrl != null) {
        profileImage.value = imageUrl;

        Get.snackbar(
          "Success",
          "Profile image updated successfully",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isUploadingImage.value = false;
    }
  }

  // Initials
  String getInitials() {
    if (name.value.trim().isEmpty) {
      return "U";
    }

    List<String> parts = name.value.trim().split(" ");

    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }
}