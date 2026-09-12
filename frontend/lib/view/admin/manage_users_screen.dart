import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() =>
      _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends State<ManageUsersScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = "All";

  final List<String> filters = [
    "All",
    "Renter",
    "House Owner",
    "Suspended",
  ];

  List<Map<String, dynamic>> users = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadUsers();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  // Load real users from Laravel
  Future<void> loadUsers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result =
          await adminService.getUsers();

      if (!mounted) {
        return;
      }

      setState(() {
        users = result;
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

  // Search and filter users
  List<Map<String, dynamic>>
      get filteredUsers {
    final String query =
        searchController.text
            .trim()
            .toLowerCase();

    return users.where((user) {
      final String name =
          user["name"]
                  ?.toString()
                  .toLowerCase() ??
              "";

      final String email =
          user["email"]
                  ?.toString()
                  .toLowerCase() ??
              "";

      final String phone =
          user["phone"]
                  ?.toString()
                  .toLowerCase() ??
              "";

      final String role =
          formatRole(
            user["role"],
          ).toLowerCase();

      final String status =
          formatStatus(
            user["status"],
          ).toLowerCase();

      final bool matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          email.contains(query) ||
          phone.contains(query);

      bool matchesFilter = true;

      if (selectedFilter == "Renter") {
        matchesFilter =
            role == "renter";
      }

      if (selectedFilter ==
          "House Owner") {
        matchesFilter =
            role == "house owner";
      }

      if (selectedFilter ==
          "Suspended") {
        matchesFilter =
            status == "suspended";
      }

      return matchesSearch &&
          matchesFilter;
    }).toList();
  }

  String formatRole(dynamic value) {
    final String role =
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
    final String status =
        value?.toString().toLowerCase() ?? "";

    if (status == "active") {
      return "Active";
    }

    if (status == "suspended") {
      return "Suspended";
    }

    return status.isEmpty ? "-" : status;
  }

  int getRoleCount(String role) {
    return users.where((user) {
      return formatRole(user["role"]) ==
          role;
    }).length;
  }

  int getSuspendedCount() {
    return users.where((user) {
      return formatStatus(
            user["status"],
          ) ==
          "Suspended";
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>>
        displayedUsers =
        filteredUsers;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7FAF8),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFF7FAF8),

        elevation: 0,

        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1F2923),
          ),
        ),

        title: const Text(
          "Manage Users",

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2923),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Summary
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                5,
              ),

              child: Row(
                children: [
                  Expanded(
                    child:
                        buildSummaryCard(
                      "Renters",
                      getRoleCount(
                        "Renter",
                      ).toString(),
                      Icons
                          .person_outline_rounded,
                      const Color(
                        0xFF3B82F6,
                      ),
                      const Color(
                        0xFFEFF6FF,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child:
                        buildSummaryCard(
                      "Owners",
                      getRoleCount(
                        "House Owner",
                      ).toString(),
                      Icons
                          .home_work_outlined,
                      const Color(
                        0xFF03045E,
                      ),
                      const Color(
                        0xFF90E0EF,
                      ).withOpacity(
                        0.30,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child:
                        buildSummaryCard(
                      "Suspended",
                      getSuspendedCount()
                          .toString(),
                      Icons.block_rounded,
                      const Color(
                        0xFFDC2626,
                      ),
                      const Color(
                        0xFFFEF2F2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Search
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: TextField(
                controller:
                    searchController,

                decoration:
                    InputDecoration(
                  hintText:
                      "Search user",

                  hintStyle:
                      const TextStyle(
                    color:
                        Color(0xFF94A099),
                    fontSize: 14,
                  ),

                  prefixIcon:
                      const Icon(
                    Icons.search_rounded,
                    color:
                        Color(0xFF68756D),
                  ),

                  suffixIcon:
                      searchController
                              .text
                              .isEmpty
                          ? null
                          : IconButton(
                              onPressed:
                                  () {
                                searchController
                                    .clear();
                              },

                              icon:
                                  const Icon(
                                Icons
                                    .close_rounded,
                                color: Color(
                                  0xFF03045E,
                                ),
                              ),
                            ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    borderSide:
                        const BorderSide(
                      color: Color(
                        0xFFE1E9E4,
                      ),
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    borderSide:
                        const BorderSide(
                      color: Color(
                        0xFFE1E9E4,
                      ),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    borderSide:
                        const BorderSide(
                      color: Color(
                        0xFF03045E,
                      ),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Filters
            SizedBox(
              height: 42,

              child: ListView.separated(
                scrollDirection:
                    Axis.horizontal,

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 20,
                ),

                itemCount:
                    filters.length,

                separatorBuilder:
                    (context, index) {
                  return const SizedBox(
                    width: 8,
                  );
                },

                itemBuilder:
                    (context, index) {
                  final String filter =
                      filters[index];

                  final bool selected =
                      selectedFilter ==
                          filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            filter;
                      });
                    },

                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),

                      decoration:
                          BoxDecoration(
                        color: selected
                            ? const Color(
                                0xFF03045E,
                              )
                            : Colors.white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        border:
                            Border.all(
                          color: selected
                              ? const Color(
                                  0xFF03045E,
                                )
                              : const Color(
                                  0xFFE1E9E4,
                                ),
                        ),

                        boxShadow:
                            selected
                                ? [
                                    BoxShadow(
                                      color:
                                          const Color(
                                        0xFF03045E,
                                      ).withOpacity(
                                        0.12,
                                      ),

                                      blurRadius:
                                          8,

                                      offset:
                                          const Offset(
                                        0,
                                        3,
                                      ),
                                    ),
                                  ]
                                : [],
                      ),

                      child: Text(
                        filter,

                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(
                                  0xFF68756D,
                                ),

                          fontWeight:
                              FontWeight
                                  .w600,

                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: buildContent(
                displayedUsers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(
    List<Map<String, dynamic>>
        displayedUsers,
  ) {
    if (isLoading) {
      return const Center(
        child:
            CircularProgressIndicator(
          color: Color(0xFF03045E),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(25),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Icon(
                Icons
                    .error_outline_rounded,
                size: 48,
                color:
                    Color(0xFFDC2626),
              ),

              const SizedBox(height: 12),

              const Text(
                "Unable to load users",

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xFF1F2923),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                errorMessage!,

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 13,
                  color:
                      Color(0xFF68756D),
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: loadUsers,

                icon: const Icon(
                  Icons.refresh_rounded,
                ),

                label:
                    const Text(
                  "Try Again",
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF03045E,
                  ),

                  foregroundColor:
                      Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Container(
              width: 60,
              height: 60,

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFF90E0EF,
                ).withOpacity(
                  0.25,
                ),

                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .person_search_outlined,
                color:
                    Color(0xFF03045E),
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "No users found",

              style: TextStyle(
                color:
                    Color(0xFF68756D),

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color:
          const Color(0xFF03045E),

      onRefresh: loadUsers,

      child: ListView.separated(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          25,
        ),

        itemCount:
            displayedUsers.length,

        separatorBuilder:
            (context, index) {
          return const SizedBox(
            height: 12,
          );
        },

        itemBuilder:
            (context, index) {
          return buildUserCard(
            displayedUsers[index],
          );
        },
      ),
    );
  }

  Widget buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color iconBackground,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color:
              const Color(0xFFE1E9E4),
        ),

        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF1F2923,
            ).withOpacity(
              0.03,
            ),

            blurRadius: 10,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration:
                BoxDecoration(
              color: iconBackground,

              borderRadius:
                  BorderRadius
                      .circular(
                11,
              ),
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 9),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 20,

              fontWeight:
                  FontWeight.bold,

              color:
                  Color(0xFF1F2923),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,

            maxLines: 1,

            style:
                const TextStyle(
              fontSize: 11,

              fontWeight:
                  FontWeight.w500,

              color:
                  Color(0xFF68756D),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserCard(
    Map<String, dynamic> user,
  ) {
    final String status =
        formatStatus(user["status"]);

    final String role =
        formatRole(user["role"]);

    final bool isSuspended =
        status == "Suspended";

    final bool isOwner =
        role == "House Owner";

    return InkWell(
      onTap: () {
        showUserDetails(user);
      },

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        padding:
            const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            16,
          ),

          border: Border.all(
            color:
                const Color(
              0xFFE1E9E4,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color:
                  const Color(
                0xFF1F2923,
              ).withOpacity(
                0.03,
              ),

              blurRadius: 10,

              offset:
                  const Offset(
                0,
                3,
              ),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,

                  decoration:
                      BoxDecoration(
                    color:
                        isSuspended
                            ? const Color(
                                0xFFFEF2F2,
                              )
                            : const Color(
                                0xFF90E0EF,
                              ).withOpacity(
                                0.25,
                              ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(
                    isOwner
                        ? Icons
                            .home_work_outlined
                        : Icons
                            .person_outline_rounded,

                    color:
                        isSuspended
                            ? const Color(
                                0xFFDC2626,
                              )
                            : const Color(
                                0xFF03045E,
                              ),

                    size: 25,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user["name"]
                                      ?.toString() ??
                                  "User",

                              style:
                                  const TextStyle(
                                fontSize:
                                    16,

                                fontWeight:
                                    FontWeight
                                        .bold,

                                color:
                                    Color(
                                  0xFF1F2923,
                                ),
                              ),
                            ),
                          ),

                          buildStatusBadge(
                            status,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        user["email"]
                                ?.toString() ??
                            "-",

                        style:
                            const TextStyle(
                          fontSize: 12,

                          color:
                              Color(
                            0xFF68756D,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Row(
                        children: [
                          const Icon(
                            Icons
                                .phone_outlined,

                            size: 14,

                            color:
                                Color(
                              0xFF94A099,
                            ),
                          ),

                          const SizedBox(
                            width: 4,
                          ),

                          Expanded(
                            child: Text(
                              user["phone"]
                                          ?.toString()
                                          .isNotEmpty ==
                                      true
                                  ? user["phone"]
                                      .toString()
                                  : "No phone number",

                              maxLines: 1,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                fontSize:
                                    12,

                                color:
                                    Color(
                                  0xFF68756D,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(
              height: 1,
              color:
                  Color(0xFFE8EEEA),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                // Role
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFF90E0EF,
                    ).withOpacity(
                      0.16,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),

                  child: Row(
                    children: [
                      Icon(
                        isOwner
                            ? Icons
                                .home_work_outlined
                            : Icons
                                .person_outline,

                        size: 14,

                        color:
                            const Color(
                          0xFF03045E,
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        role,

                        style:
                            const TextStyle(
                          fontSize: 11,

                          fontWeight:
                              FontWeight
                                  .w600,

                          color:
                              Color(
                            0xFF03045E,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (isOwner) ...[
                  const SizedBox(width: 8),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFF90E0EF,
                      ).withOpacity(
                        0.20,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),

                    child: Text(
                      "${user["properties"] ?? 0} Properties",

                      style:
                          const TextStyle(
                        fontSize: 11,

                        color:
                            Color(
                          0xFF03045E,
                        ),

                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                ],

                const Spacer(),

                Container(
                  width: 30,
                  height: 30,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFF90E0EF,
                    ).withOpacity(
                      0.20,
                    ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons
                        .chevron_right_rounded,

                    color:
                        Color(
                      0xFF03045E,
                    ),

                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatusBadge(
    String status,
  ) {
    final bool active =
        status == "Active";

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: active
            ? Colors.green
                .withOpacity(
                0.10,
              )
            : const Color(
                0xFFFEF2F2,
              ),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Container(
            width: 6,
            height: 6,

            decoration:
                BoxDecoration(
              color: active
                  ? Colors.green
                  : const Color(
                      0xFFDC2626,
                    ),

              shape:
                  BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            status,

            style: TextStyle(
              fontSize: 10,

              fontWeight:
                  FontWeight.w600,

              color: active
                  ? Colors.green
                  : const Color(
                      0xFFDC2626,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void showUserDetails(
    Map<String, dynamic> user,
  ) {
    final bool isSuspended =
        formatStatus(
              user["status"],
            ) ==
            "Suspended";

    final String role =
        formatRole(
      user["role"],
    );

    Get.bottomSheet(
      Container(
        constraints:
            BoxConstraints(
          maxHeight:
              Get.height * 0.85,
        ),

        padding:
            const EdgeInsets.fromLTRB(
          20,
          14,
          20,
          25,
        ),

        decoration:
            const BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top:
                Radius.circular(24),
          ),
        ),

        child: SafeArea(
          top: false,

          child:
              SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Container(
                  width: 45,
                  height: 5,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFD1D9D4,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                Container(
                  width: 65,
                  height: 65,

                  decoration:
                      BoxDecoration(
                    color:
                        isSuspended
                            ? const Color(
                                0xFFFEF2F2,
                              )
                            : const Color(
                                0xFF90E0EF,
                              ).withOpacity(
                                0.25,
                              ),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(
                    role ==
                            "House Owner"
                        ? Icons
                            .home_work_outlined
                        : Icons
                            .person_outline_rounded,

                    size: 30,

                    color:
                        isSuspended
                            ? const Color(
                                0xFFDC2626,
                              )
                            : const Color(
                                0xFF03045E,
                              ),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  user["name"]
                          ?.toString() ??
                      "User",

                  style:
                      const TextStyle(
                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(
                      0xFF1F2923,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  role,

                  style:
                      const TextStyle(
                    color:
                        Color(
                      0xFF68756D,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                buildDetailRow(
                  Icons
                      .email_outlined,

                  "Email",

                  user["email"]
                          ?.toString() ??
                      "-",
                ),

                buildDetailRow(
                  Icons
                      .phone_outlined,

                  "Phone",

                  user["phone"]
                              ?.toString()
                              .isNotEmpty ==
                          true
                      ? user["phone"]
                          .toString()
                      : "No phone number",
                ),

                buildDetailRow(
                  Icons
                      .shield_outlined,

                  "Account Status",

                  formatStatus(
                    user["status"],
                  ),
                ),

                if (role ==
                    "House Owner")
                  buildDetailRow(
                    Icons
                        .home_work_outlined,

                    "Submitted Properties",

                    (user["properties"] ??
                            0)
                        .toString(),
                  ),

                if (user["created_at"] !=
                    null)
                  buildDetailRow(
                    Icons
                        .calendar_today_outlined,

                    "Joined",

                    user["created_at"]
                        .toString(),
                  ),

                const SizedBox(
                  height: 18,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  height: 50,

                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      Get.back();

                      confirmAccountAction(
                        user,
                      );
                    },

                    icon: Icon(
                      isSuspended
                          ? Icons
                              .restart_alt_rounded
                          : Icons
                              .block_rounded,
                    ),

                    label: Text(
                      isSuspended
                          ? "Restore Account"
                          : "Suspend Account",

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          isSuspended
                              ? const Color(
                                  0xFF03045E,
                                )
                              : const Color(
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
                          14,
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

  Widget buildDetailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const EdgeInsets.all(
        13,
      ),

      decoration: BoxDecoration(
        color:
            const Color(
          0xFFF7FAF8,
        ),

        borderRadius:
            BorderRadius.circular(
          13,
        ),

        border: Border.all(
          color:
              const Color(
            0xFFE8EEEA,
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF90E0EF,
              ).withOpacity(
                0.20,
              ),

              borderRadius:
                  BorderRadius
                      .circular(
                10,
              ),
            ),

            child: Icon(
              icon,

              size: 19,

              color:
                  const Color(
                0xFF03045E,
              ),
            ),
          ),

          const SizedBox(width: 12),

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
                    fontSize: 11,

                    color:
                        Color(
                      0xFF94A099,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  value,

                  style:
                      const TextStyle(
                    fontSize: 13,

                    fontWeight:
                        FontWeight
                            .w600,

                    color:
                        Color(
                      0xFF526058,
                    ),
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
    final bool isSuspended =
        formatStatus(
              user["status"],
            ) ==
            "Suspended";

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

        title: Text(
          isSuspended
              ? "Restore Account?"
              : "Suspend Account?",

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFF1F2923),
          ),
        ),

        content: Text(
          isSuspended
              ? "This user will be able to use their account again."
              : "This user will be restricted from using the platform.",

          style:
              const TextStyle(
            color:
                Color(0xFF68756D),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },

            child:
                const Text(
              "Cancel",

              style: TextStyle(
                color:
                    Color(
                  0xFF68756D,
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back();

              updateAccountStatus(
                user,
                isSuspended
                    ? "active"
                    : "suspended",
              );
            },

            style:
                ElevatedButton
                    .styleFrom(
              backgroundColor:
                  isSuspended
                      ? const Color(
                          0xFF03045E,
                        )
                      : const Color(
                          0xFFDC2626,
                        ),

              foregroundColor:
                  Colors.white,

              elevation: 0,
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

  // Save real user status to Laravel
  Future<void> updateAccountStatus(
    Map<String, dynamic> user,
    String newStatus,
  ) async {
    final int? userId =
        int.tryParse(
      user["id"].toString(),
    );

    if (userId == null) {
      Get.snackbar(
        "Error",
        "User ID is missing.",

        snackPosition:
            SnackPosition.TOP,
      );

      return;
    }

    try {
      Get.dialog(
        const Center(
          child:
              CircularProgressIndicator(
            color:
                Color(0xFF03045E),
          ),
        ),

        barrierDismissible: false,
      );

      final bool success =
          await adminService
              .updateUserStatus(
        userId: userId,
        status: newStatus,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          user["status"] =
              newStatus;
        });

        final bool suspended =
            newStatus ==
                "suspended";

        Get.snackbar(
          suspended
              ? "Account Suspended"
              : "Account Restored",

          suspended
              ? "${user["name"]}'s account has been suspended."
              : "${user["name"]}'s account is active again.",

          snackPosition:
              SnackPosition.TOP,

          backgroundColor:
              suspended
                  ? const Color(
                      0xFFDC2626,
                    )
                  : const Color(
                      0xFF03045E,
                    ),

          colorText:
              Colors.white,

          duration:
              const Duration(
            seconds: 2,
          ),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
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

      Get.snackbar(
        "Update Failed",
        message,

        snackPosition:
            SnackPosition.TOP,

        backgroundColor:
            const Color(
          0xFFDC2626,
        ),

        colorText:
            Colors.white,
      );
    }
  }
}