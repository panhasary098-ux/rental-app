import 'dart:io';

import 'package:final_project/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RenterAccountController extends GetxController {
  AuthService authService = AuthService();

  RxBool isLoading = true.obs;
  RxBool isUpdating = false.obs;
  RxBool isUploadingImage = false.obs;

  RxString name = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString role = "".obs;
  RxString profileImage = "".obs;

  TextEditingController nameController =
      TextEditingController();

  TextEditingController phoneController =
      TextEditingController();

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

      nameController.text = name.value;
      phoneController.text = phone.value;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile
  Future<bool> updateProfile() async {
    String newName = nameController.text.trim();
    String newPhone = phoneController.text.trim();

    if (newName.isEmpty) {
      Get.snackbar(
        "Name Required",
        "Please enter your name.",
        snackPosition: SnackPosition.TOP,
      );

      return false;
    }

    try {
      isUpdating.value = true;

      Map<String, dynamic> user =
          await authService.updateCurrentUser(
        name: newName,
        phone: newPhone,
      );

      name.value = user["name"] ?? newName;
      phone.value = user["phone"] ?? newPhone;

      Get.snackbar(
        "Updated",
        "Your profile has been updated successfully.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF16A34A),
        colorText: Colors.white,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        "Update Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return false;
    } finally {
      isUpdating.value = false;
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

      String? imagePath =
          await authService.uploadProfileImage(
        File(image.path),
      );

      if (imagePath != null) {
        profileImage.value = imagePath;

        Get.snackbar(
          "Updated",
          "Profile image updated successfully.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFF16A34A),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Upload Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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

    parts.removeWhere(
      (item) => item.trim().isEmpty,
    );

    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}"
          .toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();

    super.onClose();
  }
}