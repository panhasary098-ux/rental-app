import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyReviewScreen extends StatelessWidget {
  PropertyReviewScreen({super.key});

  Map<String, dynamic> property = {
    "title": "Modern Room Near University",
    "owner": "Dara Sok",
    "email": "dara@gmail.com",
    "phone": "012 345 678",
    "location": "Toul Kork, Phnom Penh",
    "price": "\$120 / month",
    "submitted": "24 Aug 2026",
    "description":
        "A clean and comfortable room near university. Suitable for students and young workers.",
    "image": "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F4),

      appBar: AppBar(
        backgroundColor: Color(0xFFF3F5F4),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
          ),
        ),
        title: Text(
          "Review Submission",
          style: TextStyle(
            color: Color(0xFF111827),
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
              // STATUS
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),

                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 252, 225, 128),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color.fromARGB(255, 248, 199, 23)),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,

                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 200, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: const Color.fromARGB(255, 173, 107, 7),
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
                              color: Color(0xFF111827),
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            "Review all property and identity documents carefully.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // PROPERTY IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(18),

                child: Image.network(
                  property["image"],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Color(0xFFDCEFE3),

                      child: Icon(
                        Icons.home_work_outlined,
                        color: Color(0xFF167A3E),
                        size: 55,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 18),

              Text(
                property["title"],
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              SizedBox(height: 7),

              Text(
                property["price"],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF167A3E),
                ),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: Color(0xFF4B5563),
                  ),

                  SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      property["location"],
                      style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              buildSectionTitle("Property Information"),

              SizedBox(height: 12),

              buildInfoCard(
                children: [
                  buildInfoRow(
                    Icons.home_work_outlined,
                    "Property Type",
                    "Room",
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.attach_money_rounded,
                    "Monthly Rent",
                    property["price"],
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.location_on_outlined,
                    "Location",
                    property["location"],
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.calendar_today_outlined,
                    "Submitted",
                    property["submitted"],
                  ),
                ],
              ),

              SizedBox(height: 25),

              buildSectionTitle("Description"),

              SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: Color(0xFFD6DBD8)),
                ),

                child: Text(
                  property["description"],
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),

              SizedBox(height: 25),

              // OWNER
              buildSectionTitle("House Owner Information"),

              SizedBox(height: 12),

              buildInfoCard(
                children: [
                  buildInfoRow(
                    Icons.person_outline,
                    "Owner Name",
                    property["owner"],
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.email_outlined,
                    "Email",
                    property["email"],
                  ),

                  buildDivider(),

                  buildInfoRow(
                    Icons.phone_outlined,
                    "Phone",
                    property["phone"],
                  ),
                ],
              ),

              SizedBox(height: 25),

              // DOCUMENTS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildSectionTitle("Verification Documents"),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      "2 documents",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9A6700),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // NATIONAL ID
              buildDocumentCard(
                title: "National ID",
                subtitle: "Owner identity verification",
                icon: Icons.badge_outlined,
                onTap: () {
                  showDocumentPreview(
                    title: "National ID",
                    icon: Icons.badge_outlined,
                  );
                },
              ),

              SizedBox(height: 12),

              // PROPERTY OWNERSHIP PAPER
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

              SizedBox(height: 25),

              // CHECKLIST
              buildSectionTitle("Verification Checklist"),

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

      // APPROVE / REJECT
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 20),

        decoration: BoxDecoration(
          color: Colors.white,

          border: Border(top: BorderSide(color: Color(0xFFD6DBD8))),
        ),

        child: SafeArea(
          top: false,

          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,

                  child: OutlinedButton(
                    onPressed: () {
                      showRejectDialog();
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFB42318),

                      side: BorderSide(color: Color(0xFFB42318)),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: Text(
                      "Reject",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed: () {
                      showApproveDialog();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF167A3E),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: Text(
                      "Approve",
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget buildInfoCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Color(0xFFD6DBD8)),
      ),

      child: Column(children: children),
    );
  }

  Widget buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: Color(0xFFDCEFE3),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Icon(icon, size: 20, color: Color(0xFF167A3E)),
        ),

        SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),

              SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13),

      child: Divider(height: 1, color: Color(0xFFD6DBD8)),
    );
  }

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

          border: Border.all(color: Color(0xFFD6DBD8)),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Color(0xFFDCEFE3),
                borderRadius: BorderRadius.circular(13),
              ),

              child: Icon(icon, color: Color(0xFF167A3E)),
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
                      color: Color(0xFF111827),
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                  ),
                ],
              ),
            ),

            Icon(Icons.visibility_outlined, color: Color(0xFF167A3E)),
          ],
        ),
      ),
    );
  }

  Widget buildChecklistItem(String text) {
    return Container(
      padding: EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Color(0xFFD6DBD8)),
      ),

      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: Color(0xFFDCEFE3),
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons.check_rounded,
              color: Color(0xFF167A3E),
              size: 18,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }

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
                  color: Color(0xFF9CA3AF),
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
                      color: Color(0xFFDCEFE3),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Icon(icon, color: Color(0xFF167A3E)),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
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
                  color: Color(0xFFE7EAE8),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(icon, size: 55, color: Color(0xFF6B7280)),

                    SizedBox(height: 10),

                    Text(
                      "Document preview",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Real uploaded document will appear here.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
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
                    backgroundColor: Color(0xFF167A3E),
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
    );
  }

  void showApproveDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: Color(0xFFDCEFE3),
                shape: BoxShape.circle,
              ),

              child: Icon(Icons.check_rounded, color: Color(0xFF167A3E)),
            ),

            SizedBox(width: 12),

            Text(
              "Approve Property",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        content: Text(
          "Are you sure you want to approve this property submission?",
          style: TextStyle(color: Color(0xFF4B5563)),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text("Cancel", style: TextStyle(color: Color(0xFF4B5563))),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back();

              Get.snackbar(
                "Approved",
                "Property approved successfully.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Color(0xFF167A3E),
                colorText: Colors.white,
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF167A3E),
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            child: Text("Approve"),
          ),
        ],
      ),
    );
  }

  void showRejectDialog() {
    TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        title: Text(
          "Reject Property",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Provide a reason for rejecting this submission.",
              style: TextStyle(color: Color(0xFF4B5563), fontSize: 13),
            ),

            SizedBox(height: 14),

            TextField(
              controller: reasonController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: "Enter rejection reason",

                filled: true,
                fillColor: Color(0xFFF3F5F4),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                  borderSide: BorderSide(color: Color(0xFFD6DBD8)),
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

            child: Text("Cancel", style: TextStyle(color: Color(0xFF4B5563))),
          ),

          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar(
                  "Reason Required",
                  "Please enter a rejection reason.",
                  snackPosition: SnackPosition.TOP,
                );

                return;
              }

              Get.back();

              Get.snackbar(
                "Rejected",
                "Property submission rejected.",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Color(0xFFB42318),
                colorText: Colors.white,
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB42318),
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
