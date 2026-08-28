import 'package:final_project/model/property.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatelessWidget {
  final List<Property> properties;

  HomeScreen({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 250, 250),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.menu_rounded, size: 27),
                  ),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Stay",
                          style: TextStyle(
                            color: Color(0xFF171717),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Near",
                          style: TextStyle(
                            color: Color(0xFF35B64A),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none_rounded, size: 27),
                  ),
                ],
              ),

              SizedBox(height: 25),

              // Main heading
              Text(
                "Find a place",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171717),
                ),
              ),

              Row(
                children: [
                  Text(
                    "near your ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171717),
                    ),
                  ),
                  Text(
                    "school",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    " or ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171717),
                    ),
                  ),
                  Text(
                    "work",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35B64A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

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

                    // Filter button
                    suffixIcon: Tooltip(
                      waitDuration: const Duration(milliseconds: 500),
                      showDuration: const Duration(seconds: 2),
                      preferBelow: false,
                      message: "Filter",
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => FilterScreen());
                        },
                        icon: const Icon(Icons.tune),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Location
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Color(0xFF35B64A)),
                    SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Near",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Phnom Penh",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Icon(Icons.chevron_right_rounded, color: Colors.black),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Budget + Filters
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 67,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 24),
                          SizedBox(width: 9),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Budget",
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Price range",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      height: 67,
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined, size: 24),
                          SizedBox(width: 9),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Filters",
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Rooms",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Recommended title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended for you",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5),

              // Property list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];

                  return Container(
                    width: 300,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                              child: Image.network(
                                property.imageUrl,
                                height: 170,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Match percentage
                            Positioned(
                              top: 12,
                              right: 48,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${property.matchPercent.toInt()}% Match",
                                  style: TextStyle(
                                    color: Color(0xFF29983B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // Favorite
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Property information
                        Padding(
                          padding: EdgeInsets.fromLTRB(14, 10, 14, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 3),

                                  Text(
                                    "${property.distance} km · Phnom Penh",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),

                              Text(
                                "\$${property.price.toInt()} / month",
                                style: TextStyle(
                                  color: Color(0xFF35B64A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
