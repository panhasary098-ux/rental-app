import 'package:final_project/service/admin_service.dart';
import 'package:final_project/view/admin/property_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingVerificationScreen extends StatefulWidget {
  const PendingVerificationScreen({super.key});

  @override
  State<PendingVerificationScreen> createState() =>
      _PendingVerificationScreenState();
}

class _PendingVerificationScreenState
    extends State<PendingVerificationScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> pendingProperties = [];
  List<Map<String, dynamic>> filteredProperties = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadPendingProperties();

    searchController.addListener(
      filterProperties,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Load real pending properties from Laravel
  Future<void> loadPendingProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final properties =
          await adminService.getPendingProperties();

      if (!mounted) {
        return;
      }

      setState(() {
        pendingProperties = properties;
        filteredProperties = properties;
        isLoading = false;
      });

      filterProperties();
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

  // Search property, owner or location
  void filterProperties() {
    final String query =
        searchController.text.trim().toLowerCase();

    if (!mounted) {
      return;
    }

    if (query.isEmpty) {
      setState(() {
        filteredProperties =
            List<Map<String, dynamic>>.from(
          pendingProperties,
        );
      });

      return;
    }

    setState(() {
      filteredProperties =
          pendingProperties.where((property) {
        final String title =
            property["title"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        final String owner =
            property["owner"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        final String location =
            property["location"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        return title.contains(query) ||
            owner.contains(query) ||
            location.contains(query);
      }).toList();
    });
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
          "Pending Verification",
          style: TextStyle(
            color: Color(0xFF1F2923),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Pending summary
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),

              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1F2923)
                          .withOpacity(0.05),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,

                      decoration: BoxDecoration(
                        color: Color(0xFFF59E0B),
                        borderRadius:
                            BorderRadius.circular(
                          13,
                        ),
                      ),

                      child: Icon(
                        Icons.pending_actions_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),

                    SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            "${pendingProperties.length} submissions waiting",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Color(0xFF1F2923),
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Review property and owner documents before approval.",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              color:
                                  Color(0xFF68756D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8),

                    Container(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3D6),
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        pendingProperties.length
                            .toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),

              child: TextField(
                controller: searchController,

                decoration: InputDecoration(
                  hintText:
                      "Search property or owner",

                  hintStyle: TextStyle(
                    color: Color(0xFF94A099),
                    fontSize: 14,
                  ),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF68756D),
                  ),

                  suffixIcon: searchController
                          .text
                          .isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color:
                                Color(0xFF03045E),
                          ),
                        )
                      : Container(
                          margin:
                              EdgeInsets.all(8),

                          decoration:
                              BoxDecoration(
                            color: Color(
                              0xFF90E0EF,
                            ).withOpacity(0.25),

                            borderRadius:
                                BorderRadius.circular(
                              9,
                            ),
                          ),

                          child: Icon(
                            Icons.tune_rounded,
                            color:
                                Color(0xFF03045E),
                            size: 20,
                          ),
                        ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                      EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFFE1E9E4),
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFFE1E9E4),
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),

                    borderSide: BorderSide(
                      color: Color(0xFF03045E),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            // Main content
            Expanded(
              child: buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Loading, error, empty or property list
  Widget buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF03045E),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(25),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 50,
                color: Color(0xFFDC2626),
              ),

              SizedBox(height: 12),

              Text(
                "Unable to load pending properties",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2923),
                ),
              ),

              SizedBox(height: 7),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF68756D),
                ),
              ),

              SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: loadPendingProperties,

                icon: Icon(
                  Icons.refresh_rounded,
                ),

                label: Text(
                  "Try Again",
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF03045E),
                  foregroundColor:
                      Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 70,
              height: 70,

              decoration: BoxDecoration(
                color: Color(0xFF90E0EF)
                    .withOpacity(0.25),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.verified_user_outlined,
                size: 35,
                color: Color(0xFF03045E),
              ),
            ),

            SizedBox(height: 14),

            Text(
              searchController.text.isEmpty
                  ? "No pending submissions"
                  : "No results found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2923),
              ),
            ),

            SizedBox(height: 5),

            Text(
              searchController.text.isEmpty
                  ? "New property submissions will appear here."
                  : "Try searching with another property or owner name.",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF68756D),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Color(0xFF03045E),

      onRefresh: loadPendingProperties,

      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          20,
          10,
          20,
          25,
        ),

        itemCount:
            filteredProperties.length,

        separatorBuilder:
            (context, index) {
          return SizedBox(height: 14);
        },

        itemBuilder:
            (context, index) {
          final Map<String, dynamic>
              property =
              filteredProperties[index];

          return buildPropertyCard(
            property,
          );
        },
      ),
    );
  }

  // Property card
  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    final String imageUrl =
        getImageUrl(property["image"]);

    return InkWell(
      // Open review screen when the card is tapped
      onTap: () async {
        final dynamic result =
            await Get.to(
          () => PropertyReviewScreen(
            property: property,
          ),
        );

        // Reload list after approve or reject
        if (result == true) {
          await loadPendingProperties();
        }
      },

      borderRadius:
          BorderRadius.circular(16),

      child: Container(
        padding: EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border: Border.all(
            color: Color(0xFFE1E9E4),
          ),

          boxShadow: [
            BoxShadow(
              color: Color(0xFF1F2923)
                  .withOpacity(0.035),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // Property image
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  child: imageUrl.isEmpty
                      ? buildImagePlaceholder()
                      : Image.network(
                          imageUrl,
                          width: 105,
                          height: 105,
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

                SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      // Status
                      Container(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              Color(0xFFFFF3D6),

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
                                color: Color(
                                  0xFFD97706,
                                ),
                                shape:
                                    BoxShape.circle,
                              ),
                            ),

                            SizedBox(width: 5),

                            Text(
                              "Pending Verification",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w600,
                                color: Color(
                                  0xFFB45309,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8),

                      Text(
                        property["title"]
                                ?.toString() ??
                            "Property",

                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF1F2923),
                        ),
                      ),

                      SizedBox(height: 7),

                      Text(
                        property["price"]
                                ?.toString() ??
                            "-",

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFF03045E),
                        ),
                      ),

                      SizedBox(height: 7),

                      Row(
                        children: [
                          Icon(
                            Icons
                                .location_on_outlined,
                            size: 15,
                            color:
                                Color(0xFF68756D),
                          ),

                          SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              property["location"]
                                      ?.toString() ??
                                  "-",

                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style: TextStyle(
                                fontSize: 12,
                                color: Color(
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

            SizedBox(height: 14),

            Divider(
              color: Color(0xFFE8EEEA),
              height: 1,
            ),

            SizedBox(height: 13),

            // Owner information
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,

                  decoration: BoxDecoration(
                    color: Color(0xFF90E0EF)
                        .withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.person_outline,
                    color: Color(0xFF03045E),
                    size: 20,
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        "House Owner",
                        style: TextStyle(
                          color:
                              Color(0xFF94A099),
                          fontSize: 11,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        property["owner"]
                                ?.toString() ??
                            "Unknown Owner",

                        style: TextStyle(
                          color:
                              Color(0xFF526058),
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,

                  children: [
                    Text(
                      "Submitted",
                      style: TextStyle(
                        color:
                            Color(0xFF94A099),
                        fontSize: 11,
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      property["submitted"]
                              ?.toString() ??
                          "-",

                      style: TextStyle(
                        color:
                            Color(0xFF68756D),
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14),

            // Review button
            SizedBox(
              width: double.infinity,
              height: 46,

              child: ElevatedButton(
                onPressed: () async {
                  final dynamic result =
                      await Get.to(
                    () => PropertyReviewScreen(
                      property: property,
                    ),
                  );

                  // Reload list after approve or reject
                  if (result == true) {
                    await loadPendingProperties();
                  }
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF03045E),
                  foregroundColor:
                      Colors.white,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      size: 20,
                    ),

                    SizedBox(width: 8),

                    Text(
                      "Review Submission",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
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

  // Property image placeholder
  Widget buildImagePlaceholder() {
    return Container(
      width: 105,
      height: 105,

      decoration: BoxDecoration(
        color:
            Color(0xFF90E0EF).withOpacity(0.25),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Icon(
        Icons.home_work_outlined,
        color: Color(0xFF03045E),
        size: 35,
      ),
    );
  }
}