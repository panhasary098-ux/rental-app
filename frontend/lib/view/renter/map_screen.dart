import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  String selectedType = "All";

  static const LatLng initialPosition = LatLng(11.5564, 104.9282);

  final List<Map<String, dynamic>> sampleProperties = [
    {
      "name": "Modern Family House",
      "type": "House",
      "price": "\$500 / month",
      "location": "BKK1, Phnom Penh",
      "distance": "0.8 km",
      "position": const LatLng(11.5564, 104.9282),
    },
    {
      "name": "Cozy Apartment",
      "type": "Apartment",
      "price": "\$350 / month",
      "location": "Toul Kork, Phnom Penh",
      "distance": "1.2 km",
      "position": const LatLng(11.5740, 104.8910),
    },
    {
      "name": "Single Room",
      "type": "Room",
      "price": "\$180 / month",
      "location": "Chamkarmon, Phnom Penh",
      "distance": "1.5 km",
      "position": const LatLng(11.5420, 104.9200),
    },
  ];

  Set<Marker> get propertyMarkers {
    return sampleProperties.map((property) {
      return Marker(
        markerId: MarkerId(property["name"]),
        position: property["position"],
        infoWindow: InfoWindow(
          title: property["name"],
          snippet: property["price"],
        ),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(color: primaryColor),

        title: const Text(
          "Property Map",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          // ======================================================
          // SEARCH SECTION
          // ======================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),

                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: const TextField(
                      style: TextStyle(color: primaryColor),

                      decoration: InputDecoration(
                        hintText: "Search this area",

                        hintStyle: TextStyle(color: Colors.black38),

                        prefixIcon: Icon(Icons.search, color: primaryColor),

                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  height: 46,
                  width: 46,

                  decoration: BoxDecoration(
                    color: lightSecondaryColor,
                    borderRadius: BorderRadius.circular(14),

                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: IconButton(
                    onPressed: () {},

                    icon: const Icon(Icons.tune, color: primaryColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // PROPERTY TYPE FILTER
          // ======================================================
          SizedBox(
            height: 38,

            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),

              children: [
                typeChip("All"),
                typeChip("House"),
                typeChip("Apartment"),
                typeChip("Room"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // MAP
          // ======================================================
          Expanded(
            flex: 5,

            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),

              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: initialPosition,
                  zoom: 13,
                ),

                markers: propertyMarkers,

                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ),

          // ======================================================
          // BOTTOM PROPERTY LIST
          // ======================================================
          Expanded(
            flex: 4,

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "${sampleProperties.length} Properties Found",

                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () {},

                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: primaryColor,
                        ),

                        label: const Text(
                          "Nearest",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Expanded(
                    child: ListView.separated(
                      itemCount: sampleProperties.length,

                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: primaryColor.withOpacity(0.08),
                      ),

                      itemBuilder: (context, index) {
                        final property = sampleProperties[index];

                        return propertyItem(
                          name: property["name"],
                          type: property["type"],
                          price: property["price"],
                          location: property["location"],
                          distance: property["distance"],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // PROPERTY TYPE CHIP
  // ======================================================

  Widget typeChip(String text) {
    final bool isSelected = selectedType == text;

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ChoiceChip(
        label: Text(text),

        selected: isSelected,

        onSelected: (_) {
          setState(() {
            selectedType = text;
          });
        },

        selectedColor: primaryColor,

        backgroundColor: lightSecondaryColor,

        labelStyle: TextStyle(
          color: isSelected ? Colors.white : primaryColor,
          fontWeight: FontWeight.w600,
        ),

        side: BorderSide.none,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // ======================================================
  // PROPERTY ITEM
  // ======================================================

  Widget propertyItem({
    required String name,
    required String type,
    required String price,
    required String location,
    required String distance,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Row(
        children: [
          // Property icon
          Container(
            width: 82,
            height: 70,

            decoration: BoxDecoration(
              color: lightSecondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.home_work_outlined,
              size: 30,
              color: primaryColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Property name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: primaryColor,
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Price
                Text(
                  price,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Distance + type
          Column(
            children: [
              Text(
                distance,

                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: lightSecondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  type,

                  style: const TextStyle(
                    fontSize: 10,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
