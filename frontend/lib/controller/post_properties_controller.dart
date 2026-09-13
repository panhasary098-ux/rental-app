import 'dart:convert';
import 'dart:io';

import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostPropertyController extends GetxController {
  final RxBool isEditMode = false.obs;

  final RxnInt editingPropertyId = RxnInt();

  final RxnString originalVerificationStatus = RxnString();

  final RxnInt selectIndex = RxnInt();
  final RxInt currentStep = 1.obs;

  final nameController = TextEditingController();
  final sizeController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactController = TextEditingController();

  final RxnString status = RxnString();

  final RxBool furnished = false.obs;

  final RxnString address = RxnString();
  final RxnDouble latitude = RxnDouble();
  final RxnDouble longitude = RxnDouble();

  final RxInt houseBedrooms = 0.obs;
  final RxInt houseBathrooms = 1.obs;
  final RxInt houseTotalFloor = 1.obs;

  final RxInt apartmentBedrooms = 0.obs;
  final RxInt apartmentBathrooms = 1.obs;
  final RxInt apartmentTotalFloor = 1.obs;

  final RxList<int> apartmentAvailableFloors = <int>[].obs;

  final RxInt roomTotalFloor = 1.obs;

  final RxList<int> roomAvailableFloors = <int>[].obs;

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

  final RxList<String> existingImagePaths = <String>[].obs;

  final Rxn<XFile> ownershipDocumentImage = Rxn<XFile>();

  final RxBool hasExistingOwnershipDocument = false.obs;

  final transactionReferenceController = TextEditingController();

  final Rxn<XFile> paymentProofImage = Rxn<XFile>();

  final RxBool isSubmitting = false.obs;

  final PropertyService propertyService = PropertyService();

  void loadPropertyForEdit(Map<String, dynamic> property) {
    isEditMode.value = true;

    editingPropertyId.value = _toInt(property["id"]);

    originalVerificationStatus.value = property["verification_status"]
        ?.toString();

    final String propertyType = (property["property_type"] ?? "")
        .toString()
        .toLowerCase();

    switch (propertyType) {
      case "house":
        selectIndex.value = 0;
        break;

      case "apartment":
        selectIndex.value = 1;
        break;

      case "room":
        selectIndex.value = 2;
        break;

      default:
        selectIndex.value = null;
    }

    currentStep.value = 2;

    nameController.text = property["name"]?.toString() ?? "";

    sizeController.text = _numberToText(property["size"]);

    priceController.text = _numberToText(property["price"]);

    descriptionController.text = property["description"]?.toString() ?? "";

    contactController.text = property["contact"]?.toString() ?? "";

    status.value = property["rental_status"]?.toString();

    furnished.value = _toBool(property["furnished"]);

    address.value = property["address"]?.toString();

    latitude.value = _toDouble(property["latitude"]);

    longitude.value = _toDouble(property["longitude"]);

    final int bedrooms = _toInt(property["bedrooms"]) ?? 0;

    final int bathrooms = _toInt(property["bathrooms"]) ?? 1;

    final int totalFloor = _toInt(property["total_floor"]) ?? 1;

    if (propertyType == "house") {
      houseBedrooms.value = bedrooms;
      houseBathrooms.value = bathrooms;
      houseTotalFloor.value = totalFloor;
    }

    if (propertyType == "apartment") {
      apartmentBedrooms.value = bedrooms;
      apartmentBathrooms.value = bathrooms;
      apartmentTotalFloor.value = totalFloor;
    }

    if (propertyType == "room") {
      roomTotalFloor.value = totalFloor;
    }

    apartmentAvailableFloors.clear();
    roomAvailableFloors.clear();

    final dynamic rawFloors =
        property["available_floors"] ?? property["availableFloors"];

    final List<int> floors = _extractAvailableFloors(rawFloors);

    if (propertyType == "apartment") {
      apartmentAvailableFloors.assignAll(floors);
    }

    if (propertyType == "room") {
      roomAvailableFloors.assignAll(floors);
    }

    final dynamic rawFacilities = property["facilities"];

    if (rawFacilities is Map) {
      wifi.value = _toBool(rawFacilities["wifi"]);

      parking.value = _toBool(rawFacilities["parking"]);

      airConditioning.value = _toBool(rawFacilities["air_conditioning"]);

      petAllowed.value = _toBool(rawFacilities["pet_allowed"]);

      balcony.value = _toBool(rawFacilities["balcony"]);

      kitchen.value = _toBool(rawFacilities["kitchen"]);

      swimmingPool.value = _toBool(rawFacilities["swimming_pool"]);

      elevator.value = _toBool(rawFacilities["elevator"]);
    }

    selectedImages.clear();
    existingImagePaths.clear();

    final dynamic rawImages = property["images"];

    if (rawImages is List) {
      for (final image in rawImages) {
        if (image is Map) {
          final dynamic path = image["image_path"];

          if (path != null && path.toString().isNotEmpty) {
            existingImagePaths.add(path.toString());
          }
        }
      }
    }

    ownershipDocumentImage.value = null;

    hasExistingOwnershipDocument.value = true;

    transactionReferenceController.clear();

    paymentProofImage.value = null;
  }

  void resetForCreateMode() {
    isEditMode.value = false;
    editingPropertyId.value = null;
    originalVerificationStatus.value = null;

    currentStep.value = 1;
    selectIndex.value = null;

    nameController.clear();
    sizeController.clear();
    priceController.clear();
    descriptionController.clear();
    contactController.clear();

    status.value = null;
    furnished.value = false;

    address.value = null;
    latitude.value = null;
    longitude.value = null;

    houseBedrooms.value = 0;
    houseBathrooms.value = 1;
    houseTotalFloor.value = 1;

    apartmentBedrooms.value = 0;
    apartmentBathrooms.value = 1;
    apartmentTotalFloor.value = 1;
    apartmentAvailableFloors.clear();

    roomTotalFloor.value = 1;
    roomAvailableFloors.clear();

    wifi.value = false;
    parking.value = false;
    airConditioning.value = false;
    petAllowed.value = false;
    balcony.value = false;
    kitchen.value = false;
    swimmingPool.value = false;
    elevator.value = false;

    selectedImages.clear();
    existingImagePaths.clear();

    ownershipDocumentImage.value = null;
    hasExistingOwnershipDocument.value = false;

    transactionReferenceController.clear();
    paymentProofImage.value = null;
  }

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

  Future<void> pickOwnershipDocumentImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ownershipDocumentImage.value = image;
    }
  }

  void removeOwnershipDocumentImage() {
    ownershipDocumentImage.value = null;
  }

  Future<void> pickPaymentProofImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      paymentProofImage.value = image;
    }
  }

  void removePaymentProofImage() {
    paymentProofImage.value = null;
  }

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

  bool validateStep2() {
    if (selectIndex.value == null) {
      showValidationMessage(
        'Missing Property Type',
        'Please select a property type.',
      );

      return false;
    }

    if (nameController.text.trim().isEmpty) {
      showValidationMessage('Missing Name', 'Please enter the property name.');

      return false;
    }

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

    if (descriptionController.text.trim().isEmpty) {
      showValidationMessage(
        'Missing Description',
        'Please enter a property description.',
      );

      return false;
    }

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

    if (contactController.text.trim().isEmpty) {
      showValidationMessage(
        'Missing Contact',
        'Please enter a contact number.',
      );

      return false;
    }

    final String propertyType = getPropertyType();

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

    if (isEditMode.value) {
      if (selectedImages.isEmpty && existingImagePaths.isEmpty) {
        showValidationMessage(
          'Missing Images',
          'Please select at least one property image.',
        );

        return false;
      }
    } else {
      if (selectedImages.isEmpty) {
        showValidationMessage(
          'Missing Images',
          'Please select at least one property image.',
        );

        return false;
      }
    }

    if (isEditMode.value) {
      if (ownershipDocumentImage.value == null &&
          !hasExistingOwnershipDocument.value) {
        showValidationMessage(
          'Missing Document',
          'Please upload the ownership document.',
        );

        return false;
      }
    } else {
      if (ownershipDocumentImage.value == null) {
        showValidationMessage(
          'Missing Document',
          'Please upload the ownership document.',
        );

        return false;
      }
    }

    return true;
  }

  bool validatePaymentStep() {
    if (isEditMode.value) {
      return true;
    }

    if (paymentProofImage.value == null) {
      showValidationMessage(
        'Missing Payment Proof',
        'Please upload your payment proof.',
      );

      return false;
    }

    return true;
  }

  void showValidationMessage(String title, String message) {
    Get.snackbar(
      title,
      message,

      snackPosition: SnackPosition.BOTTOM,

      backgroundColor: Colors.white,

      colorText: const Color(0xFF111827),

      margin: const EdgeInsets.all(15),

      borderRadius: 12,

      duration: const Duration(seconds: 2),
    );
  }

  Map<String, dynamic> getTypeSpecificData() {
    final String propertyType = getPropertyType();

    int? bedrooms;
    int? bathrooms;
    int totalFloor;

    List<int> availableFloors = [];

    if (propertyType == 'house') {
      bedrooms = houseBedrooms.value;

      bathrooms = houseBathrooms.value;

      totalFloor = houseTotalFloor.value;
    } else if (propertyType == 'apartment') {
      bedrooms = apartmentBedrooms.value;

      bathrooms = apartmentBathrooms.value;

      totalFloor = apartmentTotalFloor.value;

      availableFloors = apartmentAvailableFloors.toList()..sort();
    } else {
      bedrooms = null;
      bathrooms = null;

      totalFloor = roomTotalFloor.value;

      availableFloors = roomAvailableFloors.toList()..sort();
    }

    return {
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "totalFloor": totalFloor,
      "availableFloors": availableFloors,
    };
  }

  Future<bool> submitProperty() async {
    try {
      if (isSubmitting.value) {
        return false;
      }

      if (isEditMode.value) {
        showValidationMessage(
          'Edit Mode',
          'Use Save Changes when editing a property.',
        );

        return false;
      }

      if (!validateStep2()) {
        return false;
      }

      if (!validatePaymentStep()) {
        return false;
      }

      final String propertyType = getPropertyType();

      final double size = double.parse(sizeController.text.trim());

      final double price = double.parse(priceController.text.trim());

      final typeData = getTypeSpecificData();

      final List<File> propertyImages = selectedImages
          .map((image) => File(image.path))
          .toList();

      final File ownershipDocument = File(ownershipDocumentImage.value!.path);

      final File paymentProof = File(paymentProofImage.value!.path);

      isSubmitting.value = true;

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

        bedrooms: typeData["bedrooms"],

        bathrooms: typeData["bathrooms"],

        totalFloor: typeData["totalFloor"],

        rentalStatus: status.value!,

        facilities: getFacilities(),

        availableFloors: List<int>.from(typeData["availableFloors"]),

        propertyImages: propertyImages,

        ownershipDocument: ownershipDocument,

        transactionReference: transactionReferenceController.text.trim(),

        paymentProof: paymentProof,
      );

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 201) {
        Get.snackbar(
          '',
          '',

          snackPosition: SnackPosition.BOTTOM,

          backgroundColor: Colors.white,

          margin: const EdgeInsets.all(16),

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          borderRadius: 18,

          borderColor: const Color(0xFFE5E7EB),

          borderWidth: 1,

          duration: const Duration(seconds: 3),

          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],

          icon: Container(
            width: 36,
            height: 36,

            decoration: const BoxDecoration(
              color: Color(0xFFE6F0FF),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF03045E),
              size: 20,
            ),
          ),

          titleText: const Text(
            "Property Submitted",

            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          messageText: Text(
            data?['message'] ??
                'Your property has been submitted for admin review.',

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

  Future<bool> updateProperty() async {
    try {
      if (isSubmitting.value) {
        return false;
      }

      if (!isEditMode.value) {
        showValidationMessage(
          'Invalid Action',
          'This property is not in edit mode.',
        );

        return false;
      }

      if (editingPropertyId.value == null) {
        showValidationMessage(
          'Missing Property',
          'Unable to find the property to update.',
        );

        return false;
      }

      if (!validateStep2()) {
        return false;
      }

      final double size = double.parse(sizeController.text.trim());

      final double price = double.parse(priceController.text.trim());

      final typeData = getTypeSpecificData();

      List<File>? newPropertyImages;

      if (selectedImages.isNotEmpty) {
        newPropertyImages = selectedImages
            .map((image) => File(image.path))
            .toList();
      }

      File? newOwnershipDocument;

      if (ownershipDocumentImage.value != null) {
        newOwnershipDocument = File(ownershipDocumentImage.value!.path);
      }

      isSubmitting.value = true;

      final response = await propertyService.updateProperty(
        propertyId: editingPropertyId.value!,

        name: nameController.text.trim(),

        size: size,

        price: price,

        description: descriptionController.text.trim(),

        contact: contactController.text.trim(),

        furnished: furnished.value,

        address: address.value!,

        latitude: latitude.value!,

        longitude: longitude.value!,

        bedrooms: typeData["bedrooms"],

        bathrooms: typeData["bathrooms"],

        totalFloor: typeData["totalFloor"],

        rentalStatus: status.value!,

        facilities: getFacilities(),

        availableFloors: List<int>.from(typeData["availableFloors"]),

        propertyImages: newPropertyImages,

        ownershipDocument: newOwnershipDocument,
      );

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }

      if (response.statusCode == 200 && data?["success"] == true) {
        originalVerificationStatus.value = "pending";

        return true;
      }

      Get.snackbar(
        'Update Failed',
        data?['message'] ?? 'Unable to update property.',
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

  bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final String text = value?.toString().toLowerCase() ?? "";

    return text == "1" || text == "true";
  }

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  String _numberToText(dynamic value) {
    final double? number = _toDouble(value);

    if (number == null) {
      return "";
    }

    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number.toString();
  }

  List<int> _extractAvailableFloors(dynamic rawFloors) {
    final List<int> floors = [];

    if (rawFloors is! List) {
      return floors;
    }

    for (final item in rawFloors) {
      int? floor;

      if (item is Map) {
        floor = _toInt(item["floor_number"]);
      } else {
        floor = _toInt(item);
      }

      if (floor != null) {
        floors.add(floor);
      }
    }

    floors.sort();

    return floors;
  }

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
