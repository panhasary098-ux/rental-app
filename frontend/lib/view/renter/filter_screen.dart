import 'package:final_project/view/renter/propertiesFound_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double minPrice = 50;
  double maxPrice = 500;

  List<String> selectedTypes = [];
  List<String> selectedDistance = [];
  List<String> selectedFloor = [];
  List<String> selectedFacilities = [];

  @override
  Widget build(BuildContext context) {
    List<String> types = ['Room', 'Apartment', 'House', 'Flat'];
    List<String> distances = ['1Km', '3km', '5km', '7km', '10km'];
    List<String> facilities = [
      'Parking',
      'Air Conditioner',
      'Pet allowed',
      'Balcony',
      'Swimming pool',
      'Kitchen',
      'Furnished',
      'Elevator',
    ];
    List<String> floors = ['G - 3', '4-6', '7 - 9', ' 10 up'];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 235, 234),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Search/Filter",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 233, 235, 234),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),

                  hintText: 'Search Property name....',

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            Wrap(
              spacing: 10,
              runSpacing: 10,

              children: types.map((type) {
                final bool isSelected = selectedTypes.contains(type);

                return customhChoiceBox(
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
            SizedBox(height: 20),

            //price range--------------------
            customTitle(title: "Price Range"),
            SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Color(0xFF35B64A),
                inactiveTrackColor: Colors.grey.shade300,
                trackHeight: 3,
                thumbColor: Color(0xFF35B64A),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
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

            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "\$${minPrice.toInt()}",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "\$${maxPrice.toInt()}",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            //distance
            customTitle(title: "Distance"),
            SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: distances.map((distance) {
                final bool isSelected = selectedDistance.contains(distance);

                return customhChoiceBox(
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
            SizedBox(height: 20),

            //floor----------------------------------
            customTitle(title: "Floor"),
            SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: floors.map((floor) {
                final bool isSelected = selectedFloor.contains(floor);

                return customhChoiceBox(
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
            SizedBox(height: 20),

            //Facilities-----------------------------
            customTitle(title: "Facilities"),
            SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: facilities.map((facility) {
                final bool isSelected = selectedFacilities.contains(facility);

                return customhChoiceBox(
                  item: facility,
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
              }).toList(),
            ),

            Spacer(),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF35B64A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Get.to(() => PropertiesfoundScreen());
                },
                child: Text(
                  "Show Result",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget customTitle({required String title}) {
  return Text(
    "$title",
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w900,
      //color: Colors.orangeAccent,
      //color: Colors.black,
      color: Colors.black87,
    ),
  );
}

Widget customhChoiceBox({
  required String item,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      //color: isSelected ? Color(0xFF35B64A) : Colors.white,
      color: isSelected
          ? Color(0xFF35B64A)
          //: Color.fromARGB(255, 234, 253, 237),
          : Colors.white70,

      borderRadius: BorderRadius.circular(15),
      //border: Border.all(color: Colors.green),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Text(
        "$item",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.black87,
          //color: Colors.black54,
        ),
      ),
    ),
  );
}
