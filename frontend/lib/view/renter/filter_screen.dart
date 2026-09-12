import 'package:final_project/view/renter/propertiesFound_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double minPrice = 50;
  double maxPrice = 500;

  final List<String> selectedTypes = [];
  final List<String> selectedDistance = [];
  final List<String> selectedFloor = [];
  final List<String> selectedFacilities = [];

  final List<String> types = ['Room', 'Apartment', 'House', 'Flat'];

  final List<String> distances = ['1Km', '3km', '5km', '7km', '10km'];

  final List<String> facilities = [
    'Parking',
    'Air Conditioner',
    'Pet allowed',
    'Balcony',
    'Swimming pool',
    'Kitchen',
    'Furnished',
    'Elevator',
  ];

  final List<String> floors = ['G - 3', '4 - 6', '7 - 9', '10 up'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================================================
      // APP BAR
      // ======================================================
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
                  // ======================================================
                  // SEARCH
                  // ======================================================
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

                  // ======================================================
                  // PROPERTY TYPE
                  // ======================================================
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

                  // ======================================================
                  // PRICE RANGE
                  // ======================================================
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: const [
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

                        // ==================================================
                        // RANGE SLIDER
                        // ==================================================
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

                        // ==================================================
                        // MIN + MAX PRICE
                        // ==================================================
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

                  // ======================================================
                  // DISTANCE
                  // ======================================================
                  customTitle(title: "Distance"),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,

                    children: distances.map((distance) {
                      final bool isSelected = selectedDistance.contains(
                        distance,
                      );

                      return customChoiceBox(
                        item: distance,
                        isSelected: isSelected,

                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              selectedDistance.remove(distance);
                            } else {
                              selectedDistance.add(distance);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // ======================================================
                  // FLOOR
                  // ======================================================
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

                  // ======================================================
                  // FACILITIES
                  // ======================================================
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

          // ======================================================
          // BOTTOM BUTTONS
          // ======================================================
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
                // ==================================================
                // RESET BUTTON
                // ==================================================
                Expanded(
                  child: SizedBox(
                    height: 50,

                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          minPrice = 50;
                          maxPrice = 500;

                          selectedTypes.clear();
                          selectedDistance.clear();
                          selectedFloor.clear();
                          selectedFacilities.clear();
                        });
                      },

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

                // ==================================================
                // APPLY FILTER BUTTON
                // ==================================================
                Expanded(
                  child: SizedBox(
                    height: 50,

                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const PropertiesfoundScreen());
                      },

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

// ======================================================
// SECTION TITLE
// ======================================================

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

// ======================================================
// CHOICE BOX
// ======================================================

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

// ======================================================
// PRICE BOX
// ======================================================

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

// ======================================================
// FACILITY BOX
// ======================================================

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

// ======================================================
// FACILITY ICON
// ======================================================

IconData facilityIcon(String facility) {
  switch (facility) {
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
