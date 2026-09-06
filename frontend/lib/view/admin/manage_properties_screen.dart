import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagePropertiesScreen extends StatefulWidget {
  ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() =>
      _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState
    extends State<ManagePropertiesScreen> {

  String selectedFilter = "All";

  List<Map<String, dynamic>> properties = [
    {
      "title": "Modern Room Near University",
      "owner": "Dara Sok",
      "location": "Toul Kork, Phnom Penh",
      "price": 120,
      "status": "Available",
      "postStatus": "Active",
      "description":
          "A clean and comfortable room located near the university. Suitable for students and young workers. The property is located in a quiet and convenient area.",
      "type": "Room",
      "bedroom": 1,
      "bathroom": 1,
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
    },
    {
      "title": "Student Apartment",
      "owner": "Sophea Lim",
      "location": "Sen Sok, Phnom Penh",
      "price": 180,
      "status": "Rented",
      "postStatus": "Active",
      "description":
          "A modern student apartment with comfortable living space. Conveniently located near shops, restaurants and transportation.",
      "type": "Apartment",
      "bedroom": 1,
      "bathroom": 1,
      "image":
          "https://images.unsplash.com/photo-1502672023488-70e25813eb80",
    },
    {
      "title": "Affordable Room",
      "owner": "Vanna Chea",
      "location": "Chamkarmon, Phnom Penh",
      "price": 95,
      "status": "Available",
      "postStatus": "Active",
      "description":
          "An affordable rental room in Chamkarmon. Suitable for students looking for a simple and convenient place to stay.",
      "type": "Room",
      "bedroom": 1,
      "bathroom": 1,
      "image":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
    },
    {
      "title": "Modern Apartment",
      "owner": "Sokha Chan",
      "location": "BKK1, Phnom Penh",
      "price": 250,
      "status": "Available",
      "postStatus": "Removed",
      "description":
          "Modern apartment located in BKK1 with comfortable rooms and convenient access to restaurants, cafes and shops.",
      "type": "Apartment",
      "bedroom": 2,
      "bathroom": 1,
      "image":
          "https://images.unsplash.com/photo-1493809842364-78817add7ffb",
    },
  ];

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredProperties =
        selectedFilter == "All"
            ? properties
            : properties
                .where(
                  (property) =>
                      property["postStatus"] == selectedFilter,
                )
                .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF7FAF8),

      appBar: AppBar(
        backgroundColor: Color(0xFFF7FAF8),
        elevation: 0,
        scrolledUnderElevation: 0,
         leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2923),
          ),
        ),
        title: Text(
          "Manage Properties",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2923),
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [

            // SEARCH
            Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                10,
                18,
                0,
              ),

              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search properties...",

                  hintStyle: TextStyle(
                    color: Color(0xFF94A099),
                    fontSize: 14,
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF68756D),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFF03045E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 14),

            // FILTERS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              padding: EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                children: [
                  buildFilterChip("All"),

                  SizedBox(width: 8),

                  buildFilterChip("Active"),

                  SizedBox(width: 8),

                  buildFilterChip("Removed"),
                ],
              ),
            ),

            SizedBox(height: 16),

            // PROPERTY LIST
            Expanded(
              child: filteredProperties.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Container(
                            width: 72,
                            height: 72,

                            decoration: BoxDecoration(
                              color: Color(0xFF90E0EF)
                                  .withOpacity(0.25),

                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.home_work_outlined,
                              color: Color(0xFF03045E),
                              size: 32,
                            ),
                          ),

                          SizedBox(height: 14),

                          Text(
                            "No properties found",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2923),
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "There are no properties in this category.",

                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF68756D),
                            ),
                          ),
                        ],
                      ),
                    )

                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        0,
                        18,
                        25,
                      ),

                      itemCount: filteredProperties.length,

                      separatorBuilder: (context, index) {
                        return SizedBox(height: 14);
                      },

                      itemBuilder: (context, index) {

                        Map<String, dynamic> property =
                            filteredProperties[index];

                        return buildPropertyCard(
                          property,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // FILTER CHIP
  Widget buildFilterChip(String title) {

    bool isSelected = selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius: BorderRadius.circular(20),

      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),

        padding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF03045E)
              : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? Color(0xFF03045E)
                : Colors.grey.withOpacity(0.4),
          ),

          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        Color(0xFF03045E).withOpacity(0.15),

                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : [],
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,

            color: isSelected
                ? Colors.white
                : Color(0xFF68756D),
          ),
        ),
      ),
    );
  }

  // PROPERTY CARD
  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {

    return Container(
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),

            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [

          // PROPERTY INFORMATION
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // IMAGE
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(13),

                child: Image.network(
                  property["image"],

                  width: 105,
                  height: 105,

                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {

                    return Container(
                      width: 105,
                      height: 105,

                      color:
                          Color(0xFF90E0EF).withOpacity(0.25),

                      child: Icon(
                        Icons.home_work_outlined,
                        color: Color(0xFF03045E),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 14),

              // DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // TITLE + ADMIN STATUS
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            property["title"],

                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 16,
                              height: 1.3,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFF1F2923),
                            ),
                          ),
                        ),

                        SizedBox(width: 8),

                        buildPostStatusBadge(
                          property["postStatus"],
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // PRICE
                    Text(
                      "\$${property["price"]} / month",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
                      ),
                    ),

                    SizedBox(height: 7),

                    // OWNER PROPERTY STATUS
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 9,

                          color:
                              property["status"] ==
                                      "Available"
                                  ? Colors.green
                                  : Color(0xFF3B82F6),
                        ),

                        SizedBox(width: 6),

                        Text(
                          property["status"],

                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,

                            color:
                                property["status"] ==
                                        "Available"
                                    ? Colors.green
                                    : Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // OWNER
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 17,
                          color: Color(0xFF68756D),
                        ),

                        SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            property["owner"],

                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF68756D),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 7),

                    // LOCATION
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 17,
                          color: Color(0xFF68756D),
                        ),

                        SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            property["location"],

                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF68756D),
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

          SizedBox(height: 16),

          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.25),
          ),

          SizedBox(height: 16),

          // ACTION BUTTONS
          Row(
            children: [

              // VIEW POST
              Expanded(
                child: SizedBox(
                  height: 50,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      showPropertyPost(property);
                    },

                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 20,
                    ),

                    label: Text(
                      "View Post",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF03045E),

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(13),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              // MANAGE POST
              SizedBox(
                width: 70,
                height: 50,

                child: OutlinedButton(
                  onPressed: () {
                    showManagePostSheet(
                      property,
                    );
                  },

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        Color(0xFF68756D),

                    backgroundColor:
                        Colors.white,

                    side: BorderSide(
                      color:
                          Colors.grey.withOpacity(0.4),
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(13),
                    ),
                  ),

                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ADMIN POST STATUS BADGE
  Widget buildPostStatusBadge(
    String status,
  ) {

    Color textColor;
    Color backgroundColor;

    if (status == "Active") {
      textColor = Color(0xFF03045E);

      backgroundColor =
          Color(0xFF90E0EF).withOpacity(0.25);
    } else {
      textColor = Color(0xFFDC2626);

      backgroundColor =
          Color(0xFFFEF2F2);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // VIEW FULL PROPERTY POST
  void showPropertyPost(
    Map<String, dynamic> property,
  ) {

    Get.to(
      () => Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,

          leading: IconButton(
            onPressed: () {
              Get.back();
            },

            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF03045E),
              size: 20,
            ),
          ),

          title: Text(
            "Property Post",

            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045E),
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // LARGE IMAGE
              Image.network(
                property["image"],

                width: double.infinity,
                height: 260,

                fit: BoxFit.cover,

                errorBuilder:
                    (context, error, stackTrace) {

                  return Container(
                    width: double.infinity,
                    height: 260,

                    color:
                        Color(0xFF90E0EF)
                            .withOpacity(0.20),

                    child: Icon(
                      Icons.home_work_outlined,
                      size: 60,
                      color: Color(0xFF03045E),
                    ),
                  );
                },
              ),

              Padding(
                padding: EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // ADMIN POST STATUS
                    buildPostStatusBadge(
                      property["postStatus"],
                    ),

                    SizedBox(height: 14),

                    // TITLE
                    Text(
                      property["title"],

                      style: TextStyle(
                        fontSize: 23,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2923),
                      ),
                    ),

                    SizedBox(height: 10),

                    // PRICE
                    Text(
                      "\$${property["price"]} / month",

                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
                      ),
                    ),

                    SizedBox(height: 14),

                    // RENTAL STATUS
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color:
                            property["status"] ==
                                    "Available"
                                ? Colors.green
                                    .withOpacity(0.08)
                                : Color(0xFF3B82F6)
                                    .withOpacity(0.08),

                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [
                          Container(
                            width: 8,
                            height: 8,

                            decoration: BoxDecoration(
                              color:
                                  property["status"] ==
                                          "Available"
                                      ? Colors.green
                                      : Color(
                                          0xFF3B82F6),

                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 7),

                          Text(
                            property["status"],

                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w600,

                              color:
                                  property["status"] ==
                                          "Available"
                                      ? Colors.green
                                      : Color(
                                          0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    Divider(
                      color:
                          Colors.grey.withOpacity(0.3),
                    ),

                    SizedBox(height: 18),

                    // PROPERTY INFORMATION
                    Text(
                      "Property Information",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
                      ),
                    ),

                    SizedBox(height: 16),

                    buildPostInformation(
                      icon: Icons.home_outlined,
                      title: "Property Type",
                      value: property["type"],
                    ),

                    SizedBox(height: 14),

                    buildPostInformation(
                      icon: Icons.person_outline_rounded,
                      title: "Property Owner",
                      value: property["owner"],
                    ),

                    SizedBox(height: 14),

                    buildPostInformation(
                      icon:
                          Icons.location_on_outlined,
                      title: "Location",
                      value: property["location"],
                    ),

                    SizedBox(height: 14),

                    buildPostInformation(
                      icon:
                          Icons.home_work_outlined,
                      title: "Rental Status",
                      value: property["status"],
                    ),

                    SizedBox(height: 14),

                    Row(
                      children: [

                        Expanded(
                          child: buildPostInformation(
                            icon:
                                Icons.bed_outlined,
                            title: "Bedroom",
                            value:
                                "${property["bedroom"]}",
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: buildPostInformation(
                            icon:
                                Icons.bathtub_outlined,
                            title: "Bathroom",
                            value:
                                "${property["bathroom"]}",
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26),

                    Divider(
                      color:
                          Colors.grey.withOpacity(0.3),
                    ),

                    SizedBox(height: 18),

                    // DESCRIPTION
                    Text(
                      "Description",

                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      property["description"],

                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: Color(0xFF68756D),
                      ),
                    ),

                    SizedBox(height: 26),

                    Divider(
                      color:
                          Colors.grey.withOpacity(0.3),
                    ),

                    SizedBox(height: 18),

                    // ADMIN REVIEW INFORMATION
                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color:
                            Color(0xFF90E0EF)
                                .withOpacity(0.15),

                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Icon(
                            Icons
                                .admin_panel_settings_outlined,

                            color:
                                Color(0xFF03045E),

                            size: 22,
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  "Admin Management",

                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: Color(
                                        0xFF03045E),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Review this property post and decide whether it should remain visible on JoulNow.",

                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: Color(
                                        0xFF68756D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 22),

                    // MANAGE POST BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          showManagePostSheet(
                            property,
                          );
                        },

                        icon: Icon(
                          Icons
                              .settings_outlined,

                          size: 20,
                        ),

                        label: Text(
                          "Manage Post",

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF03045E),

                          foregroundColor:
                              Colors.white,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              13,
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
        ),
      ),
    );
  }

  // PROPERTY INFORMATION ITEM
  Widget buildPostInformation({
    required IconData icon,
    required String title,
    required String value,
  }) {

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color:
                Color(0xFF90E0EF)
                    .withOpacity(0.20),

            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            size: 21,
            color: Color(0xFF03045E),
          ),
        ),

        SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF7D8990),
                ),
              ),

              SizedBox(height: 3),

              Text(
                value,

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2923),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // MANAGE POST BOTTOM SHEET
  void showManagePostSheet(
    Map<String, dynamic> property,
  ) {

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          25,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // HANDLE
              Center(
                child: Container(
                  width: 45,
                  height: 4,

                  decoration: BoxDecoration(
                    color: Color(0xFFD8E0DB),

                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Manage Post",

                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2923),
                ),
              ),

              SizedBox(height: 5),

              Text(
                property["title"],

                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF68756D),
                ),
              ),

              SizedBox(height: 20),

              // KEEP POST
              InkWell(
                onTap: () {

                  setState(() {
                    property["postStatus"] =
                        "Active";
                  });

                  Get.back();

                  Get.snackbar(
                    "Post Kept",
                    "This property will remain visible to renters.",

                    snackPosition:
                        SnackPosition.TOP,

                    backgroundColor:
                        Color(0xFF03045E),

                    colorText: Colors.white,

                    duration:
                        Duration(seconds: 2),
                  );
                },

                borderRadius:
                    BorderRadius.circular(14),

                child: Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(14),

                    border: Border.all(
                      color:
                          Colors.grey.withOpacity(0.4),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.08),

                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color:
                              Color(0xFF90E0EF)
                                  .withOpacity(0.25),

                          borderRadius:
                              BorderRadius.circular(11),
                        ),

                        child: Icon(
                          Icons
                              .check_circle_outline_rounded,

                          color:
                              Color(0xFF03045E),

                          size: 21,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Keep Post",

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xFF1F2923),
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Keep this property visible to renters.",

                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF68756D),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (property["postStatus"] ==
                          "Active")
                        Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF03045E),
                          size: 21,
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),

              // REMOVE POST
              InkWell(
                onTap: () {
                  Get.back();

                  showRemoveConfirmation(
                    property,
                  );
                },

                borderRadius:
                    BorderRadius.circular(14),

                child: Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: Color(0xFFFEF2F2),

                    borderRadius:
                        BorderRadius.circular(14),

                    border: Border.all(
                      color:
                          Color(0xFFDC2626)
                              .withOpacity(0.20),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration: BoxDecoration(
                          color:
                              Color(0xFFDC2626)
                                  .withOpacity(0.08),

                          borderRadius:
                              BorderRadius.circular(11),
                        ),

                        child: Icon(
                          Icons
                              .delete_outline_rounded,

                          color:
                              Color(0xFFDC2626),

                          size: 21,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Remove Post",

                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xFFDC2626),
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Remove this property from public listings.",

                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF68756D),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (property["postStatus"] ==
                          "Removed")
                        Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFFDC2626),
                          size: 21,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // REMOVE CONFIRMATION
  void showRemoveConfirmation(
    Map<String, dynamic> property,
  ) {

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color:
                    Color(0xFFDC2626)
                        .withOpacity(0.08),

                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFDC2626),
                size: 20,
              ),
            ),

            SizedBox(width: 12),

            Text(
              "Remove Post",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),
          ],
        ),

        content: Text(
          "Are you sure you want to remove this property from public listings?",

          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: Color(0xFF68756D),
          ),
        ),

        actions: [

          // CANCEL
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text(
              "Cancel",

              style: TextStyle(
                color: Color(0xFF68756D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // REMOVE
          ElevatedButton(
            onPressed: () {

              setState(() {
                property["postStatus"] =
                    "Removed";
              });

              Get.back();

              Get.snackbar(
                "Post Removed",
                "The property has been removed from public listings.",

                snackPosition:
                    SnackPosition.TOP,

                backgroundColor:
                    Color(0xFFDC2626),

                colorText: Colors.white,

                duration:
                    Duration(seconds: 2),
              );
            },

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Color(0xFFDC2626),

              foregroundColor:
                  Colors.white,

              elevation: 0,

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            child: Text(
              "Remove",

              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}