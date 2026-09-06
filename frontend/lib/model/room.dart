import 'package:final_project/model/property.dart';

class Room extends Property {
  int totalFloor;

  List<int> availableFloors;

  Room({
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

    required this.totalFloor,
    required this.availableFloors,
  });
}
