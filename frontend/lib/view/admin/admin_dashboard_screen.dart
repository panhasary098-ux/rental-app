import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/admin_nav_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService adminService = AdminService();

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

  // Load real dashboard data
  Future<void> loadDashboard() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      final Map<String, dynamic> data =
          await adminService.getDashboardSummary();

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

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst(
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

  // Fix Laravel localhost URL for Android emulator
  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString();

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

  void goToPendingVerification() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(1);
  }

  void goToManageProperties() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(2);
  }

  void goToManageUsers() {
    final AdminNavController controller =
        Get.find<AdminNavController>();

    controller.changePage(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      body: SafeArea(
        child: isLoading
            ? buildLoadingState()
            : errorMessage != null
                ? buildErrorState()
                : RefreshIndicator(
                    color: const Color(0xFF03045E),

                    onRefresh: loadDashboard,

                    child: SingleChildScrollView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),

                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        30,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          buildHeader(),

                          const SizedBox(height: 28),

                          buildSectionTitle(
                            "Overview",
                          ),

                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: buildStatCard(
                                  title: "Total Users",
                                  value:
                                      totalUsers.toString(),
                                  subtitle:
                                      "Registered accounts",
                                  icon: Icons
                                      .people_outline_rounded,
                                  iconColor:
                                      const Color(
                                    0xFF3B82F6,
                                  ),
                                  iconBackground:
                                      const Color(
                                    0xFFEFF6FF,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: buildStatCard(
                                  title: "Properties",
                                  value: totalProperties
                                      .toString(),
                                  subtitle:
                                      "Rental listings",
                                  icon: Icons
                                      .home_work_outlined,
                                  iconColor:
                                      const Color(
                                    0xFF03045E,
                                  ),
                                  iconBackground:
                                      const Color(
                                    0xFF90E0EF,
                                  ).withOpacity(
                                    0.35,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: buildStatCard(
                                  title: "Pending",
                                  value: pendingProperties
                                      .toString(),
                                  subtitle:
                                      "Needs verification",
                                  icon: Icons
                                      .pending_actions_rounded,
                                  iconColor:
                                      const Color(
                                    0xFFD97706,
                                  ),
                                  iconBackground:
                                      const Color(
                                    0xFFFFF3D6,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: buildStatCard(
                                  title: "Suspended",
                                  value: suspendedUsers
                                      .toString(),
                                  subtitle:
                                      "Restricted accounts",
                                  icon: Icons
                                      .block_outlined,
                                  iconColor:
                                      const Color(
                                    0xFFDC2626,
                                  ),
                                  iconBackground:
                                      const Color(
                                    0xFFFEF2F2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          buildPendingHeader(),

                          const SizedBox(height: 8),

                          buildRecentPending(),

                          const SizedBox(height: 30),

                          buildSectionTitle(
                            "Quick Management",
                          ),

                          const SizedBox(height: 14),

                          buildManagementButton(
                            title:
                                "Property Verification",
                            subtitle:
                                "Review owner documents and property details",
                            icon: Icons
                                .verified_user_outlined,
                            onTap:
                                goToPendingVerification,
                          ),

                          const SizedBox(height: 12),

                          buildManagementButton(
                            title:
                                "Manage Properties",
                            subtitle:
                                "Control property availability and status",
                            icon: Icons
                                .home_work_outlined,
                            onTap:
                                goToManageProperties,
                          ),

                          const SizedBox(height: 12),

                          buildManagementButton(
                            title: "Manage Users",
                            subtitle:
                                "Review renter and house owner accounts",
                            icon: Icons
                                .manage_accounts_outlined,
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

  Widget buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF03045E),
      ),
    );
  }

  Widget buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 72,
              height: 72,

              decoration: const BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline_rounded,
                size: 34,
                color: Color(0xFFDC2626),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Unable to load dashboard",

              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2923),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              errorMessage ?? "",

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF68756D),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: loadDashboard,

              icon: const Icon(
                Icons.refresh_rounded,
              ),

              label: const Text(
                "Try Again",
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF03045E),

                foregroundColor:
                    Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

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

        const SizedBox(width: 15),

        Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: const Color(0xFF03045E),

            borderRadius:
                BorderRadius.circular(15),

            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF03045E,
                ).withOpacity(0.18),

                blurRadius: 12,

                offset:
                    const Offset(0, 4),
              ),
            ],
          ),

          child: const Icon(
            Icons.admin_panel_settings_outlined,
            color: Colors.white,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget buildPendingHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        buildSectionTitle(
          "Pending Verification",
        ),

        TextButton(
          onPressed:
              goToPendingVerification,

          style: TextButton.styleFrom(
            foregroundColor:
                const Color(0xFF03045E),
          ),

          child: const Row(
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
    );
  }

  Widget buildRecentPending() {
    if (recentPending.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(
          vertical: 28,
          horizontal: 20,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: const Color(
              0xFFE1E9E4,
            ),
          ),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.verified_rounded,
              color: Color(0xFF03045E),
              size: 34,
            ),

            SizedBox(height: 10),

            Text(
              "No pending submissions",

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2923),
              ),
            ),

            SizedBox(height: 4),

            Text(
              "All property submissions have been reviewed.",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 11.5,
                color: Color(0xFF68756D),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(
        recentPending.length,
        (index) {
          final Map<String, dynamic> property =
              recentPending[index];

          final Widget card =
              buildPendingPropertyCard(
            title:
                property["title"]?.toString() ??
                    "Property",

            owner:
                property["owner"]?.toString() ??
                    "Unknown Owner",

            location:
                property["location"]?.toString() ??
                    "-",

            date:
                property["submitted"]?.toString() ??
                    "-",

            image: getImageUrl(
              property["image"],
            ),

            onTap:
                goToPendingVerification,
          );

          if (index ==
              recentPending.length - 1) {
            return card;
          }

          return Column(
            children: [
              card,
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget buildSectionTitle(
    String title,
  ) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2923),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE1E9E4),
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF1F2923,
            ).withOpacity(0.035),

            blurRadius: 10,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: iconBackground,

                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),

                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF68756D),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            value,

            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2923),
              height: 1,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            subtitle,

            maxLines: 1,

            overflow:
                TextOverflow.ellipsis,

            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF94A099),
            ),
          ),
        ],
      ),
    );
  }

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
          BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: const Color(
              0xFFE1E9E4,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF1F2923,
              ).withOpacity(0.03),

              blurRadius: 10,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(12),

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

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFFFF3D6,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [
                        Container(
                          width: 6,
                          height: 6,

                          decoration:
                              const BoxDecoration(
                            color: Color(
                              0xFFD97706,
                            ),

                            shape:
                                BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          "Pending",

                          style: TextStyle(
                            color:
                                Color(
                              0xFFB45309,
                            ),

                            fontSize: 10,

                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    title,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF1F2923),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color:
                            Color(0xFF68756D),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          owner,

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 11.5,

                            color: Color(
                              0xFF68756D,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .location_on_outlined,

                        size: 14,

                        color:
                            Color(0xFF68756D),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          location,

                          maxLines: 1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 11.5,

                            color: Color(
                              0xFF68756D,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .calendar_today_outlined,

                        size: 12,

                        color:
                            Color(0xFF94A099),
                      ),

                      const SizedBox(width: 5),

                      Text(
                        date,

                        style:
                            const TextStyle(
                          fontSize: 10.5,

                          color: Color(
                            0xFF94A099,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: const Color(
                  0xFF90E0EF,
                ).withOpacity(0.25),

                shape: BoxShape.circle,
              ),

              child: const Icon(
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

  Widget buildImagePlaceholder() {
    return Container(
      width: 88,
      height: 100,

      color: const Color(
        0xFF90E0EF,
      ).withOpacity(0.25),

      child: const Icon(
        Icons.home_work_outlined,
        color: Color(0xFF03045E),
        size: 30,
      ),
    );
  }

  Widget buildManagementButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: const Color(
              0xFFE1E9E4,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF1F2923,
              ).withOpacity(0.025),

              blurRadius: 10,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,

              decoration: BoxDecoration(
                color: const Color(
                  0xFF90E0EF,
                ).withOpacity(0.30),

                borderRadius:
                    BorderRadius.circular(13),
              ),

              child: Icon(
                icon,
                color: const Color(
                  0xFF03045E,
                ),
                size: 23,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Color(0xFF1F2923),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.3,
                      color:
                          Color(0xFF68756D),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: const Color(
                  0xFF90E0EF,
                ).withOpacity(0.20),

                shape: BoxShape.circle,
              ),

              child: const Icon(
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