import 'package:final_project/model/property.dart';
import 'package:final_project/view/renter/propertiesFound_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class FilterScreen extends StatefulWidget {
  final List<Property> properties;

  const FilterScreen({super.key, this.properties = const []});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController searchController = TextEditingController();

  // Full range means no price restriction by default
  double minPrice = 0;
  double maxPrice = 1000;

  final List<String> selectedTypes = [];
  final List<String> selectedFloor = [];
  final List<String> selectedFacilities = [];

  final List<String> types = ['Room', 'Apartment/Flat', 'House'];

  final List<String> floors = ['1 - 3', '4 - 6', '7 - 9', '10 up'];

  final List<String> facilities = [
    'WiFi',
    'Parking',
    'Air Conditioner',
    'Pet allowed',
    'Balcony',
    'Swimming pool',
    'Kitchen',
    'Furnished',
    'Elevator',
  ];

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  void resetFilters() {
    setState(() {
      searchController.clear();

      minPrice = 0;
      maxPrice = 1000;

      selectedTypes.clear();
      selectedFloor.clear();
      selectedFacilities.clear();
    });
  }

  void applyFilter() {
    final List<Property> filteredProperties = widget.properties.where((
      property,
    ) {
      if (!_matchSearch(property)) {
        return false;
      }

      if (!_matchPropertyType(property)) {
        return false;
      }

      if (!_matchPrice(property)) {
        return false;
      }

      if (!_matchFloor(property)) {
        return false;
      }

      if (!_matchFacilities(property)) {
        return false;
      }

      return true;
    }).toList();

    Get.to(
      () => const PropertiesfoundScreen(),
      arguments: {
        "properties": filteredProperties,
        "search": searchController.text.trim(),
      },
    );
  }

  bool _matchSearch(Property property) {
    final String searchText = searchController.text.trim().toLowerCase();

    // Empty search means every property name is allowed
    if (searchText.isEmpty) {
      return true;
    }

    return property.name.toLowerCase().contains(searchText);
  }

  bool _matchPropertyType(Property property) {
    // No selected type means every property type is allowed
    if (selectedTypes.isEmpty) {
      return true;
    }

    final String propertyType = _getPropertyType(property);

    for (final String selectedType in selectedTypes) {
      if (selectedType == 'Room' && propertyType == 'room') {
        return true;
      }

      if (selectedType == 'Apartment/Flat' && propertyType == 'apartment') {
        return true;
      }

      if (selectedType == 'House' && propertyType == 'house') {
        return true;
      }
    }

    return false;
  }

  bool _matchPrice(Property property) {
    return property.price >= minPrice && property.price <= maxPrice;
  }

  bool _matchFloor(Property property) {
    // No floor selected means floor does not restrict results
    if (selectedFloor.isEmpty) {
      return true;
    }

    final List<int> availableFloors = _getAvailableFloors(property);

    // Property has no available floor data
    if (availableFloors.isEmpty) {
      return false;
    }

    for (final int floor in availableFloors) {
      for (final String selectedRange in selectedFloor) {
        if (_floorMatchesRange(floor, selectedRange)) {
          return true;
        }
      }
    }

    return false;
  }

  bool _floorMatchesRange(int floor, String range) {
    switch (range) {
      case '1 - 3':
        return floor >= 1 && floor <= 3;

      case '4 - 6':
        return floor >= 4 && floor <= 6;

      case '7 - 9':
        return floor >= 7 && floor <= 9;

      case '10 up':
        return floor >= 10;

      default:
        return false;
    }
  }

  bool _matchFacilities(Property property) {
    // No selected facilities means facility does not restrict results
    if (selectedFacilities.isEmpty) {
      return true;
    }

    // Facilities use AND logic.
    // Property must have every selected facility.
    for (final String facility in selectedFacilities) {
      if (facility == 'Furnished') {
        if (!_isFurnished(property)) {
          return false;
        }

        continue;
      }

      if (!_hasFacility(property, facility)) {
        return false;
      }
    }

    return true;
  }

  String _getPropertyType(Property property) {
    dynamic dynamicProperty = property;

    // Try propertyType field first
    try {
      final dynamic value = dynamicProperty.propertyType;

      if (value != null) {
        final String type = value.toString().toLowerCase();

        if (type.contains('apartment') || type.contains('flat')) {
          return 'apartment';
        }

        if (type.contains('house')) {
          return 'house';
        }

        if (type.contains('room')) {
          return 'room';
        }
      }
    } catch (_) {}

    // Fallback to Dart class name
    final String runtimeType = property.runtimeType.toString().toLowerCase();

    if (runtimeType.contains('apartment') || runtimeType.contains('flat')) {
      return 'apartment';
    }

    if (runtimeType.contains('house')) {
      return 'house';
    }

    if (runtimeType.contains('room')) {
      return 'room';
    }

    return '';
  }

  List<int> _getAvailableFloors(Property property) {
    final List<int> floors = [];

    dynamic dynamicProperty = property;

    try {
      final dynamic rawFloors = dynamicProperty.availableFloors;

      if (rawFloors is List) {
        for (final dynamic item in rawFloors) {
          if (item is int) {
            floors.add(item);

            continue;
          }

          if (item is num) {
            floors.add(item.toInt());

            continue;
          }

          if (item is Map) {
            final dynamic value = item["floor_number"];

            if (value != null) {
              final int? parsed = int.tryParse(value.toString());

              if (parsed != null) {
                floors.add(parsed);
              }
            }

            continue;
          }

          final int? parsed = int.tryParse(item.toString());

          if (parsed != null) {
            floors.add(parsed);
          }
        }
      }
    } catch (_) {}

    return floors;
  }

  bool _isFurnished(Property property) {
    dynamic dynamicProperty = property;

    try {
      final dynamic value = dynamicProperty.furnished;

      if (value is bool) {
        return value;
      }

      if (value is int) {
        return value == 1;
      }

      final String text = value?.toString().toLowerCase() ?? '';

      return text == 'true' || text == '1';
    } catch (_) {
      return false;
    }
  }

  bool _hasFacility(Property property, String facility) {
    dynamic dynamicProperty = property;

    dynamic propertyFacilities;

    try {
      propertyFacilities = dynamicProperty.facilities;
    } catch (_) {
      return false;
    }

    if (propertyFacilities == null) {
      return false;
    }

    switch (facility) {
      case 'WiFi':
        return _readFacilityValue(propertyFacilities, 'wifi');

      case 'Parking':
        return _readFacilityValue(propertyFacilities, 'parking');

      case 'Air Conditioner':
        return _readFacilityValue(propertyFacilities, 'air_conditioning');

      case 'Pet allowed':
        return _readFacilityValue(propertyFacilities, 'pet_allowed');

      case 'Balcony':
        return _readFacilityValue(propertyFacilities, 'balcony');

      case 'Swimming pool':
        return _readFacilityValue(propertyFacilities, 'swimming_pool');

      case 'Kitchen':
        return _readFacilityValue(propertyFacilities, 'kitchen');

      case 'Elevator':
        return _readFacilityValue(propertyFacilities, 'elevator');

      default:
        return false;
    }
  }

  bool _readFacilityValue(dynamic propertyFacilities, String key) {
    // If facilities are stored as a Map
    if (propertyFacilities is Map) {
      final dynamic value = propertyFacilities[key];

      return _valueToBool(value);
    }

    // If facilities use a Facilities model
    try {
      switch (key) {
        case 'wifi':
          return _valueToBool(propertyFacilities.wifi);

        case 'parking':
          return _valueToBool(propertyFacilities.parking);

        case 'air_conditioning':
          return _valueToBool(propertyFacilities.airConditioning);

        case 'pet_allowed':
          return _valueToBool(propertyFacilities.petAllowed);

        case 'balcony':
          return _valueToBool(propertyFacilities.balcony);

        case 'swimming_pool':
          return _valueToBool(propertyFacilities.swimmingPool);

        case 'kitchen':
          return _valueToBool(propertyFacilities.kitchen);

        case 'elevator':
          return _valueToBool(propertyFacilities.elevator);
      }
    } catch (_) {}

    return false;
  }

  bool _valueToBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    final String text = value?.toString().toLowerCase() ?? '';

    return text == 'true' || text == '1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () { 
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: primaryColor,
          ),
        ),

        title: const Text(
          "Search / Filter",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),

        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Search property name
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(12),

                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: TextFormField(
                      controller: searchController,

                      style: const TextStyle(color: primaryColor, fontSize: 14),

                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: primaryColor),

                        hintText: 'Search Property name....',

                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 14,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  customTitle(title: "Property Type"),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: types.map((type) {
                      final bool isSelected = selectedTypes.contains(type);

                      return customChoiceBox(
                        item: type,

                        isSelected: isSelected,

                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedTypes.remove(type);
                            } else {
                              selectedTypes.add(type);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  customTitle(title: "Price Range"),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              "\$0",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                              ),
                            ),

                            Text(
                              "\$1000",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),

                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryColor,

                            inactiveTrackColor: lightSecondaryColor,

                            trackHeight: 3,

                            thumbColor: primaryColor,

                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),

                            overlayColor: secondaryColor.withOpacity(0.2),

                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                          ),

                          child: RangeSlider(
                            values: RangeValues(minPrice, maxPrice),

                            min: 0,
                            max: 1000,
                            divisions: 20,

                            onChanged: (values) {
                              setState(() {
                                minPrice = values.start;

                                maxPrice = values.end;
                              });
                            },
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(child: priceBox("\$${minPrice.toInt()}")),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),

                              child: Text(
                                "-",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            Expanded(child: priceBox("\$${maxPrice.toInt()}")),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  customTitle(title: "Floor Level"),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: floors.map((floor) {
                      final bool isSelected = selectedFloor.contains(floor);

                      return customChoiceBox(
                        item: floor,

                        isSelected: isSelected,

                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedFloor.remove(floor);
                            } else {
                              selectedFloor.add(floor);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  customTitle(title: "Facilities"),

                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: facilities.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 3.2,
                        ),

                    itemBuilder: (context, index) {
                      final String facility = facilities[index];

                      final bool isSelected = selectedFacilities.contains(
                        facility,
                      );

                      return facilityBox(
                        item: facility,

                        icon: facilityIcon(facility),

                        isSelected: isSelected,

                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedFacilities.remove(facility);
                            } else {
                              selectedFacilities.add(facility);
                            }
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),

            decoration: BoxDecoration(
              color: backgroundColor,

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),

            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,

                    child: OutlinedButton(
                      onPressed: resetFilters,

                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryColor, width: 1.5),

                        foregroundColor: primaryColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,

                  child: SizedBox(
                    height: 50,

                    child: ElevatedButton(
                      onPressed: applyFilter,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,

                        foregroundColor: Colors.white,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget customTitle({required String title}) {
  return Text(
    title,

    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: primaryColor,
    ),
  );
}

Widget customChoiceBox({
  required String item,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,

    borderRadius: BorderRadius.circular(12),

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),

      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),

      decoration: BoxDecoration(
        color: isSelected ? lightSecondaryColor : Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Text(
        item,

        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,

          color: isSelected ? primaryColor : Colors.black87,
        ),
      ),
    ),
  );
}

Widget priceBox(String value) {
  return Container(
    height: 45,

    alignment: Alignment.center,

    decoration: BoxDecoration(
      color: lightSecondaryColor,

      borderRadius: BorderRadius.circular(10),

      border: Border.all(color: secondaryColor),
    ),

    child: Text(
      value,

      style: const TextStyle(
        color: primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

Widget facilityBox({
  required String item,
  required IconData icon,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,

    borderRadius: BorderRadius.circular(12),

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: BoxDecoration(
        color: isSelected ? lightSecondaryColor : Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: isSelected ? primaryColor : Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 19,

            color: isSelected ? primaryColor : primaryColor.withOpacity(0.65),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              item,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,

                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

IconData facilityIcon(String facility) {
  switch (facility) {
    case "WiFi":
      return Icons.wifi_rounded;

    case "Parking":
      return Icons.local_parking_outlined;

    case "Air Conditioner":
      return Icons.ac_unit;

    case "Pet allowed":
      return Icons.pets_outlined;

    case "Balcony":
      return Icons.balcony_outlined;

    case "Swimming pool":
      return Icons.pool_outlined;

    case "Kitchen":
      return Icons.kitchen_outlined;

    case "Furnished":
      return Icons.chair_outlined;

    case "Elevator":
      return Icons.elevator_outlined;

    default:
      return Icons.check_circle_outline;
  }
}
