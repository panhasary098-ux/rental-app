import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_nav_controller.dart';
import 'property_review_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAF8),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Admin Dashboard",

                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2923),
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Manage and verify rental listings.",

                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF68756D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 15),

                  Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      color: Color(0xFF03045E),
                      borderRadius: BorderRadius.circular(15),

                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF03045E).withOpacity(0.18),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28),

              // OVERVIEW
              buildSectionTitle("Overview"),

              SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: buildStatCard(
                      title: "Total Users",
                      value: "1,248",
                      subtitle: "Registered accounts",
                      icon: Icons.people_outline_rounded,
                      iconColor: Color(0xFF3B82F6),
                      iconBackground: Color(0xFFEFF6FF),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildStatCard(
                      title: "Properties",
                      value: "356",
                      subtitle: "Rental listings",
                      icon: Icons.home_work_outlined,
                      iconColor: Color(0xFF03045E),
                      iconBackground:
                          Color(0xFF90E0EF).withOpacity(0.35),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: buildStatCard(
                      title: "Pending",
                      value: "24",
                      subtitle: "Needs verification",
                      icon: Icons.pending_actions_rounded,
                      iconColor: Color(0xFFD97706),
                      iconBackground: Color(0xFFFFF3D6),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildStatCard(
                      title: "Suspended",
                      value: "8",
                      subtitle: "Restricted accounts",
                      icon: Icons.block_outlined,
                      iconColor: Color(0xFFDC2626),
                      iconBackground: Color(0xFFFEF2F2),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // PENDING VERIFICATION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  buildSectionTitle(
                    "Pending Verification",
                  ),

                  TextButton(
                    onPressed: () {
                      AdminNavController controller =
                          Get.find<AdminNavController>();

                      controller.changePage(1);
                    },

                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFF03045E),
                    ),

                    child: Row(
                      children: [
                        Text(
                          "View all",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF03045E),
                          ),
                        ),

                        SizedBox(width: 3),

                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: Color(0xFF03045E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              // PENDING PROPERTY 1
              buildPendingPropertyCard(
                title: "Modern Room Near University",
                owner: "Dara Sok",
                location: "Toul Kork, Phnom Penh",
                date: "24 Aug 2026",
                image:
                    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",

                onTap: () {
                  Get.to(
                    () => PropertyReviewScreen(),
                  );
                },
              ),

              SizedBox(height: 12),

              // PENDING PROPERTY 2
              buildPendingPropertyCard(
                title: "Affordable Student Apartment",
                owner: "Sophea Lim",
                location: "Sen Sok, Phnom Penh",
                date: "23 Aug 2026",
                image:
                    "https://images.unsplash.com/photo-1502672023488-70e25813eb80",

                onTap: () {
                  Get.to(
                    () => PropertyReviewScreen(),
                  );
                },
              ),

              SizedBox(height: 30),

              // QUICK MANAGEMENT
              buildSectionTitle(
                "Quick Management",
              ),

              SizedBox(height: 14),

              // PROPERTY VERIFICATION
              buildManagementButton(
                title: "Property Verification",
                subtitle:
                    "Review owner documents and property details",
                icon: Icons.verified_user_outlined,

                onTap: () {
                  AdminNavController controller =
                      Get.find<AdminNavController>();

                  controller.changePage(1);
                },
              ),

              SizedBox(height: 12),

              // MANAGE PROPERTIES
              buildManagementButton(
                title: "Manage Properties",
                subtitle:
                    "Control property availability and status",
                icon: Icons.home_work_outlined,

                onTap: () {
                  AdminNavController controller =
                      Get.find<AdminNavController>();

                  controller.changePage(2);
                },
              ),

              SizedBox(height: 12),

              // MANAGE USERS
              buildManagementButton(
                title: "Manage Users",
                subtitle:
                    "Review renter and house owner accounts",
                icon: Icons.manage_accounts_outlined,

                onTap: () {
                  AdminNavController controller =
                      Get.find<AdminNavController>();

                  controller.changePage(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SECTION TITLE
  Widget buildSectionTitle(String title) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2923),
      ),
    );
  }

  // STATUS CARD
  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Color(0xFFE1E9E4),
        ),

        boxShadow: [
          BoxShadow(
            color: Color(0xFF1F2923).withOpacity(0.035),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(11),
                ),

                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF68756D),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            value,

            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2923),
              height: 1,
            ),
          ),

          SizedBox(height: 7),

          Text(
            subtitle,

            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 10.5,
              color: Color(0xFF94A099),
            ),
          ),
        ],
      ),
    );
  }

  // PENDING PROPERTY CARD
  Widget buildPendingPropertyCard({
    required String title,
    required String owner,
    required String location,
    required String date,
    required String image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

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
              color: Color(0xFF1F2923).withOpacity(0.03),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            // PROPERTY IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.network(
                image,

                width: 88,
                height: 100,

                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 88,
                    height: 100,

                    color: Color(0xFF90E0EF).withOpacity(0.25),

                    child: Icon(
                      Icons.home_work_outlined,
                      color: Color(0xFF03045E),
                      size: 30,
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // PENDING STATUS
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                          "Pending",

                          style: TextStyle(
                            color: Color(0xFFB45309),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 7),

                  // TITLE
                  Text(
                    title,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2923),
                    ),
                  ),

                  SizedBox(height: 6),

                  // OWNER
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Color(0xFF68756D),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          owner,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF68756D),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // LOCATION
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF68756D),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          location,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF68756D),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),

                  // DATE
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFF94A099),
                      ),

                      SizedBox(width: 5),

                      Text(
                        date,

                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF94A099),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 5),

            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.25),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF03045E),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MANAGEMENT BUTTON
  Widget buildManagementButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: Color(0xFFE1E9E4),
          ),

          boxShadow: [
            BoxShadow(
              color: Color(0xFF1F2923).withOpacity(0.025),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.30),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(
                icon,
                color: Color(0xFF03045E),
                size: 23,
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2923),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.3,
                      color: Color(0xFF68756D),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.20),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF03045E),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}