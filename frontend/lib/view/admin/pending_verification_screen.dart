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
          "Pending Verification",
          style: TextStyle(
            color: Color(0xFF1F2923),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // PENDING SUMMARY
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1F2923).withOpacity(0.05),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(
                        color: Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(13),
                      ),

                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: Colors.white,
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
                              color: Color(0xFF1F2923),
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Review property and owner documents before approval.",

                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: Color(0xFF68756D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3D6),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        pendingProperties.length.toString(),

                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SEARCH
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),

              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search property or owner",

                  hintStyle: TextStyle(
                    color: Color(0xFF94A099),
                    fontSize: 14,
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF68756D),
                  ),

                  suffixIcon: Container(
                    margin: EdgeInsets.all(8),

                    decoration: BoxDecoration(
                      color: Color(0xFF90E0EF).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(9),
                    ),

                    child: Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF03045E),
                      size: 20,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFFE1E9E4),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFFE1E9E4),
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

            SizedBox(height: 5),

            // PROPERTY LIST
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

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    return InkWell(
      onTap: () {
        // NEXT SCREEN
        // Get.to(
        //   () => PropertyReviewScreen(
        //     property: property,
        //   ),
        // );
      },

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: Color(0xFFE1E9E4),
          ),

          boxShadow: [
            BoxShadow(
              color: Color(0xFF1F2923).withOpacity(0.035),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // PROPERTY IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),

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
                          color: Color(0xFF90E0EF).withOpacity(0.25),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Icon(
                          Icons.home_work_outlined,
                          color: Color(0xFF03045E),
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
                      // STATUS
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3D6),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Container(
                              width: 6,
                              height: 6,

                              decoration: BoxDecoration(
                                color: Color(0xFFD97706),
                                shape: BoxShape.circle,
                              ),
                            ),

                            SizedBox(width: 5),

                            Text(
                              "Pending Verification",

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB45309),
                              ),
                            ),
                          ],
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
                          color: Color(0xFF1F2923),
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        property["price"],

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF03045E),
                        ),
                      ),

                      SizedBox(height: 7),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: Color(0xFF68756D),
                          ),

                          SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              property["location"],

                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 12,
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

            SizedBox(height: 14),

            Divider(
              color: Color(0xFFE8EEEA),
              height: 1,
            ),

            SizedBox(height: 13),

            // OWNER
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Color(0xFF90E0EF).withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF03045E),
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
                          color: Color(0xFF94A099),
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        property["owner"],

                        style: TextStyle(
                          color: Color(0xFF526058),
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
                        color: Color(0xFF94A099),
                        fontSize: 11,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      property["submitted"],

                      style: TextStyle(
                        color: Color(0xFF68756D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14),

            // REVIEW BUTTON
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
                  backgroundColor: Color(0xFF03045E),
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