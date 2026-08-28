import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageUsersScreen extends StatefulWidget {
  ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String selectedFilter = "All";

  List<String> filters = [
    "All",
    "Renter",
    "House Owner",
    "Suspended",
  ];

  List<Map<String, dynamic>> users = [
    {
      "name": "Dara Sok",
      "email": "dara@gmail.com",
      "phone": "012 345 678",
      "role": "House Owner",
      "status": "Active",
      "properties": 3,
    },
    {
      "name": "Sophea Lim",
      "email": "sophea@gmail.com",
      "phone": "010 456 789",
      "role": "Renter",
      "status": "Active",
      "properties": 0,
    },
    {
      "name": "Vanna Chan",
      "email": "vanna@gmail.com",
      "phone": "097 123 456",
      "role": "House Owner",
      "status": "Active",
      "properties": 2,
    },
    {
      "name": "Sokha Meas",
      "email": "sokha@gmail.com",
      "phone": "096 222 333",
      "role": "House Owner",
      "status": "Suspended",
      "properties": 1,
    },
    {
      "name": "Ravy Kim",
      "email": "ravy@gmail.com",
      "phone": "015 888 999",
      "role": "Renter",
      "status": "Active",
      "properties": 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredUsers;

    if (selectedFilter == "All") {
      filteredUsers = users;
    } else if (selectedFilter == "Suspended") {
      filteredUsers = users
          .where((user) => user["status"] == "Suspended")
          .toList();
    } else {
      filteredUsers = users
          .where((user) => user["role"] == selectedFilter)
          .toList();
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 235, 234),

      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 233, 235, 234),
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
          "Manage Users",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // SUMMARY
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                children: [
                  Expanded(
                    child: buildSummaryCard(
                      "Renters",
                      getRoleCount("Renter").toString(),
                      Icons.person_outline_rounded,
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: buildSummaryCard(
                      "Owners",
                      getRoleCount("House Owner").toString(),
                      Icons.home_work_outlined,
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: buildSummaryCard(
                      "Suspended",
                      getSuspendedCount().toString(),
                      Icons.block_rounded,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),

            // SEARCH
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search user",

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF6B7280),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Color(0xFF198754),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),

            // FILTERS
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),

                itemCount: filters.length,

                separatorBuilder: (context, index) {
                  return SizedBox(width: 8);
                },

                itemBuilder: (context, index) {
                  String filter = filters[index];
                  bool selected = selectedFilter == filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? Color(0xFF198754)
                            : Colors.white,

                        borderRadius: BorderRadius.circular(20),

                        border: Border.all(
                          color: selected
                              ? Color(0xFF198754)
                              : Color(0xFFE5E7EB),
                        ),
                      ),

                      child: Text(
                        filter,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // USER LIST
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        10,
                        20,
                        25,
                      ),

                      itemCount: filteredUsers.length,

                      separatorBuilder: (context, index) {
                        return SizedBox(height: 12);
                      },

                      itemBuilder: (context, index) {
                        return buildUserCard(
                          filteredUsers[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: Color(0xFFEAF7F0),
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(
              icon,
              color: Color(0xFF198754),
              size: 20,
            ),
          ),

          SizedBox(height: 9),

          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          SizedBox(height: 2),

          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserCard(
    Map<String, dynamic> user,
  ) {
    bool isSuspended = user["status"] == "Suspended";
    bool isOwner = user["role"] == "House Owner";

    return InkWell(
      onTap: () {
        showUserDetails(user);
      },

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Color(0xFFE5E7EB),
          ),
        ),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // AVATAR
                Container(
                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(
                    color: isSuspended
                        ? Color(0xFFFFECEC)
                        : Color(0xFFEAF7F0),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    isOwner
                        ? Icons.home_work_outlined
                        : Icons.person_outline_rounded,

                    color: isSuspended
                        ? Color(0xFFDC2626)
                        : Color(0xFF198754),

                    size: 25,
                  ),
                ),

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user["name"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),

                          buildStatusBadge(
                            user["status"],
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      Text(
                        user["email"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),

                          SizedBox(width: 4),

                          Text(
                            user["phone"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14),

            Divider(
              height: 1,
              color: Color(0xFFE5E7EB),
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        isOwner
                            ? Icons.home_work_outlined
                            : Icons.person_outline,
                        size: 14,
                        color: Color(0xFF6B7280),
                      ),

                      SizedBox(width: 5),

                      Text(
                        user["role"],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isOwner) ...[
                  SizedBox(width: 8),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Color(0xFFEAF7F0),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      "${user["properties"]} Properties",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF198754),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                Spacer(),

                Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusBadge(String status) {
    bool active = status == "Active";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: active
            ? Color(0xFFEAF7F0)
            : Color(0xFFFFECEC),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,

          color: active
              ? Color(0xFF198754)
              : Color(0xFFDC2626),
        ),
      ),
    );
  }

  void showUserDetails(
    Map<String, dynamic> user,
  ) {
    bool isSuspended = user["status"] == "Suspended";

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          20,
          25,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 45,
                height: 5,

                decoration: BoxDecoration(
                  color: Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: 22),

              Container(
                width: 65,
                height: 65,

                decoration: BoxDecoration(
                  color: Color(0xFFEAF7F0),
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  user["role"] == "House Owner"
                      ? Icons.home_work_outlined
                      : Icons.person_outline_rounded,

                  size: 30,
                  color: Color(0xFF198754),
                ),
              ),

              SizedBox(height: 12),

              Text(
                user["name"],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              SizedBox(height: 5),

              Text(
                user["role"],
                style: TextStyle(
                  color: Color(0xFF6B7280),
                ),
              ),

              SizedBox(height: 22),

              buildDetailRow(
                Icons.email_outlined,
                "Email",
                user["email"],
              ),

              buildDetailRow(
                Icons.phone_outlined,
                "Phone",
                user["phone"],
              ),

              buildDetailRow(
                Icons.shield_outlined,
                "Account Status",
                user["status"],
              ),

              if (user["role"] == "House Owner")
                buildDetailRow(
                  Icons.home_work_outlined,
                  "Submitted Properties",
                  user["properties"].toString(),
                ),

              SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();

                    confirmAccountAction(user);
                  },

                  icon: Icon(
                    isSuspended
                        ? Icons.restart_alt_rounded
                        : Icons.block_rounded,
                  ),

                  label: Text(
                    isSuspended
                        ? "Restore Account"
                        : "Suspend Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuspended
                        ? Color(0xFF198754)
                        : Color(0xFFDC2626),

                    foregroundColor: Colors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

  Widget buildDetailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(13),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Color(0xFF198754),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void confirmAccountAction(
    Map<String, dynamic> user,
  ) {
    bool isSuspended = user["status"] == "Suspended";

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: Text(
          isSuspended
              ? "Restore Account?"
              : "Suspend Account?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        content: Text(
          isSuspended
              ? "This user will be able to use their account again."
              : "This user will be restricted from using the platform.",
          style: TextStyle(
            color: Color(0xFF6B7280),
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
                color: Color(0xFF6B7280),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                user["status"] =
                    isSuspended ? "Active" : "Suspended";
              });

              Get.back();

              Get.snackbar(
                isSuspended
                    ? "Account Restored"
                    : "Account Suspended",

                isSuspended
                    ? "${user["name"]}'s account is active again."
                    : "${user["name"]}'s account has been suspended.",

                snackPosition: SnackPosition.TOP,

                backgroundColor: isSuspended
                    ? Color(0xFF198754)
                    : Color(0xFFDC2626),

                colorText: Colors.white,
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: isSuspended
                  ? Color(0xFF198754)
                  : Color(0xFFDC2626),

              foregroundColor: Colors.white,
              elevation: 0,
            ),

            child: Text(
              isSuspended ? "Restore" : "Suspend",
            ),
          ),
        ],
      ),
    );
  }

  int getRoleCount(String role) {
    return users
        .where((user) => user["role"] == role)
        .length;
  }

  int getSuspendedCount() {
    return users
        .where((user) => user["status"] == "Suspended")
        .length;
  }
}