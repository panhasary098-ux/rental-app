import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color ownerPrimaryColor = Color(0xFF03045E);
const Color ownerBackgroundColor = Color(0xFFF4FCFE);
const Color ownerLightSecondaryColor = Color(0xFFE6F9FC);

class OwnerHomeScreen extends StatelessWidget {
  OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ownerBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // HEADER
              buildHeader(),

              SizedBox(height: 22),

              // HERO
              buildHeroCard(),

              SizedBox(height: 22),

              // SUMMARY
              buildSummarySection(),

              SizedBox(height: 26),

              // QUICK ACTIONS TITLE
              Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(height: 14),

              // QUICK ACTIONS
              Row(
                children: [
                  Expanded(
                    child: buildQuickAction(
                      icon: Icons.add_home_work_outlined,
                      title: "Post Property",
                      onTap: () {
                        // Navigate to Post Property later
                      },
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildQuickAction(
                      icon: Icons.home_work_outlined,
                      title: "My Properties",
                      onTap: () {
                        // Navigate to My Properties later
                      },
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildQuickAction(
                      icon: Icons.bar_chart_rounded,
                      title: "View Reports",
                      onTap: () {
                        // Reports later
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28),

              // RECENT PROPERTIES TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Recent Properties",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      // Navigate to My Properties later
                    },

                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xFF03045E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // PROPERTY 1
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1564013799919-ab600027ffc6",
                title: "Modern Family House",
                location: "Sen Sok, Phnom Penh",
                price: "\$850 / month",
                rentalStatus: "Available",
                verificationStatus: "Approved",
              ),

              SizedBox(height: 14),

              // PROPERTY 2
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
                title: "BKK1 City Apartment",
                location: "BKK1, Phnom Penh",
                price: "\$550 / month",
                rentalStatus: "Rented",
                verificationStatus: "Approved",
              ),

              SizedBox(height: 14),

              // PROPERTY 3
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
                title: "Toul Kork Room",
                location: "Toul Kork, Phnom Penh",
                price: "\$180 / month",
                rentalStatus: "Available",
                verificationStatus: "Pending",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: ownerLightSecondaryColor,
            shape: BoxShape.circle,
          ),

          alignment: Alignment.center,

          child: Text(
            "DS",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045E),
            ),
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Hello, Dara Sok",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(height: 2),

              Text(
                "House Owner",
                style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),

            border: Border.all(color: Colors.grey.withOpacity(0.25)),
          ),

          child: Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF03045E),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // HERO CARD
  // =========================================================

  Widget buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 235,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
          ),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,

            colors: [
              Color(0xFF03045E).withOpacity(0.95),
              Color(0xFF03045E).withOpacity(0.60),
              Colors.transparent,
            ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "Manage Your\nProperties with\nEase",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.15,
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: 230,

              child: Text(
                "Post, track and manage your rental properties all in one place.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.35,
                ),
              ),
            ),

            SizedBox(height: 12),

            InkWell(
              onTap: () {
                // Navigate to Post Property later
              },

              borderRadius: BorderRadius.circular(30),

              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(Icons.add_rounded, size: 20, color: Color(0xFF03045E)),

                    SizedBox(width: 6),

                    Text(
                      "Post a New Property",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03045E),
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

  // =========================================================
  // SUMMARY
  // =========================================================

  Widget buildSummarySection() {
    return Row(
      children: [
        Expanded(
          child: buildSummaryCard(
            icon: Icons.home_rounded,
            number: "5",
            title: "Total",
            iconBackground: Color(0xFFE6F0FF),
            iconColor: Color(0xFF2563EB),
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: buildSummaryCard(
            icon: Icons.schedule_rounded,
            number: "1",
            title: "Pending",
            iconBackground: Color(0xFFFFF1D6),
            iconColor: Color(0xFFF59E0B),
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: buildSummaryCard(
            icon: Icons.check_circle_rounded,
            number: "3",
            title: "Available",
            iconBackground: Color(0xFFE6F7EE),
            iconColor: Color(0xFF16A34A),
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: buildSummaryCard(
            icon: Icons.key_rounded,
            number: "1",
            title: "Rented",
            iconBackground: Color(0xFFFFE8E8),
            iconColor: Color(0xFFDC2626),
          ),
        ),
      ],
    );
  }

  Widget buildSummaryCard({
    required IconData icon,
    required String number,
    required String title,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 5),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.withOpacity(0.20)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(icon, size: 20, color: iconColor),
          ),

          SizedBox(height: 8),

          Text(
            number,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFF03045E),
            ),
          ),

          SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(fontSize: 9.5, color: Color(0xFF7D8990)),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // QUICK ACTION
  // =========================================================

  Widget buildQuickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        height: 100,

        decoration: BoxDecoration(
          color: ownerLightSecondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 28, color: Color(0xFF03045E)),

            SizedBox(height: 8),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),

              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,

                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF03045E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PROPERTY CARD
  // =========================================================

  Widget buildPropertyCard({
    required String image,
    required String title,
    required String location,
    required String price,
    required String rentalStatus,
    required String verificationStatus,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.22)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),

                child: Image.network(
                  image,
                  width: 115,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                left: 7,
                top: 7,

                child: buildBadge(
                  rentalStatus,
                  rentalStatus == "Available"
                      ? Color(0xFF16A34A)
                      : Color(0xFFDC2626),
                ),
              ),
            ],
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF03045E),
                        ),
                      ),
                    ),

                    Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: Color(0xFF667085),
                    ),
                  ],
                ),

                SizedBox(height: 5),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF7D8990),
                    ),

                    SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7D8990),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 7),

                Text(
                  price,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),

                SizedBox(height: 8),

                Row(
                  children: [
                    buildBadge(
                      verificationStatus,
                      verificationStatus == "Approved"
                          ? Color(0xFF2563EB)
                          : Color(0xFFF59E0B),
                    ),

                    Spacer(),

                    InkWell(
                      onTap: () {
                        showStatusBottomSheet(title, rentalStatus);
                      },

                      borderRadius: BorderRadius.circular(10),

                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          border: Border.all(color: Color(0xFF2563EB)),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.swap_horiz_rounded,
                              size: 15,
                              color: Color(0xFF2563EB),
                            ),

                            SizedBox(width: 3),

                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
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
  // BADGE
  // =========================================================

  Widget buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // =========================================================
  // CHANGE AVAILABILITY BOTTOM SHEET
  // =========================================================

  void showStatusBottomSheet(String propertyName, String currentStatus) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 28),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              propertyName,
              style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),

            SizedBox(height: 20),

            buildStatusOption(
              icon: Icons.check_circle_outline_rounded,
              title: "Available",
              subtitle: "This property is currently open for rent",
              color: Color(0xFF16A34A),
              selected: currentStatus == "Available",

              onTap: () {
                Get.back();

                // Update property to Available later
              },
            ),

            SizedBox(height: 12),

            buildStatusOption(
              icon: Icons.key_rounded,
              title: "Rented",
              subtitle: "This property is currently occupied",
              color: Color(0xFFDC2626),
              selected: currentStatus == "Rented",

              onTap: () {
                Get.back();

                // Update property to Rented later
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
          color: selected ? color.withOpacity(0.08) : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected ? color : Colors.grey.withOpacity(0.30),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 22),
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
                    style: TextStyle(fontSize: 11, color: Color(0xFF7D8990)),
                  ),
                ],
              ),
            ),

            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
