import 'dart:convert';

import 'package:final_project/model/property.dart';
import 'package:final_project/service/property_service.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerProfileScreen extends StatefulWidget {
  final int ownerId;

  final String ownerName;

  final String ownerProfileImage;

  final List<Property> ownerProperties;

  const OwnerProfileScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
    required this.ownerProfileImage,
    required this.ownerProperties,
  });

  @override
  State<OwnerProfileScreen> createState() {
    return _OwnerProfileScreenState();
  }
}

class _OwnerProfileScreenState
    extends State<OwnerProfileScreen> {
  final PropertyService propertyService =
      PropertyService();

  final Color primaryColor =
      Color(0xFF080B78);

  final Color backgroundColor =
      Color(0xFFF8FAFC);

  final Color borderColor =
      Color(0xFFF0F1F5);

  final Color mutedTextColor =
      Color(0xFF85899B);

  bool isLoading = true;

  String ownerName = "";

  String ownerProfileImage = "";

  String memberSince = "";

  int totalProperties = 0;

  int availableProperties = 0;

  List<Property> properties = [];

  @override
  void initState() {
    super.initState();

    ownerName = widget.ownerName;

    ownerProfileImage =
        widget.ownerProfileImage;

    properties =
        widget.ownerProperties;

    loadOwnerProfile();
  }

  // Load Owner Profile
  Future<void> loadOwnerProfile() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final profileResponse =
          await propertyService
              .getOwnerProfile(
        ownerId: widget.ownerId,
      );

      String newOwnerName =
          ownerName;

      String newOwnerProfileImage =
          ownerProfileImage;

      String newMemberSince =
          memberSince;

      int newTotalProperties =
          totalProperties;

      int newAvailableProperties =
          availableProperties;

      final dynamic profileDecoded =
          jsonDecode(
        profileResponse.body,
      );

      if (profileResponse.statusCode ==
              200 &&
          profileDecoded["success"] ==
              true) {
        final dynamic owner =
            profileDecoded["owner"];

        if (owner is Map) {
          newOwnerName =
              owner["name"]
                      ?.toString() ??
                  newOwnerName;

          newOwnerProfileImage =
              fixLaravelUrl(
            owner["profile_image"]
                    ?.toString() ??
                newOwnerProfileImage,
          );

          newMemberSince =
              owner["member_since"]
                      ?.toString() ??
                  newMemberSince;

          newTotalProperties =
              int.tryParse(
                    owner["total_properties"]
                            ?.toString() ??
                        "0",
                  ) ??
                  newTotalProperties;

          newAvailableProperties =
              int.tryParse(
                    owner["available_properties"]
                            ?.toString() ??
                        "0",
                  ) ??
                  newAvailableProperties;
        }
      }

      // Load owner post history from API.
      // The current renter Property objects are reused
      // so property details keep all existing fields.
      final historyResponse =
          await propertyService
              .getOwnerProperties(
        ownerId: widget.ownerId,
      );

      final dynamic historyDecoded =
          jsonDecode(
        historyResponse.body,
      );

      List<Property> newProperties =
          List<Property>.from(
        widget.ownerProperties,
      );

      if (historyResponse.statusCode ==
              200 &&
          historyDecoded["success"] ==
              true) {
        final List<dynamic> history =
            historyDecoded["properties"] ??
                [];

        final List<int> historyIds =
            [];

        for (final dynamic item
            in history) {
          if (item is Map) {
            final int? id =
                int.tryParse(
              item["id"]
                      ?.toString() ??
                  "",
            );

            if (id != null) {
              historyIds.add(id);
            }
          }
        }

        if (historyIds.isNotEmpty) {
          newProperties =
              widget.ownerProperties
                  .where(
                    (property) =>
                        property.id !=
                            null &&
                        historyIds.contains(
                          property.id!,
                        ),
                  )
                  .toList();

          newProperties.sort(
            (a, b) {
              final int aIndex =
                  historyIds.indexOf(
                a.id!,
              );

              final int bIndex =
                  historyIds.indexOf(
                b.id!,
              );

              return aIndex.compareTo(
                bIndex,
              );
            },
          );
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        ownerName = newOwnerName;

        ownerProfileImage =
            newOwnerProfileImage;

        memberSince =
            newMemberSince;

        totalProperties =
            newTotalProperties;

        availableProperties =
            newAvailableProperties;

        properties =
            newProperties;

        isLoading = false;
      });
    } catch (e) {
      print(
        "OWNER PROFILE LOAD ERROR: $e",
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      Get.snackbar(
        "Error",
        "Unable to load owner profile",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          backgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,

          onRefresh:
              loadOwnerProfile,

          child: CustomScrollView(
            physics:
                AlwaysScrollableScrollPhysics(),

            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    28,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      // Header
                      Row(
                        children: [
                          buildHeaderButton(
                            icon: Icons
                                .arrow_back_rounded,
                            onTap: () {
                              Get.back();
                            },
                          ),

                          Expanded(
                            child: Text(
                              "Owner Profile",
                              textAlign:
                                  TextAlign
                                      .center,
                              style:
                                  TextStyle(
                                color:
                                    primaryColor,
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .w800,
                              ),
                            ),
                          ),

                          buildHeaderButton(
                            icon: Icons
                                .refresh_rounded,
                            onTap: () {
                              loadOwnerProfile();
                            },
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 22,
                      ),

                      // Owner Card
                      buildOwnerCard(),

                      SizedBox(
                        height: 26,
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [
                          Text(
                            "Property History",
                            style:
                                TextStyle(
                              color:
                                  primaryColor,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),

                          if (!isLoading)
                            Text(
                              "${properties.length} posts",
                              style:
                                  TextStyle(
                                color:
                                    mutedTextColor,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(
                        height: 12,
                      ),

                      if (isLoading)
                        buildLoadingState()
                      else if (properties
                          .isEmpty)
                        buildEmptyState()
                      else
                        ...properties.map(
                          (property) {
                            return buildPropertyCard(
                              property,
                            );
                          },
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

  // Header Button
  Widget buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius:
            BorderRadius.circular(
          14,
        ),

        child: Container(
          width: 44,
          height: 44,

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

          child: Icon(
            icon,
            color: primaryColor,
            size: 22,
          ),
        ),
      ),
    );
  }

  // Owner Card
  Widget buildOwnerCard() {
    return Container(
      width: double.infinity,

      padding:
          EdgeInsets.fromLTRB(
        20,
        24,
        20,
        20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          24,
        ),

        border: Border.all(
          color: borderColor,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.045,
            ),
            blurRadius: 18,
            offset: Offset(
              0,
              6,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          buildOwnerAvatar(
            size: 88,
          ),

          SizedBox(
            height: 14,
          ),

          Text(
            ownerName.trim().isNotEmpty
                ? ownerName
                : "House Owner",

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: primaryColor,
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 5,
          ),

          Container(
            padding:
                EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color:
                  Color(0xFFF0F1F8),

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Text(
              "House Owner",
              style: TextStyle(
                color: primaryColor,
                fontSize: 11,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          if (memberSince
              .isNotEmpty) ...[
            SizedBox(
              height: 9,
            ),

            Text(
              "Member since ${formatMemberSince(memberSince)}",
              style: TextStyle(
                color:
                    mutedTextColor,
                fontSize: 11,
              ),
            ),
          ],

          SizedBox(
            height: 22,
          ),

          Row(
            children: [
              Expanded(
                child: buildStatCard(
                  value:
                      totalProperties
                          .toString(),
                  label:
                      "Public Listings",
                  icon: Icons
                      .home_work_outlined,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              Expanded(
                child: buildStatCard(
                  value:
                      availableProperties
                          .toString(),
                  label:
                      "Available",
                  icon: Icons
                      .check_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Owner Avatar
  Widget buildOwnerAvatar({
    required double size,
  }) {
    final String cleanName =
        ownerName.trim();

    final String initial =
        cleanName.isNotEmpty
            ? cleanName[0]
                .toUpperCase()
            : "O";

    final String cleanImage =
        fixLaravelUrl(
      ownerProfileImage,
    );

    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: Color(0xFFF0F1F8),
        shape: BoxShape.circle,

        border: Border.all(
          color:
              Color(0xFFE5E7F0),
          width: 2,
        ),
      ),

      child: ClipOval(
        child: cleanImage.isNotEmpty
            ? Image.network(
                cleanImage,
                width: size,
                height: size,
                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return buildInitial(
                    initial,
                    size,
                  );
                },
              )
            : buildInitial(
                initial,
                size,
              ),
      ),
    );
  }

  // Owner Initial
  Widget buildInitial(
    String initial,
    double size,
  ) {
    return Container(
      width: size,
      height: size,

      alignment:
          Alignment.center,

      color: Color(0xFFF0F1F8),

      child: Text(
        initial,

        style: TextStyle(
          color: primaryColor,
          fontSize: size * 0.36,
          fontWeight:
              FontWeight.w800,
        ),
      ),
    );
  }

  // Stat Card
  Widget buildStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding:
          EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color: Color(0xFFF8F9FC),

        borderRadius:
            BorderRadius.circular(
          17,
        ),

        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),

          SizedBox(
            height: 7,
          ),

          Text(
            value,

            style: TextStyle(
              color: primaryColor,
              fontSize: 19,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(
            height: 2,
          ),

          Text(
            label,

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color:
                  mutedTextColor,
              fontSize: 10,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Property Card
  Widget buildPropertyCard(
    Property property,
  ) {
    return Container(
      margin:
          EdgeInsets.only(
        bottom: 14,
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
            color:
                Colors.black.withOpacity(
              0.04,
            ),
            blurRadius: 14,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: InkWell(
        onTap: () {
          Get.to(
            () =>
                PropertyDetailScreen(
              property: property,
            ),
          );
        },

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(
                left: Radius.circular(
                  20,
                ),
              ),

              child: buildPropertyImage(
                property,
              ),
            ),

            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(
                  14,
                  13,
                  12,
                  13,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property.name,

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                              color:
                                  primaryColor,
                              fontSize: 15,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                        ),

                        Icon(
                          Icons
                              .chevron_right_rounded,
                          color:
                              Color(
                            0xFFB5B8C4,
                          ),
                          size: 20,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 7,
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons
                              .location_on_outlined,
                          size: 14,
                          color:
                              mutedTextColor,
                        ),

                        SizedBox(
                          width: 3,
                        ),

                        Expanded(
                          child: Text(
                            property.location
                                    .address ??
                                "Unknown location",

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                TextStyle(
                              color:
                                  mutedTextColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: [
                        Text(
                          "\$${property.price.toInt()}",

                          style:
                              TextStyle(
                            color:
                                primaryColor,
                            fontSize: 15,
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),

                        Text(
                          " / month",

                          style:
                              TextStyle(
                            color:
                                mutedTextColor,
                            fontSize: 10,
                          ),
                        ),

                        Spacer(),

                        buildStatusBadge(
                          property.status,
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
    );
  }

  // Property Image
  Widget buildPropertyImage(
    Property property,
  ) {
    if (property.images.isEmpty) {
      return Container(
        width: 112,
        height: 118,

        color: Color(0xFFF1F2F6),

        child: Icon(
          Icons.home_work_outlined,
          color: primaryColor,
          size: 32,
        ),
      );
    }

    return Image.network(
      property.images.first,

      width: 112,
      height: 118,
      fit: BoxFit.cover,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          width: 112,
          height: 118,

          color: Color(0xFFF1F2F6),

          child: Icon(
            Icons.home_work_outlined,
            color: primaryColor,
            size: 32,
          ),
        );
      },
    );
  }

  // Status Badge
  Widget buildStatusBadge(
    String status,
  ) {
    final bool isAvailable =
        status.toLowerCase() ==
                "available" ||
            status.toLowerCase() ==
                "available now";

    final Color statusColor =
        isAvailable
            ? Color(0xFF168A4B)
            : Color(0xFFB45309);

    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: statusColor
            .withOpacity(
          0.08,
        ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: statusColor,
          fontSize: 9,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }

  // Loading
  Widget buildLoadingState() {
    return Container(
      width: double.infinity,
      height: 180,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        border: Border.all(
          color: borderColor,
        ),
      ),

      child: Center(
        child:
            CircularProgressIndicator(
          color: primaryColor,
        ),
      ),
    );
  }

  // Empty
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,

      padding:
          EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
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
      ),

      child: Column(
        children: [
          Icon(
            Icons
                .home_work_outlined,
            size: 40,
            color: primaryColor,
          ),

          SizedBox(
            height: 10,
          ),

          Text(
            "No public properties",

            style: TextStyle(
              color: primaryColor,
              fontSize: 15,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          SizedBox(
            height: 4,
          ),

          Text(
            "This owner does not have any public property posts yet.",

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color:
                  mutedTextColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Laravel URL
  String fixLaravelUrl(
    String url,
  ) {
    if (url.isEmpty) {
      return "";
    }

    return url
        .replaceFirst(
          "http://localhost:8000",
          "http://10.0.2.2:8000",
        )
        .replaceFirst(
          "http://127.0.0.1:8000",
          "http://10.0.2.2:8000",
        );
  }

  // Member Since
  String formatMemberSince(
    String value,
  ) {
    final DateTime? date =
        DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return "${months[date.month - 1]} ${date.year}";
  }
}
