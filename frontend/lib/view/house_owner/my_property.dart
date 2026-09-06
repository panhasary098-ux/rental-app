import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen> {
  String selectedFilter = "All";

  List<Map<String, dynamic>> properties = [
    {
      "title": "Modern Family House",
      "location": "Sen Sok, Phnom Penh",
      "price": "\$850 / month",
      "rentalStatus": "Available",
      "verificationStatus": "Approved",
      "image":
          "https://images.unsplash.com/photo-1564013799919-ab600027ffc6",
    },
    {
      "title": "BKK1 City Apartment",
      "location": "BKK1, Phnom Penh",
      "price": "\$550 / month",
      "rentalStatus": "Rented",
      "verificationStatus": "Approved",
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
    },
    {
      "title": "Toul Kork Room",
      "location": "Toul Kork, Phnom Penh",
      "price": "\$180 / month",
      "rentalStatus": "Available",
      "verificationStatus": "Pending",
      "image":
          "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProperties =
        properties.where((property) {
      if (selectedFilter == "All") {
        return true;
      }

      if (selectedFilter == "Pending") {
        return property["verificationStatus"] == "Pending";
      }

      return property["rentalStatus"] == selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: Text(
          "My Properties",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045E),
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            // SEARCH + FILTER AREA
            Container(
              color: Colors.white,

              padding: EdgeInsets.fromLTRB(
                18,
                10,
                18,
                16,
              ),

              child: Column(
                children: [
                  // SEARCH
                  Container(
                    height: 50,

                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(15),

                      border: Border.all(
                        color: Colors.grey.withOpacity(0.20),
                      ),
                    ),

                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search your properties",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF98A2B3),
                        ),

                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF667085),
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 14),

                  // FILTERS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: Row(
                      children: [
                        buildFilterChip("All"),
                        SizedBox(width: 8),
                        buildFilterChip("Available"),
                        SizedBox(width: 8),
                        buildFilterChip("Rented"),
                        SizedBox(width: 8),
                        buildFilterChip("Pending"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // PROPERTY COUNT
            Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                10,
              ),

              child: Row(
                children: [
                  Text(
                    "${filteredProperties.length} Properties",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF03045E),
                    ),
                  ),

                  Spacer(),

                  Text(
                    "Manage your listings",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7D8990),
                    ),
                  ),
                ],
              ),
            ),

            // PROPERTY LIST
            Expanded(
              child: filteredProperties.isEmpty
                  ? buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        4,
                        18,
                        28,
                      ),

                      itemCount: filteredProperties.length,

                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },

                      itemBuilder: (context, index) {
                        return buildPropertyCard(
                          filteredProperties[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FILTER
  // =========================================================

  Widget buildFilterChip(String title) {
    bool selected = selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius: BorderRadius.circular(30),

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected
              ? Color(0xFFE8E9FF)
              : Colors.white,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: selected
                ? Color(0xFF03045E).withOpacity(0.25)
                : Colors.grey.withOpacity(0.25),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,
            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.w500,

            color: selected
                ? Color(0xFF03045E)
                : Color(0xFF667085),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PROPERTY CARD
  // =========================================================

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.withOpacity(0.25),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),

                child: Image.network(
                  property["image"],
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              // RENTAL STATUS
              Positioned(
                left: 12,
                top: 12,

                child: buildBadge(
                  property["rentalStatus"],
                  property["rentalStatus"] == "Available"
                      ? Color(0xFF16A34A)
                      : Color(0xFFDC2626),
                ),
              ),

              // MENU
              Positioned(
                right: 10,
                top: 10,

                child: Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    shape: BoxShape.circle,
                  ),

                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,

                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: Color(0xFF03045E),
                    ),

                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 19,
                              ),

                              SizedBox(width: 10),

                              Text("Edit Property"),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          value: "view",
                          child: Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 19,
                              ),

                              SizedBox(width: 10),

                              Text("View Details"),
                            ],
                          ),
                        ),
                      ];
                    },

                    onSelected: (value) {
                      if (value == "edit") {
                        // Edit property later
                      }

                      if (value == "view") {
                        // View property details later
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // DETAILS
          Padding(
            padding: EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property["title"],

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF03045E),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    buildVerificationBadge(
                      property["verificationStatus"],
                    ),
                  ],
                ),

                SizedBox(height: 7),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF7D8990),
                    ),

                    SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        property["location"],

                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7D8990),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  property["price"],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),

                SizedBox(height: 15),

                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.20),
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    // EDIT
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Edit Property later
                        },

                        icon: Icon(
                          Icons.edit_outlined,
                          size: 17,
                        ),

                        label: Text(
                          "Edit",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF03045E),

                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.35),
                          ),

                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    // CHANGE STATUS
                    Expanded(
                      flex: 2,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          showStatusBottomSheet(
                            property,
                          );
                        },

                        icon: Icon(
                          Icons.swap_horiz_rounded,
                          size: 18,
                        ),

                        label: Text(
                          "Change Status",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF03045E),
                          foregroundColor: Colors.white,
                          elevation: 0,

                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // VERIFICATION BADGE
  // =========================================================

  Widget buildVerificationBadge(
    String status,
  ) {
    Color color;

    if (status == "Approved") {
      color = Color(0xFF2563EB);
    } else if (status == "Pending") {
      color = Color(0xFFF59E0B);
    } else {
      color = Color(0xFFDC2626);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            status == "Approved"
                ? Icons.verified_rounded
                : Icons.schedule_rounded,
            size: 13,
            color: color,
          ),

          SizedBox(width: 4),

          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BADGE
  // =========================================================

  Widget buildBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            width: 7,
            height: 7,

            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 5),

          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CHANGE AVAILABILITY
  // =========================================================

  void showStatusBottomSheet(
    Map<String, dynamic> property,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          28,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.30),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Change Availability",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 5),

            Text(
              property["title"],
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7D8990),
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Choose the current rental status of this property.",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF98A2B3),
              ),
            ),

            SizedBox(height: 20),

            buildStatusOption(
              icon: Icons.check_circle_outline_rounded,
              title: "Available",
              subtitle: "Property is currently open for rent",
              color: Color(0xFF16A34A),

              selected:
                  property["rentalStatus"] == "Available",

              onTap: () {
                setState(() {
                  property["rentalStatus"] = "Available";
                });

                Get.back();

                Get.snackbar(
                  "Status Updated",
                  "${property["title"]} is now available",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.white,
                  colorText: Color(0xFF03045E),
                );
              },
            ),

            SizedBox(height: 12),

            buildStatusOption(
              icon: Icons.key_rounded,
              title: "Rented",
              subtitle: "Property is currently occupied",
              color: Color(0xFFDC2626),

              selected:
                  property["rentalStatus"] == "Rented",

              onTap: () {
                setState(() {
                  property["rentalStatus"] = "Rented";
                });

                Get.back();

                Get.snackbar(
                  "Status Updated",
                  "${property["title"]} is now rented",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.white,
                  colorText: Color(0xFF03045E),
                );
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  Widget buildStatusOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.08)
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected
                ? color
                : Colors.grey.withOpacity(0.30),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: color,
                size: 23,
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                    ),
                  ),

                  SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7D8990),
                    ),
                  ),
                ],
              ),
            ),

            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 80,
              height: 80,

              decoration: BoxDecoration(
                color: Color(0xFFE8E9FF),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.home_work_outlined,
                size: 37,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 18),

            Text(
              "No properties found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 6),

            Text(
              "Your properties matching this filter will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF7D8990),
              ),
            ),
          ],
        ),
      ),
    );
  }
}