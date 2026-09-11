import 'package:final_project/service/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyReviewScreen extends StatelessWidget {
  final Map<String, dynamic> property;
  final AdminService adminService = AdminService();
  PropertyReviewScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAF8),

      appBar: AppBar(
        backgroundColor: Color(0xFFF7FAF8),
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2923),
          ),
        ),

        title: Text(
          "Review Submission",
          style: TextStyle(
            color: Color(0xFF1F2923),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 120),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Status
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1F2923).withOpacity(0.05),
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
                        color: Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    SizedBox(width: 13),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Pending Verification",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2923),
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            "Review all property and identity documents carefully.",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color: Color(0xFF68756D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3D6),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22),

              // Property image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),

                child: Image.network(
                  property["image"] ?? "",
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Color(0xFF90E0EF).withOpacity(0.25),

                      child: Icon(
                        Icons.home_work_outlined,
                        color: Color(0xFF03045E),
                        size: 55,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 18),

              Text(
                property["title"]?.toString() ?? "Property",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2923),
                ),
              ),

              SizedBox(height: 7),

              Text(
                property["price"]?.toString() ?? "-",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045E),
                ),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Color(0xFF68756D),
                  ),

                  SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      property["location"]?.toString() ?? "-",
                      style: TextStyle(fontSize: 14, color: Color(0xFF68756D)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 26),

              // Property information
              buildSectionTitle("Property Information"),

              SizedBox(height: 12),

              buildInfoCard(
                children: [
                  buildInfoRow(
                    Icons.home_work_outlined,
                    "Property Type",
                    property["property_type"]?.toString() ?? "Room",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.attach_money_rounded,
                    "Monthly Rent",
                    property["price"]?.toString() ?? "-",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.location_on_outlined,
                    "Location",
                    property["location"]?.toString() ?? "-",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.calendar_today_outlined,
                    "Submitted",
                    property["submitted"]?.toString() ?? "-",
                  ),
                ],
              ),

              SizedBox(height: 26),

              // Description
              buildSectionTitle("Description"),

              SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFE1E9E4)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1F2923).withOpacity(0.025),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Text(
                  property["description"]?.toString() ?? "-",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF68756D),
                  ),
                ),
              ),

              SizedBox(height: 26),

              // Owner information
              buildSectionTitle("House Owner Information"),

              SizedBox(height: 12),

              buildInfoCard(
                children: [
                  buildInfoRow(
                    Icons.person_outline,
                    "Owner Name",
                    property["owner"]?.toString() ?? "-",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.email_outlined,
                    "Email",
                    property["email"]?.toString() ?? "-",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.phone_outlined,
                    "Phone",
                    property["phone"]?.toString() ?? "-",
                  ),
                ],
              ),

              SizedBox(height: 26),

              // Verification documents
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(child: buildSectionTitle("Verification Documents")),

                  SizedBox(width: 10),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                    decoration: BoxDecoration(
                      color: Color(0xFF90E0EF).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      "2 documents",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF03045E),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // National ID
              buildDocumentCard(
                title: "National ID",
                subtitle: "Owner identity verification",
                icon: Icons.badge_outlined,
                onTap: () {
                  showNationalIdPreview();
                },
              ),

              SizedBox(height: 12),

              // Property ownership document
              buildDocumentCard(
                title: "Property Ownership Document",
                subtitle: "Ownership / rental authorization evidence",
                icon: Icons.description_outlined,
                onTap: () {
                  showDocumentPreview(
                    title: "Property Ownership Document",
                    icon: Icons.description_outlined,
                  );
                },
              ),

              SizedBox(height: 26),

              // Verification checklist
              buildSectionTitle("Verification Checklist"),

              SizedBox(height: 5),

              Text(
                "Confirm each item before making a decision.",
                style: TextStyle(fontSize: 12, color: Color(0xFF94A099)),
              ),

              SizedBox(height: 12),

              buildChecklistItem(
                "Owner identity matches submitted information",
              ),

              SizedBox(height: 10),

              buildChecklistItem(
                "Ownership document matches property information",
              ),

              SizedBox(height: 10),

              buildChecklistItem("Property details appear valid and complete"),

              SizedBox(height: 10),

              buildChecklistItem("Submitted property images are appropriate"),
            ],
          ),
        ),
      ),

      // Approve / Reject
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 20),

        decoration: BoxDecoration(
          color: Colors.white,

          border: Border(top: BorderSide(color: Color(0xFFE1E9E4))),

          boxShadow: [
            BoxShadow(
              color: Color(0xFF1F2923).withOpacity(0.05),
              blurRadius: 14,
              offset: Offset(0, -4),
            ),
          ],
        ),

        child: SafeArea(
          top: false,

          child: Row(
            children: [
              // Reject
              Expanded(
                child: SizedBox(
                  height: 52,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      showRejectDialog();
                    },

                    icon: Icon(Icons.close_rounded, size: 20),

                    label: Text(
                      "Reject",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Approve
              Expanded(
                child: SizedBox(
                  height: 52,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      showApproveDialog();
                    },

                    icon: Icon(Icons.check_rounded, size: 20),

                    label: Text(
                      "Approve",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03045E),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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

  // Section title
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2923),
      ),
    );
  }

  // Information card
  Widget buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Color(0xFFE1E9E4)),

        boxShadow: [
          BoxShadow(
            color: Color(0xFF1F2923).withOpacity(0.025),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(children: children),
    );
  }

  // Information row
  Widget buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: Color(0xFF90E0EF).withOpacity(0.20),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 20, color: Color(0xFF03045E)),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Color(0xFF94A099)),
              ),

              SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF526058),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Divider
  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13),

      child: Divider(height: 1, color: Color(0xFFE8EEEA)),
    );
  }

  // Document card
  Widget buildDocumentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: Color(0xFFE1E9E4)),

          boxShadow: [
            BoxShadow(
              color: Color(0xFF1F2923).withOpacity(0.025),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.20),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(icon, color: Color(0xFF03045E)),
            ),

            SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2923),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Color(0xFF68756D),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 36,
              height: 36,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.20),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.visibility_outlined,
                color: Color(0xFF03045E),
                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Checklist item
  Widget buildChecklistItem(String text) {
    return Container(
      padding: EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Color(0xFFE1E9E4)),
      ),

      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: Color(0xFF90E0EF).withOpacity(0.25),
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.check_rounded,
              color: Color(0xFF03045E),
              size: 18,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: Color(0xFF526058),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Property ownership document placeholder
  void showDocumentPreview({required String title, required IconData icon}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: Color(0xFFD1D9D4),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: Color(0xFF90E0EF).withOpacity(0.20),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(icon, color: Color(0xFF03045E)),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2923),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                height: 230,

                decoration: BoxDecoration(
                  color: Color(0xFFF3F7F4),

                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Color(0xFFE1E9E4)),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      width: 70,
                      height: 70,

                      decoration: BoxDecoration(
                        color: Color(0xFF90E0EF).withOpacity(0.20),

                        shape: BoxShape.circle,
                      ),

                      child: Icon(icon, size: 34, color: Color(0xFF03045E)),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Document preview",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF526058),
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Real uploaded document will appear here.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A099)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03045E),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  child: Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Show owner's private National ID
  void showNationalIdPreview() {
    final dynamic ownerId = property["owner_id"];

    if (ownerId == null) {
      Get.snackbar(
        "Unable to Open",
        "Owner information is missing.",
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: Color(0xFFD1D9D4),

                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: Color(0xFF90E0EF).withOpacity(0.20),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(Icons.badge_outlined, color: Color(0xFF03045E)),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "National ID",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2923),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              FutureBuilder<String?>(
                future: FirebaseAuth.instance.currentUser?.getIdToken(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: double.infinity,
                      height: 230,

                      decoration: BoxDecoration(
                        color: Color(0xFFF3F7F4),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF03045E),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return buildDocumentError("Unable to authenticate admin.");
                  }

                  final String token = snapshot.data!;

                  final String nationalIdUrl =
                      "http://10.0.2.2:8000/api/admin/users/$ownerId/national-id";

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),

                    child: Image.network(
                      nationalIdUrl,

                      headers: {
                        "Authorization": "Bearer $token",
                        "Accept": "image/*",
                      },

                      width: double.infinity,

                      height: 260,

                      fit: BoxFit.contain,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          width: double.infinity,
                          height: 260,

                          color: Color(0xFFF3F7F4),

                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF03045E),
                            ),
                          ),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return buildDocumentError(
                          "National ID could not be loaded.",
                        );
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,

                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03045E),

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),

                  child: Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // Error UI for private document
  Widget buildDocumentError(String message) {
    return Container(
      width: double.infinity,
      height: 230,

      decoration: BoxDecoration(
        color: Color(0xFFF3F7F4),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Color(0xFFE1E9E4)),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.error_outline_rounded, size: 42, color: Color(0xFFDC2626)),

          SizedBox(height: 10),

          Text(
            message,
            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 13, color: Color(0xFF68756D)),
          ),
        ],
      ),
    );
  }

  // Approve confirmation
  // Approve property
  void showApproveDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF).withOpacity(0.25),
                shape: BoxShape.circle,
              ),

              child: Icon(Icons.check_rounded, color: Color(0xFF03045E)),
            ),

            SizedBox(width: 12),

            Text(
              "Approve Property",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2923),
              ),
            ),
          ],
        ),

        content: Text(
          "Are you sure you want to approve this property submission?",
          style: TextStyle(color: Color(0xFF68756D)),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text("Cancel", style: TextStyle(color: Color(0xFF68756D))),
          ),

          ElevatedButton(
            onPressed: () async {
              final int? propertyId = int.tryParse(property["id"].toString());

              if (propertyId == null) {
                Get.snackbar(
                  "Error",
                  "Property ID is missing.",
                  snackPosition: SnackPosition.TOP,
                );

                return;
              }

              // Close confirmation dialog
              Get.back();

              try {
                // Show loading
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(color: Color(0xFF03045E)),
                  ),
                  barrierDismissible: false,
                );

                final bool success = await adminService.approveProperty(
                  propertyId,
                );

                // Close loading
                if (Get.isDialogOpen == true) {
                  Get.back();
                }

                if (success) {
                  Get.snackbar(
                    "Approved",
                    "Property approved successfully.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Color(0xFF03045E),
                    colorText: Colors.white,
                  );

                  // Return true so pending list can refresh
                  Get.back(result: true);
                }
              } catch (e) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }

                String message = e.toString();

                if (message.startsWith("Exception: ")) {
                  message = message.replaceFirst("Exception: ", "");
                }

                Get.snackbar(
                  "Approval Failed",
                  message,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Color(0xFFDC2626),
                  colorText: Colors.white,
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF03045E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            child: Text("Approve"),
          ),
        ],
      ),
    );
  }

  // Reject confirmation
  // Reject property
  void showRejectDialog() {
    TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),

              child: Icon(Icons.close_rounded, color: Color(0xFFDC2626)),
            ),

            SizedBox(width: 12),

            Text(
              "Reject Property",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF1F2923),
              ),
            ),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Provide a reason for rejecting this submission.",
              style: TextStyle(color: Color(0xFF68756D), fontSize: 13),
            ),

            SizedBox(height: 14),

            TextField(
              controller: reasonController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: "Enter rejection reason",

                hintStyle: TextStyle(color: Color(0xFF94A099)),

                filled: true,
                fillColor: Color(0xFFF7FAF8),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: Color(0xFFE1E9E4)),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: Color(0xFFE1E9E4)),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: Color(0xFFDC2626), width: 1.5),
                ),
              ),
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text("Cancel", style: TextStyle(color: Color(0xFF68756D))),
          ),

          ElevatedButton(
            onPressed: () async {
              final String reason = reasonController.text.trim();

              if (reason.isEmpty) {
                Get.snackbar(
                  "Reason Required",
                  "Please enter a rejection reason.",
                  snackPosition: SnackPosition.TOP,
                );

                return;
              }

              final int? propertyId = int.tryParse(property["id"].toString());

              if (propertyId == null) {
                Get.snackbar(
                  "Error",
                  "Property ID is missing.",
                  snackPosition: SnackPosition.TOP,
                );

                return;
              }

              // Close confirmation dialog
              Get.back();

              try {
                // Show loading
                Get.dialog(
                  Center(
                    child: CircularProgressIndicator(color: Color(0xFF03045E)),
                  ),
                  barrierDismissible: false,
                );

                final bool success = await adminService.rejectProperty(
                  propertyId: propertyId,
                  reason: reason,
                );

                // Close loading
                if (Get.isDialogOpen == true) {
                  Get.back();
                }

                if (success) {
                  Get.snackbar(
                    "Rejected",
                    "Property submission rejected.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Color(0xFFDC2626),
                    colorText: Colors.white,
                  );

                  // Return true so pending list can refresh
                  Get.back(result: true);
                }
              } catch (e) {
                if (Get.isDialogOpen == true) {
                  Get.back();
                }

                String message = e.toString();

                if (message.startsWith("Exception: ")) {
                  message = message.replaceFirst("Exception: ", "");
                }

                Get.snackbar(
                  "Rejection Failed",
                  message,
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Color(0xFFDC2626),
                  colorText: Colors.white,
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            child: Text("Reject"),
          ),
        ],
      ),
    );
  }
}
