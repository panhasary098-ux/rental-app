import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenterAccountScreen extends StatelessWidget {
  RenterAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        title: Text(
          "Account",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045E),
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // PROFILE CARD
              buildProfileCard(),

              SizedBox(height: 22),

              // ACCOUNT
              buildSectionTitle("Account"),

              SizedBox(height: 9),

              buildMenuCard(
                children: [
                  buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: "Personal Information",
                    subtitle: "Update your profile details",
                    onTap: () {
                      // Personal information screen later
                    },
                  ),

                  buildDivider(),

                  buildMenuItem(
                    icon: Icons.favorite_border_rounded,
                    title: "Saved Properties",
                    subtitle: "View your saved rental properties",
                    onTap: () {
                      // Saved properties screen later
                    },
                  ),

                  buildDivider(),

                  buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: "Notifications",
                    subtitle: "Manage your notifications",
                    onTap: () {
                      // Notifications screen later
                    },
                  ),
                ],
              ),

              SizedBox(height: 22),

              // SUPPORT
              buildSectionTitle("Support"),

              SizedBox(height: 9),

              buildMenuCard(
                children: [
                  buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: "Help Center",
                    subtitle: "Find answers to common questions",
                    onTap: () {},
                  ),

                  buildDivider(),

                  buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: "About Us",
                    subtitle: "Learn more about our app",
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 26),

              // LOGOUT
              Container(
                width: double.infinity,
                height: 52,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Colors.grey.withOpacity(0.25)),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.10),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Material(
                  color: Colors.transparent,

                  child: InkWell(
                    onTap: () {
                      showLogoutDialog();
                    },

                    borderRadius: BorderRadius.circular(16),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: Color(0xFFDC2626),
                        ),

                        SizedBox(width: 9),

                        Text(
                          "Log out",

                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                          ),
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

  // PROFILE CARD
  Widget buildProfileCard() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.grey.withOpacity(0.4)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 14,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // PROFILE PHOTO
          Stack(
            clipBehavior: Clip.none,

            children: [
              Container(
                width: 88,
                height: 88,

                decoration: BoxDecoration(
                  color: Color(0xFF90E0EF).withOpacity(0.40),

                  shape: BoxShape.circle,

                  border: Border.all(color: Colors.white, width: 4),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.20),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                alignment: Alignment.center,

                child: Text(
                  "DS",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),
              ),

              Positioned(
                right: -2,
                bottom: -1,

                child: Container(
                  width: 33,
                  height: 33,

                  decoration: BoxDecoration(
                    color: Color(0xFF03045E),

                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 3),
                  ),

                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 15),

          // RENTER INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Dara Sok",

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045E),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "dara@gmail.com",

                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(fontSize: 12.5, color: Color(0xFF68756D)),
                ),

                SizedBox(height: 3),

                Text(
                  "012 345 678",

                  style: TextStyle(fontSize: 12.5, color: Color(0xFF68756D)),
                ),

                SizedBox(height: 9),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                  decoration: BoxDecoration(
                    color: Color(0xFF90E0EF).withOpacity(0.40),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.person_rounded,
                        size: 15,
                        color: Color(0xFF03045E),
                      ),

                      SizedBox(width: 5),

                      Text(
                        "Renter",

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF03045E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          // EDIT PROFILE
          OutlinedButton.icon(
            onPressed: () {
              // Edit profile later
            },

            icon: Icon(Icons.edit_outlined, size: 15),

            label: Text(
              "Edit",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),

            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF03045E),

              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),

              side: BorderSide(color: Colors.grey.withOpacity(0.4)),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION TITLE
  Widget buildSectionTitle(String title) {
    return Text(
      title,

      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Color(0xFF03045E),
      ),
    );
  }

  // MENU CARD
  Widget buildMenuCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.4)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(children: children),
    );
  }

  // MENU ITEM
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),

        child: Row(
          children: [
            // ICON
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.30),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, size: 22, color: Color(0xFF03045E)),
            ),

            SizedBox(width: 13),

            // TEXT
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

                  SizedBox(height: 2),

                  Text(
                    subtitle,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(fontSize: 11.5, color: Color(0xFF7D8990)),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF667085),
            ),
          ],
        ),
      ),
    );
  }

  // DIVIDER
  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 70, right: 16),

      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Colors.grey.withOpacity(0.4),
      ),
    );
  }

  // LOGOUT DIALOG
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        titlePadding: EdgeInsets.fromLTRB(22, 22, 22, 0),

        contentPadding: EdgeInsets.fromLTRB(22, 12, 22, 20),

        actionsPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                color: Color(0xFFDC2626).withOpacity(0.08),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.logout_rounded,
                size: 20,
                color: Color(0xFFDC2626),
              ),
            ),

            SizedBox(width: 12),

            Text(
              "Log out",

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),
          ],
        ),

        content: Text(
          "Are you sure you want to log out of your account?",

          style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF68756D)),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            style: TextButton.styleFrom(foregroundColor: Color(0xFF68756D)),

            child: Text(
              "Cancel",

              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              Get.back();
              try {
                await AuthService().logout();

                Get.offAll(() => LoginScreen());

                Get.snackbar(
                  "Logged Out",
                  "You have been logged out successfully",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  "Logout Failed",
                  e.toString(),
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,

              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 11),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            child: Text(
              "Log out",

              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
