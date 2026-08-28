import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int currentIndex = 1;
  List<String> images = [
    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
    "https://i.pinimg.com/736x/ea/5c/43/ea5c43affdd542481ab2862014027f12.jpg",
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
      //backgroundColor: Color.fromARGB(255, 233, 235, 234),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 233, 235, 234),
        title: Center(
          child: Text(
            "View detail info ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(25),
              //   topRight: Radius.circular(25),
              // ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,

                    // child: CarouselSlider(
                    //   items: images.map((imag) {
                    //     return SizedBox.expand(
                    //       child: Image.network(imag, fit: BoxFit.cover),
                    //     );
                    //   }).toList(),
                    //   options: CarouselOptions(
                    //     height: 300,

                    //     autoPlay: true,
                    //     autoPlayInterval: const Duration(seconds: 3),
                    //     autoPlayAnimationDuration: const Duration(
                    //       milliseconds: 500,
                    //     ),
                    //     enlargeCenterPage: false,
                    //     viewportFraction: 1.0,
                    //   ),
                    // ),
                    child: ImageSlideshow(
                      children: images.map((imag) {
                        return SizedBox.expand(
                          child: Image.network(imag, fit: BoxFit.cover),
                        );
                      }).toList(),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 58, 58, 58),
                      child: IconButton(
                        onPressed: () {},

                        icon: Icon(
                          Icons.favorite_border,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //--------------------------------------------------------
          //                    Property Infor
          //--------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "BaliN3-Apartment",
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF35B64A),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            height: 28,
                            width: 90,

                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 15,
                                  ),
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
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Location
                              // Text(
                              //   "Chrouy jongvaa, PhnomPenh",
                              //   style: TextStyle(
                              //     color: Colors.black54,
                              //     fontSize: 15,
                              //     fontWeight: FontWeight.w800,
                              //   ),
                              // ),
                              // SizedBox(height: 10),

                              //distance
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black.withValues(alpha: 0.7),
                                    size: 20,
                                  ),
                                  Text(
                                    "Chrouy jong vaa, Phnom Penh",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.near_me_outlined,
                                    color: Colors.black.withValues(alpha: 0.7),
                                    size: 20,
                                  ),
                                  Text(
                                    "8Km from your location",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                "\$150",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange[800],
                                ),
                              ),
                              Text(
                                "/Month",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF35B64A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      //*******  Main infor Scroll
                      Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.black12,
                      ),

                      Container(
                        height: 40,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(mainInfo.length, (index) {
                            return Row(
                              children: [
                                Icon(mainInfo[index]["icon"], size: 15),
                                SizedBox(width: 5),
                                Text(
                                  mainInfo[index]["text"],
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),

                      Container(
                        height: 2,
                        width: double.infinity,
                        color: Colors.black12,
                      ),

                      //Main infor Scroll*******
                      SizedBox(height: 10),

                      //*****Floor
                      Row(
                        children: [
                          Text(
                            "Floor ",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          IconButton(
                            onPressed: floorList,
                            icon: Icon(
                              showFloor
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 25,
                            ),
                          ),
                        ],
                      ),

                      // Container(
                      //   height: 2,
                      //   width: double.infinity,

                      //   decoration: BoxDecoration(
                      //     color: Colors.black12,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Colors.black.withValues(alpha: 0.1),
                      //         blurRadius: 8,
                      //         spreadRadius: ,
                      //         offset: const Offset(0, 8),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Visibility(
                        visible: showFloor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Container(
                            height: 200,
                            child: SingleChildScrollView(
                              child: Column(
                                children: floors.map((item) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.apartment,
                                              size: 20,
                                              color: Colors.teal[700],
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "${item["floor"]} Floor",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Spacer(),

                                            Text(
                                              item["available"]
                                                  ? "${"Available"}"
                                                  : "${"Not available"}",
                                              style: TextStyle(
                                                fontSize: 15,

                                                color: item["available"]
                                                    ? Colors.orange[900]
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //   height: 2,
                      //   width: double.infinity,
                      //   color: Colors.black12,
                      // ),
                      SizedBox(height: 10),

                      //*******description
                      Text(
                        "About this place",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),

                      Text(
                        "Clean and modern apartment in a safe area, close to school, local markets and food shapes",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),

                      //*****Floor

                      //description*******
                      SizedBox(height: 15),

                      //********Facilites
                      Text(
                        "Facilities",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 10),

                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: facilities.length,
                          itemBuilder: (context, index) {
                            final item = facilities[index];
                            return Container(
                              height: 60,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(color: Colors.black26),
                                //color: const Color.fromARGB(255, 245, 245, 245),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Icon(item["icon"], size: 20),
                                    Text(
                                      item["text"],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16,
            top: 20,
            bottom: 20,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},

                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 42, 177, 64),
                    //backgroundColor: const Color(0xFFECFDF5),
                    backgroundColor: const Color.fromARGB(255, 220, 252, 237),
                    //side: BorderSide(color: Color(0xFF35B64A), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    // text + icon color
                  ),

                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 23),
                        Text(
                          "View in map",
                          style: TextStyle(fontWeight: FontWeight.w800),

                          //style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () {},

                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 30, 94, 233),
                    //backgroundColor: const Color(0xFFEFF6FF),
                    backgroundColor: const Color.fromARGB(255, 221, 235, 252),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    // text + icon color
                  ),

                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_outline_rounded, size: 23),
                        Text(
                          "Context",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
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
