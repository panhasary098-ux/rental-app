import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
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

  static const Color primaryColor =
      Color(0xFF03045E);

  static const Color backgroundColor =
      Color(0xFFF8F9FC);

  static const Color textColor =
      Color(0xFF111827);

  static const Color secondaryTextColor =
      Color(0xFF6B7280);

  static const Color borderColor =
      Color(0xFFE5E7EB);

  static const Color softGrey =
      Color(0xFFF5F6F8);

  static const Color redColor =
      Color(0xFFDC2626);

  static const Color redSoft =
      Color(0xFFFEF2F2);

  static const Color greenColor =
      Color(0xFF15803D);

  static const Color greenSoft =
      Color(0xFFF0FDF4);

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

  // Load users
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

  // Search and filter
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
        value
                ?.toString()
                .toLowerCase() ??
            "";

    if (role == "house_owner") {
      return "House Owner";
    }

    if (role == "renter") {
      return "Renter";
    }

    return role.isEmpty ? "-" : role;
  }

  String formatStatus(
    dynamic value,
  ) {
    final String status =
        value
                ?.toString()
                .toLowerCase() ??
            "";

    if (status == "active") {
      return "Active";
    }

    if (status == "suspended") {
      return "Suspended";
    }

    return status.isEmpty
        ? "-"
        : status;
  }

  int getRoleCount(String role) {
    return users.where((user) {
      return formatRole(
            user["role"],
          ) ==
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
          backgroundColor,

      appBar: AppBar(
        backgroundColor:
            backgroundColor,

        elevation: 0,
        scrolledUnderElevation: 0,

        leading: Padding(
          padding:
              EdgeInsets.only(
            left: 10,
          ),

          child: IconButton(
            onPressed: () {
              Get.back();
            },

            icon: Icon(
              Icons
                  .arrow_back_ios_new_rounded,
              color: textColor,
              size: 20,
            ),
          ),
        ),

        titleSpacing: 10,

        title: Text(
          "Manage Users",
          style: TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.w800,
            color: textColor,
            letterSpacing: -0.3,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: Column(
          children: [
            // Summary
            Padding(
              padding:
                  EdgeInsets.fromLTRB(
                18,
                10,
                18,
                0,
              ),

              child: Row(
                children: [
                  Expanded(
                    child:
                        buildSummaryCard(
                      title: "Renters",
                      value:
                          getRoleCount(
                        "Renter",
                      ).toString(),
                      icon:
                          Icons.person_outline_rounded,
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child:
                        buildSummaryCard(
                      title: "Owners",
                      value:
                          getRoleCount(
                        "House Owner",
                      ).toString(),
                      icon:
                          Icons.home_work_outlined,
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child:
                        buildSummaryCard(
                      title:
                          "Suspended",
                      value:
                          getSuspendedCount()
                              .toString(),
                      icon:
                          Icons.block_rounded,
                      isDanger: true,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 18),

            // Search
            Padding(
              padding:
                  EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Container(
                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius
                          .circular(
                    16,
                  ),

                  border:
                      Border.all(
                    color:
                        borderColor,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .black
                          .withValues(
                        alpha: 0.025,
                      ),

                      blurRadius: 12,

                      offset:
                          Offset(
                        0,
                        4,
                      ),
                    ),
                  ],
                ),

                child: TextField(
                  controller:
                      searchController,

                  decoration:
                      InputDecoration(
                    hintText:
                        "Search by name, email or phone",

                    hintStyle:
                        TextStyle(
                      color: Color(
                        0xFF9CA3AF,
                      ),
                      fontSize: 13,
                    ),

                    prefixIcon:
                        Icon(
                      Icons
                          .search_rounded,
                      color:
                          secondaryTextColor,
                      size: 21,
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
                                    Icon(
                                  Icons
                                      .close_rounded,
                                  color:
                                      secondaryTextColor,
                                  size:
                                      19,
                                ),
                              ),

                    filled: true,
                    fillColor:
                        Colors.white,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      borderSide:
                          BorderSide
                              .none,
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      borderSide:
                          BorderSide
                              .none,
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      borderSide:
                          BorderSide(
                        color:
                            primaryColor,
                        width: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 14),

            // Filters
            SizedBox(
              height: 38,

              child: ListView.separated(
                scrollDirection:
                    Axis.horizontal,

                padding:
                    EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                itemCount:
                    filters.length,

                separatorBuilder:
                    (
                  context,
                  index,
                ) {
                  return SizedBox(
                    width: 8,
                  );
                },

                itemBuilder:
                    (
                  context,
                  index,
                ) {
                  final String
                      filter =
                      filters[
                          index];

                  final bool
                      selected =
                      selectedFilter ==
                          filter;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter =
                            filter;
                      });
                    },

                    child: AnimatedContainer(
                      duration:
                          Duration(
                        milliseconds:
                            180,
                      ),

                      padding:
                          EdgeInsets
                              .symmetric(
                        horizontal:
                            16,
                        vertical: 8,
                      ),

                      decoration:
                          BoxDecoration(
                        color: selected
                            ? primaryColor
                            : Colors
                                .white,

                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),

                        border:
                            Border.all(
                          color: selected
                              ? primaryColor
                              : borderColor,
                        ),
                      ),

                      child: Text(
                        filter,

                        style:
                            TextStyle(
                          color: selected
                              ? Colors
                                  .white
                              : textColor,

                          fontWeight:
                              FontWeight
                                  .w600,

                          fontSize:
                              12.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 8),

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

  // Content
  Widget buildContent(
    List<Map<String, dynamic>>
        displayedUsers,
  ) {
    if (isLoading) {
      return Center(
        child:
            CircularProgressIndicator(
          color: primaryColor,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              EdgeInsets.all(25),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 64,
                height: 64,

                decoration:
                    BoxDecoration(
                  color: redSoft,
                  shape:
                      BoxShape.circle,
                ),

                child: Icon(
                  Icons
                      .error_outline_rounded,
                  size: 30,
                  color: redColor,
                ),
              ),

              SizedBox(height: 14),

              Text(
                "Unable to load users",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                  color: textColor,
                ),
              ),

              SizedBox(height: 7),

              Text(
                errorMessage!,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color:
                      secondaryTextColor,
                ),
              ),

              SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: loadUsers,
                icon: Icon(
                  Icons.refresh_rounded,
                ),
                label: Text(
                  "Try Again",
                ),
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      primaryColor,
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
              width: 66,
              height: 66,

              decoration:
                  BoxDecoration(
                color: Colors.white,

                shape:
                    BoxShape.circle,

                border:
                    Border.all(
                  color:
                      borderColor,
                ),
              ),

              child: Icon(
                Icons
                    .person_search_outlined,
                color: primaryColor,
                size: 28,
              ),
            ),

            SizedBox(height: 14),

            Text(
              "No users found",
              style: TextStyle(
                color: textColor,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            SizedBox(height: 4),

            Text(
              "Try changing your search or filter.",
              style: TextStyle(
                fontSize: 12,
                color:
                    secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: primaryColor,

      onRefresh: loadUsers,

      child: ListView.separated(
        padding:
            EdgeInsets.fromLTRB(
          18,
          10,
          18,
          25,
        ),

        itemCount:
            displayedUsers.length,

        separatorBuilder:
            (
          context,
          index,
        ) {
          return SizedBox(
            height: 10,
          );
        },

        itemBuilder:
            (
          context,
          index,
        ) {
          return buildUserCard(
            displayedUsers[
                index],
          );
        },
      ),
    );
  }

  // Summary card
  Widget buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    bool isDanger = false,
  }) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.025,
            ),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration:
                BoxDecoration(
              color: isDanger
                  ? redSoft
                  : softGrey,

              borderRadius:
                  BorderRadius
                      .circular(
                12,
              ),
            ),

            child: Icon(
              icon,
              color: isDanger
                  ? redColor
                  : primaryColor,
              size: 20,
            ),
          ),

          SizedBox(height: 9),

          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
              color: textColor,
            ),
          ),

          SizedBox(height: 2),

          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w500,
              color:
                  secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // User card
  Widget buildUserCard(
    Map<String, dynamic> user,
  ) {
    final String status =
        formatStatus(
      user["status"],
    );

    final String role =
        formatRole(
      user["role"],
    );

    final bool isSuspended =
        status == "Suspended";

    final bool isOwner =
        role == "House Owner";

    return InkWell(
      onTap: () {
        showUserDetails(
          user,
        );
      },

      borderRadius:
          BorderRadius.circular(
        18,
      ),

      child: Container(
        padding:
            EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: borderColor,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha: 0.025,
              ),
              blurRadius: 12,
              offset:
                  Offset(0, 4),
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
                  width: 50,
                  height: 50,

                  decoration:
                      BoxDecoration(
                    color: Colors.white,

                    shape:
                        BoxShape.circle,

                    border:
                        Border.all(
                      color:
                          isSuspended
                              ? Color(
                                  0xFFFECACA,
                                )
                              : borderColor,
                    ),
                  ),

                  child: Icon(
                    isOwner
                        ? Icons
                            .home_work_outlined
                        : Icons
                            .person_outline_rounded,

                    color: isSuspended
                        ? redColor
                        : primaryColor,

                    size: 23,
                  ),
                ),

                SizedBox(width: 13),

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

                              maxLines:
                                  1,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  TextStyle(
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                color:
                                    textColor,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 8,
                          ),

                          buildStatusBadge(
                            status,
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      Text(
                        user["email"]
                                ?.toString() ??
                            "-",

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            TextStyle(
                          fontSize: 12,
                          color:
                              secondaryTextColor,
                        ),
                      ),

                      SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons
                                .phone_outlined,
                            size: 14,
                            color: Color(
                              0xFF9CA3AF,
                            ),
                          ),

                          SizedBox(
                            width: 5,
                          ),

                          Expanded(
                            child: Text(
                              user["phone"]
                                          ?.toString()
                                          .isNotEmpty ==
                                      true
                                  ? user[
                                          "phone"]
                                      .toString()
                                  : "No phone number",

                              maxLines:
                                  1,

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  TextStyle(
                                fontSize:
                                    12,
                                color:
                                    secondaryTextColor,
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

            SizedBox(height: 14),

            Divider(
              height: 1,
              color: borderColor,
            ),

            SizedBox(height: 12),

            Row(
              children: [
                // Role badge
                Container(
                  padding:
                      EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),

                    border:
                        Border.all(
                      color:
                          borderColor,
                    ),
                  ),

                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Icon(
                        isOwner
                            ? Icons
                                .home_work_outlined
                            : Icons
                                .person_outline_rounded,

                        size: 13,
                        color:
                            primaryColor,
                      ),

                      SizedBox(
                        width: 5,
                      ),

                      Text(
                        role,

                        style:
                            TextStyle(
                          fontSize:
                              11,
                          fontWeight:
                              FontWeight
                                  .w600,
                          color:
                              primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                if (isOwner) ...[
                  SizedBox(width: 8),

                  Container(
                    padding:
                        EdgeInsets
                            .symmetric(
                      horizontal:
                          10,
                      vertical: 6,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          softGrey,

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),

                    child: Text(
                      "${user["properties"] ?? 0} Properties",

                      style:
                          TextStyle(
                        fontSize:
                            11,
                        color:
                            textColor,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                ],

                Spacer(),

                Container(
                  width: 30,
                  height: 30,

                  decoration:
                      BoxDecoration(
                    color: softGrey,

                    shape:
                        BoxShape.circle,
                  ),

                  child: Icon(
                    Icons
                        .chevron_right_rounded,
                    color:
                        primaryColor,
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

  // Status
  Widget buildStatusBadge(
    String status,
  ) {
    final bool active =
        status == "Active";

    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: active
            ? greenSoft
            : redSoft,

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
                BoxDecoration(
              color: active
                  ? greenColor
                  : redColor,
              shape:
                  BoxShape.circle,
            ),
          ),

          SizedBox(width: 5),

          Text(
            status,

            style: TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w600,
              color: active
                  ? greenColor
                  : redColor,
            ),
          ),
        ],
      ),
    );
  }

  // User details
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
            EdgeInsets.fromLTRB(
          20,
          14,
          20,
          25,
        ),

        decoration:
            BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              26,
            ),
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
                  width: 44,
                  height: 5,

                  decoration:
                      BoxDecoration(
                    color:
                        borderColor,

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),
                  ),
                ),

                SizedBox(
                  height: 22,
                ),

                Container(
                  width: 68,
                  height: 68,

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    shape:
                        BoxShape.circle,

                    border:
                        Border.all(
                      color:
                          isSuspended
                              ? Color(
                                  0xFFFECACA,
                                )
                              : borderColor,
                    ),
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
                            ? redColor
                            : primaryColor,
                  ),
                ),

                SizedBox(
                  height: 13,
                ),

                Text(
                  user["name"]
                          ?.toString() ??
                      "User",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight
                            .w800,
                    color:
                        textColor,
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                Text(
                  role,

                  style: TextStyle(
                    fontSize: 12,
                    color:
                        secondaryTextColor,
                  ),
                ),

                SizedBox(
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

                if (user[
                        "created_at"] !=
                    null)
                  buildDetailRow(
                    Icons
                        .calendar_today_outlined,
                    "Joined",
                    user["created_at"]
                        .toString(),
                  ),

                SizedBox(
                  height: 18,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  height: 50,

                  child:
                      ElevatedButton
                          .icon(
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
                          TextStyle(
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
                              ? primaryColor
                              : redColor,

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

  // Detail row
  Widget buildDetailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin:
          EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          14,
        ),

        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration:
                BoxDecoration(
              color: softGrey,

              borderRadius:
                  BorderRadius
                      .circular(
                11,
              ),
            ),

            child: Icon(
              icon,
              size: 19,
              color: primaryColor,
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  title,

                  style:
                      TextStyle(
                    fontSize: 10.5,
                    color:
                        secondaryTextColor,
                  ),
                ),

                SizedBox(
                  height: 3,
                ),

                Text(
                  value,

                  style:
                      TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight
                            .w600,
                    color:
                        textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Confirm
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

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            color: textColor,
          ),
        ),

        content: Text(
          isSuspended
              ? "This user will be able to use their account again."
              : "This user will be restricted from using the platform.",

          style: TextStyle(
            color:
                secondaryTextColor,
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
                color:
                    secondaryTextColor,
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
                      ? primaryColor
                      : redColor,

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

  // Update status
  Future<void>
      updateAccountStatus(
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
        Center(
          child:
              CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
        barrierDismissible:
            false,
      );

      final bool success =
          await adminService
              .updateUserStatus(
        userId: userId,
        status: newStatus,
      );

      if (Get.isDialogOpen ==
          true) {
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
                  ? redColor
                  : primaryColor,

          colorText:
              Colors.white,

          duration:
              Duration(
            seconds: 2,
          ),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ==
          true) {
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
            redColor,
        colorText:
            Colors.white,
      );
    }
  }
}