import 'package:final_project/controller/renter_account_controller.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenterAccountScreen extends StatelessWidget {
  RenterAccountScreen({super.key});

  final RenterAccountController controller = Get.put(RenterAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,

        title: Text(
          "Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045E),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // Settings later
            },

            icon: Icon(
              Icons.settings_outlined,
              size: 25,
              color: Color(0xFF03045E),
            ),
          ),

          SizedBox(width: 10),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return SafeArea(
          top: false,

          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(18, 10, 18, 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // PROFILE
                buildProfileCard(),

                SizedBox(height: 28),

                // ACCOUNT
                buildSectionTitle("Account"),

                SizedBox(height: 10),

                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: "Personal Information",
                      onTap: () {
                        // Personal Information later
                      },
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.favorite_border_rounded,
                      title: "Saved Properties",
                      onTap: () {
                        // Saved Properties later
                      },
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: "Notifications",
                      onTap: () {
                        // Notifications later
                      },
                    ),
                  ],
                ),

                SizedBox(height: 28),

                // SUPPORT
                buildSectionTitle("Support"),

                SizedBox(height: 10),

                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: "Help Center",
                      onTap: () {
                        // Help Center later
                      },
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: "About Us",
                      onTap: () {
                        // About Us later
                      },
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // LOGOUT
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      showLogoutDialog();
                    },

                    icon: Icon(
                      Icons.logout_rounded,
                      size: 20,
                    ),

                    label: Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFEF4444),
                      backgroundColor: Colors.white,

                      side: BorderSide(
                        color: Color(0xFFEF4444).withOpacity(0.45),
                        width: 1.2,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // =========================================================
  // PROFILE CARD
  // =========================================================

  Widget buildProfileCard() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // PROFILE IMAGE
          Stack(
            clipBehavior: Clip.none,

            children: [
              Obx(
                () => Container(
                  width: 70,
                  height: 70,

                  decoration: BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    shape: BoxShape.circle,
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: controller.profileImage.value.isNotEmpty
                      ? Image.network(
                          getProfileImageUrl(
                            controller.profileImage.value,
                          ),

                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Center(
                              child: Text(
                                controller.getInitials(),

                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF03045E),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            controller.getInitials(),

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF03045E),
                            ),
                          ),
                        ),
                ),
              ),

              Positioned(
                right: -1,
                bottom: -1,

                child: GestureDetector(
                  onTap: () {
                    controller.pickProfileImage();
                  },

                  child: Obx(
                    () => Container(
                      width: 25,
                      height: 25,

                      decoration: BoxDecoration(
                        color: Color(0xFF03045E),
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),

                      child: controller.isUploadingImage.value
                          ? Padding(
                              padding: EdgeInsets.all(6),

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 14),

          // RENTER INFORMATION
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Obx(
                  () => Text(
                    controller.name.value,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                    ),
                  ),
                ),

                SizedBox(height: 3),

                Obx(
                  () => Text(
                    controller.email.value,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),

                SizedBox(height: 7),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Obx(
                    () => Text(
                      formatRole(
                        controller.role.value,
                      ),

                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF03045E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          Icon(
            Icons.chevron_right_rounded,
            size: 27,
            color: Color(0xFF667085),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2),

      child: Text(
        title,

        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF03045E),
        ),
      ),
    );
  }

  // =========================================================
  // MENU CARD
  // =========================================================

  Widget buildMenuCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.withOpacity(0.15),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  // =========================================================
  // MENU ITEM
  // =========================================================

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
        ),

        child: Row(
          children: [
            SizedBox(
              width: 30,

              child: Icon(
                icon,
                size: 23,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF03045E),
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: 23,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================

  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.only(
        left: 57,
        right: 14,
      ),

      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Colors.grey.withOpacity(0.18),
      ),
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        contentPadding: EdgeInsets.fromLTRB(
          24,
          25,
          24,
          18,
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                color: Color(0xFFFFE8E8),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 27,
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Log out",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Are you sure you want to log out of your account?",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),

        actionsPadding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                  ),

                  child: Text(
                    "Cancel",

                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();

                    try {
                      await AuthService().logout();

                      Get.offAll(
                        () => LoginScreen(),
                      );

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

                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),

                  child: Text(
                    "Log out",

                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatRole(String role) {
  if (role == "house_owner") {
    return "House Owner";
  }

  if (role == "admin") {
    return "Admin";
  }

  return "Renter";
}

String getProfileImageUrl(String image) {
  if (image.isEmpty) {
    return "";
  }

  if (image.startsWith("http://127.0.0.1:8000")) {
    return image.replaceFirst(
      "http://127.0.0.1:8000",
      "http://10.0.2.2:8000",
    );
  }

  if (image.startsWith("http://localhost:8000")) {
    return image.replaceFirst(
      "http://localhost:8000",
      "http://10.0.2.2:8000",
    );
  }

  if (image.startsWith("http")) {
    return image;
  }

  return "http://10.0.2.2:8000/storage/$image";
}