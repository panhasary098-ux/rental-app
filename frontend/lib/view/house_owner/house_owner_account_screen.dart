import 'package:final_project/controller/owner_account_controller.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerAccountScreen extends StatelessWidget {
  OwnerAccountScreen({super.key});

  final OwnerAccountController controller =
      Get.put(OwnerAccountController());

  void showSuccessNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      borderRadius: 18,
      borderColor: Color(0xFFE5E7EB),
      borderWidth: 1,
      duration: Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFEAF7EE),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_rounded,
          color: Color(0xFF15803D),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: TextStyle(
          color: Color(0xFF15803D),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  void showErrorNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      borderRadius: 18,
      borderColor: Color(0xFFF3D2D2),
      borderWidth: 1,
      duration: Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Color(0xFFFDECEC),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.priority_high_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: false,

      // App Bar
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
            onPressed: () {},
            icon: Icon(
              Icons.settings_outlined,
              size: 25,
              color: Color(0xFF03045E),
            ),
          ),

          SizedBox(width: 10),
        ],
      ),

      // Body
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFF03045E),
              ),
            );
          }

          return SafeArea(
            top: false,

            child: Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                8,
                18,
                14,
              ),

              child: Column(
                children: [
                  // Profile
                  buildProfileCard(),

                  SizedBox(height: 16),

                  // Account
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildSectionTitle(
                      "Account",
                    ),
                  ),

                  SizedBox(height: 8),

                  buildMenuCard(
                    children: [
                      buildMenuItem(
                        icon: Icons.person_outline_rounded,
                        title: "Personal Information",
                        onTap: () {},
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon: Icons.home_outlined,
                        title: "My Properties",
                        onTap: () {},
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: "Notifications",
                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: 14),

                  // Support
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildSectionTitle(
                      "Support",
                    ),
                  ),

                  SizedBox(height: 8),

                  buildMenuCard(
                    children: [
                      buildMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: "Help Center",
                        onTap: () {},
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon: Icons.info_outline_rounded,
                        title: "About Us",
                        onTap: () {},
                      ),
                    ],
                  ),

                  Spacer(),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: OutlinedButton.icon(
                      onPressed: () {
                        showLogoutDialog();
                      },

                      icon: Icon(
                        Icons.logout_rounded,
                        size: 19,
                      ),

                      label: Text(
                        "Log out",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFFEF4444),
                        backgroundColor: Colors.white,

                        side: BorderSide(
                          color: Color(0xFFEF4444)
                              .withValues(alpha: 0.45),
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
        },
      ),
    );
  }

  // Profile
  Widget buildProfileCard() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: Color(0xFFE8EAF0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          // Profile Image
          Stack(
            clipBehavior: Clip.none,

            children: [
              Obx(
                () => Container(
                  width: 98,
                  height: 98,

                  decoration: BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF03045E)
                            .withValues(alpha: 0.10),
                        blurRadius: 14,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: controller.profileImage.value.isNotEmpty
                      ? Image.network(
                          getProfileImageUrl(
                            controller.profileImage.value,
                          ),
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
                                  fontSize: 30,
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
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF03045E),
                            ),
                          ),
                        ),
                ),
              ),

              // Camera
              Positioned(
                right: 0,
                bottom: 1,

                child: GestureDetector(
                  onTap: () {
                    controller.pickProfileImage();
                  },

                  child: Obx(
                    () => Container(
                      width: 32,
                      height: 32,

                      decoration: BoxDecoration(
                        color: Color(0xFF03045E),
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),

                      child: controller.isUploadingImage.value
                          ? Padding(
                              padding: EdgeInsets.all(7),

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 18),

          // User Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Name
                Obx(
                  () => Text(
                    controller.name.value,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),

                SizedBox(height: 5),

                // Email
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

                SizedBox(height: 10),

                // Role
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Obx(
                    () => Text(
                      controller.role.value == "house_owner"
                          ? "House Owner"
                          : controller.role.value,

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF03045E),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Edit Profile
                GestureDetector(
                  onTap: () {},

                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 15,
                        color: Color(0xFF03045E),
                      ),

                      SizedBox(width: 5),

                      Text(
                        "Edit profile",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF03045E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: 2,
      ),

      child: Text(
        title,

        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF03045E),
        ),
      ),
    );
  }

  // Menu Card
  Widget buildMenuCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Color(0xFFE8EAF0),
        ),
      ),

      child: Column(
        children: children,
      ),
    );
  }

  // Menu Item
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
          horizontal: 14,
          vertical: 11,
        ),

        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: Color(0xFFF0F1FF),
                borderRadius: BorderRadius.circular(11),
              ),

              child: Icon(
                icon,
                size: 20,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(width: 13),

            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }

  // Divider
  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.only(
        left: 63,
        right: 14,
      ),

      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Color(0xFFE5E7EB),
      ),
    );
  }

  // Logout
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

                      Future.delayed(
                        Duration(milliseconds: 200),
                        () {
                          showSuccessNotification(
                            title: "Logged Out",
                            message:
                                "You have been logged out successfully.",
                          );
                        },
                      );
                    } catch (e) {
                      showErrorNotification(
                        title: "Logout Failed",
                        message:
                            "Something went wrong. Please try again.",
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

// Profile Image URL
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