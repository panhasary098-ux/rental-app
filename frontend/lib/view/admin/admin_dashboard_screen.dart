import 'package:final_project/service/admin_service.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_nav_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
  });

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends State<AdminDashboardScreen> {
  final AdminService adminService = AdminService();
  final AuthService authService = AuthService();

  // Colors
  static const Color primaryColor =
      Color(0xFF03045E);

  static const Color backgroundColor =
      Color(0xFFF8FAFC);

  static const Color cardColor =
      Colors.white;

  static const Color textColor =
      Color(0xFF111827);

  static const Color secondaryTextColor =
      Color(0xFF6B7280);

  static const Color borderColor =
      Color(0xFFE5E7EB);

  static const Color blueAccent =
      Color(0xFF2563EB);

  static const Color blueSoft =
      Color(0xFFEFF6FF);

  static const Color purpleAccent =
      Color(0xFF7C3AED);

  static const Color purpleSoft =
      Color(0xFFF3E8FF);

  static const Color orangeAccent =
      Color(0xFFD97706);

  static const Color orangeSoft =
      Color(0xFFFFF7E6);

  static const Color redAccent =
      Color(0xFFDC2626);

  static const Color redSoft =
      Color(0xFFFEF2F2);

  static const Color greenAccent =
      Color(0xFF16A34A);

  static const Color greenSoft =
      Color(0xFFECFDF3);

  bool isLoading = true;

  String? errorMessage;

  int totalUsers = 0;
  int totalProperties = 0;
  int pendingProperties = 0;
  int suspendedUsers = 0;

  List<Map<String, dynamic>> recentPending = [];

  @override
  void initState() {
    super.initState();

    loadDashboard();
  }

  // Load Dashboard
  Future<void> loadDashboard() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      final Map<String, dynamic> data =
          await adminService
              .getDashboardSummary();

      final Map<String, dynamic> stats =
          Map<String, dynamic>.from(
        data["stats"] ?? {},
      );

      final List<dynamic> pending =
          data["recent_pending"] ?? [];

      if (!mounted) {
        return;
      }

      setState(() {
        totalUsers =
            int.tryParse(
              stats["total_users"]
                      ?.toString() ??
                  "0",
            ) ??
            0;

        totalProperties =
            int.tryParse(
              stats["total_properties"]
                      ?.toString() ??
                  "0",
            ) ??
            0;

        pendingProperties =
            int.tryParse(
              stats["pending_properties"]
                      ?.toString() ??
                  "0",
            ) ??
            0;

        suspendedUsers =
            int.tryParse(
              stats["suspended_users"]
                      ?.toString() ??
                  "0",
            ) ??
            0;

        recentPending = pending
            .map(
              (item) =>
                  Map<String, dynamic>.from(
                item,
              ),
            )
            .toList();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message =
          e.toString();

      if (message.startsWith(
        "Exception: ",
      )) {
        message =
            message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      setState(() {
        isLoading = false;
        errorMessage = message;
      });
    }
  }

  // Image URL
  String getImageUrl(
    dynamic value,
  ) {
    if (value == null) {
      return "";
    }

    String url =
        value.toString();

    url = url.replaceFirst(
      "http://localhost:8000",
      "http://10.0.2.2:8000",
    );

    url = url.replaceFirst(
      "http://127.0.0.1:8000",
      "http://10.0.2.2:8000",
    );

    return url;
  }

  // Pending
  void goToPendingVerification() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(1);
  }

  // Properties
  void goToManageProperties() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(2);
  }

  // Users
  void goToManageUsers() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(3);
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
            const EdgeInsets.fromLTRB(
          24,
          26,
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
                  const BoxDecoration(
                color: redSoft,
                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons.logout_rounded,
                color:
                    redAccent,
                size: 27,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              "Leave Admin Panel?",

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                color:
                    textColor,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              "You will be logged out of your admin account.",

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    secondaryTextColor,
              ),
            ),
          ],
        ),

        actionsPadding:
            const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),

        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,

                  child:
                      OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },

                    style:
                        OutlinedButton
                            .styleFrom(
                      foregroundColor:
                          const Color(
                        0xFF374151,
                      ),

                      side:
                          const BorderSide(
                        color:
                            borderColor,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),
                    ),

                    child:
                        const Text(
                      "Cancel",

                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: SizedBox(
                  height: 44,

                  child:
                      ElevatedButton(
                    onPressed:
                        () async {
                      Get.back();

                      try {
                        await authService
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
                              redAccent,

                          colorText:
                              Colors.white,
                        );
                      }
                    },

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          redAccent,

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),
                    ),

                    child:
                        const Text(
                      "Log out",

                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body: SafeArea(
        child: isLoading
            ? buildLoadingState()
            : errorMessage != null
                ? buildErrorState()
                : RefreshIndicator(
                    color:
                        primaryColor,

                    onRefresh:
                        loadDashboard,

                    child:
                        SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      padding:
                          const EdgeInsets.fromLTRB(
                        18,
                        16,
                        18,
                        30,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          buildHeader(),

                          const SizedBox(
                            height: 26,
                          ),

                          buildSectionTitle(
                            "Overview",
                          ),

                          const SizedBox(
                            height: 13,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    buildStatCard(
                                  title:
                                      "Total Users",
                                  value:
                                      totalUsers
                                          .toString(),
                                  subtitle:
                                      "Registered accounts",
                                  icon: Icons
                                      .people_outline_rounded,
                                  iconColor:
                                      blueAccent,
                                  iconBackground:
                                      blueSoft,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child:
                                    buildStatCard(
                                  title:
                                      "Properties",
                                  value:
                                      totalProperties
                                          .toString(),
                                  subtitle:
                                      "Rental listings",
                                  icon: Icons
                                      .home_work_outlined,
                                  iconColor:
                                      purpleAccent,
                                  iconBackground:
                                      purpleSoft,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    buildStatCard(
                                  title:
                                      "Pending",
                                  value:
                                      pendingProperties
                                          .toString(),
                                  subtitle:
                                      "Needs verification",
                                  icon: Icons
                                      .pending_actions_rounded,
                                  iconColor:
                                      orangeAccent,
                                  iconBackground:
                                      orangeSoft,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child:
                                    buildStatCard(
                                  title:
                                      "Suspended",
                                  value:
                                      suspendedUsers
                                          .toString(),
                                  subtitle:
                                      "Restricted accounts",
                                  icon: Icons
                                      .block_outlined,
                                  iconColor:
                                      redAccent,
                                  iconBackground:
                                      redSoft,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          buildPendingHeader(),

                          const SizedBox(
                            height: 10,
                          ),

                          buildRecentPending(),

                          const SizedBox(
                            height: 30,
                          ),

                          buildSectionTitle(
                            "Quick Management",
                          ),

                          const SizedBox(
                            height: 13,
                          ),

                          buildManagementButton(
                            title:
                                "Property Verification",
                            subtitle:
                                "Review property and owner documents",
                            icon: Icons
                                .verified_user_outlined,
                            iconColor:
                                orangeAccent,
                            iconBackground:
                                orangeSoft,
                            onTap:
                                goToPendingVerification,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          buildManagementButton(
                            title:
                                "Manage Properties",
                            subtitle:
                                "Control listings and availability",
                            icon: Icons
                                .home_work_outlined,
                            iconColor:
                                purpleAccent,
                            iconBackground:
                                purpleSoft,
                            onTap:
                                goToManageProperties,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          buildManagementButton(
                            title:
                                "Manage Users",
                            subtitle:
                                "Review renter and owner accounts",
                            icon: Icons
                                .manage_accounts_outlined,
                            iconColor:
                                blueAccent,
                            iconBackground:
                                blueSoft,
                            onTap:
                                goToManageUsers,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  // Loading
  Widget buildLoadingState() {
    return const Center(
      child:
          CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  // Error
  Widget buildErrorState() {
    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration:
                  const BoxDecoration(
                color: redSoft,
                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons
                    .error_outline_rounded,
                size: 33,
                color:
                    redAccent,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              "Unable to load dashboard",

              style: TextStyle(
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
                color:
                    textColor,
              ),
            ),

            const SizedBox(
              height: 7,
            ),

            Text(
              errorMessage ?? "",

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                fontSize: 13,
                color:
                    secondaryTextColor,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            ElevatedButton.icon(
              onPressed:
                  loadDashboard,

              icon:
                  const Icon(
                Icons
                    .refresh_rounded,
              ),

              label:
                  const Text(
                "Try Again",
              ),

              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    primaryColor,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  Widget buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              Text(
                "Admin Dashboard",

                style: TextStyle(
                  fontSize: 25,
                  fontWeight:
                      FontWeight
                          .w800,
                  color:
                      textColor,
                  letterSpacing:
                      -0.4,
                ),
              ),

              SizedBox(
                height: 4,
              ),

              Text(
                "Manage your rental platform.",

                style: TextStyle(
                  fontSize: 13,
                  color:
                      secondaryTextColor,
                ),
              ),
            ],
          ),
        ),

        // Admin
        Container(
          width: 44,
          height: 44,

          decoration:
              BoxDecoration(
            color:
                primaryColor,

            borderRadius:
                BorderRadius.circular(
              13,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    primaryColor
                        .withOpacity(
                  0.16,
                ),

                blurRadius: 12,

                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),

          child:
              const Icon(
            Icons
                .admin_panel_settings_outlined,
            color:
                Colors.white,
            size: 23,
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        // Logout
        InkWell(
          onTap:
              showLogoutDialog,

          borderRadius:
              BorderRadius.circular(
            13,
          ),

          child: Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color:
                  redSoft,

              borderRadius:
                  BorderRadius
                      .circular(
                13,
              ),

              border:
                  Border.all(
                color:
                    const Color(
                  0xFFFECACA,
                ),
              ),
            ),

            child:
                const Icon(
              Icons
                  .logout_rounded,
              color:
                  redAccent,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // Pending Header
  Widget buildPendingHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,

      children: [
        buildSectionTitle(
          "Pending Verification",
        ),

        TextButton(
          onPressed:
              goToPendingVerification,

          style:
              TextButton.styleFrom(
            foregroundColor:
                primaryColor,
          ),

          child: const Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Text(
                "View all",

                style:
                    TextStyle(
                  fontSize:
                      12,
                  fontWeight:
                      FontWeight
                          .w700,
                  color:
                      primaryColor,
                ),
              ),

              SizedBox(
                width: 3,
              ),

              Icon(
                Icons
                    .arrow_forward_rounded,
                size: 16,
                color:
                    primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Recent Pending
  Widget buildRecentPending() {
    if (recentPending.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
            const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),

        decoration:
            BoxDecoration(
          color:
              cardColor,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color:
                borderColor,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withOpacity(
                0.025,
              ),

              blurRadius: 12,

              offset:
                  const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,

              decoration:
                  BoxDecoration(
                color:
                    greenSoft,

                borderRadius:
                    BorderRadius
                        .circular(
                  15,
                ),
              ),

              child:
                  const Icon(
                Icons
                    .verified_rounded,
                color:
                    greenAccent,
                size: 27,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              "No pending submissions",

              style:
                  TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight
                        .w700,
                color:
                    textColor,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              "All property submissions have been reviewed.",

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                fontSize:
                    11.5,
                color:
                    secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          List.generate(
        recentPending.length,
        (index) {
          final Map<String, dynamic>
              property =
              recentPending[index];

          final Widget card =
              buildPendingPropertyCard(
            title:
                property["title"]
                        ?.toString() ??
                    property["name"]
                        ?.toString() ??
                    "Property",

            owner:
                property["owner"]
                        ?.toString() ??
                    "Unknown Owner",

            location:
                property["location"]
                        ?.toString() ??
                    property["address"]
                        ?.toString() ??
                    "-",

            date:
                property["submitted"]
                        ?.toString() ??
                    "-",

            image: getImageUrl(
              property["image"],
            ),

            onTap:
                goToPendingVerification,
          );

          if (index ==
              recentPending.length -
                  1) {
            return card;
          }

          return Column(
            children: [
              card,

              const SizedBox(
                height: 12,
              ),
            ],
          );
        },
      ),
    );
  }

  // Section Title
  Widget buildSectionTitle(
    String title,
  ) {
    return Text(
      title,

      style:
          const TextStyle(
        fontSize: 17,
        fontWeight:
            FontWeight.w800,
        color:
            textColor,
        letterSpacing:
            -0.2,
      ),
    );
  }

  // Stat Card
  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(
        15,
      ),

      decoration:
          BoxDecoration(
        color:
            cardColor,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border:
            Border.all(
          color:
              borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withOpacity(
              0.025,
            ),

            blurRadius: 12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration:
                    BoxDecoration(
                  color:
                      iconBackground,

                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),

                child: Icon(
                  icon,
                  color:
                      iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  title,

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize:
                        11.5,
                    fontWeight:
                        FontWeight
                            .w600,
                    color:
                        secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 29,
              fontWeight:
                  FontWeight
                      .w800,
              color:
                  textColor,
              height: 1,
              letterSpacing:
                  -0.5,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            subtitle,

            maxLines: 1,

            overflow:
                TextOverflow
                    .ellipsis,

            style:
                const TextStyle(
              fontSize:
                  10.5,
              color:
                  Color(
                0xFF9CA3AF,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pending Card
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

      borderRadius:
          BorderRadius.circular(
        18,
      ),

      child: Container(
        padding:
            const EdgeInsets.all(
          12,
        ),

        decoration:
            BoxDecoration(
          color:
              cardColor,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color:
                borderColor,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withOpacity(
                0.025,
              ),

              blurRadius: 12,

              offset:
                  const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius
                      .circular(
                13,
              ),

              child: image.isEmpty
                  ? buildImagePlaceholder()
                  : Image.network(
                      image,

                      width: 88,
                      height: 100,

                      fit: BoxFit.cover,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return buildImagePlaceholder();
                      },
                    ),
            ),

            const SizedBox(
              width: 13,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          8,
                      vertical:
                          4,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          orangeSoft,

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),

                    child:
                        const Text(
                      "Pending",

                      style:
                          TextStyle(
                        color:
                            orangeAccent,

                        fontSize:
                            10,

                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    title,

                    maxLines: 1,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          textColor,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  buildSmallInfo(
                    Icons
                        .person_outline,
                    owner,
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  buildSmallInfo(
                    Icons
                        .location_on_outlined,
                    location,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,
                        size: 12,
                        color:
                            Color(
                          0xFF9CA3AF,
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        date,

                        style:
                            const TextStyle(
                          fontSize:
                              10.5,
                          color:
                              Color(
                            0xFF9CA3AF,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 6,
            ),

            Container(
              width: 32,
              height: 32,

              decoration:
                  const BoxDecoration(
                color:
                    Color(
                  0xFFF3F4F6,
                ),
                shape:
                    BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Small Info
  Widget buildSmallInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        const SizedBox(
          width: 0,
        ),

        Icon(
          icon,
          size: 14,
          color:
              secondaryTextColor,
        ),

        const SizedBox(
          width: 4,
        ),

        Expanded(
          child: Text(
            text,

            maxLines: 1,

            overflow:
                TextOverflow
                    .ellipsis,

            style:
                const TextStyle(
              fontSize:
                  11.5,
              color:
                  secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  // Placeholder
  Widget buildImagePlaceholder() {
    return Container(
      width: 88,
      height: 100,

      color:
          purpleSoft,

      child:
          const Icon(
        Icons
            .home_work_outlined,
        color:
            purpleAccent,
        size: 30,
      ),
    );
  }

  // Management Button
  Widget buildManagementButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(
        18,
      ),

      child: Container(
        padding:
            const EdgeInsets.all(
          15,
        ),

        decoration:
            BoxDecoration(
          color:
              cardColor,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color:
                borderColor,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withOpacity(
                0.02,
              ),

              blurRadius: 12,

              offset:
                  const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration:
                  BoxDecoration(
                color:
                    iconBackground,

                borderRadius:
                    BorderRadius
                        .circular(
                  13,
                ),
              ),

              child: Icon(
                icon,
                color:
                    iconColor,
                size: 22,
              ),
            ),

            const SizedBox(
              width: 14,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight
                              .w700,
                      color:
                          textColor,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    subtitle,

                    style:
                        const TextStyle(
                      fontSize:
                          11.5,
                      height: 1.3,
                      color:
                          secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 32,
              height: 32,

              decoration:
                  BoxDecoration(
                color:
                    iconBackground,

                shape:
                    BoxShape.circle,
              ),

              child: Icon(
                Icons
                    .chevron_right_rounded,
                color:
                    iconColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}