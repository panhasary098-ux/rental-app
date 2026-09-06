import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPropertyController extends GetxController {
  // Step / property type
  final RxnInt selectIndex = RxnInt();
  final RxInt currentStep = 1.obs;

  // Common Property fields
  final nameController = TextEditingController();
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactController = TextEditingController();

  final RxnString status = RxnString();

  final RxBool furnished = false.obs;

  // Location
  // String? address;
  // double? latitude;
  // double? longitude;

  final RxnString address = RxnString();
  final RxnDouble latitude = RxnDouble();
  final RxnDouble longitude = RxnDouble();

  // House
  final RxInt houseBedrooms = 0.obs;
  final RxInt houseBathrooms = 1.obs;
  final RxInt houseTotalFloor = 1.obs;

  // Apartment / Flat
  final RxInt apartmentBedrooms = 0.obs;
  final RxInt apartmentBathrooms = 1.obs;
  final RxInt apartmentTotalFloor = 1.obs;
  final RxList<int> apartmentAvailableFloors = <int>[].obs;

  // Room
  final RxInt roomTotalFloor = 1.obs;
  final RxList<int> roomAvailableFloors = <int>[].obs;

  //faciliteis
  final RxBool wifi = false.obs;
  final RxBool parking = false.obs;
  final RxBool airConditioning = false.obs;
  final RxBool petAllowed = false.obs;
  final RxBool balcony = false.obs;
  final RxBool swimmingPool = false.obs;
  final RxBool kitchen = false.obs;
  final RxBool elevator = false.obs;

  final ImagePicker picker = ImagePicker();
  final RxList<XFile> selectedImages = <XFile>[].obs;

  @override
  void onClose() {
    nameController.dispose();
    sizeController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    contactController.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    print("IMAGE PICKER CLICKED");

    final List<XFile> images = await picker.pickMultiImage();

    print("Selected: ${images.length}");

    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
}
