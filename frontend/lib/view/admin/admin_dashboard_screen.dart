import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_nav_controller.dart';
import 'property_review_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9F8),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Manage and verify rental listings.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
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


              Text(
                "Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: buildStatCard(
                      title: "Total Users",
                      value: "1,248",
                      icon: Icons.people_outline_rounded,
                      iconColor: Color(0xFF2563EB),
                      iconBackground: Color.fromARGB(255, 165, 204, 255),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildStatCard(
                      title: "Properties",
                      value: "356",
                      icon: Icons.home_work_outlined,
                      iconColor: Color(0xFF198754),
                      iconBackground: Color.fromARGB(255, 206, 255, 229),
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
                      icon: Icons.pending_actions_outlined,
                      iconColor: Color(0xFFD97706),
                      iconBackground: Color.fromARGB(255, 253, 229, 148),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: buildStatCard(
                      title: "Suspended",
                      value: "8",
                      icon: Icons.block_outlined,
                      iconColor: Color(0xFFDC2626),
                      iconBackground: Color.fromARGB(255, 255, 208, 208),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Pending verification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    "Pending Verification",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      AdminNavController controller =
                          Get.find<AdminNavController>();

                      controller.changePage(1);
                    },

                    child: Text(
                      "View all",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

                // Pendeing property 1
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

              // Pending property 2
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

              //Quick management
              Text(
                "Quick Management",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              SizedBox(height: 14),

              // Property verification
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

              // Manage properties
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

              // Manage users
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

  // Status card
  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          SizedBox(height: 14),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // Pending property card
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

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Color(0xFFE5E7EB),
          ),
        ),

        child: Row(
          children: [
            // Property image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),

              child: Image.network(
                image,

                width: 90,
                height: 100,

                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 90,
                    height: 100,

                    color: Color(0xFFEAF7F0),

                    child: Icon(
                      Icons.home_work_outlined,
                      color: Color(0xFF198754),
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
                  // Status
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 247, 126, 51),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      "Pending Verification",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 7),

                  // Title
                  Text(
                    title,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  SizedBox(height: 5),

                  // Owner
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          owner,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          location,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Color(0xFF9CA3AF),
                      ),

                      SizedBox(width: 5),

                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 5),

            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  // Management Button

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
            color: Color(0xFFE5E7EB),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),

                borderRadius: BorderRadius.circular(14),
              ),

              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}