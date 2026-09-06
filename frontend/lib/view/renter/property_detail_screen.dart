import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int currentIndex = 1;

  List<String> images = [
    "https://i.pinimg.com/1200x/6a/17/d3/6a17d3982fe119f3c1110a65417fc5dc.jpg",
    "https://i.pinimg.com/1200x/50/3e/83/503e838a83d1f2bcdd499b9814b2050e.jpg",
    "https://i.pinimg.com/1200x/f5/b5/23/f5b52328776ad50ad5842bdecf853bdb.jpg",
  ];

  List<Map<String, dynamic>> mainInfo = [
    {"icon": Icons.bed_outlined, "text": "2 Bedrooms"},
    {"icon": Icons.bathtub_outlined, "text": "1 Bath"},
    {"icon": Icons.square_foot, "text": "50 m²"},
    {"icon": Icons.chair_outlined, "text": "Furnished"},
  ];

  List<Map<String, dynamic>> facilities = [
    {"icon": Icons.wifi, "text": "Free"},
    {"icon": Icons.local_parking_outlined, "text": "Parking-free"},
    {"icon": Icons.ac_unit, "text": "Air Con"},
    {"icon": Icons.pets_outlined, "text": "Pet Allowed"},
    {"icon": Icons.balcony_outlined, "text": "Balcony"},
    {"icon": Icons.pool_outlined, "text": "Swim-Pool"},
    {"icon": Icons.kitchen_outlined, "text": "Kitchen"},
    {"icon": Icons.chair_outlined, "text": "Furnished"},
    {"icon": Icons.elevator_outlined, "text": "Elevator-24h"},
  ];

  List<Map<String, dynamic>> floors = [
    {"floor": 1, "available": true},
    {"floor": 2, "available": true},
    {"floor": 3, "available": false},
    {"floor": 4, "available": true},
    {"floor": 5, "available": false},
    {"floor": 6, "available": true},
    {"floor": 7, "available": false},
    {"floor": 8, "available": true},
    {"floor": 9, "available": false},
    {"floor": 10, "available": false},
  ];

  bool showFloor = false;

  void floorList() {
    setState(() {
      showFloor = !showFloor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        iconTheme: const IconThemeData(color: primaryColor),

        title: const Text(
          "View detail info",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          // ======================================================
          // IMAGE SLIDESHOW
          // ======================================================
          Padding(
            padding: const EdgeInsets.only(bottom: 16),

            child: ClipRRect(
              child: Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,

                    child: ImageSlideshow(
                      width: double.infinity,
                      height: 280,

                      initialPage: 0,

                      indicatorColor: primaryColor,
                      indicatorBackgroundColor: Colors.white70,

                      autoPlayInterval: 3000,
                      isLoop: true,

                      children: images.map((imag) {
                        return SizedBox.expand(
                          child: Image.network(imag, fit: BoxFit.cover),
                        );
                      }).toList(),
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 10,
                    right: 10,

                    child: Container(
                      width: 36,
                      height: 36,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // PROPERTY INFO
          // ======================================================
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),

                child: SizedBox(
                  width: double.infinity,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 10),

                      // ==================================================
                      // NAME + AVAILABLE
                      // ==================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Expanded(
                            child: Text(
                              "BaliN3-Apartment",

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 22,
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            height: 28,

                            padding: const EdgeInsets.symmetric(horizontal: 10),

                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: const Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 15,
                                ),

                                SizedBox(width: 4),

                                Text(
                                  "Available",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // LOCATION + PRICE
                      // ==================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: primaryColor,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 3),

                                    Expanded(
                                      child: Text(
                                        "Chrouy jong vaa, Phnom Penh",

                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.65),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.near_me_outlined,
                                      color: primaryColor,
                                      size: 20,
                                    ),

                                    const SizedBox(width: 3),

                                    Expanded(
                                      child: Text(
                                        "8Km from your location",

                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black.withOpacity(0.65),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          Row(
                            children: [
                              const Text(
                                "\$150",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  color: primaryColor,
                                ),
                              ),

                              const Text(
                                "/Month",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // MAIN INFO
                      // ==================================================
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: secondaryColor.withOpacity(0.6),
                      ),

                      SizedBox(
                        height: 45,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: List.generate(mainInfo.length, (index) {
                            return Row(
                              children: [
                                Icon(
                                  mainInfo[index]["icon"],
                                  size: 16,
                                  color: primaryColor,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  mainInfo[index]["text"],

                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      Container(
                        height: 1,
                        width: double.infinity,
                        color: secondaryColor.withOpacity(0.6),
                      ),

                      const SizedBox(height: 10),

                      // ==================================================
                      // FLOOR
                      // ==================================================
                      Row(
                        children: [
                          const Text(
                            "Floor",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: primaryColor,
                            ),
                          ),

                          IconButton(
                            onPressed: floorList,

                            icon: Icon(
                              showFloor
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,

                              size: 25,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),

                      Visibility(
                        visible: showFloor,

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          child: Container(
                            height: 200,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),

                              border: Border.all(
                                color: secondaryColor.withOpacity(0.5),
                              ),
                            ),

                            child: SingleChildScrollView(
                              child: Column(
                                children: floors.map((item) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),

                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.apartment,
                                              size: 20,
                                              color: primaryColor,
                                            ),

                                            const SizedBox(width: 5),

                                            Text(
                                              "${item["floor"]} Floor",

                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            const Spacer(),

                                            Text(
                                              item["available"]
                                                  ? "Available"
                                                  : "Not available",

                                              style: TextStyle(
                                                fontSize: 15,

                                                fontWeight: item["available"]
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,

                                                color: item["available"]
                                                    ? primaryColor
                                                    : Colors.black45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: secondaryColor.withOpacity(0.4),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // DESCRIPTION
                      // ==================================================
                      const Text(
                        "About this place",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        "Clean and modern apartment in a safe area, "
                        "close to school, local markets and food shapes",

                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // FACILITIES
                      // ==================================================
                      const Text(
                        "Facilities",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 65,

                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: facilities.length,

                          itemBuilder: (context, index) {
                            final item = facilities[index];

                            return Container(
                              height: 60,

                              decoration: BoxDecoration(
                                color: lightSecondaryColor,

                                borderRadius: BorderRadius.circular(13),

                                border: Border.all(color: secondaryColor),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(
                                      item["icon"],
                                      size: 20,
                                      color: primaryColor,
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      item["text"],

                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },

                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 12);
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ======================================================
      // BOTTOM BUTTONS
      // ======================================================
      bottomNavigationBar: Container(
        height: 90,

        decoration: BoxDecoration(
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.10),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 20,
          ),

          child: Row(
            children: [
              // ==================================================
              // VIEW MAP
              // ==================================================
              Expanded(
                child: TextButton(
                  onPressed: () {},

                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    backgroundColor: lightSecondaryColor,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.map_outlined, size: 23),

                      SizedBox(width: 5),

                      Text(
                        "View in map",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // ==================================================
              // CONTACT
              // ==================================================
              Expanded(
                child: TextButton(
                  onPressed: () {},

                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.person_outline_rounded, size: 23),

                      SizedBox(width: 5),

                      Text(
                        "Context",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
