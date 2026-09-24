import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUserProfileScreen extends StatefulWidget {
  final int userId;

  AdminUserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<AdminUserProfileScreen> createState() =>
      _AdminUserProfileScreenState();
}

class _AdminUserProfileScreenState
    extends State<AdminUserProfileScreen> {
  final AdminService adminService = AdminService();

  Color primaryColor = Color(0xFF03045E);
  Color backgroundColor = Color(0xFFF5F6FA);
  Color textColor = Color(0xFF111827);
  Color secondaryTextColor = Color(0xFF6B7280);
  Color borderColor = Color(0xFFE8EAF0);
  Color softGrey = Color(0xFFF5F6F8);

  Color greenColor = Color(0xFF15803D);
  Color greenSoft = Color(0xFFF0FDF4);

  Color redColor = Color(0xFFDC2626);
  Color redSoft = Color(0xFFFEF2F2);

  Color orangeColor = Color(0xFFD97706);
  Color orangeSoft = Color(0xFFFFF7E6);

  Map<String, dynamic>? user;
  bool isLoading = true;
  bool isUpdatingStatus = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // Load Profile
  Future<void> loadProfile() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final Map<String, dynamic> result =
          await adminService.getAdminUserProfile(
        widget.userId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        user = Map<String, dynamic>.from(
          result["user"] ?? {},
        );

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

  String formatRole(dynamic value) {
    String role =
        value?.toString().toLowerCase() ?? "";

    if (role == "house_owner") {
      return "House Owner";
    }

    if (role == "renter") {
      return "Renter";
    }

    return role.isEmpty ? "-" : role;
  }

  String formatStatus(dynamic value) {
    String status =
        value?.toString().toLowerCase() ?? "";

    if (status == "active") {
      return "Active";
    }

    if (status == "suspended") {
      return "Suspended";
    }

    return status.isEmpty ? "-" : status;
  }

  String formatVerificationStatus(
    dynamic value,
  ) {
    String status =
        value?.toString().toLowerCase() ?? "";

    if (status == "approved") {
      return "Approved";
    }

    if (status == "pending") {
      return "Pending";
    }

    if (status == "rejected") {
      return "Rejected";
    }

    return status.isEmpty ? "-" : status;
  }

  String formatRentalStatus(dynamic value) {
    String status =
        value?.toString().toLowerCase() ?? "";

    if (status == "available") {
      return "Available";
    }

    if (status == "rented") {
      return "Rented";
    }

    return status.isEmpty ? "-" : status;
  }

  String formatPostStatus(dynamic value) {
    String status =
        value?.toString().toLowerCase() ?? "";

    if (status == "active") {
      return "Active";
    }

    if (status == "removed") {
      return "Removed";
    }

    return status.isEmpty ? "-" : status;
  }

  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString().trim();

    if (url.isEmpty) {
      return "";
    }

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

  String getInitials(String name) {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return "U";
    }

    List<String> parts = cleanName.split(" ");

    parts.removeWhere(
      (element) => element.trim().isEmpty,
    );

    if (parts.length == 1) {
      return parts.first
          .substring(0, 1)
          .toUpperCase();
    }

    return "${parts.first.substring(0, 1)}"
            "${parts.last.substring(0, 1)}"
        .toUpperCase();
  }

  Map<String, dynamic> get ownerDetails {
    if (user?["owner_details"] is Map) {
      return Map<String, dynamic>.from(
        user!["owner_details"],
      );
    }

    return {};
  }

  List<Map<String, dynamic>> get properties {
    final dynamic value =
        ownerDetails["properties"];

    if (value is! List) {
      return [];
    }

    return value
        .map(
          (item) => Map<String, dynamic>.from(
            item,
          ),
        )
        .toList();
  }

  // Update Status
  Future<void> updateStatus() async {
    if (user == null || isUpdatingStatus) {
      return;
    }

    final bool isSuspended =
        formatStatus(user!["status"]) ==
            "Suspended";

    final String newStatus =
        isSuspended ? "active" : "suspended";

    try {
      setState(() {
        isUpdatingStatus = true;
      });

      final bool success =
          await adminService.updateUserStatus(
        userId: widget.userId,
        status: newStatus,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          user!["status"] = newStatus;
          isUpdatingStatus = false;
        });

        Get.snackbar(
          newStatus == "suspended"
              ? "Account Suspended"
              : "Account Restored",
          newStatus == "suspended"
              ? "This account has been suspended."
              : "This account is active again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor:
              newStatus == "suspended"
                  ? redColor
                  : primaryColor,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
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
        isUpdatingStatus = false;
      });

      Get.snackbar(
        "Update Failed",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: redColor,
        colorText: Colors.white,
      );
    }
  }

  // Confirm Status
  void confirmStatusChange() {
    if (user == null) {
      return;
    }

    final bool isSuspended =
        formatStatus(user!["status"]) ==
            "Suspended";

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(22),
        ),
        title: Text(
          isSuspended
              ? "Restore Account?"
              : "Suspend Account?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        content: Text(
          isSuspended
              ? "This user will be able to use their account again."
              : "This user will be restricted from using JoulNow.",
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: secondaryTextColor,
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
                color: secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              updateStatus();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isSuspended
                      ? primaryColor
                      : redColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
            child: Text(
              isSuspended
                  ? "Restore"
                  : "Suspend",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          "User Profile",
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: loadProfile,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 500,
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          ),
        ],
      );
    }

    if (errorMessage != null || user == null) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24),
        children: [
          SizedBox(height: 100),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: redSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: redColor,
              size: 32,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Unable to load user profile",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          SizedBox(height: 7),
          Text(
            errorMessage ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: secondaryTextColor,
            ),
          ),
          SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: loadProfile,
              icon: Icon(
                Icons.refresh_rounded,
              ),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    final String role =
        formatRole(user!["role"]);

    final bool isOwner =
        role == "House Owner";

    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        30,
      ),
      children: [
        buildProfileHeader(),

        SizedBox(height: 18),

        buildAccountInformation(),

        if (isOwner) ...[
          SizedBox(height: 18),
          buildOwnerOverview(),
          SizedBox(height: 18),
          buildPropertyHistory(),
        ],

        SizedBox(height: 20),

        buildAccountAction(),
      ],
    );
  }

  // Profile Header
  Widget buildProfileHeader() {
    final String name =
        user!["name"]?.toString() ?? "User";

    final String role =
        formatRole(user!["role"]);

    final String status =
        formatStatus(user!["status"]);

    final bool isSuspended =
        status == "Suspended";

    final String profileImageUrl =
        getImageUrl(user!["profile_image"]);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
                primaryColor.withValues(
              alpha: 0.16,
            ),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(21),
              child: profileImageUrl.isEmpty
                  ? Center(
                      child: Text(
                        getInitials(name),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight:
                              FontWeight.w900,
                          color: isSuspended
                              ? redColor
                              : primaryColor,
                        ),
                      ),
                    )
                  : Image.network(
                      profileImageUrl,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (
                            context,
                            error,
                            stackTrace,
                          ) {
                        return Center(
                          child: Text(
                            getInitials(name),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                role,
                style: TextStyle(
                  color: Colors.white
                      .withValues(alpha: 0.72),
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  color: isSuspended
                      ? Color(0xFFFCA5A5)
                      : Color(0xFF86EFAC),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Account Information
  Widget buildAccountInformation() {
    return buildSection(
      title: "Account Information",
      child: Column(
        children: [
          buildInfoRow(
            Icons.email_outlined,
            "Email",
            user!["email"]?.toString() ?? "-",
          ),
          buildDivider(),
          buildInfoRow(
            Icons.phone_outlined,
            "Phone",
            user!["phone"]
                        ?.toString()
                        .isNotEmpty ==
                    true
                ? user!["phone"].toString()
                : "No phone number",
          ),
          buildDivider(),
          buildInfoRow(
            Icons.badge_outlined,
            "Role",
            formatRole(user!["role"]),
          ),
          buildDivider(),
          buildInfoRow(
            Icons.shield_outlined,
            "Account Status",
            formatStatus(user!["status"]),
          ),
          buildDivider(),
          buildInfoRow(
            Icons.calendar_today_outlined,
            "Member Since",
            user!["member_since"]
                    ?.toString() ??
                "-",
          ),
        ],
      ),
    );
  }

  // Owner Overview
  Widget buildOwnerOverview() {
    final bool hasNationalId =
        ownerDetails["has_national_id"] == true;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "Owner Overview",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        SizedBox(height: 11),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border:
                Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildStat(
                      ownerDetails[
                                  "total_properties"]
                              ?.toString() ??
                          "0",
                      "Total",
                    ),
                  ),
                  buildVerticalDivider(),
                  Expanded(
                    child: buildStat(
                      ownerDetails[
                                  "approved_properties"]
                              ?.toString() ??
                          "0",
                      "Approved",
                    ),
                  ),
                  buildVerticalDivider(),
                  Expanded(
                    child: buildStat(
                      ownerDetails[
                                  "pending_properties"]
                              ?.toString() ??
                          "0",
                      "Pending",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 1,
                color: borderColor,
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    hasNationalId
                        ? Icons
                            .verified_user_outlined
                        : Icons
                            .gpp_maybe_outlined,
                    color: hasNationalId
                        ? greenColor
                        : orangeColor,
                    size: 20,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      "National ID",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: hasNationalId
                          ? greenSoft
                          : orangeSoft,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      hasNationalId
                          ? "Uploaded"
                          : "Not Uploaded",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w700,
                        color: hasNationalId
                            ? greenColor
                            : orangeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStat(
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget buildVerticalDivider() {
    return Container(
      width: 1,
      height: 42,
      color: borderColor,
    );
  }

  // Property History
  Widget buildPropertyHistory() {
    final List<Map<String, dynamic>>
        ownerProperties = properties;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Property History",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
            Text(
              "${ownerProperties.length} posts",
              style: TextStyle(
                fontSize: 11,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 11),
        if (ownerProperties.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(18),
              border:
                  Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.home_work_outlined,
                  color: primaryColor,
                  size: 30,
                ),
                SizedBox(height: 10),
                Text(
                  "No property history",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "This owner has not submitted any properties.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: List.generate(
              ownerProperties.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index ==
                                ownerProperties
                                        .length -
                                    1
                            ? 0
                            : 10,
                  ),
                  child: buildPropertyCard(
                    ownerProperties[index],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    final String imageUrl =
        getImageUrl(
      property["cover_image"],
    );

    final String verificationStatus =
        formatVerificationStatus(
      property["verification_status"],
    );

    final String rentalStatus =
        formatRentalStatus(
      property["rental_status"],
    );

    final String postStatus =
        formatPostStatus(
      property["post_status"],
    );

    Color verificationColor =
        orangeColor;
    Color verificationBackground =
        orangeSoft;

    if (verificationStatus ==
        "Approved") {
      verificationColor = greenColor;
      verificationBackground = greenSoft;
    }

    if (verificationStatus ==
        "Rejected") {
      verificationColor = redColor;
      verificationBackground = redSoft;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border:
            Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(13),
                child: imageUrl.isEmpty
                    ? buildPropertyPlaceholder()
                    : Image.network(
                        imageUrl,
                        width: 92,
                        height: 92,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                              context,
                              error,
                              stackTrace,
                            ) {
                          return buildPropertyPlaceholder();
                        },
                      ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      property["name"]
                              ?.toString() ??
                          "Property",
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "\$${property["price"] ?? 0} / month",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons
                              .location_on_outlined,
                          size: 14,
                          color:
                              secondaryTextColor,
                        ),
                        SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            property["address"]
                                    ?.toString() ??
                                "-",
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style: TextStyle(
                              fontSize: 10.5,
                              color:
                                  secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      property["created_at"]
                              ?.toString() ??
                          "-",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(
                          0xFF9CA3AF,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 11),
          Container(
            height: 1,
            color: borderColor,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              buildSmallBadge(
                verificationStatus,
                verificationBackground,
                verificationColor,
              ),
              SizedBox(width: 6),
              buildSmallBadge(
                rentalStatus,
                softGrey,
                primaryColor,
              ),
              Spacer(),
              Text(
                postStatus,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: postStatus == "Removed"
                      ? redColor
                      : secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPropertyPlaceholder() {
    return Container(
      width: 92,
      height: 92,
      color: softGrey,
      child: Icon(
        Icons.home_work_outlined,
        color: primaryColor,
        size: 28,
      ),
    );
  }

  Widget buildSmallBadge(
    String text,
    Color background,
    Color foreground,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }

  Widget buildAccountAction() {
    final bool isSuspended =
        formatStatus(user!["status"]) ==
            "Suspended";

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isUpdatingStatus
            ? null
            : confirmStatusChange,
        icon: isUpdatingStatus
            ? SizedBox(
                width: 18,
                height: 18,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                isSuspended
                    ? Icons.restart_alt_rounded
                    : Icons.block_rounded,
                size: 19,
              ),
        label: Text(
          isUpdatingStatus
              ? "Updating..."
              : isSuspended
                  ? "Restore Account"
                  : "Suspend Account",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSuspended
              ? primaryColor
              : redColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              isSuspended
                  ? primaryColor
                      .withValues(alpha: 0.65)
                  : redColor
                      .withValues(alpha: 0.65),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        SizedBox(height: 11),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            border:
                Border.all(color: borderColor),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget buildInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: softGrey,
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 18,
              color: primaryColor,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.5,
                    color:
                        secondaryTextColor,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 65),
      child: Container(
        height: 1,
        color: borderColor,
      ),
    );
  }
}
