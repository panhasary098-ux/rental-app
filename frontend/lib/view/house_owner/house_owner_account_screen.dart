import 'dart:convert';

import 'package:final_project/controller/owner_account_controller.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:final_project/view/house_owner/owner_requests_screen.dart';
import 'package:final_project/view/house_owner/owner_notifications_screen.dart';
import 'package:final_project/view/house_owner/owner_property_detail_screen.dart';
import 'package:final_project/view/house_owner/owner_request_detail_screen.dart';
import 'package:final_project/view/house_owner/post_property/PostPropertyScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:final_project/view/house_owner/send_owner_request_screen.dart';

class OwnerAccountScreen extends StatelessWidget {
  OwnerAccountScreen({super.key});

  final OwnerAccountController controller = Get.put(OwnerAccountController());

  final AuthService authService = AuthService();

  final PropertyService propertyService = PropertyService();

  // Colors
  static const Color primaryColor = Color(0xFF03045E);

  static const Color backgroundColor = Color(0xFFF8FAFC);

  static const Color textColor = Color(0xFF111827);

  static const Color secondaryTextColor = Color(0xFF6B7280);

  static const Color borderColor = Color(0xFFE5E7EB);

  static const Color blueAccent = Color(0xFF2563EB);

  static const Color blueSoft = Color(0xFFEFF6FF);

  static const Color purpleAccent = Color(0xFF7C3AED);

  static const Color purpleSoft = Color(0xFFF3E8FF);

  static const Color orangeAccent = Color(0xFFD97706);

  static const Color orangeSoft = Color(0xFFFFF7E6);

  static const Color greenAccent = Color(0xFF16A34A);

  static const Color greenSoft = Color(0xFFECFDF3);

  static const Color redAccent = Color(0xFFDC2626);

  static const Color redSoft = Color(0xFFFEF2F2);

  // Success
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
      borderColor: borderColor,
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
          color: greenSoft,
          shape: BoxShape.circle,
        ),

        child: const Icon(Icons.check_rounded, color: greenAccent, size: 20),
      ),

      titleText: Text(
        title,

        style: const TextStyle(
          color: greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: const TextStyle(
          color: secondaryTextColor,
          fontSize: 13,
          height: 1.35,
        ),
      ),
    );
  }

  // Error
  void showErrorNotification({required String title, required String message}) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 18,
      borderColor: const Color(0xFFFECACA),
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

        decoration: const BoxDecoration(color: redSoft, shape: BoxShape.circle),

        child: const Icon(
          Icons.priority_high_rounded,
          color: redAccent,
          size: 20,
        ),
      ),

      titleText: Text(
        title,

        style: const TextStyle(
          color: redAccent,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),

      messageText: Text(
        message,

        style: const TextStyle(
          color: secondaryTextColor,
          fontSize: 13,
          height: 1.35,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,

        title: const Text(
          "Account",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: textColor,
            letterSpacing: -0.4,
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),

            child: InkWell(
              onTap: showSettingsSheet,

              borderRadius: BorderRadius.circular(12),

              child: Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: borderColor),
                ),

                child: const Icon(
                  Icons.settings_outlined,
                  size: 21,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        return SafeArea(
          top: false,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Profile
                buildProfileCard(),

                const SizedBox(height: 26),

                // Account
                buildSectionTitle("Account"),

                const SizedBox(height: 10),

                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      iconColor: blueAccent,
                      // iconBackground: blueSoft,
                      title: "Personal Information",
                      subtitle: "View and edit your account details",
                      onTap: showPersonalInformation,
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      iconColor: orangeAccent,
                      // iconBackground: orangeSoft,
                      title: "Notifications",
                      subtitle: "Property and account updates",
                      onTap: openNotifications,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Support
                buildSectionTitle("Support"),

                const SizedBox(height: 10),

                buildMenuCard(
                  children: [
                    buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      iconColor: greenAccent,
                      // iconBackground: greenSoft,
                      title: "Help Center",
                      subtitle: "Answers and owner guidance",
                      onTap: showHelpCenter,
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.support_agent_rounded,
                      iconColor: blueAccent,
                      title: "Send a Request",
                      subtitle: "Contact admin for assistance",
                      onTap: () {
                        Get.to(() => const SendOwnerRequestScreen());
                      },
                    ),
                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.inbox_outlined,
                      iconColor: orangeAccent,
                      title: "My Requests",
                      subtitle: "View your submitted requests",
                      onTap: () {
                        Get.to(() => const OwnerRequestsScreen());
                      },
                    ),

                    buildDivider(),

                    buildMenuItem(
                      icon: Icons.info_outline_rounded,
                      iconColor: purpleAccent,
                      // iconBackground: purpleSoft,
                      title: "About Rental App",
                      subtitle: "Information about the platform",
                      onTap: showAboutSheet,
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                // Logout
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton.icon(
                    onPressed: showLogoutDialog,

                    icon: const Icon(Icons.logout_rounded, size: 19),

                    label: const Text(
                      "Log out",

                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: redAccent,
                      backgroundColor: Colors.white,

                      side: const BorderSide(color: Color(0xFFFECACA)),

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

  // Profile
  Widget buildProfileCard() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: primaryColor,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.18),

            blurRadius: 22,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,

            child: Container(
              width: 150,
              height: 150,

              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),

                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -50,
            left: -30,

            child: Container(
              width: 130,
              height: 130,

              decoration: BoxDecoration(
                color: purpleAccent.withOpacity(0.14),

                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                Row(
                  children: [
                    // Image
                    Stack(
                      children: [
                        Obx(
                          () => Container(
                            width: 90,
                            height: 90,

                            decoration: BoxDecoration(
                              color: Colors.white,

                              shape: BoxShape.circle,

                              border: Border.all(color: Colors.white, width: 4),
                            ),

                            clipBehavior: Clip.antiAlias,

                            child: controller.profileImage.value.isNotEmpty
                                ? Image.network(
                                    getProfileImageUrl(
                                      controller.profileImage.value,
                                    ),

                                    fit: BoxFit.cover,

                                    errorBuilder: (context, error, stackTrace) {
                                      return buildInitialsAvatar();
                                    },
                                  )
                                : buildInitialsAvatar(),
                          ),
                        ),

                        Positioned(
                          bottom: 1,
                          right: 1,

                          child: InkWell(
                            onTap: () {
                              controller.pickProfileImage();
                            },

                            child: Container(
                              width: 30,
                              height: 30,

                              decoration: BoxDecoration(
                                color: purpleAccent,

                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                              ),

                              child: Obx(
                                () => controller.isUploadingImage.value
                                    ? const Padding(
                                        padding: EdgeInsets.all(7),

                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Info
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
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          Obx(
                            () => Text(
                              controller.email.value,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 12,

                                color: Colors.white.withOpacity(0.72),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),

                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: const Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                Icon(
                                  Icons.home_work_outlined,
                                  size: 13,
                                  color: Colors.white,
                                ),

                                SizedBox(width: 5),

                                Text(
                                  "House Owner",

                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: Colors.white,

                                    fontWeight: FontWeight.w700,
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

                const SizedBox(height: 18),

                Container(height: 1, color: Colors.white.withOpacity(0.12)),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,

                  child: buildProfileAction(
                    icon: Icons.edit_outlined,
                    title: "Edit Profile",
                    onTap: showEditProfileSheet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Initials
  Widget buildInitialsAvatar() {
    return Center(
      child: Obx(
        () => Text(
          controller.getInitials(),

          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  // Profile Action
  Widget buildProfileAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 16, color: Colors.white),

            const SizedBox(width: 6),

            Text(
              title,

              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section
  Widget buildSectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
    );
  }

  // Menu Card
  Widget buildMenuCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: borderColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(children: children),
    );
  }

  // Menu Item
  Widget buildMenuItem({
    required IconData icon,
    required Color iconColor,
    // required Color iconBackground,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                // color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, size: 21, color: iconColor),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  // Divider
  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 69, right: 14),

      child: Divider(height: 1, color: borderColor),
    );
  }

  // Personal Info
  void showPersonalInformation() {
    Get.bottomSheet(
      buildSheet(
        title: "Personal Information",

        icon: Icons.person_outline_rounded,

        iconColor: blueAccent,
        iconBackground: blueSoft,

        child: Column(
          children: [
            buildInfoRow("Full Name", controller.name.value),

            buildInfoRow("Email", controller.email.value),

            buildInfoRow(
              "Phone",
              controller.phone.value.isEmpty
                  ? "Not provided"
                  : controller.phone.value,
            ),

            buildInfoRow("Account Type", "House Owner"),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,

              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();

                  showEditProfileSheet();
                },

                icon: const Icon(Icons.edit_outlined, size: 18),

                label: const Text("Edit Information"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Edit Profile
  void showEditProfileSheet() {
    final TextEditingController nameController = TextEditingController(
      text: controller.name.value,
    );

    final TextEditingController phoneController = TextEditingController(
      text: controller.phone.value,
    );

    bool isSaving = false;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return buildSheet(
            title: "Edit Profile",

            icon: Icons.edit_outlined,

            iconColor: purpleAccent,
            iconBackground: purpleSoft,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                buildFieldLabel("Full Name"),

                const SizedBox(height: 7),

                buildTextField(
                  controller: nameController,
                  hint: "Enter your name",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 15),

                buildFieldLabel("Phone Number"),

                const SizedBox(height: 7),

                buildTextField(
                  controller: phoneController,
                  hint: "Enter your phone number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,

                  child: ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () async {
                            final String name = nameController.text.trim();

                            final String phone = phoneController.text.trim();

                            if (name.isEmpty) {
                              showErrorNotification(
                                title: "Name Required",
                                message: "Please enter your name.",
                              );

                              return;
                            }

                            try {
                              setModalState(() {
                                isSaving = true;
                              });

                              await authService.updateCurrentUser(
                                name: name,
                                phone: phone,
                              );

                              await controller.loadUser();

                              Get.back();

                              showSuccessNotification(
                                title: "Profile Updated",
                                message:
                                    "Your profile information was updated successfully.",
                              );
                            } catch (e) {
                              showErrorNotification(
                                title: "Update Failed",
                                message: e.toString().replaceFirst(
                                  "Exception: ",
                                  "",
                                ),
                              );
                            } finally {
                              setModalState(() {
                                isSaving = false;
                              });
                            }
                          },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),

                    child: isSaving
                        ? const SizedBox(
                            width: 21,
                            height: 21,

                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Save Changes",

                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      isScrollControlled: true,
    );
  }

  // Settings
  void showSettingsSheet() {
    Get.bottomSheet(
      buildSheet(
        title: "Settings",

        icon: Icons.settings_outlined,

        iconColor: primaryColor,
        iconBackground: blueSoft,

        child: Column(
          children: [
            buildSimpleAction(
              icon: Icons.edit_outlined,
              title: "Edit Profile",
              subtitle: "Update your account information",

              onTap: () {
                Get.back();

                showEditProfileSheet();
              },
            ),

            const SizedBox(height: 10),

            buildSimpleAction(
              icon: Icons.image_outlined,
              title: "Profile Photo",
              subtitle: "Change your profile picture",

              onTap: () {
                Get.back();

                controller.pickProfileImage();
              },
            ),

            const SizedBox(height: 10),

            buildSimpleAction(
              icon: Icons.refresh_rounded,
              title: "Refresh Account",
              subtitle: "Reload your latest information",

              onTap: () async {
                Get.back();

                await controller.loadUser();

                showSuccessNotification(
                  title: "Refreshed",
                  message: "Your account information is up to date.",
                );
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Notifications
  // This uses the same notification flow as the Owner Home bell:
  // property approval/rejection feedback + replies to Owner Requests.
  Future<List<Map<String, dynamic>>> loadPropertiesForNotifications() async {
    try {
      final response = await propertyService.getMyProperties();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          "ACCOUNT NOTIFICATION PROPERTY LOAD FAILED: "
          "${response.statusCode} ${response.body}",
        );

        return [];
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        return [];
      }

      final dynamic rawProperties = decoded["properties"];

      if (rawProperties is! List) {
        return [];
      }

      return rawProperties
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      debugPrint("ACCOUNT NOTIFICATION PROPERTY LOAD ERROR: $e");
      return [];
    }
  }

  String buildNotificationStorageUrl(String path) {
    if (path.trim().isEmpty) {
      return "";
    }

    if (path.startsWith("http://") || path.startsWith("https://")) {
      return path
          .replaceFirst("http://localhost:8000", "http://10.0.2.2:8000")
          .replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");
    }

    String cleanPath = path;

    if (cleanPath.startsWith("/")) {
      cleanPath = cleanPath.substring(1);
    }

    if (cleanPath.startsWith("storage/")) {
      return "http://10.0.2.2:8000/$cleanPath";
    }

    return "http://10.0.2.2:8000/storage/$cleanPath";
  }

  Future<List<OwnerAdminFeedback>> loadCombinedNotifications() async {
    final List<OwnerAdminFeedback> items = [];

    // 1. Property submission notifications.
    try {
      final response = await propertyService.getOwnerNotifications();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          final dynamic rawNotifications = decoded["notifications"];

          if (rawNotifications is List) {
            for (final dynamic rawItem in rawNotifications) {
              if (rawItem is! Map) {
                continue;
              }

              final Map<String, dynamic> data = Map<String, dynamic>.from(
                rawItem,
              );

              final String rawImage = data["property_image"]?.toString() ?? "";

              final bool isNew =
                  data["is_new"] == true || data["is_new"]?.toString() == "1";

              items.add(
                OwnerAdminFeedback(
                  id: int.tryParse(data["id"]?.toString() ?? "") ?? 0,
                  propertyId:
                      int.tryParse(data["property_id"]?.toString() ?? "") ?? 0,
                  propertyName: data["property_name"]?.toString() ?? "Property",
                  propertyImage: rawImage.isEmpty
                      ? ""
                      : buildNotificationStorageUrl(rawImage),
                  location: data["location"]?.toString() ?? "-",
                  type: data["type"]?.toString() ?? "",
                  notificationKind: "property",
                  reason: data["reason"]?.toString(),
                  note: data["note"]?.toString(),
                  createdAt:
                      DateTime.tryParse(data["created_at"]?.toString() ?? "") ??
                      DateTime.now(),
                  isNew: isNew,
                ),
              );
            }
          }
        }
      } else {
        debugPrint(
          "ACCOUNT PROPERTY NOTIFICATION LOAD FAILED: "
          "${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("ACCOUNT PROPERTY NOTIFICATION ERROR: $e");
    }

    // 2. Admin replies to Owner Requests.
    try {
      final response = await propertyService.getOwnerRequests();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          final dynamic rawRequests = decoded["requests"];

          if (rawRequests is List) {
            for (final dynamic rawItem in rawRequests) {
              if (rawItem is! Map) {
                continue;
              }

              final Map<String, dynamic> data = Map<String, dynamic>.from(
                rawItem,
              );

              final String adminReply =
                  data["admin_reply"]?.toString().trim() ?? "";

              final String repliedAtText =
                  data["replied_at"]?.toString().trim() ?? "";

              // A pending request is not a notification yet.
              if (adminReply.isEmpty || repliedAtText.isEmpty) {
                continue;
              }

              final String ownerSeenAt =
                  data["owner_seen_at"]?.toString().trim() ?? "";

              final int requestId =
                  int.tryParse(data["id"]?.toString() ?? "") ?? 0;

              items.add(
                OwnerAdminFeedback(
                  id: requestId,
                  propertyId: 0,
                  propertyName: "",
                  propertyImage: "",
                  location: "",
                  type: "request_reply",
                  notificationKind: "request",
                  requestId: requestId,
                  requestSubject:
                      data["subject"]?.toString() ?? "Owner Request",
                  requestMessage: data["message"]?.toString() ?? "",
                  adminReply: adminReply,
                  createdAt: DateTime.tryParse(repliedAtText) ?? DateTime.now(),
                  isNew: ownerSeenAt.isEmpty,
                ),
              );
            }
          }
        }
      } else {
        debugPrint(
          "ACCOUNT REQUEST NOTIFICATION LOAD FAILED: "
          "${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("ACCOUNT REQUEST NOTIFICATION ERROR: $e");
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  Map<String, dynamic>? findPropertyForNotification(
    List<Map<String, dynamic>> properties,
    int propertyId,
  ) {
    for (final Map<String, dynamic> property in properties) {
      if (property["id"]?.toString() == propertyId.toString()) {
        return property;
      }
    }

    return null;
  }

  Future<void> openNotifications() async {
    // Show a small loader because Account does not keep the notification
    // list in memory like Home does.
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: primaryColor)),
      barrierDismissible: false,
    );

    try {
      final List<OwnerAdminFeedback> notifications =
          await loadCombinedNotifications();

      final List<Map<String, dynamic>> properties =
          await loadPropertiesForNotifications();

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      final bool hadNewPropertyNotifications = notifications.any(
        (item) => item.isPropertyFeedback && item.isNew,
      );

      final bool hadNewRequestNotifications = notifications.any(
        (item) => item.isRequestReply && item.isNew,
      );

      await Get.to(
        () => OwnerNotificationsScreen(
          notifications: notifications,
          onNotificationsSeen: () {},

          onViewProperty: (notification) {
            final Map<String, dynamic>? property = findPropertyForNotification(
              properties,
              notification.propertyId,
            );

            if (property == null) {
              showErrorNotification(
                title: "Property Not Found",
                message: "This property could not be loaded.",
              );
              return;
            }

            // Close Notifications first, then open the selected property.
            Get.back();

            Get.to(() => OwnerPropertyDetailScreen(property: property));
          },

          onEditAndResubmit: (notification) async {
            final Map<String, dynamic>? property = findPropertyForNotification(
              properties,
              notification.propertyId,
            );

            if (property == null) {
              showErrorNotification(
                title: "Property Not Found",
                message: "This property could not be loaded for editing.",
              );
              return;
            }

            await Get.to(() => Postpropertyscreen(propertyToEdit: property));
          },

          onViewRequest: (notification) {
            Get.to(
              () => OwnerRequestDetailScreen(
                requestId: notification.requestId ?? notification.id,
                subject: notification.requestSubject ?? "Owner Request",
                message: notification.requestMessage ?? "",
                adminReply: notification.adminReply ?? "",
                repliedAt: notification.createdAt,
              ),
            );
          },
        ),
      );

      // Same behavior as Home: once the owner leaves the main notification
      // screen, mark the notifications that were New as seen.
      if (hadNewPropertyNotifications) {
        try {
          final response = await propertyService.markOwnerNotificationsSeen();

          if (response.statusCode < 200 || response.statusCode >= 300) {
            debugPrint(
              "ACCOUNT MARK PROPERTY NOTIFICATIONS SEEN FAILED: "
              "${response.statusCode} ${response.body}",
            );
          }
        } catch (e) {
          debugPrint("ACCOUNT MARK PROPERTY NOTIFICATIONS SEEN ERROR: $e");
        }
      }

      if (hadNewRequestNotifications) {
        try {
          final response = await propertyService
              .markOwnerRequestNotificationsSeen();

          if (response.statusCode < 200 || response.statusCode >= 300) {
            debugPrint(
              "ACCOUNT MARK REQUEST NOTIFICATIONS SEEN FAILED: "
              "${response.statusCode} ${response.body}",
            );
          }
        } catch (e) {
          debugPrint("ACCOUNT MARK REQUEST NOTIFICATIONS SEEN ERROR: $e");
        }
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      showErrorNotification(
        title: "Unable to Load Notifications",
        message: e.toString().replaceFirst("Exception: ", ""),
      );
    }
  }

  // Help
  void showHelpCenter() {
    Get.bottomSheet(
      buildSheet(
        title: "Help Center",

        icon: Icons.help_outline_rounded,

        iconColor: greenAccent,
        iconBackground: greenSoft,

        child: Column(
          children: [
            buildHelpItem(
              "How do I submit a property?",
              "Open the Post tab, complete all required property information, upload verification documents and payment proof, then submit it for admin review.",
            ),

            buildHelpItem(
              "Why is my property not visible yet?",
              "New properties remain unpublished until an admin verifies and approves the submission.",
            ),

            buildHelpItem(
              "How do I manage my property?",
              "Open the Properties tab from the bottom navigation to manage your listings.",
            ),

            buildHelpItem(
              "Why do I need a National ID?",
              "The National ID is used as part of owner verification before property submissions can be trusted by renters.",
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // About
  void showAboutSheet() {
    Get.bottomSheet(
      buildSheet(
        title: "About Rental App",

        icon: Icons.info_outline_rounded,

        iconColor: purpleAccent,
        iconBackground: purpleSoft,

        child: const Column(
          children: [
            Text(
              "Rental App is a verified rental platform designed to help renters find trusted properties and help house owners manage rental listings.",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: secondaryTextColor,
              ),
            ),

            SizedBox(height: 18),

            Text(
              "Version 1.0",

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Sheet
  Widget buildSheet({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required Widget child,
  }) {
    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.85),

      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 44,
              height: 5,

              decoration: BoxDecoration(
                color: borderColor,

                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,

                  decoration: BoxDecoration(
                    color: iconBackground,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(icon, color: iconColor, size: 21),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: Get.back,

                  icon: const Icon(
                    Icons.close_rounded,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            child,
          ],
        ),
      ),
    );
  }

  // Info Row
  Widget buildInfoRow(String title, String value) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(fontSize: 10.5, color: secondaryTextColor),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Label
  Widget buildFieldLabel(String text) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  // Field
  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon, color: secondaryTextColor),

        filled: true,
        fillColor: backgroundColor,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),

          borderSide: const BorderSide(color: borderColor),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),

          borderSide: const BorderSide(color: primaryColor, width: 1.4),
        ),
      ),
    );
  }

  // Action
  Widget buildSimpleAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(14),

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius: BorderRadius.circular(14),

          border: Border.all(color: borderColor),
        ),

        child: Row(
          children: [
            Icon(icon, color: primaryColor),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }

  // Help
  Widget buildHelpItem(String question, String answer) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,

      childrenPadding: const EdgeInsets.only(bottom: 12),

      title: Text(
        question,

        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),

      children: [
        Text(
          answer,

          style: const TextStyle(
            fontSize: 12,
            height: 1.45,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  // Logout
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
                color: redSoft,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.logout_rounded,
                color: redAccent,
                size: 27,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Log out?",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Are you sure you want to log out of your account?",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),

        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },

                  child: const Text("Cancel"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();

                    try {
                      await authService.logout();

                      Get.offAll(() => LoginScreen());
                    } catch (e) {
                      showErrorNotification(
                        title: "Logout Failed",
                        message: "Something went wrong. Please try again.",
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),

                  child: const Text("Log out"),
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
