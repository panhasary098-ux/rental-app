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
    required this.nationalIDImage,
    required this.ownerShipImage,
    required this.facilities,
    this.furnished = false,
  });
}

final List<Property> properties = [
  // 1. House
  House(
    id: 1,
    name: "Modern Family House",
    size: 180.0,
    location: PropertyLocation(
      address: "Sen Sok, Phnom Penh",
      latitude: 11.5876,
      longitude: 104.8862,
    ),
    price: 850.0,
    description: "Spacious modern house in a quiet neighborhood.",
    status: "Available now",
    contact: "012345678",
    images: [
      "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
      "https://i.pinimg.com/1200x/cb/0b/5b/cb0b5b2810179b9c1260648cd9230304.jpg",
    ],

    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",

    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      petAllowed: true,
      balcony: true,
      kitchen: true,
      swimmingPool: false,
      elevator: false,
    ),
    furnished: true,
    bedrooms: 4,
    bathrooms: 3,
    totalFloor: 2,
  ),

  // 2. Room
  Room(
    id: 2,
    name: "Cozy Room Toul Kork",
    size: 25.0,
    location: PropertyLocation(
      address: "Toul Kork, Phnom Penh",
      latitude: 11.5783,
      longitude: 104.8987,
    ),
    price: 150.0,
    description: "Affordable room suitable for students.",
    status: "Available now",
    contact: "098765432",
    images: [
      "https://i.pinimg.com/736x/13/61/de/1361deb9f2833ca90045fdee3a8bff8d.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      kitchen: false,
      balcony: false,
    ),
    furnished: true,
    totalFloor: 4,
    availableFloors: [1, 2, 4],
  ),

  // 3. Apartment
  ApartmentFlat(
    id: 3,
    name: "BKK1 City Apartment",
    size: 75.0,
    location: PropertyLocation(
      address: "BKK1, Phnom Penh",
      latitude: 11.5504,
      longitude: 104.9282,
    ),
    price: 550.0,
    description: "Modern apartment close to restaurants and cafes.",
    status: "Available in 15 days",
    contact: "011223344",
    images: [
      "https://i.pinimg.com/1200x/6a/17/d3/6a17d3982fe119f3c1110a65417fc5dc.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",

    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      balcony: true,
      kitchen: true,
      swimmingPool: true,
      elevator: true,
    ),
    furnished: true,
    bedrooms: 2,
    bathrooms: 2,
    totalFloor: 12,
    availableFloors: [3, 6, 8],
  ),

  // 4. Apartment
  ApartmentFlat(
    id: 4,
    name: "Riverside Apartment",
    size: 90.0,
    location: PropertyLocation(
      address: "Riverside, Phnom Penh",
      latitude: 11.5690,
      longitude: 104.9308,
    ),
    price: 700.0,
    description: "Apartment with a beautiful river view.",
    status: "Available now",
    contact: "097112233",
    images: [
      "https://i.pinimg.com/1200x/f5/b5/23/f5b52328776ad50ad5842bdecf853bdb.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      balcony: true,
      kitchen: true,
      swimmingPool: true,
      elevator: true,
    ),
    furnished: false,
    bedrooms: 3,
    bathrooms: 2,
    totalFloor: 15,
    availableFloors: [5, 9, 12],
  ),

  // 5. House
  House(
    id: 5,
    name: "Villa Sen Sok",
    size: 250.0,
    location: PropertyLocation(
      address: "Sen Sok, Phnom Penh",
      latitude: 11.5982,
      longitude: 104.8814,
    ),
    price: 1200.0,
    description: "Large villa with private parking and garden.",
    status: "Available in 1 month",
    contact: "010556677",
    images: [
      "https://i.pinimg.com/736x/92/0e/59/920e59c3ae27b635ee75a20d17d79864.jpg",
      "https://i.pinimg.com/736x/0f/d3/42/0fd3425d2b92ccb9dafbf70a5a49d964.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      petAllowed: true,
      balcony: true,
      kitchen: true,
      swimmingPool: true,
    ),
    furnished: true,
    bedrooms: 5,
    bathrooms: 4,
    totalFloor: 3,
  ),

  // 6. Room
  Room(
    id: 6,
    name: "Budget Room Near University",
    size: 20.0,
    location: PropertyLocation(
      address: "Russian Federation Blvd, Phnom Penh",
      latitude: 11.5665,
      longitude: 104.8901,
    ),
    price: 100.0,
    description: "Simple and affordable room near university.",
    status: "Available now",
    contact: "096334455",
    images: [
      "https://i.pinimg.com/1200x/33/bc/54/33bc54d67db0899605a57439fe03a5ba.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: false,
      airConditioning: true,
      kitchen: false,
    ),
    furnished: false,
    totalFloor: 3,
    availableFloors: [2, 3],
  ),

  // 7. House
  House(
    id: 7,
    name: "Green Garden House",
    size: 160.0,
    location: PropertyLocation(
      address: "Chroy Changvar, Phnom Penh",
      latitude: 11.5877,
      longitude: 104.9483,
    ),
    price: 650.0,
    description: "Comfortable family house with a garden.",
    status: "Available in 7 days",
    contact: "015778899",
    images: [
      "https://i.pinimg.com/736x/86/89/e1/8689e109a09f53d97cb91369c4217bd5.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      petAllowed: true,
      balcony: true,
      kitchen: true,
    ),
    furnished: false,
    bedrooms: 3,
    bathrooms: 2,
    totalFloor: 2,
  ),

  // 8. Apartment
  ApartmentFlat(
    id: 8,
    name: "Toul Kork Luxury Apartment",
    size: 110.0,
    location: PropertyLocation(
      address: "Toul Kork, Phnom Penh",
      latitude: 11.5835,
      longitude: 104.8985,
    ),
    price: 900.0,
    description: "Luxury apartment with modern facilities.",
    status: "Available now",
    contact: "093445566",
    images: [
      "https://i.pinimg.com/1200x/50/3e/83/503e838a83d1f2bcdd499b9814b2050e.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      balcony: true,
      kitchen: true,
      swimmingPool: true,
      elevator: true,
    ),
    furnished: true,
    bedrooms: 3,
    bathrooms: 3,
    totalFloor: 20,
    availableFloors: [4, 10, 17],
  ),

  // 9. Room
  Room(
    id: 9,
    name: "Private Room BKK3",
    size: 30.0,
    location: PropertyLocation(
      address: "BKK3, Phnom Penh",
      latitude: 11.5455,
      longitude: 104.9158,
    ),
    price: 200.0,
    description: "Clean private room in a convenient location.",
    status: "Available in 2 weeks",
    contact: "088667788",
    images: [
      "https://i.pinimg.com/1200x/26/10/70/261070a7a4519aebd064e35ba16a10ad.jpg",
    ],
    nationalIDImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    ownerShipImage:
        "https://i.pinimg.com/736x/cb/32/a4/cb32a4cb991b33bb126fd1d1b5b3ddd4.jpg",
    facilities: Facilities(
      wifi: true,
      parking: true,
      airConditioning: true,
      balcony: true,
      kitchen: true,
    ),
    furnished: true,
    totalFloor: 5,
    availableFloors: [1, 3, 5],
  ),
];
