import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ManageUsersScreen extends StatefulWidget {
  ManageUsersScreen({super.key});

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

  Color primaryColor = Color(0xFF03045E);
  Color backgroundColor = Color(0xFFF5F6FA);
  Color textColor = Color(0xFF111827);
  Color secondaryTextColor = Color(0xFF6B7280);
  Color borderColor = Color(0xFFE8EAF0);
  Color softGrey = Color(0xFFF5F6F8);

  Color redColor = Color(0xFFDC2626);
  Color redSoft = Color(0xFFFEF2F2);

  Color greenColor = Color(0xFF15803D);
  Color greenSoft = Color(0xFFF0FDF4);

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

  // Load Users
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

  // Search
  List<Map<String, dynamic>> get filteredUsers {
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

      if (selectedFilter == "House Owner") {
        matchesFilter =
            role == "house owner";
      }

      if (selectedFilter == "Suspended") {
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

  String formatStatus(dynamic value) {
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

  String getInitials(String name) {
    String cleanName = name.trim();

    if (cleanName.isEmpty) {
      return "U";
    }

    List<String> parts =
        cleanName.split(" ");

    parts.removeWhere(
      (element) =>
          element.trim().isEmpty,
    );

    if (parts.length == 1) {
      return parts.first
          .substring(0, 1)
          .toUpperCase();
    }

    return "${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}"
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>>
        displayedUsers =
        filteredUsers;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
            Brightness.dark,
        statusBarBrightness:
            Brightness.light,
      ),

      child: Scaffold(
        backgroundColor:
            backgroundColor,

        body: SafeArea(
          child: Column(
            children: [
              // Header
              buildHeader(),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 18),

                    // Overview
                    Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child:
                          buildOverviewCard(),
                    ),

                    SizedBox(height: 18),

                    // Search
                    Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child:
                          buildSearchField(),
                    ),

                    SizedBox(height: 14),

                    // Filter
                    buildFilters(),

                    SizedBox(height: 8),

                    Expanded(
                      child: buildContent(
                        displayedUsers,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        30,
        18,
        0,
      ),
      child: Container(
        width: double.infinity,
      
        decoration: BoxDecoration(
          color: primaryColor,
      
          borderRadius:
              BorderRadius.only(
                topLeft:
                    Radius.circular(28),
                    topRight:
                    Radius.circular(28),
            bottomLeft:
                Radius.circular(28),
            bottomRight:
                Radius.circular(28),
          ),
      
          boxShadow: [
            BoxShadow(
              color: primaryColor
                  .withValues(
                alpha: 0.18,
              ),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
      
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(
            18,
            18,
            18,
            22,
          ),
      
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
      
                  children: [
                    Text(
                      "Manage Users",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight:
                            FontWeight
                                .w800,
                        color:
                            Colors.white,
                        letterSpacing:
                            -0.4,
                      ),
                    ),
      
                    SizedBox(height: 3),
      
                    Text(
                      "Review and manage platform accounts",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white
                            .withValues(
                          alpha: 0.68,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              Container(
                width: 42,
                height: 42,
      
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.10,
                  ),
      
                  borderRadius:
                      BorderRadius
                          .circular(
                    13,
                  ),
                ),
      
                child: IconButton(
                  onPressed:
                      loadUsers,
      
                  icon: Icon(
                    Icons
                        .refresh_rounded,
                    color:
                        Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Overview
  Widget buildOverviewCard() {
    return Container(
      width: double.infinity,

      padding:
          EdgeInsets.fromLTRB(
        18,
        17,
        18,
        18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.035,
            ),
            blurRadius: 18,
            offset: Offset(0, 6),
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
                width: 36,
                height: 36,

                decoration:
                    BoxDecoration(
                  color:
                      Color(0xFFF0F1FA),

                  borderRadius:
                      BorderRadius
                          .circular(
                    11,
                  ),
                ),

                child: Icon(
                  Icons
                      .groups_2_outlined,
                  color:
                      primaryColor,
                  size: 19,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      "User Overview",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            FontWeight
                                .w800,
                        color:
                            textColor,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      "${users.length} registered accounts",
                      style: TextStyle(
                        fontSize: 11.5,
                        color:
                            secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Color(0xFFF0FDF4),

                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,

                      decoration:
                          BoxDecoration(
                        color:
                            greenColor,
                        shape:
                            BoxShape.circle,
                      ),
                    ),

                    SizedBox(width: 5),

                    Text(
                      "Live",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight
                                .w700,
                        color:
                            greenColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          Container(
            height: 1,
            color: borderColor,
          ),

          SizedBox(height: 17),

          Row(
            children: [
              Expanded(
                child:
                    buildOverviewItem(
                  value:
                      getRoleCount(
                    "Renter",
                  ).toString(),
                  label:
                      "Renters",
                  icon:
                      Icons.person_outline_rounded,
                  iconBackground:
                      Color(0xFFF0F1FA),
                  iconColor:
                      primaryColor,
                ),
              ),

              buildVerticalDivider(),

              Expanded(
                child:
                    buildOverviewItem(
                  value:
                      getRoleCount(
                    "House Owner",
                  ).toString(),
                  label:
                      "Owners",
                  icon:
                      Icons.home_work_outlined,
                  iconBackground:
                      Color(0xFFF5F3FF),
                  iconColor:
                      Color(0xFF5B21B6),
                ),
              ),

              buildVerticalDivider(),

              Expanded(
                child:
                    buildOverviewItem(
                  value:
                      getSuspendedCount()
                          .toString(),
                  label:
                      "Suspended",
                  icon:
                      Icons.block_rounded,
                  iconBackground:
                      redSoft,
                  iconColor:
                      redColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOverviewItem({
    required String value,
    required String label,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,

          decoration:
              BoxDecoration(
            color:
                iconBackground,

            borderRadius:
                BorderRadius
                    .circular(
              11,
            ),
          ),

          child: Icon(
            icon,
            size: 18,
            color:
                iconColor,
          ),
        ),

        SizedBox(height: 8),

        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.w800,
            color:
                textColor,
          ),
        ),

        SizedBox(height: 1),

        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight:
                FontWeight.w500,
            color:
                secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget buildVerticalDivider() {
    return Container(
      height: 58,
      width: 1,
      color: borderColor,
    );
  }

  // Search
  Widget buildSearchField() {
    return Container(
      height: 50,

      decoration:
          BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          15,
        ),

        border:
            Border.all(
          color:
              borderColor,
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

      child: TextField(
        controller:
            searchController,

        style: TextStyle(
          fontSize: 13,
          color:
              textColor,
        ),

        decoration:
            InputDecoration(
          hintText:
              "Search users...",

          hintStyle:
              TextStyle(
            color:
                Color(0xFF9CA3AF),
            fontSize: 13,
          ),

          prefixIcon:
              Icon(
            Icons.search_rounded,
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
                        size: 18,
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
              15,
            ),
            borderSide:
                BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(
              15,
            ),
            borderSide:
                BorderSide.none,
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(
              15,
            ),

            borderSide:
                BorderSide(
              color:
                  primaryColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  // Filters
  Widget buildFilters() {
    return SizedBox(
      height: 38,

      child:
          ListView.separated(
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

            child:
                AnimatedContainer(
              duration:
                  Duration(
                milliseconds: 180,
              ),

              padding:
                  EdgeInsets.symmetric(
                horizontal: 16,
              ),

              alignment:
                  Alignment.center,

              decoration:
                  BoxDecoration(
                color: selected
                    ? primaryColor
                    : Colors.white,

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),

                border:
                    Border.all(
                  color: selected
                      ? primaryColor
                      : borderColor,
                ),

                boxShadow: selected
                    ? [
                        BoxShadow(
                          color:
                              primaryColor
                                  .withValues(
                            alpha:
                                0.15,
                          ),
                          blurRadius:
                              10,
                          offset:
                              Offset(
                            0,
                            4,
                          ),
                        ),
                      ]
                    : [],
              ),

              child: Text(
                filter,

                style:
                    TextStyle(
                  color: selected
                      ? Colors.white
                      : secondaryTextColor,

                  fontWeight:
                      FontWeight
                          .w600,

                  fontSize:
                      12,
                ),
              ),
            ),
          );
        },
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
          color:
              primaryColor,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              EdgeInsets.all(
            25,
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Container(
                width: 68,
                height: 68,

                decoration:
                    BoxDecoration(
                  color:
                      redSoft,

                  borderRadius:
                      BorderRadius
                          .circular(
                    20,
                  ),
                ),

                child: Icon(
                  Icons
                      .error_outline_rounded,
                  size: 30,
                  color:
                      redColor,
                ),
              ),

              SizedBox(height: 14),

              Text(
                "Unable to load users",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      textColor,
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
                onPressed:
                    loadUsers,

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
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
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
              width: 72,
              height: 72,

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius
                        .circular(
                  22,
                ),

                border:
                    Border.all(
                  color:
                      borderColor,
                ),
              ),

              child: Icon(
                Icons
                    .person_search_outlined,
                color:
                    primaryColor,
                size: 30,
              ),
            ),

            SizedBox(height: 14),

            Text(
              "No users found",
              style: TextStyle(
                color:
                    textColor,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            SizedBox(height: 5),

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
      color:
          primaryColor,

      onRefresh:
          loadUsers,

      child:
          ListView.separated(
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

  // User Card
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

    final String name =
        user["name"]
                ?.toString() ??
            "User";

    return Material(
      color:
          Colors.transparent,

      child: InkWell(
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
          decoration:
              BoxDecoration(
            color:
                Colors.white,

            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),

            border:
                Border.all(
              color: isSuspended
                  ? Color(
                      0xFFFEE2E2,
                    )
                  : borderColor,
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(
                  alpha: 0.03,
                ),
                blurRadius: 14,
                offset:
                    Offset(
                  0,
                  5,
                ),
              ),
            ],
          ),

          child: Row(
            children: [
              // Side Accent
              Container(
                width: 4,
                height: 122,

                decoration:
                    BoxDecoration(
                  color: isSuspended
                      ? redColor
                      : primaryColor,

                  borderRadius:
                      BorderRadius.only(
                    topLeft:
                        Radius.circular(
                      18,
                    ),
                    bottomLeft:
                        Radius.circular(
                      18,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.all(
                    15,
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 50,
                            height: 50,

                            alignment:
                                Alignment.center,

                            decoration:
                                BoxDecoration(
                              color: isSuspended
                                  ? redSoft
                                  : Color(
                                      0xFFF0F1FA,
                                    ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                15,
                              ),
                            ),

                            child: Text(
                              getInitials(
                                name,
                              ),

                              style:
                                  TextStyle(
                                fontSize:
                                    15,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color: isSuspended
                                    ? redColor
                                    : primaryColor,
                              ),
                            ),
                          ),

                          SizedBox(width: 12),

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
                                        name,

                                        maxLines: 1,

                                        overflow:
                                            TextOverflow
                                                .ellipsis,

                                        style:
                                            TextStyle(
                                          fontSize: 15,
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

                                SizedBox(
                                  height: 5,
                                ),

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
                                    fontSize:
                                        11.5,
                                    color:
                                        secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 13),

                      Row(
                        children: [
                          buildRoleBadge(
                            role,
                            isOwner,
                          ),

                          if (isOwner) ...[
                            SizedBox(
                              width: 7,
                            ),

                            buildPropertyBadge(
                              user,
                            ),
                          ],

                          Spacer(),

                          Container(
                            width: 31,
                            height: 31,

                            decoration:
                                BoxDecoration(
                              color:
                                  softGrey,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),

                            child: Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              color:
                                  primaryColor,
                              size: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRoleBadge(
    String role,
    bool isOwner,
  ) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration:
          BoxDecoration(
        color:
            Color(0xFFF7F7FB),

        borderRadius:
            BorderRadius
                .circular(
          9,
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

          SizedBox(width: 5),

          Text(
            role,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight:
                  FontWeight.w600,
              color:
                  primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPropertyBadge(
    Map<String, dynamic> user,
  ) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration:
          BoxDecoration(
        color:
            softGrey,

        borderRadius:
            BorderRadius
                .circular(
          9,
        ),
      ),

      child: Text(
        "${user["properties"] ?? 0} Properties",

        style: TextStyle(
          fontSize: 10.5,
          fontWeight:
              FontWeight.w600,
          color:
              textColor,
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

      decoration:
          BoxDecoration(
        color: active
            ? greenSoft
            : redSoft,

        borderRadius:
            BorderRadius
                .circular(
          8,
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
              fontSize: 9.5,
              fontWeight:
                  FontWeight.w700,
              color: active
                  ? greenColor
                  : redColor,
            ),
          ),
        ],
      ),
    );
  }

  // User Details
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

    final String name =
        user["name"]
                ?.toString() ??
            "User";

    Get.bottomSheet(
      Container(
        constraints:
            BoxConstraints(
          maxHeight:
              Get.height * 0.88,
        ),

        decoration:
            BoxDecoration(
          color:
              backgroundColor,

          borderRadius:
              BorderRadius.vertical(
            top:
                Radius.circular(
              28,
            ),
          ),
        ),

        child: SafeArea(
          top: false,

          child:
              SingleChildScrollView(
            child: Column(
              children: [
                // Sheet Header
                Container(
                  width:
                      double.infinity,

                  padding:
                      EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        primaryColor,

                    borderRadius:
                        BorderRadius
                            .vertical(
                      top:
                          Radius.circular(
                        28,
                      ),
                    ),
                  ),

                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withValues(
                            alpha: 0.30,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),
                        ),
                      ),

                      SizedBox(height: 22),

                      Container(
                        width: 72,
                        height: 72,

                        alignment:
                            Alignment.center,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            22,
                          ),
                        ),

                        child: Text(
                          getInitials(
                            name,
                          ),

                          style:
                              TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight
                                    .w900,
                            color: isSuspended
                                ? redColor
                                : primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 13),

                      Text(
                        name,

                        textAlign:
                            TextAlign.center,

                        style:
                            TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight
                                  .w800,
                          color:
                              Colors.white,
                        ),
                      ),

                      SizedBox(height: 6),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        children: [
                          Text(
                            role,
                            style:
                                TextStyle(
                              fontSize: 12,
                              color: Colors
                                  .white
                                  .withValues(
                                alpha:
                                    0.72,
                              ),
                            ),
                          ),

                          SizedBox(width: 8),

                          Container(
                            width: 4,
                            height: 4,

                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .white
                                  .withValues(
                                alpha:
                                    0.45,
                              ),
                              shape:
                                  BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: 8),

                          Text(
                            formatStatus(
                              user[
                                  "status"],
                            ),

                            style:
                                TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
                              color: isSuspended
                                  ? Color(
                                      0xFFFCA5A5,
                                    )
                                  : Color(
                                      0xFF86EFAC,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    25,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Text(
                        "Account Information",
                        style:
                            TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w800,
                          color:
                              textColor,
                        ),
                      ),

                      SizedBox(height: 11),

                      Container(
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),

                          border:
                              Border.all(
                            color:
                                borderColor,
                          ),
                        ),

                        child: Column(
                          children: [
                            buildDetailRow(
                              Icons
                                  .email_outlined,
                              "Email",
                              user["email"]
                                      ?.toString() ??
                                  "-",
                            ),

                            buildDetailDivider(),

                            buildDetailRow(
                              Icons
                                  .phone_outlined,
                              "Phone",
                              user["phone"]
                                          ?.toString()
                                          .isNotEmpty ==
                                      true
                                  ? user[
                                          "phone"]
                                      .toString()
                                  : "No phone number",
                            ),

                            buildDetailDivider(),

                            buildDetailRow(
                              Icons
                                  .shield_outlined,
                              "Account Status",
                              formatStatus(
                                user[
                                    "status"],
                              ),
                            ),

                            if (role ==
                                "House Owner") ...[
                              buildDetailDivider(),

                              buildDetailRow(
                                Icons
                                    .home_work_outlined,
                                "Submitted Properties",
                                (user["properties"] ??
                                        0)
                                    .toString(),
                              ),
                            ],

                            if (user[
                                    "created_at"] !=
                                null) ...[
                              buildDetailDivider(),

                              buildDetailRow(
                                Icons
                                    .calendar_today_outlined,
                                "Joined",
                                user["created_at"]
                                    .toString(),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,

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
                            size: 19,
                          ),

                          label: Text(
                            isSuspended
                                ? "Restore Account"
                                : "Suspend Account",

                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w700,
                              fontSize: 13,
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
              ],
            ),
          ),
        ),
      ),

      isScrollControlled:
          true,
    );
  }

  // Detail Row
  Widget buildDetailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration:
                BoxDecoration(
              color:
                  softGrey,

              borderRadius:
                  BorderRadius
                      .circular(
                11,
              ),
            ),

            child: Icon(
              icon,
              size: 18,
              color:
                  primaryColor,
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

                SizedBox(height: 3),

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

  Widget buildDetailDivider() {
    return Padding(
      padding:
          EdgeInsets.only(
        left: 65,
      ),

      child: Container(
        height: 1,
        color:
            borderColor,
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
            22,
          ),
        ),

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration:
                  BoxDecoration(
                color: isSuspended
                    ? Color(
                        0xFFF0F1FA,
                      )
                    : redSoft,

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              ),

              child: Icon(
                isSuspended
                    ? Icons
                        .restart_alt_rounded
                    : Icons
                        .block_rounded,

                color: isSuspended
                    ? primaryColor
                    : redColor,

                size: 20,
              ),
            ),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                isSuspended
                    ? "Restore Account?"
                    : "Suspend Account?",

                style:
                    TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight
                          .w800,
                  color:
                      textColor,
                ),
              ),
            ),
          ],
        ),

        content: Text(
          isSuspended
              ? "This user will be able to use their account again."
              : "This user will be restricted from using the platform.",

          style:
              TextStyle(
            fontSize: 13,
            height: 1.45,
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

              style:
                  TextStyle(
                color:
                    secondaryTextColor,
                fontWeight:
                    FontWeight
                        .w600,
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

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(
                  10,
                ),
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

  // Update Status
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
        Center(
          child:
              CircularProgressIndicator(
            color:
                primaryColor,
          ),
        ),
        barrierDismissible:
            false,
      );

      final bool success =
          await adminService
              .updateUserStatus(
        userId:
            userId,
        status:
            newStatus,
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