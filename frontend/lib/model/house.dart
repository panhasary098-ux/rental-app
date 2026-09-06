import 'package:final_project/model/property.dart';

class House extends Property {
  int bedrooms;
  int bathrooms;
  int totalFloor;

  House({
    super.id,
    required super.name,
    required super.size,
    required super.location,
    required super.price,
    required super.description,
    required super.status,
    required super.contact,
    required super.images,
    required super.facilities,
    super.furnished,

    required this.bedrooms,
    required this.bathrooms,
    required this.totalFloor,
  });
}