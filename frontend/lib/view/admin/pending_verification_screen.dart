import 'package:final_project/view/admin/property_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingVerificationScreen extends StatelessWidget {
  PendingVerificationScreen({super.key});

  List<Map<String, dynamic>> pendingProperties = [
    {
      "title": "Modern Room Near University",
      "owner": "Dara Sok",
      "location": "Toul Kork, Phnom Penh",
      "submitted": "24 Aug 2026",
      "price": "\$120 / month",
      "image":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
    },
    {
      "title": "Affordable Student Apartment",
      "owner": "Sophea Lim",
      "location": "Sen Sok, Phnom Penh",
      "submitted": "23 Aug 2026",
      "price": "\$180 / month",
      "image":
          "https://images.unsplash.com/photo-1502672023488-70e25813eb80",
    },
    {
      "title": "Private Room for Students",
      "owner": "Vanna Chan",
      "location": "Boeung Keng Kang",
      "submitted": "22 Aug 2026",
      "price": "\$95 / month",
      "image":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 242, 239),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 242, 239),
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
          "Pending Verification",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:  Color(0xFFD97706),
                  borderRadius: BorderRadius.circular(16),
                  // border: Border.all(
                  //   color: Color.fromARGB(255, 208, 207, 204),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 239, 238, 238),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                       color: Color.fromARGB(255, 253, 229, 148),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: Color.fromARGB(255, 223, 188, 72),
                        ),
                      ),
                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: Color(0xFFD97706),
                        size: 25,
                      ),
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${pendingProperties.length} submissions waiting",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Review property and owner documents before approval.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
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

                  suffixIcon: Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF167A3E),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFD6DBD8),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFD6DBD8),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFF167A3E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            // Property list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  25,
                ),

                itemCount: pendingProperties.length,

                separatorBuilder: (context, index) {
                  return SizedBox(height: 14);
                },

                itemBuilder: (context, index) {
                  Map<String, dynamic> property =
                      pendingProperties[index];

                  return buildPropertyCard(property);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPropertyCard(Map<String, dynamic> property) {
    return InkWell(
      onTap: () {
        // NEXT SCREEN
        // Get.to(
        //   () => PropertyReviewScreen(
        //     property: property,
        //   ),
        // );
      },

      borderRadius: BorderRadius.circular(18),

      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Property image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    property["image"],
                    width: 105,
                    height: 105,
                    fit: BoxFit.cover,

                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        width: 105,
                        height: 105,

                        decoration: BoxDecoration(
                          color: Color(0xFFDCEFE3),
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Icon(
                          Icons.home_work_outlined,
                          color: Color(0xFF167A3E),
                          size: 35,
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // Status
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 249, 227),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          "Pending Verification",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 247, 126, 51),
                          ),
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        property["title"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        property["price"],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      SizedBox(height: 7),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Color(0xFF4B5563),
                          ),

                          SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              property["location"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4B5563),
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
              height: 1,
            ),

            SizedBox(height: 13),

            // Owner
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Color(0xFFDCEFE3),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF167A3E),
                    size: 20,
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "House Owner",
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        property["owner"],
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Submitted",
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      property["submitted"],
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14),

            // Review
            SizedBox(
              width: double.infinity,
              height: 46,

              child: ElevatedButton(
                onPressed: () {
                  // NEXT
                  // Get.to(
                  //   () => PropertyReviewScreen(
                  //     property: property,
                  //   ),
                  // );
                  Get.to(() => PropertyReviewScreen());
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      size: 20,
                    ),

                    SizedBox(width: 8),

                    Text(
                      "Review Submission",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}