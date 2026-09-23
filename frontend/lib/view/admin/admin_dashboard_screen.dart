import 'dart:convert';

import 'package:final_project/controller/admin_nav_controller.dart';
import 'package:final_project/service/admin_service.dart';
import 'package:final_project/service/auth_service.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/admin/admin_owner_requests_screen.dart';
import 'package:final_project/view/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService adminService = AdminService();
  final AuthService authService = AuthService();
  final PropertyService propertyService = PropertyService();

  // Colors
  static Color primaryColor = Color(0xFF03045E);
  static Color backgroundColor = Color(0xFFF6F7FB);
  static Color cardColor = Colors.white;

  static Color textColor = Color(0xFF111827);
  static Color secondaryTextColor = Color(0xFF6B7280);
  static Color borderColor = Color(0xFFE8EAF0);

  static Color blueAccent = Color(0xFF2563EB);
  static Color blueSoft = Color(0xFFEFF6FF);

  static Color purpleAccent = Color(0xFF7C3AED);
  static Color purpleSoft = Color(0xFFF5F3FF);

  static Color orangeAccent = Color(0xFFD97706);
  static Color orangeSoft = Color(0xFFFFF7ED);

  static Color redAccent = Color(0xFFDC2626);
  static Color redSoft = Color(0xFFFEF2F2);

  static Color greenAccent = Color(0xFF16A34A);
  static Color greenSoft = Color(0xFFF0FDF4);

  bool isLoading = true;

  String? errorMessage;

  int totalUsers = 0;
  int totalProperties = 0;
  int pendingProperties = 0;
  int suspendedUsers = 0;
  int pendingOwnerRequests = 0;

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

      final Map<String, dynamic> data = await adminService
          .getDashboardSummary();

      // Load pending owner request count separately.
      // If this request fails, the rest of the dashboard can still load.
      int ownerRequestCount = 0;

      try {
        final response = await propertyService.getAdminOwnerRequests();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final dynamic decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            final dynamic rawRequests = decoded["requests"];

            if (rawRequests is List) {
              ownerRequestCount = rawRequests.where((request) {
                if (request is! Map) {
                  return false;
                }

                return request["status"]?.toString().toLowerCase() == "pending";
              }).length;
            }
          }
        } else {
          debugPrint(
            "FAILED TO LOAD OWNER REQUEST COUNT: "
            "${response.statusCode} ${response.body}",
          );
        }
      } catch (e) {
        debugPrint("OWNER REQUEST COUNT ERROR: $e");
      }

      final Map<String, dynamic> stats = Map<String, dynamic>.from(
        data["stats"] ?? {},
      );

      final List<dynamic> pending = data["recent_pending"] ?? [];

      if (!mounted) {
        return;
      }

      setState(() {
        totalUsers = int.tryParse(stats["total_users"]?.toString() ?? "0") ?? 0;

        totalProperties =
            int.tryParse(stats["total_properties"]?.toString() ?? "0") ?? 0;

        pendingProperties =
            int.tryParse(stats["pending_properties"]?.toString() ?? "0") ?? 0;

        suspendedUsers =
            int.tryParse(stats["suspended_users"]?.toString() ?? "0") ?? 0;

        pendingOwnerRequests = ownerRequestCount;

        recentPending = pending
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      setState(() {
        isLoading = false;
        errorMessage = message;
      });
    }
  }

  // Image URL
  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString();

    url = url.replaceFirst("http://localhost:8000", "http://10.0.2.2:8000");

    url = url.replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");

    return url;
  }

  // Pending
  void goToPendingVerification() {
    final AdminNavController controller = Get.find<AdminNavController>();

    controller.changePage(1);
  }

  // Properties
  void goToManageProperties() {
    final AdminNavController controller = Get.find<AdminNavController>();

    controller.changePage(2);
  }

  // Users
  void goToManageUsers() {
    final AdminNavController controller = Get.find<AdminNavController>();

    controller.changePage(3);
  }

  // Owner Requests
  Future<void> goToOwnerRequests() async {
    await Get.to(() => const AdminOwnerRequestsScreen());

    if (!mounted) {
      return;
    }

    await loadDashboard();
  }

  // Logout
  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        contentPadding: EdgeInsets.fromLTRB(24, 26, 24, 18),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: redSoft, shape: BoxShape.circle),
              child: Icon(Icons.logout_rounded, color: redAccent, size: 27),
            ),
            SizedBox(height: 16),
            Text(
              "Leave Admin Panel?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "You will be logged out of your admin account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF374151),
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();

                      try {
                        await authService.logout();

                        Get.offAll(() => LoginScreen());
                      } catch (e) {
                        Get.snackbar(
                          "Logout Failed",
                          e.toString(),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Log out",
                      style: TextStyle(fontWeight: FontWeight.w600),
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
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: isLoading
              ? buildLoadingState()
              : errorMessage != null
              ? buildErrorState()
              : RefreshIndicator(
                  color: primaryColor,
                  onRefresh: loadDashboard,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildHeader(),

                        SizedBox(height: 16),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: buildStats(),
                        ),

                        SizedBox(height: 12),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: buildOwnerRequestsCard(),
                        ),

                        SizedBox(height: 20),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: buildPendingHeader(),
                        ),

                        SizedBox(height: 8),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: buildRecentPending(),
                        ),

                        SizedBox(height: 18),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: buildCommunityBanner(),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Loading
  Widget buildLoadingState() {
    return Center(child: CircularProgressIndicator(color: primaryColor));
  }

  // Error
  Widget buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: redSoft,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 33,
                color: redAccent,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Unable to load dashboard",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 7),
            Text(
              errorMessage ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: secondaryTextColor),
            ),
            SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: loadDashboard,
              icon: Icon(Icons.refresh_rounded),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16, 30, 16, 0),
      padding: EdgeInsets.fromLTRB(18, 16, 16, 17),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.home_work_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "JoulNow Admin",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: loadDashboard,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              SizedBox(width: 7),

              InkWell(
                onTap: showLogoutDialog,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Welcome back, ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                TextSpan(
                  text: "JoulNow Team",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stats
  Widget buildStats() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F1FA),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.dashboard_outlined,
                  color: primaryColor,
                  size: 19,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Platform Overview",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Current platform activity",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: greenSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Live",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18),
          Container(height: 1, color: borderColor),
          SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: buildDashboardStatItem(
                  value: totalUsers.toString(),
                  label: "Users",
                  icon: Icons.people_alt_outlined,
                ),
              ),
              buildDashboardDivider(),
              Expanded(
                child: buildDashboardStatItem(
                  value: totalProperties.toString(),
                  label: "Properties",
                  icon: Icons.home_work_outlined,
                ),
              ),
              buildDashboardDivider(),
              Expanded(
                child: buildDashboardStatItem(
                  value: pendingProperties.toString(),
                  label: "Pending",
                  icon: Icons.schedule_rounded,
                ),
              ),
              buildDashboardDivider(),
              Expanded(
                child: buildDashboardStatItem(
                  value: suspendedUsers.toString(),
                  label: "Suspended",
                  icon: Icons.person_off_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDashboardStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Color(0xFFF5F6F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: primaryColor),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        SizedBox(height: 1),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget buildDashboardDivider() {
    return Container(width: 1, height: 58, color: borderColor);
  }

  // Owner Requests
  Widget buildOwnerRequestsCard() {
    final bool hasRequests = pendingOwnerRequests > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: goToOwnerRequests,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Color(0xFFF1F3F8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Owner Requests",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      hasRequests
                          ? "$pendingOwnerRequests pending ${pendingOwnerRequests == 1 ? "request" : "requests"}"
                          : "No pending requests",
                      style: TextStyle(fontSize: 11, color: secondaryTextColor),
                    ),
                  ],
                ),
              ),

              if (hasRequests) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F3F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "New",
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),

                SizedBox(width: 10),
              ],

              Icon(Icons.chevron_right_rounded, color: primaryColor, size: 21),
            ],
          ),
        ),
      ),
    );
  }

  // Pending Header
  Widget buildPendingHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Recent Pending Properties",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: -0.2,
            ),
          ),
        ),
        TextButton(
          onPressed: goToPendingVerification,
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 2),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: primaryColor,
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
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: greenSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.verified_rounded, color: greenAccent, size: 24),
            ),
            SizedBox(height: 11),
            Text(
              "Everything is reviewed",
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "There are no property submissions waiting for verification.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(recentPending.length, (index) {
          final Map<String, dynamic> property = recentPending[index];

          return Column(
            children: [
              buildPendingPropertyCard(
                title:
                    property["title"]?.toString() ??
                    property["name"]?.toString() ??
                    "Property",
                owner: property["owner"]?.toString() ?? "Unknown Owner",
                location:
                    property["location"]?.toString() ??
                    property["address"]?.toString() ??
                    "-",
                date: property["submitted"]?.toString() ?? "-",
                image: getImageUrl(property["image"]),
                onTap: goToPendingVerification,
              ),
              if (index != recentPending.length - 1)
                Divider(height: 1, color: borderColor),
            ],
          );
        }),
      ),
    );
  }

  // Pending Property Card
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
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.isEmpty
                  ? buildImagePlaceholder()
                  : Image.network(
                      image,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return buildImagePlaceholder();
                      },
                    ),
            ),

            SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: orangeSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Pending",
                          style: TextStyle(
                            color: orangeAccent,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  buildSmallInfo(Icons.person_outline_rounded, owner),

                  SizedBox(height: 4),

                  buildSmallInfo(Icons.location_on_outlined, location),

                  SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 4),

            // Container(
            //   width: 30,
            //   height: 30,
            //   decoration: BoxDecoration(
            //     color: Color(0xFFF7F7FA),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Icon(
            //     Icons.chevron_right_rounded,
            //     color: primaryColor,
            //     size: 19,
            //   ),
            //),
          ],
        ),
      ),
    );
  }

  // Small Info
  Widget buildSmallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: secondaryTextColor),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: secondaryTextColor),
          ),
        ),
      ],
    );
  }

  // Placeholder
  Widget buildImagePlaceholder() {
    return Container(
      width: 82,
      height: 82,
      color: purpleSoft,
      child: Icon(Icons.home_work_outlined, color: purpleAccent, size: 25),
    );
  }

  // Community Banner
  Widget buildCommunityBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.fromLTRB(17, 16, 15, 14),
      decoration: BoxDecoration(
        color: Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: Color(0xFFDCEAFF)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -25,
            child: Icon(
              Icons.home_work_rounded,
              size: 110,
              color: primaryColor.withValues(alpha: 0.065),
            ),
          ),

          Positioned(
            right: 58,
            bottom: -12,
            child: Icon(
              Icons.home_rounded,
              size: 55,
              color: blueAccent.withValues(alpha: 0.08),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: Text(
                  "A safer, better rental community starts with you.",
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ),

              SizedBox(height: 7),

              SizedBox(
                width: 225,
                child: Text(
                  "Thank you for keeping JoulNow a trusted place.",
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: secondaryTextColor,
                  ),
                ),
              ),

              Spacer(),

              Container(
                width: 35,
                height: 3,
                decoration: BoxDecoration(
                  color: blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
