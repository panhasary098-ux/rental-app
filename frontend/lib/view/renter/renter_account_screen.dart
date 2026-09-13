import 'package:final_project/controller/renter_account_controller.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenterAccountScreen extends StatelessWidget {
  RenterAccountScreen({super.key});

  final RenterAccountController controller = Get.put(RenterAccountController());

  void showSuccessNotification({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFE5E7EB),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF7EE),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Color(0xFF15803D),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF15803D),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: const Icon(
          Icons.close_rounded,
          color: Color(0xFF9CA3AF),
          size: 21,
        ),
      ),
    );
  }

  void showErrorNotification({required String title, required String message}) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFF3D2D2),
      borderWidth: 1,
      duration: const Duration(seconds: 3),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
      icon: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFFFDECEC),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.priority_high_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
      ),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 13,
          height: 1.35,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: const Icon(
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
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,

        title: const Text(
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
            icon: const Icon(
              Icons.settings_outlined,
              size: 25,
              color: Color(0xFF03045E),
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF03045E)),
          );
        }

        return SafeArea(
          top: false,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                buildProfileCard(),

                const SizedBox(height: 28),

                buildSectionTitle("Account"),

                const SizedBox(height: 10),

                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: "Personal Information",
                      onTap: () {},
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.favorite_border_rounded,
                      title: "Saved Properties",
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

                const SizedBox(height: 28),

                buildSectionTitle("Support"),

                const SizedBox(height: 10),

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

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      showLogoutDialog();
                    },

                    icon: const Icon(Icons.logout_rounded, size: 20),

                    label: const Text(
                      "Log out",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      backgroundColor: Colors.white,

                      side: BorderSide(
                        color: const Color(0xFFEF4444).withOpacity(0.45),
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

  Widget buildProfileCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.15)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,

            children: [
              Obx(
                () => Container(
                  width: 70,
                  height: 70,

                  decoration: const BoxDecoration(
                    color: Color(0xFFE8E9FF),
                    shape: BoxShape.circle,
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: controller.profileImage.value.isNotEmpty
                      ? Image.network(
                          getProfileImageUrl(controller.profileImage.value),

                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                controller.getInitials(),

                                style: const TextStyle(
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

                            style: const TextStyle(
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
                        color: const Color(0xFF03045E),
                        shape: BoxShape.circle,

                        border: Border.all(color: Colors.white, width: 2),
                      ),

                      child: controller.isUploadingImage.value
                          ? const Padding(
                              padding: EdgeInsets.all(6),

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
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

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Obx(
                  () => Text(
                    controller.name.value,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03045E),
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                Obx(
                  () => Text(
                    controller.email.value,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Obx(
                    () => Text(
                      formatRole(controller.role.value),

                      style: const TextStyle(
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

          const SizedBox(width: 8),

          const Icon(
            Icons.chevron_right_rounded,
            size: 27,
            color: Color(0xFF667085),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF03045E),
        ),
      ),
    );
  }

  Widget buildMenuCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.grey.withOpacity(0.15)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(children: children),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),

        child: Row(
          children: [
            SizedBox(
              width: 30,

              child: Icon(icon, size: 23, color: const Color(0xFF03045E)),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF03045E),
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              size: 23,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 57, right: 14),

      child: Divider(
        height: 1,
        thickness: 0.7,
        color: Colors.grey.withOpacity(0.18),
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        contentPadding: const EdgeInsets.fromLTRB(24, 25, 24, 18),

        content: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 58,
              height: 58,

              decoration: const BoxDecoration(
                color: Color(0xFFFFE8E8),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 27,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Log out",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF03045E),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
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

        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),

                  child: const Text(
                    "Cancel",

                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();

                    try {
                      await AuthService().logout();

                      Get.offAll(() => LoginScreen());

                      Future.delayed(const Duration(milliseconds: 200), () {
                        showSuccessNotification(
                          title: "Logged Out",
                          message: "You have been logged out successfully.",
                        );
                      });
                    } catch (e) {
                      showErrorNotification(
                        title: "Logout Failed",
                        message: "Something went wrong. Please try again.",
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    elevation: 0,

                    padding: const EdgeInsets.symmetric(vertical: 12),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),

                  child: const Text(
                    "Log out",

                    style: TextStyle(fontWeight: FontWeight.w600),
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
    return image.replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");
  }

  if (image.startsWith("http://localhost:8000")) {
    return image.replaceFirst("http://localhost:8000", "http://10.0.2.2:8000");
  }

  if (image.startsWith("http")) {
    return image;
  }

  return "http://10.0.2.2:8000/storage/$image";
}
