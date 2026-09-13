import 'package:final_project/controller/renter_account_controller.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenterAccountScreen extends StatelessWidget {
  RenterAccountScreen({super.key});

  final RenterAccountController controller =
      Get.put(RenterAccountController());

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
            onPressed: () {
              showSettings();
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

            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                18,
                8,
                18,
                20,
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
                        icon:
                            Icons.person_outline_rounded,
                        title:
                            "Personal Information",

                        onTap: () {
                          showEditProfile();
                        },
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon:
                            Icons.favorite_border_rounded,
                        title:
                            "Saved Properties",

                        onTap: () {
                          showNotReady(
                            "Saved Properties",
                          );
                        },
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon: Icons
                            .notifications_none_rounded,
                        title:
                            "Notifications",

                        onTap: () {
                          showNotReady(
                            "Notifications",
                          );
                        },
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
                        icon:
                            Icons.help_outline_rounded,
                        title: "Help Center",

                        onTap: () {
                          showHelpCenter();
                        },
                      ),

                      buildDivider(),

                      buildMenuItem(
                        icon:
                            Icons.info_outline_rounded,
                        title: "About Us",

                        onTap: () {
                          showAboutUs();
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 28),

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

                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            Color(0xFFEF4444),

                        backgroundColor:
                            Colors.white,

                        side: BorderSide(
                          color:
                              Color(0xFFEF4444)
                                  .withValues(
                            alpha: 0.45,
                          ),

                          width: 1.2,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
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

        borderRadius: BorderRadius.circular(
          22,
        ),

        border: Border.all(
          color: Color(0xFFE8EAF0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),

            blurRadius: 18,

            offset: Offset(
              0,
              6,
            ),
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
                    color:
                        Color(0xFFE8E9FF),

                    shape:
                        BoxShape.circle,

                    border: Border.all(
                      color:
                          Colors.white,

                      width: 4,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color:
                            Color(0xFF03045E)
                                .withValues(
                          alpha: 0.10,
                        ),

                        blurRadius: 14,

                        offset: Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  clipBehavior:
                      Clip.antiAlias,

                  child: controller
                          .profileImage
                          .value
                          .isNotEmpty
                      ? Image.network(
                          getProfileImageUrl(
                            controller
                                .profileImage
                                .value,
                          ),

                          fit:
                              BoxFit.cover,

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Center(
                              child: Text(
                                controller
                                    .getInitials(),

                                style:
                                    TextStyle(
                                  fontSize:
                                      30,

                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  color:
                                      Color(
                                    0xFF03045E,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            controller
                                .getInitials(),

                            style:
                                TextStyle(
                              fontSize:
                                  30,

                              fontWeight:
                                  FontWeight
                                      .bold,

                              color:
                                  Color(
                                0xFF03045E,
                              ),
                            ),
                          ),
                        ),
                ),
              ),

              // Camera
              Positioned(
                right: 0,
                bottom: 1,

                child:
                    GestureDetector(
                  onTap: () {
                    controller
                        .pickProfileImage();
                  },

                  child: Obx(
                    () => Container(
                      width: 32,
                      height: 32,

                      decoration:
                          BoxDecoration(
                        color: Color(
                          0xFF03045E,
                        ),

                        shape:
                            BoxShape.circle,

                        border:
                            Border.all(
                          color:
                              Colors.white,

                          width: 3,
                        ),
                      ),

                      child: controller
                              .isUploadingImage
                              .value
                          ? Padding(
                              padding:
                                  EdgeInsets
                                      .all(
                                7,
                              ),

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,

                                color:
                                    Colors.white,
                              ),
                            )
                          : Icon(
                              Icons
                                  .camera_alt_rounded,

                              size: 15,

                              color:
                                  Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 18),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // Name
                Obx(
                  () => Text(
                    controller.name.value,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 19,

                      fontWeight:
                          FontWeight.w800,

                      color:
                          Color(0xFF111827),
                    ),
                  ),
                ),

                SizedBox(height: 5),

                // Email
                Obx(
                  () => Text(
                    controller.email.value,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 12,

                      color:
                          Color(0xFF667085),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Role
                Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Color(0xFFE8E9FF),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Obx(
                    () => Text(
                      formatRole(
                        controller.role.value,
                      ),

                      style: TextStyle(
                        fontSize: 11,

                        fontWeight:
                            FontWeight.w700,

                        color:
                            Color(0xFF03045E),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Edit Profile
                GestureDetector(
                  onTap: () {
                    showEditProfile();
                  },

                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.edit_outlined,

                        size: 15,

                        color:
                            Color(0xFF03045E),
                      ),

                      SizedBox(width: 5),

                      Text(
                        "Edit profile",

                        style: TextStyle(
                          fontSize: 12,

                          fontWeight:
                              FontWeight.w700,

                          color:
                              Color(
                            0xFF03045E,
                          ),
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

          fontWeight:
              FontWeight.bold,

          color:
              Color(0xFF03045E),
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

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        border: Border.all(
          color:
              Color(0xFFE8EAF0),
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

      child: Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),

        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,

              decoration:
                  BoxDecoration(
                color:
                    Color(0xFFF0F1FF),

                borderRadius:
                    BorderRadius.circular(
                  11,
                ),
              ),

              child: Icon(
                icon,

                size: 20,

                color:
                    Color(0xFF03045E),
              ),
            ),

            SizedBox(width: 13),

            Expanded(
              child: Text(
                title,

                style: TextStyle(
                  fontSize: 13,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Color(0xFF111827),
                ),
              ),
            ),

            Icon(
              Icons
                  .chevron_right_rounded,

              size: 22,

              color:
                  Color(0xFF98A2B3),
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

        color:
            Color(0xFFE5E7EB),
      ),
    );
  }

  // Edit Profile
  void showEditProfile() {
    controller.nameController.text =
        controller.name.value;

    controller.phoneController.text =
        controller.phone.value;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          25,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              24,
            ),
          ),
        ),

        child: SafeArea(
          top: false,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,

                    decoration:
                        BoxDecoration(
                      color:
                          Color(0xFFD1D5DB),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Edit Profile",

                  style: TextStyle(
                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(0xFF03045E),
                  ),
                ),

                SizedBox(height: 20),

                // Name
                TextField(
                  controller:
                      controller.nameController,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Full Name",

                    prefixIcon:
                        Icon(
                      Icons
                          .person_outline,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14),

                // Email
                TextField(
                  enabled: false,

                  controller:
                      TextEditingController(
                    text:
                        controller.email.value,
                  ),

                  decoration:
                      InputDecoration(
                    labelText:
                        "Email",

                    prefixIcon:
                        Icon(
                      Icons
                          .email_outlined,
                    ),

                    filled: true,

                    fillColor:
                        Color(0xFFF3F4F6),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14),

                // Phone
                TextField(
                  controller:
                      controller.phoneController,

                  keyboardType:
                      TextInputType.phone,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Phone",

                    prefixIcon:
                        Icon(
                      Icons
                          .phone_outlined,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 22),

                // Save
                Obx(
                  () => SizedBox(
                    width:
                        double.infinity,

                    height: 50,

                    child:
                        ElevatedButton(
                      onPressed: controller
                              .isUpdating
                              .value
                          ? null
                          : () async {
                              bool
                                  success =
                                  await controller
                                      .updateProfile();

                              if (success) {
                                Get.back();
                              }
                            },

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Color(
                          0xFF03045E,
                        ),

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                      ),

                      child: controller
                              .isUpdating
                              .value
                          ? SizedBox(
                              width: 22,
                              height: 22,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,

                                color:
                                    Colors.white,
                              ),
                            )
                          : Text(
                              "Save Changes",

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Settings
  void showSettings() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(
          20,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              24,
            ),
          ),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              ListTile(
                leading: Icon(
                  Icons
                      .person_outline,

                  color:
                      Color(0xFF03045E),
                ),

                title: Text(
                  "Edit Profile",
                ),

                onTap: () {
                  Get.back();

                  showEditProfile();
                },
              ),

              ListTile(
                leading: Icon(
                  Icons
                      .logout_rounded,

                  color:
                      Color(0xFFDC2626),
                ),

                title: Text(
                  "Log out",

                  style: TextStyle(
                    color:
                        Color(0xFFDC2626),
                  ),
                ),

                onTap: () {
                  Get.back();

                  showLogoutDialog();
                },
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Help Center
  void showHelpCenter() {
    Get.dialog(
      AlertDialog(
        backgroundColor:
            Colors.white,

        title: Text(
          "Help Center",

          style: TextStyle(
            color:
                Color(0xFF03045E),

            fontWeight:
                FontWeight.bold,
          ),
        ),

        content: Text(
          "For support with your account or property listings, please contact the JoulNow support team.",
        ),

        actions: [
          TextButton(
            onPressed:
                Get.back,

            child:
                Text("Close"),
          ),
        ],
      ),
    );
  }

  // About Us
  void showAboutUs() {
    Get.dialog(
      AlertDialog(
        backgroundColor:
            Colors.white,

        title: Text(
          "About JoulNow",

          style: TextStyle(
            color:
                Color(0xFF03045E),

            fontWeight:
                FontWeight.bold,
          ),
        ),

        content: Text(
          "JoulNow is a verified rental platform that helps renters find trusted rooms, houses, and apartments.",
        ),

        actions: [
          TextButton(
            onPressed:
                Get.back,

            child:
                Text("Close"),
          ),
        ],
      ),
    );
  }

  // Not Ready
  void showNotReady(
    String feature,
  ) {
    Get.snackbar(
      feature,
      "This feature will be available soon.",

      snackPosition:
          SnackPosition.TOP,

      backgroundColor:
          Color(0xFF03045E),

      colorText:
          Colors.white,
    );
  }

  // Logout
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor:
            Colors.white,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        contentPadding:
            EdgeInsets.fromLTRB(
          24,
          25,
          24,
          18,
        ),

        content: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 58,
              height: 58,

              decoration:
                  BoxDecoration(
                color:
                    Color(0xFFFFE8E8),

                shape:
                    BoxShape.circle,
              ),

              child: Icon(
                Icons.logout_rounded,

                color:
                    Color(0xFFDC2626),

                size: 27,
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Log out",

              style: TextStyle(
                fontSize: 20,

                fontWeight:
                    FontWeight.bold,

                color:
                    Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 8),

            Text(
              "Are you sure you want to log out of your account?",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 13,

                height: 1.4,

                color:
                    Color(0xFF667085),
              ),
            ),
          ],
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child:
                    TextButton(
                  onPressed: () {
                    Get.back();
                  },

                  child: Text(
                    "Cancel",

                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w600,

                      color:
                          Color(
                        0xFF667085,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child:
                    ElevatedButton(
                  onPressed:
                      () async {
                    Get.back();

                    try {
                      await AuthService()
                          .logout();

                      Get.offAll(
                        () =>
                            LoginScreen(),
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Logout Failed",
                        e.toString(),

                        snackPosition:
                            SnackPosition
                                .TOP,

                        backgroundColor:
                            Colors.red,

                        colorText:
                            Colors.white,
                      );
                    }
                  },

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Color(
                      0xFFDC2626,
                    ),

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        11,
                      ),
                    ),
                  ),

                  child: Text(
                    "Log out",

                    style:
                        TextStyle(
                      fontWeight:
                          FontWeight.w600,
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

// Role
String formatRole(String role) {
  if (role == "house_owner") {
    return "House Owner";
  }

  if (role == "admin") {
    return "Admin";
  }

  return "Renter";
}

// Profile Image URL
String getProfileImageUrl(
  String image,
) {
  if (image.isEmpty) {
    return "";
  }

  if (image.startsWith(
    "http://127.0.0.1:8000",
  )) {
    return image.replaceFirst(
      "http://127.0.0.1:8000",
      "http://10.0.2.2:8000",
    );
  }

  if (image.startsWith(
    "http://localhost:8000",
  )) {
    return image.replaceFirst(
      "http://localhost:8000",
      "http://10.0.2.2:8000",
    );
  }

  if (image.startsWith(
    "http",
  )) {
    return image;
  }

  return "http://10.0.2.2:8000/storage/$image";
}