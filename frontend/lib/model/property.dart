import 'package:final_project/model/Location.dart';
import 'package:final_project/model/apartmentFlat.dart';
import 'package:final_project/model/facilities.dart';
import 'package:final_project/model/house.dart';
import 'package:final_project/model/room.dart';

class Property {
  int? id;
  String name;
  double size;
  PropertyLocation location;
  double price;
  String description;
  String status;
  String contact;
  List<String> images;

  // These fields existed in the old model.
  // Renter API does not receive private documents.
  String nationalIDImage;
  String ownerShipImage;

  Facilities facilities;
  bool furnished;

  Property({
    this.id,
    required this.name,
    required this.size,
    required this.location,
    required this.price,
    required this.description,
    required this.status,
    required this.contact,
    required this.images,
    this.nationalIDImage = "",
    this.ownerShipImage = "",
    required this.facilities,
    this.furnished = false,
  });

  // Convert Laravel JSON into House, ApartmentFlat or Room
  static Property fromJson(
    Map<String, dynamic> json,
  ) {
    final String propertyType =
        json["property_type"]
                ?.toString()
                .toLowerCase() ??
            "";

    final PropertyLocation location =
        PropertyLocation(
      address: json["address"]?.toString(),

      latitude: _toDouble(
        json["latitude"],
      ),

      longitude: _toDouble(
        json["longitude"],
      ),
    );

    final Facilities facilities =
        _parseFacilities(
      json["facilities"],
    );

    final List<String> images =
        _parseImages(
      json["images"],
    );

    final List<int> availableFloors =
        _parseAvailableFloors(
      json["available_floors"],
    );

    final String rentalStatus =
        _formatRentalStatus(
      json["rental_status"],
    );

    final int id =
        _toInt(
      json["id"],
    );

    final String name =
        json["name"]?.toString() ??
            "Property";

    final double size =
        _toDouble(
      json["size"],
    );

    final double price =
        _toDouble(
      json["price"],
    );

    final String description =
        json["description"]
                ?.toString() ??
            "";

    final String contact =
        json["contact"]
                ?.toString() ??
            "";

    final bool furnished =
        _toBool(
      json["furnished"],
    );

    final int bedrooms =
        _toInt(
      json["bedrooms"],
    );

    final int bathrooms =
        _toInt(
      json["bathrooms"],
    );

    final int totalFloor =
        _toInt(
      json["total_floor"],
    );

    // House
    if (propertyType == "house") {
      return House(
        id: id,
        name: name,
        size: size,
        location: location,
        price: price,
        description: description,
        status: rentalStatus,
        contact: contact,
        images: images,

        // Private documents are not sent to renter
        nationalIDImage: "",
        ownerShipImage: "",

        facilities: facilities,
        furnished: furnished,

        bedrooms: bedrooms,
        bathrooms: bathrooms,
        totalFloor: totalFloor,
      );
    }

    // Apartment
    if (propertyType == "apartment") {
      return ApartmentFlat(
        id: id,
        name: name,
        size: size,
        location: location,
        price: price,
        description: description,
        status: rentalStatus,
        contact: contact,
        images: images,

        // Private documents are not sent to renter
        nationalIDImage: "",
        ownerShipImage: "",

        facilities: facilities,
        furnished: furnished,

        bedrooms: bedrooms,
        bathrooms: bathrooms,
        totalFloor: totalFloor,
        availableFloors: availableFloors,
      );
    }

    // Room
    if (propertyType == "room") {
      return Room(
        id: id,
        name: name,
        size: size,
        location: location,
        price: price,
        description: description,
        status: rentalStatus,
        contact: contact,
        images: images,

        // Private documents are not sent to renter
        nationalIDImage: "",
        ownerShipImage: "",

        facilities: facilities,
        furnished: furnished,

        totalFloor: totalFloor,
        availableFloors: availableFloors,
      );
    }

    // Fallback
    return Property(
      id: id,
      name: name,
      size: size,
      location: location,
      price: price,
      description: description,
      status: rentalStatus,
      contact: contact,
      images: images,
      nationalIDImage: "",
      ownerShipImage: "",
      facilities: facilities,
      furnished: furnished,
    );
  }

  // Parse Laravel image list
  static List<String> _parseImages(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    final List<String> result = [];

    for (final dynamic item in value) {
      if (item is Map) {
        final dynamic imageUrl =
            item["image_url"];

        final dynamic imagePath =
            item["image_path"];

        if (imageUrl != null &&
            imageUrl
                .toString()
                .isNotEmpty) {
          result.add(
            _fixLaravelUrl(
              imageUrl.toString(),
            ),
          );
        } else if (imagePath != null &&
            imagePath
                .toString()
                .isNotEmpty) {
          result.add(
            _buildStorageUrl(
              imagePath.toString(),
            ),
          );
        }
      }
    }

    return result;
  }

  // Parse facilities
  static Facilities _parseFacilities(
    dynamic value,
  ) {
    if (value is! Map) {
      return Facilities();
    }

    return Facilities(
      wifi: _toBool(
        value["wifi"],
      ),

      parking: _toBool(
        value["parking"],
      ),

      airConditioning: _toBool(
        value["air_conditioning"],
      ),

      petAllowed: _toBool(
        value["pet_allowed"],
      ),

      balcony: _toBool(
        value["balcony"],
      ),

      kitchen: _toBool(
        value["kitchen"],
      ),

      swimmingPool: _toBool(
        value["swimming_pool"],
      ),

      elevator: _toBool(
        value["elevator"],
      ),
    );
  }

  // Parse available floors
  static List<int> _parseAvailableFloors(
    dynamic value,
  ) {
    if (value is! List) {
      return [];
    }

    return value
        .map(
          (floor) => _toInt(
            floor,
          ),
        )
        .where(
          (floor) => floor > 0,
        )
        .toList();
  }

  // Convert Laravel available/rented status
  static String _formatRentalStatus(
    dynamic value,
  ) {
    final String status =
        value
            ?.toString()
            .toLowerCase() ??
        "";

    if (status == "rented") {
      return "Rented";
    }

    if (status == "available") {
      return "Available";
    }

    return status.isEmpty
        ? "Available"
        : status;
  }

  // Convert value to int
  static int _toInt(
    dynamic value,
  ) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }

  // Convert value to double
  static double _toDouble(
    dynamic value,
  ) {
    if (value == null) {
      return 0.0;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0.0;
  }

  // Convert value to bool
  static bool _toBool(
    dynamic value,
  ) {
    if (value == true) {
      return true;
    }

    if (value == false ||
        value == null) {
      return false;
    }

    if (value is num) {
      return value == 1;
    }

    final String text =
        value
            .toString()
            .toLowerCase();

    return text == "1" ||
        text == "true";
  }

  // Fix Laravel localhost URL for Android emulator
  static String _fixLaravelUrl(
    String url,
  ) {
    return url
        .replaceFirst(
          "http://localhost:8000",
          "http://10.0.2.2:8000",
        )
        .replaceFirst(
          "http://127.0.0.1:8000",
          "http://10.0.2.2:8000",
        );
  }

  // Build public storage URL
  static String _buildStorageUrl(
    String path,
  ) {
    String cleanPath = path;

    if (cleanPath.startsWith("/")) {
      cleanPath =
          cleanPath.substring(1);
    }

    if (cleanPath.startsWith(
      "storage/",
    )) {
      return "http://10.0.2.2:8000/$cleanPath";
    }

    return "http://10.0.2.2:8000/storage/$cleanPath";
  }
}