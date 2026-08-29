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
      "price": "\$120 / month",
      "status": "Available",
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
    },
    {
      "title": "Student Apartment",
      "owner": "Sophea Lim",
      "location": "Sen Sok, Phnom Penh",
      "price": "\$180 / month",
      "status": "Rented",
      "image":
          "https://images.unsplash.com/photo-1502672023488-70e25813eb80",
    },
    {
      "title": "Private Room",
      "owner": "Vanna Chan",
      "location": "Boeung Keng Kang",
      "price": "\$95 / month",
      "status": "Pending",
      "image":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
    },
    {
      "title": "City View Apartment",
      "owner": "Sokha Meas",
      "location": "Chamkarmon",
      "price": "\$240 / month",
      "status": "Suspended",
      "image":
          "https://images.unsplash.com/photo-1493809842364-78817add7ffb",
    },
  ];

  List<String> filters = [
    "All",
    "Available",
    "Rented",
    "Pending",
    "Suspended",
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProperties =
        selectedFilter == "All"
        ? properties
        : properties
              .where(
                (property) =>
                    property["status"] == selectedFilter,
              )
              .toList();

    return Scaffold(
      backgroundColor: Color(0xFFF3F5F4),

      appBar: AppBar(
        backgroundColor: Color(0xFFF3F5F4),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
          ),
        ),

        title: Text(
          "Manage Properties",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                10,
                20,
                10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search property or owner",

                  hintStyle: TextStyle(
                    color: Color(0xFF6B7280),
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF4B5563),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFD6DBD8),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFD6DBD8),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFF167A3E),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            SizedBox(
              height: 44,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                scrollDirection: Axis.horizontal,

                itemCount: filters.length,

                separatorBuilder: (
                  context,
                  index,
                ) {
                  return SizedBox(width: 8);
                },

                itemBuilder: (
                  context,
                  index,
                ) {
                  String filter = filters[index];

                  bool selected =
                      selectedFilter == filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? Color(0xFF167A3E)
                            : Colors.white,

                        borderRadius:
                            BorderRadius.circular(20),

                        border: Border.all(
                          color: selected
                              ? Color(0xFF167A3E)
                              : Color(0xFFD6DBD8),
                        ),
                      ),

                      child: Text(
                        filter,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : Color(0xFF4B5563),

                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 14),

            Expanded(
              child: filteredProperties.isEmpty
                  ? Center(
                      child: Text(
                        "No properties found",
                        style: TextStyle(
                          color:
                              Color(0xFF4B5563),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding:
                          EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        25,
                      ),

                      itemCount:
                          filteredProperties.length,

                      separatorBuilder: (
                        context,
                        index,
                      ) {
                        return SizedBox(
                          height: 14,
                        );
                      },

                      itemBuilder: (
                        context,
                        index,
                      ) {
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

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    return Container(
      padding: EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Color(0xFFD6DBD8),
        ),
      ),

      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(14),

                child: Image.network(
                  property["image"],
                  width: 95,
                  height: 95,
                  fit: BoxFit.cover,

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      width: 95,
                      height: 95,
                      color: Color(0xFFDCEFE3),

                      child: Icon(
                        Icons.home_work_outlined,
                        color: Color(0xFF167A3E),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Expanded(
                          child: Text(
                            property["title"],

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFF111827),
                            ),
                          ),
                        ),

                        SizedBox(width: 8),

                        buildStatusBadge(
                          property["status"],
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    Text(
                      property["price"],
                      style: TextStyle(
                        color: Color(0xFF167A3E),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 15,
                          color:
                              Color(0xFF4B5563),
                        ),

                        SizedBox(width: 4),

                        Text(
                          property["owner"],
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons
                              .location_on_outlined,
                          size: 15,
                          color:
                              Color(0xFF4B5563),
                        ),

                        SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            property["location"],

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style: TextStyle(
                              fontSize: 12,
                              color: Color(
                                0xFF4B5563,
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

          SizedBox(height: 14),

          Divider(
            color: Color(0xFFD6DBD8),
          ),

          SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showStatusSheet(property);
                  },

                  icon: Icon(
                    Icons.sync_alt_rounded,
                    size: 18,
                  ),

                  label: Text(
                    "Change Status",
                  ),

                  style:
                      OutlinedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF167A3E),
                        foregroundColor: Colors.white,

                    side: BorderSide(
                      color: Color(0xFF167A3E),
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE7EAE8),
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: IconButton(
                  onPressed: () {},

                  icon: Icon(
                    Icons
                        .more_horiz_rounded,
                    color:
                        Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatusBadge(
    String status,
  ) {
    Color backgroundColor;
    Color textColor;

    if (status == "Available") {
      backgroundColor = Color(0xFFDCEFE3);
      textColor = Color(0xFF167A3E);
    } else if (status == "Rented") {
      backgroundColor = Color(0xFFDCE8F8);
      textColor = Color(0xFF1D4F91);
    } else if (status == "Pending") {
      backgroundColor = Color(0xFFFFF3CD);
      textColor = Color(0xFF9A6700);
    } else {
      backgroundColor = Color(0xFFFADDDD);
      textColor = Color(0xFFB42318);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void showStatusSheet(
    Map<String, dynamic> property,
  ) {
    List<String> statuses = [
      "Available",
      "Rented",
      "Suspended",
    ];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          25,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,

                  decoration: BoxDecoration(
                    color: Color(0xFF9CA3AF),

                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Update Property Status",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              SizedBox(height: 5),

              Text(
                property["title"],
                style: TextStyle(
                  color: Color(0xFF4B5563),
                ),
              ),

              SizedBox(height: 18),

              ...statuses.map(
                (status) {
                  return Padding(
                    padding:
                        EdgeInsets.only(
                      bottom: 10,
                    ),

                    child: InkWell(
                      onTap: () {
                        setState(() {
                          property["status"] =
                              status;
                        });

                        Get.back();

                        Get.snackbar(
                          "Status Updated",
                          "Property status changed to $status",
                          snackPosition:
                              SnackPosition.TOP,
                          backgroundColor:
                              Color(0xFF167A3E),
                          colorText:
                              Colors.white,
                        );
                      },

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),

                      child: Container(
                        padding:
                            EdgeInsets.all(15),

                        decoration:
                            BoxDecoration(
                          color:
                              Color(0xFFF3F5F4),

                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),

                          border: Border.all(
                            color: Color(
                              0xFFD6DBD8,
                            ),
                          ),
                        ),

                        child: Row(
                          children: [
                            buildStatusBadge(
                              status,
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                getStatusDescription(
                                  status,
                                ),

                                style:
                                    TextStyle(
                                  fontSize: 12,
                                  color: Color(
                                    0xFF4B5563,
                                  ),
                                ),
                              ),
                            ),

                            Icon(
                              Icons
                                  .chevron_right_rounded,
                              color: Color(
                                0xFF6B7280,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  String getStatusDescription(
    String status,
  ) {
    if (status == "Available") {
      return "Property is publicly available for renters.";
    }

    if (status == "Rented") {
      return "Property is currently rented and unavailable.";
    }

    return "Temporarily remove this property from public listings.";
  }
}