import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerAccountScreen extends StatelessWidget {
  OwnerAccountScreen({super.key});

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
          padding: EdgeInsets.fromLTRB(
            18,
            8,
            18,
            24,
          ),

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
                    icon: Icons.home_work_outlined,
                    title: "My Properties",
                    subtitle: "Manage your listed properties",
                    onTap: () {
                      // My properties screen later
                    },
                  ),

                  buildDivider(),

                  buildMenuItem(
                    icon: Icons.verified_user_outlined,
                    title: "Verification Status",
                    subtitle: "Check your account verification",
                    onTap: () {
                      // Verification status screen later
                    },
                  ),

                  buildDivider(),

                  buildMenuItem(
                    icon: Icons.description_outlined,
                    title: "Verification Documents",
                    subtitle: "Upload or view your documents",
                    onTap: () {
                      // Verification documents screen later
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
              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton.icon(
                  onPressed: () {
                    showLogoutDialog();
                  },

                  icon: Icon(
                    Icons.logout_rounded,
                    size: 22,
                  ),

                  label: Text(
                    "Log out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,

                    backgroundColor:
                         Colors.white,

                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.4),
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
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

        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 14,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // PROFILE PHOTO
              Stack(
                clipBehavior: Clip.none,

                children: [
                  Container(
                    width: 88,
                    height: 88,

                    decoration: BoxDecoration(
                      color: Color(0xFF90E0EF)
                          .withOpacity(0.40),

                      shape: BoxShape.circle,

                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.20),

                          blurRadius: 10,

                          offset:
                              Offset(0, 4),
                        ),
                      ],
                    ),

                    alignment: Alignment.center,

                    child: Text(
                      "SL",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            Color(0xFF03045E),
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
                        color:
                            Color(0xFF03045E),

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
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

              // OWNER INFORMATION
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Sophea Lim",

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,

                        color:
                            Color(0xFF03045E),
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      "sophea@gmail.com",

                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 12.5,
                        color:
                            Color(0xFF68756D),
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      "098 888 999",

                      style: TextStyle(
                        fontSize: 12.5,
                        color:
                            Color(0xFF68756D),
                      ),
                    ),

                    SizedBox(height: 9),

                    Container(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Color(0xFF90E0EF)
                            .withOpacity(0.40),

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,

                        children: [
                          Icon(
                            Icons.home_rounded,
                            size: 15,
                            color:
                                Color(0xFF03045E),
                          ),

                          SizedBox(width: 5),

                          Text(
                            "House Owner",

                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w600,

                              color:
                                  Color(0xFF03045E),
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

                icon: Icon(
                  Icons.edit_outlined,
                  size: 15,
                ),

                label: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      Color(0xFF03045E),

                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),

                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.4),
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: buildProfileStat(
                  value: "3",
                  label: "Properties",
                  icon: Icons.home_work_outlined,
                ),
              ),

              Container(
                width: 1,
                height: 38,
                color: Colors.grey.withOpacity(0.4),
              ),

              Expanded(
                child: buildProfileStat(
                  value: "4.8",
                  label: "Rating",
                  icon: Icons.star_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // PROFILE STAT
  Widget buildProfileStat({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              Text(
                value,

                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(width: 4),

              Icon(
                icon,
                size: 18,
                color: Color(0xFF03045E),
              ),
            ],
          ),

          SizedBox(height: 3),

          Text(
            label,

            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF7D8990),
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
  Widget buildMenuCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.18),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: children,
      ),
    );
  }

  // MENU ITEM
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),

        child: Row(
          children: [
            // ICON
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF)
                    .withOpacity(0.30),

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                size: 22,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(width: 13),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,

                      color:
                          Color(0xFF03045E),
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    subtitle,

                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 11.5,

                      color:
                          Color(0xFF7D8990),
                    ),
                  ),
                ],
              ),
            ),

            if (value != null)
              Padding(
                padding:
                    EdgeInsets.only(right: 8),

                child: Text(
                  value,

                  style: TextStyle(
                    fontSize: 12,

                    color:
                        Color(0xFF68756D),
                  ),
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
      padding: EdgeInsets.only(
        left: 70,
        right: 16,
      ),

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

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),

        title: Text(
          "Log out",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF03045E),
          ),
        ),

        content: Text(
          "Are you sure you want to log out?",

          style: TextStyle(
            color: Color(0xFF68756D),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text(
              "Cancel",

              style: TextStyle(
                color: Color(0xFF68756D),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back();

              // Connect logout later
            },

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Color(0xFFDC2626),

              foregroundColor: Colors.white,

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),

            child: Text(
              "Log out",

              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}