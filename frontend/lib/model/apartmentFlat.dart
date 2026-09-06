import 'package:final_project/model/property.dart';

class ApartmentFlat extends Property {
  int bedrooms;
  int bathrooms;
  int totalFloor;

  List<int> availableFloors;

  ApartmentFlat({
    super.id,
    required super.name,
    required super.size,
    required super.location,
    required super.price,
    required super.description,
    required super.status,
    required super.contact,
    required super.images,
    required super.nationalIDImage,
    required super.ownerShipImage,
    required super.facilities,
    super.furnished,

    required this.bedrooms,
    required this.bathrooms,
    required this.totalFloor,
    required this.availableFloors,
  });
}
