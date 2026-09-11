import 'dart:convert';
import 'dart:io';

import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPropertyController extends GetxController {
  // ======================================================
  // STEP / PROPERTY TYPE
  // ======================================================

  final RxnInt selectIndex = RxnInt();
  final RxInt currentStep = 1.obs;

  // ======================================================
  // COMMON PROPERTY FIELDS
  // ======================================================

  final nameController = TextEditingController();
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactController = TextEditingController();

  final RxnString status = RxnString();

  final RxBool furnished = false.obs;

  // ======================================================
  // LOCATION
  // ======================================================

  final RxnString address = RxnString();
  final RxnDouble latitude = RxnDouble();
  final RxnDouble longitude = RxnDouble();

  // ======================================================
  // HOUSE
  // ======================================================

  final RxInt houseBedrooms = 0.obs;
  final RxInt houseBathrooms = 1.obs;
  final RxInt houseTotalFloor = 1.obs;

  // ======================================================
  // APARTMENT / FLAT
  // ======================================================

  final RxInt apartmentBedrooms = 0.obs;
  final RxInt apartmentBathrooms = 1.obs;
  final RxInt apartmentTotalFloor = 1.obs;

  final RxList<int> apartmentAvailableFloors = <int>[].obs;

  // ======================================================
  // ROOM
  // ======================================================

  final RxInt roomTotalFloor = 1.obs;

  final RxList<int> roomAvailableFloors = <int>[].obs;

  // ======================================================
  // FACILITIES
  // ======================================================

  final RxBool wifi = false.obs;
  final RxBool parking = false.obs;
  final RxBool airConditioning = false.obs;
  final RxBool petAllowed = false.obs;
  final RxBool balcony = false.obs;
  final RxBool swimmingPool = false.obs;
  final RxBool kitchen = false.obs;
  final RxBool elevator = false.obs;

  // ======================================================
  // IMAGE PICKER
  // ======================================================

  final ImagePicker picker = ImagePicker();

  // ======================================================
  // PROPERTY IMAGES
  // ======================================================

  final RxList<XFile> selectedImages = <XFile>[].obs;

  // ======================================================
  // OWNERSHIP DOCUMENT
  // ======================================================

  final Rxn<XFile> ownershipDocumentImage = Rxn<XFile>();

  // ======================================================
  // PAYMENT
  // ======================================================

  final transactionReferenceController = TextEditingController();

  final Rxn<XFile> paymentProofImage = Rxn<XFile>();

  // ======================================================
  // SUBMIT STATE
  // ======================================================

  final RxBool isSubmitting = false.obs;

  final PropertyService propertyService = PropertyService();

  // ======================================================
  // PROPERTY IMAGES
  // ======================================================

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      selectedImages.addAll(images);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // ======================================================
  // OWNERSHIP DOCUMENT
  // ======================================================

  Future<void> pickOwnershipDocumentImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ownershipDocumentImage.value = image;
    }
  }

  void removeOwnershipDocumentImage() {
    ownershipDocumentImage.value = null;
  }

  // ======================================================
  // PAYMENT PROOF
  // ======================================================

  Future<void> pickPaymentProofImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      paymentProofImage.value = image;
    }
  }

  void removePaymentProofImage() {
    paymentProofImage.value = null;
  }

  // ======================================================
  // PROPERTY TYPE
  // ======================================================

  String getPropertyType() {
    switch (selectIndex.value) {
      case 0:
        return 'house';

      case 1:
        return 'apartment';

      case 2:
        return 'room';

      default:
        throw Exception('Property type is not selected');
    }
  }

  // ======================================================
  // PAYMENT AMOUNT
  // ======================================================

  double getPaymentAmount() {
    switch (selectIndex.value) {
      case 0:
        return 50.0; // House

      case 1:
        return 40.0; // Apartment

      case 2:
        return 30.0; // Room

      default:
        return 0.0;
    }
  }

  // ======================================================
  // FACILITIES MAP
  // ======================================================

  Map<String, bool> getFacilities() {
    return {
      'wifi': wifi.value,
      'parking': parking.value,
      'air_conditioning': airConditioning.value,
      'pet_allowed': petAllowed.value,
      'balcony': balcony.value,
      'kitchen': kitchen.value,
      'swimming_pool': swimmingPool.value,
      'elevator': elevator.value,
    };
  }

  // ======================================================
  // STEP 2 VALIDATION
  // ======================================================

  bool validateStep2() {
    // PROPERTY TYPE
    if (selectIndex.value == null) {
      showValidationMessage(
        'Missing Property Type',
        'Please select a property type.',
      );

      return false;
    }

    // NAME
    if (nameController.text.trim().isEmpty) {
      showValidationMessage('Missing Name', 'Please enter the property name.');

      return false;
    }

    // SIZE
    if (sizeController.text.trim().isEmpty) {
      showValidationMessage('Missing Size', 'Please enter the property size.');

      return false;
    }

    final double? size = double.tryParse(sizeController.text.trim());

    if (size == null || size <= 0) {
      showValidationMessage(
        'Invalid Size',
        'Please enter a valid property size.',
      );

      return false;
    }

    // LOCATION
    if (address.value == null ||
        address.value!.trim().isEmpty ||
        latitude.value == null ||
        longitude.value == null) {
      showValidationMessage(
        'Missing Location',
        'Please select the property location.',
      );

      return false;
    }

    // PRICE
    if (priceController.text.trim().isEmpty) {
      showValidationMessage('Missing Price', 'Please enter the rent price.');

      return false;
    }

    final double? price = double.tryParse(priceController.text.trim());

    if (price == null || price <= 0) {
      showValidationMessage(
        'Invalid Price',
        'Please enter a valid rent price.',
      );

      return false;
    }

    // DESCRIPTION
    if (descriptionController.text.trim().isEmpty) {
      showValidationMessage(
        'Missing Description',
        'Please enter a property description.',
      );

      return false;
    }

    // STATUS
    if (status.value == null || status.value!.isEmpty) {
      showValidationMessage(
        'Missing Status',
        'Please select the rental status.',
      );

      return false;
    }

    if (status.value != 'available' && status.value != 'rented') {
      showValidationMessage(
        'Invalid Status',
        'Please select a valid rental status.',
      );

      return false;
    }

    // CONTACT
    if (contactController.text.trim().isEmpty) {
      showValidationMessage(
        'Missing Contact',
        'Please enter a contact number.',
      );

      return false;
    }

    // ==================================================
    // TYPE-SPECIFIC VALIDATION
    // ==================================================

    final String propertyType = getPropertyType();

    // HOUSE
    if (propertyType == 'house') {
      if (houseBathrooms.value < 1) {
        showValidationMessage(
          'Invalid Bathrooms',
          'House must have at least one bathroom.',
        );

        return false;
      }

      if (houseTotalFloor.value < 1) {
        showValidationMessage(
          'Invalid Floors',
          'House must have at least one floor.',
        );

        return false;
      }
    }

    // APARTMENT
    if (propertyType == 'apartment') {
      if (apartmentBathrooms.value < 1) {
        showValidationMessage(
          'Invalid Bathrooms',
          'Apartment must have at least one bathroom.',
        );

        return false;
      }

      if (apartmentTotalFloor.value < 1) {
        showValidationMessage(
          'Invalid Floors',
          'Apartment must have at least one floor.',
        );

        return false;
      }

      if (apartmentAvailableFloors.isEmpty) {
        showValidationMessage(
          'Missing Available Floor',
          'Please select at least one available floor.',
        );

        return false;
      }

      final bool hasInvalidFloor = apartmentAvailableFloors.any(
        (floor) => floor < 1 || floor > apartmentTotalFloor.value,
      );

      if (hasInvalidFloor) {
        showValidationMessage(
          'Invalid Available Floor',
          'An available floor cannot be higher than the total floors.',
        );

        return false;
      }
    }

    // ROOM
    if (propertyType == 'room') {
      if (roomTotalFloor.value < 1) {
        showValidationMessage(
          'Invalid Floors',
          'Total floors must be at least 1.',
        );

        return false;
      }

      if (roomAvailableFloors.isEmpty) {
        showValidationMessage(
          'Missing Available Floor',
          'Please select at least one available floor.',
        );

        return false;
      }

      final bool hasInvalidFloor = roomAvailableFloors.any(
        (floor) => floor < 1 || floor > roomTotalFloor.value,
      );

      if (hasInvalidFloor) {
        showValidationMessage(
          'Invalid Available Floor',
          'An available floor cannot be higher than the total floors.',
        );

        return false;
      }
    }

    // PROPERTY IMAGES
    if (selectedImages.isEmpty) {
      showValidationMessage(
        'Missing Images',
        'Please select at least one property image.',
      );

      return false;
    }

    // OWNERSHIP DOCUMENT
    if (ownershipDocumentImage.value == null) {
      showValidationMessage(
        'Missing Document',
        'Please upload the ownership document.',
      );

      return false;
    }

    return true;
  }

  // ======================================================
  // PAYMENT VALIDATION
  // ======================================================

  bool validatePaymentStep() {
    if (paymentProofImage.value == null) {
      showValidationMessage(
        'Missing Payment Proof',
        'Please upload your payment proof.',
      );

      return false;
    }

    return true;
  }

  // ======================================================
  // VALIDATION MESSAGE
  // ======================================================

  void showValidationMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 2),
    );
  }

  // ======================================================
  // SUBMIT PROPERTY
  // ======================================================

  Future<bool> submitProperty() async {
    try {
      // Prevent double submission
      if (isSubmitting.value) {
        return false;
      }

      // Recheck property information
      if (!validateStep2()) {
        return false;
      }

      // Check payment proof
      if (!validatePaymentStep()) {
        return false;
      }

      final String propertyType = getPropertyType();

      final double size = double.parse(sizeController.text.trim());

      final double price = double.parse(priceController.text.trim());

      // Payment amount is automatically selected
      // based on the property type.
      final double paymentAmount = getPaymentAmount();

      // ==================================================
      // TYPE-SPECIFIC DATA
      // ==================================================

      int? bedrooms;
      int? bathrooms;
      int? totalFloor;

      List<int> availableFloors = [];

      // HOUSE
      if (propertyType == 'house') {
        bedrooms = houseBedrooms.value;
        bathrooms = houseBathrooms.value;
        totalFloor = houseTotalFloor.value;
      }

      // APARTMENT
      if (propertyType == 'apartment') {
        bedrooms = apartmentBedrooms.value;
        bathrooms = apartmentBathrooms.value;
        totalFloor = apartmentTotalFloor.value;

        availableFloors = apartmentAvailableFloors.toList()..sort();
      }

      // ROOM
      if (propertyType == 'room') {
        bedrooms = null;
        bathrooms = null;
        totalFloor = roomTotalFloor.value;

        availableFloors = roomAvailableFloors.toList()..sort();
      }

      // ==================================================
      // CONVERT XFILE → FILE
      // ==================================================

      final List<File> propertyImages = selectedImages
          .map((image) => File(image.path))
          .toList();

      final File ownershipDocument = File(ownershipDocumentImage.value!.path);

      final File paymentProof = File(paymentProofImage.value!.path);

      isSubmitting.value = true;

      // ==================================================
      // SEND TO LARAVEL
      // ==================================================

      final response = await propertyService.submitProperty(
        name: nameController.text.trim(),

        propertyType: propertyType,

        size: size,

        price: price,

        description: descriptionController.text.trim(),

        contact: contactController.text.trim(),

        furnished: furnished.value,

        address: address.value!,

        latitude: latitude.value!,

        longitude: longitude.value!,

        bedrooms: bedrooms,

        bathrooms: bathrooms,

        totalFloor: totalFloor,

        rentalStatus: status.value!,

        facilities: getFacilities(),

        availableFloors: availableFloors,

        propertyImages: propertyImages,

        ownershipDocument: ownershipDocument,

        transactionReference: transactionReferenceController.text.trim(),

        paymentProof: paymentProof,
      );

      // ==================================================
      // RESPONSE
      // ==================================================

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          data?['message'] ?? 'Property submitted successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return true;
      }

      Get.snackbar(
        'Submission Failed',
        data?['message'] ?? 'Unable to submit property.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);

      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // ======================================================
  // CLOSE
  // ======================================================

  @override
  void onClose() {
    nameController.dispose();
    sizeController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    contactController.dispose();

    transactionReferenceController.dispose();

    super.onClose();
  }
}
