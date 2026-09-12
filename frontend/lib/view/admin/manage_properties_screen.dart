import 'package:final_project/service/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

const Color _primaryColor = Color(0xFF03045E);
const Color _secondaryColor = Color(0xFF90E0EF);
const Color _backgroundColor = Color(0xFFF4FCFE);
const Color _lightSecondaryColor = Color(0xFFE6F9FC);

class ManagePropertiesScreen extends StatefulWidget {
  const ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() =>
      _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState
    extends State<ManagePropertiesScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = "All";

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> properties = [];

  @override
  void initState() {
    super.initState();

    loadProperties();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  Future<void> loadProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result =
          await adminService.getManagedProperties();

      if (!mounted) {
        return;
      }

      setState(() {
        properties = result;
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

  List<Map<String, dynamic>>
  get filteredProperties {
    final String query =
        searchController.text
            .trim()
            .toLowerCase();

    return properties.where(
      (property) {
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

        final String postStatus =
            property["post_status"]
                    ?.toString()
                    .toLowerCase() ??
                "";

        final bool matchesSearch =
            query.isEmpty ||
            title.contains(query) ||
            owner.contains(query) ||
            location.contains(query);

        bool matchesFilter = true;

        if (selectedFilter == "Active") {
          matchesFilter =
              postStatus == "active";
        }

        if (selectedFilter == "Removed") {
          matchesFilter =
              postStatus == "removed";
        }

        return matchesSearch &&
            matchesFilter;
      },
    ).toList();
  }

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

  String formatPostStatus(dynamic value) {
    final String status =
        value?.toString().toLowerCase() ??
            "";

    if (status == "active") {
      return "Active";
    }

    if (status == "removed") {
      return "Removed";
    }

    return status.isEmpty
        ? "-"
        : status;
  }

  String formatRentalStatus(
    dynamic value,
  ) {
    final String status =
        value?.toString().toLowerCase() ??
            "";

    if (status == "available") {
      return "Available";
    }

    if (status == "rented") {
      return "Rented";
    }

    return status.isEmpty
        ? "-"
        : status;
  }

  String getPrice(
    Map<String, dynamic> property,
  ) {
    final dynamic price =
        property["price"];

    if (price != null &&
        price.toString().isNotEmpty) {
      return price.toString();
    }

    final dynamic rawPrice =
        property["raw_price"];

    if (rawPrice != null) {
      return "\$$rawPrice / month";
    }

    return "-";
  }

  @override
  Widget build(BuildContext context) {
    final displayedProperties =
        filteredProperties;

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
            Icons
                .arrow_back_ios_new_rounded,

            color:
                Color(0xFF1F2923),
          ),
        ),

        title: const Text(
          "Manage Properties",

          style: TextStyle(
            fontSize: 20,

            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFF1F2923),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                10,
                18,
                0,
              ),

              child: TextField(
                controller:
                    searchController,

                decoration:
                    InputDecoration(
                  hintText:
                      "Search properties...",

                  hintStyle:
                      const TextStyle(
                    color:
                        Color(
                      0xFF94A099,
                    ),

                    fontSize: 14,
                  ),

                  prefixIcon:
                      const Icon(
                    Icons.search_rounded,

                    color:
                        Color(
                      0xFF68756D,
                    ),
                  ),

                  suffixIcon:
                      searchController
                              .text
                              .isEmpty
                          ? null
                          : IconButton(
                              onPressed:
                                  searchController
                                      .clear,

                              icon:
                                  const Icon(
                                Icons
                                    .close_rounded,

                                color:
                                    _primaryColor,
                              ),
                            ),

                  filled: true,

                  fillColor:
                      Colors.white,

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    borderSide:
                        BorderSide(
                      color:
                          Colors.grey
                              .withOpacity(
                        0.4,
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
                      color:
                          _primaryColor,

                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
              ),

              child: Row(
                children: [
                  buildFilterChip(
                    "All",
                  ),

                  const SizedBox(width: 8),

                  buildFilterChip(
                    "Active",
                  ),

                  const SizedBox(width: 8),

                  buildFilterChip(
                    "Removed",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: buildContent(
                displayedProperties,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(
    List<Map<String, dynamic>>
        displayedProperties,
  ) {
    if (isLoading) {
      return const Center(
        child:
            CircularProgressIndicator(
          color: _primaryColor,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            25,
          ),

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
                "Unable to load properties",

                style: TextStyle(
                  fontSize: 16,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(
                    0xFF1F2923,
                  ),
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
                      Color(
                    0xFF68756D,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed:
                    loadProperties,

                icon: const Icon(
                  Icons.refresh_rounded,
                ),

                label: const Text(
                  "Try Again",
                ),

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      _primaryColor,

                  foregroundColor:
                      Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (displayedProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color:
                    _secondaryColor
                        .withOpacity(
                  0.25,
                ),

                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .home_work_outlined,

                color:
                    _primaryColor,

                size: 32,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "No properties found",

              style: TextStyle(
                fontSize: 16,

                fontWeight:
                    FontWeight.bold,

                color:
                    Color(
                  0xFF1F2923,
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "There are no properties in this category.",

              style: TextStyle(
                fontSize: 12,

                color:
                    Color(
                  0xFF68756D,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _primaryColor,

      onRefresh: loadProperties,

      child: ListView.separated(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          0,
          18,
          25,
        ),

        itemCount:
            displayedProperties.length,

        separatorBuilder:
            (context, index) {
          return const SizedBox(
            height: 14,
          );
        },

        itemBuilder:
            (context, index) {
          return buildPropertyCard(
            displayedProperties[
                index],
          );
        },
      ),
    );
  }

  Widget buildFilterChip(
    String title,
  ) {
    final bool isSelected =
        selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },

      borderRadius:
          BorderRadius.circular(20),

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor
              : Colors.white,

          borderRadius:
              BorderRadius.circular(
            20,
          ),

          border: Border.all(
            color: isSelected
                ? _primaryColor
                : Colors.grey
                    .withOpacity(
                    0.4,
                  ),
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            fontSize: 12,

            fontWeight:
                FontWeight.w600,

            color: isSelected
                ? Colors.white
                : const Color(
                    0xFF68756D,
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    final String imageUrl =
        getImageUrl(
      property["image"],
    );

    final String postStatus =
        formatPostStatus(
      property["post_status"],
    );

    final String rentalStatus =
        formatRentalStatus(
      property["rental_status"],
    );

    return Container(
      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              Colors.grey.withOpacity(
            0.4,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(
              0.12,
            ),

            blurRadius: 12,

            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius
                        .circular(
                  13,
                ),

                child:
                    imageUrl.isEmpty
                        ? buildImagePlaceholder()
                        : Image.network(
                            imageUrl,

                            width: 105,

                            height: 105,

                            fit:
                                BoxFit.cover,

                            errorBuilder:
                                (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return buildImagePlaceholder();
                            },
                          ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Expanded(
                          child: Text(
                            property["title"]
                                    ?.toString() ??
                                "Property",

                            maxLines: 2,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 16,

                              height: 1.3,

                              fontWeight:
                                  FontWeight
                                      .bold,

                              color: Color(
                                0xFF1F2923,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        buildPostStatusBadge(
                          postStatus,
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    Text(
                      getPrice(property),

                      style:
                          const TextStyle(
                        fontSize: 16,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            _primaryColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.circle,

                          size: 9,

                          color:
                              rentalStatus ==
                                      "Available"
                                  ? const Color(
                                      0xFF16A34A,
                                    )
                                  : const Color(
                                      0xFFDC2626,
                                    ),
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Text(
                          rentalStatus,

                          style: TextStyle(
                            fontSize: 12,

                            fontWeight:
                                FontWeight
                                    .w600,

                            color:
                                rentalStatus ==
                                        "Available"
                                    ? const Color(
                                        0xFF16A34A,
                                      )
                                    : const Color(
                                        0xFFDC2626,
                                      ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .person_outline_rounded,

                          size: 16,

                          color:
                              Color(
                            0xFF68756D,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            property["owner"]
                                    ?.toString() ??
                                "Unknown Owner",

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 12,

                              color: Color(
                                0xFF68756D,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,

                          size: 16,

                          color:
                              Color(
                            0xFF68756D,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            property["location"]
                                    ?.toString() ??
                                "-",

                            maxLines: 1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
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

          const SizedBox(height: 16),

          Divider(
            height: 1,

            color:
                Colors.grey.withOpacity(
              0.25,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,

                  child:
                      ElevatedButton.icon(
                    onPressed: () {
                      showPropertyPost(
                        property,
                      );
                    },

                    icon: const Icon(
                      Icons
                          .visibility_outlined,

                      size: 20,
                    ),

                    label:
                        const Text(
                      "View Post",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          _primaryColor,

                      foregroundColor:
                          Colors.white,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              SizedBox(
                width: 70,
                height: 50,

                child: OutlinedButton(
                  onPressed: () {
                    showManagePostSheet(
                      property,
                    );
                  },

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        const Color(
                      0xFF68756D,
                    ),

                    side: BorderSide(
                      color:
                          Colors.grey
                              .withOpacity(
                        0.4,
                      ),
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        13,
                      ),
                    ),
                  ),

                  child: const Icon(
                    Icons
                        .more_horiz_rounded,

                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      width: 105,
      height: 105,

      color:
          _secondaryColor.withOpacity(
        0.25,
      ),

      child: const Icon(
        Icons.home_work_outlined,

        color: _primaryColor,

        size: 32,
      ),
    );
  }

  Widget buildPostStatusBadge(
    String status,
  ) {
    final bool active =
        status == "Active";

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: active
            ? _secondaryColor
                .withOpacity(
                0.25,
              )
            : const Color(
                0xFFFEF2F2,
              ),

        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),

      child: Text(
        status,

        style: TextStyle(
          fontSize: 10,

          fontWeight:
              FontWeight.bold,

          color: active
              ? _primaryColor
              : const Color(
                  0xFFDC2626,
                ),
        ),
      ),
    );
  }

  void showPropertyPost(
    Map<String, dynamic> property,
  ) {
    Get.to(
      () =>
          _ManagedPropertyDetailScreen(
        property: property,

        onManagePost: () {
          showManagePostSheet(
            property,
          );
        },
      ),
    );
  }

  void showManagePostSheet(
    Map<String, dynamic> property,
  ) {
    final String postStatus =
        formatPostStatus(
      property["post_status"],
    );

    Get.bottomSheet(
      Container(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          25,
        ),

        decoration:
            const BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(
              24,
            ),
          ),
        ),

        child: SafeArea(
          top: false,

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 4,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFD8E0DB,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Manage Post",

                style: TextStyle(
                  fontSize: 19,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(
                    0xFF1F2923,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                property["title"]
                        ?.toString() ??
                    "Property",

                style:
                    const TextStyle(
                  fontSize: 13,

                  color:
                      Color(
                    0xFF68756D,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: () {
                  Get.back();

                  if (postStatus !=
                      "Active") {
                    updatePostStatus(
                      property:
                          property,

                      postStatus:
                          "active",
                    );
                  }
                },

                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),

                child: Container(
                  padding:
                      const EdgeInsets
                          .all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    border:
                        Border.all(
                      color:
                          _secondaryColor,
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration:
                            BoxDecoration(
                          color:
                              _lightSecondaryColor,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            11,
                          ),
                        ),

                        child:
                            const Icon(
                          Icons
                              .check_circle_outline_rounded,

                          color:
                              _primaryColor,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      const Expanded(
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Text(
                              "Keep Post",

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,

                                color:
                                    _primaryColor,
                              ),
                            ),

                            SizedBox(
                              height: 3,
                            ),

                            Text(
                              "Keep this property visible to renters.",

                              style:
                                  TextStyle(
                                fontSize:
                                    11,

                                color:
                                    Color(
                                  0xFF68756D,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (postStatus ==
                          "Active")
                        const Icon(
                          Icons
                              .check_circle_rounded,

                          color:
                              _primaryColor,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: () {
                  Get.back();

                  if (postStatus !=
                      "Removed") {
                    showRemoveConfirmation(
                      property,
                    );
                  }
                },

                borderRadius:
                    BorderRadius
                        .circular(
                  14,
                ),

                child: Container(
                  padding:
                      const EdgeInsets
                          .all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFFEF2F2,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    border:
                        Border.all(
                      color:
                          const Color(
                        0xFFDC2626,
                      ).withOpacity(
                        0.20,
                      ),
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,

                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFDC2626,
                          ).withOpacity(
                            0.08,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            11,
                          ),
                        ),

                        child:
                            const Icon(
                          Icons
                              .delete_outline_rounded,

                          color:
                              Color(
                            0xFFDC2626,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      const Expanded(
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Text(
                              "Remove Post",

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,

                                color:
                                    Color(
                                  0xFFDC2626,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 3,
                            ),

                            Text(
                              "Remove this property from public listings.",

                              style:
                                  TextStyle(
                                fontSize:
                                    11,

                                color:
                                    Color(
                                  0xFF68756D,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (postStatus ==
                          "Removed")
                        const Icon(
                          Icons
                              .check_circle_rounded,

                          color:
                              Color(
                            0xFFDC2626,
                          ),
                        ),
                    ],
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

  void showRemoveConfirmation(
    Map<String, dynamic> property,
  ) {
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

        title: const Text(
          "Remove Post",

          style: TextStyle(
            fontWeight:
                FontWeight.bold,

            color:
                Color(0xFFDC2626),
          ),
        ),

        content: const Text(
          "Are you sure you want to remove this property from public listings?",
        ),

        actions: [
          TextButton(
            onPressed: Get.back,

            child: const Text(
              "Cancel",
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back();

              updatePostStatus(
                property: property,

                postStatus:
                    "removed",
              );
            },

            style:
                ElevatedButton
                    .styleFrom(
              backgroundColor:
                  const Color(
                0xFFDC2626,
              ),

              foregroundColor:
                  Colors.white,
            ),

            child: const Text(
              "Remove",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updatePostStatus({
    required Map<String, dynamic>
        property,

    required String postStatus,
  }) async {
    final int? propertyId =
        int.tryParse(
      property["id"].toString(),
    );

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing.",

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
            color: _primaryColor,
          ),
        ),

        barrierDismissible: false,
      );

      final bool success =
          await adminService
              .updatePropertyPostStatus(
        propertyId: propertyId,

        postStatus: postStatus,
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
          property["post_status"] =
              postStatus;
        });

        Get.snackbar(
          postStatus == "active"
              ? "Post Activated"
              : "Post Removed",

          postStatus == "active"
              ? "The property is visible to renters again."
              : "The property has been removed from public listings.",

          snackPosition:
              SnackPosition.TOP,

          backgroundColor:
              postStatus == "active"
                  ? _primaryColor
                  : const Color(
                      0xFFDC2626,
                    ),

          colorText:
              Colors.white,
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
            const Color(
          0xFFDC2626,
        ),

        colorText:
            Colors.white,
      );
    }
  }
}

class _ManagedPropertyDetailScreen
    extends StatefulWidget {
  final Map<String, dynamic>
      property;

  final VoidCallback onManagePost;

  const _ManagedPropertyDetailScreen({
    required this.property,
    required this.onManagePost,
  });

  @override
  State<_ManagedPropertyDetailScreen>
      createState() =>
          _ManagedPropertyDetailScreenState();
}

class _ManagedPropertyDetailScreenState
    extends State<
        _ManagedPropertyDetailScreen> {
  bool showFloor = false;

  Map<String, dynamic> get property =>
      widget.property;

  String get propertyType =>
      property["property_type"]
          ?.toString()
          .toLowerCase() ??
      "";

  bool get hasAvailableFloorList {
    return propertyType == "room" ||
        propertyType == "apartment";
  }

  int get totalFloor {
    return int.tryParse(
          property["total_floor"]
                  ?.toString() ??
              "0",
        ) ??
        0;
  }

  List<int> get availableFloors {
    final dynamic value =
        property["available_floors"];

    if (value is! List) {
      return [];
    }

    return value
        .map(
          (item) =>
              int.tryParse(
                item.toString(),
              ) ??
              0,
        )
        .where(
          (floor) => floor > 0,
        )
        .toList();
  }

  bool getBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final String text =
        value?.toString().toLowerCase() ??
            "";

    return text == "true" ||
        text == "1";
  }

  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url =
        value.toString();

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

  List<String> get images {
    final List<String> result = [];

    final dynamic rawImages =
        property["images"];

    if (rawImages is List) {
      for (final item
          in rawImages) {
        if (item is Map) {
          final dynamic url =
              item["image_url"];

          if (url != null) {
            result.add(
              getImageUrl(url),
            );
          }
        }
      }
    }

    if (result.isEmpty &&
        property["image"] != null) {
      result.add(
        getImageUrl(
          property["image"],
        ),
      );
    }

    return result;
  }

  String get rentalStatus {
    final String value =
        property["rental_status"]
            ?.toString()
            .toLowerCase() ??
        "";

    if (value == "rented") {
      return "Rented";
    }

    return "Available";
  }

  String get price {
    final dynamic raw =
        property["raw_price"];

    final double? value =
        double.tryParse(
      raw?.toString() ?? "",
    );

    if (value == null) {
      return "-";
    }

    if (value ==
        value.roundToDouble()) {
      return value.toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(2);
  }

  String get size {
    final double? value =
        double.tryParse(
      property["size"]
              ?.toString() ??
          "",
    );

    if (value == null) {
      return "-";
    }

    if (value ==
        value.roundToDouble()) {
      return value.toStringAsFixed(
        0,
      );
    }

    return value.toStringAsFixed(1);
  }

  List<Map<String, dynamic>>
  get mainInfo {
    final List<Map<String, dynamic>>
        result = [];

    if (propertyType == "house" ||
        propertyType ==
            "apartment") {
      if (property["bedrooms"] !=
          null) {
        result.add({
          "icon":
              Icons.bed_outlined,

          "text":
              "${property["bedrooms"]} Bedrooms",
        });
      }

      if (property["bathrooms"] !=
          null) {
        result.add({
          "icon":
              Icons.bathtub_outlined,

          "text":
              "${property["bathrooms"]} Bath",
        });
      }
    }

    result.add({
      "icon": Icons.square_foot,

      "text": "$size m²",
    });

    result.add({
      "icon":
          Icons.chair_outlined,

      "text":
          getBool(
            property["furnished"],
          )
              ? "Furnished"
              : "Unfurnished",
    });

    return result;
  }

  List<Map<String, dynamic>>
  get facilities {
    final dynamic raw =
        property["facilities"];

    if (raw is! Map) {
      return [];
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(
      raw,
    );

    final List<Map<String, dynamic>>
        result = [];

    if (getBool(data["wifi"])) {
      result.add({
        "icon": Icons.wifi,

        "text": "WiFi",
      });
    }

    if (getBool(data["parking"])) {
      result.add({
        "icon": Icons
            .local_parking_outlined,

        "text": "Parking",
      });
    }

    if (getBool(
      data["air_conditioning"],
    )) {
      result.add({
        "icon": Icons.ac_unit,

        "text": "Air Con",
      });
    }

    if (getBool(
      data["pet_allowed"],
    )) {
      result.add({
        "icon":
            Icons.pets_outlined,

        "text": "Pet Allowed",
      });
    }

    if (getBool(data["balcony"])) {
      result.add({
        "icon":
            Icons.balcony_outlined,

        "text": "Balcony",
      });
    }

    if (getBool(data["kitchen"])) {
      result.add({
        "icon":
            Icons.kitchen_outlined,

        "text": "Kitchen",
      });
    }

    if (getBool(
      data["swimming_pool"],
    )) {
      result.add({
        "icon": Icons.pool_outlined,

        "text": "Swimming Pool",
      });
    }

    if (getBool(data["elevator"])) {
      result.add({
        "icon":
            Icons.elevator_outlined,

        "text": "Elevator",
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _backgroundColor,

      appBar: AppBar(
        backgroundColor:
            _backgroundColor,

        elevation: 0,

        centerTitle: true,

        scrolledUnderElevation: 0,

        iconTheme:
            const IconThemeData(
          color: _primaryColor,
        ),

        title: const Text(
          "Property Post",

          style: TextStyle(
            fontSize: 20,

            fontWeight:
                FontWeight.w600,

            color:
                _primaryColor,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 300,

            child:
                buildImageSlideshow(),
          ),

          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                16,
                20,
                16,
                30,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      Expanded(
                        child: Text(
                          property["title"]
                                  ?.toString() ??
                              "Property",

                          maxLines: 2,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              const TextStyle(
                            fontSize: 22,

                            fontWeight:
                                FontWeight
                                    .w900,

                            color:
                                _primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 10,
                      ),

                      buildRentalStatusBadge(),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,

                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            const Icon(
                              Icons
                                  .location_on_outlined,

                              size: 20,

                              color:
                                  _primaryColor,
                            ),

                            const SizedBox(
                              width: 3,
                            ),

                            Expanded(
                              child: Text(
                                property["location"]
                                        ?.toString() ??
                                    "-",

                                style:
                                    TextStyle(
                                  fontSize:
                                      15,

                                  color: Colors
                                      .black
                                      .withOpacity(
                                    0.65,
                                  ),

                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .end,

                        children: [
                          Text(
                            "\$$price",

                            style:
                                const TextStyle(
                              fontSize:
                                  23,

                              fontWeight:
                                  FontWeight
                                      .w800,

                              color:
                                  _primaryColor,
                            ),
                          ),

                          const Padding(
                            padding:
                                EdgeInsets
                                    .only(
                              bottom: 3,
                            ),

                            child: Text(
                              "/Month",

                              style:
                                  TextStyle(
                                fontSize:
                                    13,

                                fontWeight:
                                    FontWeight
                                        .w600,

                                color:
                                    _primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 1,

                    width:
                        double.infinity,

                    color:
                        _secondaryColor
                            .withOpacity(
                      0.6,
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 13,
                    ),

                    child: Wrap(
                      spacing: 18,
                      runSpacing: 10,

                      children:
                          mainInfo
                              .map(
                        (item) {
                          return Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min,

                            children: [
                              Icon(
                                item["icon"],

                                size: 17,

                                color:
                                    _primaryColor,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(
                                item["text"],

                                style:
                                    const TextStyle(
                                  fontSize:
                                      13,

                                  color:
                                      _primaryColor,

                                  fontWeight:
                                      FontWeight
                                          .w500,
                                ),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  Container(
                    height: 1,

                    width:
                        double.infinity,

                    color:
                        _secondaryColor
                            .withOpacity(
                      0.6,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  buildFloorSection(),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(
                    "About this place",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight
                              .w800,

                      color:
                          _primaryColor,
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  Text(
                    property["description"]
                            ?.toString() ??
                        "-",

                    style:
                        const TextStyle(
                      fontSize: 13,

                      height: 1.5,

                      color:
                          Colors.black87,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Text(
                    "Facilities",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight
                              .w800,

                      color:
                          _primaryColor,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  buildFacilities(),

                  const SizedBox(
                    height: 26,
                  ),

                  const Text(
                    "Admin Management",

                    style: TextStyle(
                      fontSize: 17,

                      fontWeight:
                          FontWeight
                              .w800,

                      color:
                          _primaryColor,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets
                            .all(
                      15,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          _lightSecondaryColor,

                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),

                      border: Border.all(
                        color:
                            _secondaryColor,
                      ),
                    ),

                    child: Column(
                      children: [
                        adminInfoRow(
                          Icons
                              .person_outline_rounded,

                          "Property Owner",

                          property["owner"]
                                  ?.toString() ??
                              "-",
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        adminInfoRow(
                          Icons
                              .visibility_outlined,

                          "Post Status",

                          formatPostStatus(
                            property[
                                "post_status"],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  SizedBox(
                    width:
                        double.infinity,

                    height: 50,

                    child:
                        ElevatedButton
                            .icon(
                      onPressed:
                          widget
                              .onManagePost,

                      icon:
                          const Icon(
                        Icons
                            .settings_outlined,
                      ),

                      label:
                          const Text(
                        "Manage Post",

                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),

                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            _primaryColor,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatPostStatus(
    dynamic value,
  ) {
    final String status =
        value?.toString().toLowerCase() ??
            "";

    if (status == "active") {
      return "Active";
    }

    if (status == "removed") {
      return "Removed";
    }

    return status.isEmpty
        ? "-"
        : status;
  }

  Widget buildImageSlideshow() {
    if (images.isEmpty) {
      return Container(
        color:
            _lightSecondaryColor,

        child: const Icon(
          Icons.home_work_outlined,

          size: 60,

          color:
              _primaryColor,
        ),
      );
    }

    return ImageSlideshow(
      width: double.infinity,

      height: 300,

      initialPage: 0,

      indicatorColor:
          _primaryColor,

      indicatorBackgroundColor:
          Colors.white70,

      autoPlayInterval:
          images.length > 1
              ? 3000
              : 0,

      isLoop:
          images.length > 1,

      children:
          images.map((image) {
        return Image.network(
          image,

          fit: BoxFit.cover,

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color:
                  _lightSecondaryColor,

              child: const Icon(
                Icons
                    .home_work_outlined,

                size: 55,

                color:
                    _primaryColor,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildRentalStatusBadge() {
    final bool available =
        rentalStatus ==
            "Available";

    final Color color =
        available
            ? const Color(
                0xFF16A34A,
              )
            : const Color(
                0xFFDC2626,
              );

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color,

        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            available
                ? Icons
                    .check_circle_rounded
                : Icons
                    .cancel_rounded,

            color: Colors.white,

            size: 15,
          ),

          const SizedBox(width: 4),

          Text(
            rentalStatus,

            style:
                const TextStyle(
              color: Colors.white,

              fontSize: 12,

              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFloorSection() {
    if (totalFloor <= 0) {
      return const SizedBox.shrink();
    }

    if (hasAvailableFloorList) {
      return Column(
        children: [
          Row(
            children: [
              const Text(
                "Floor",

                style: TextStyle(
                  fontSize: 17,

                  fontWeight:
                      FontWeight
                          .w800,

                  color:
                      _primaryColor,
                ),
              ),

              const Spacer(),

              Text(
                "$totalFloor Floors",

                style:
                    const TextStyle(
                  fontSize: 12,

                  color:
                      Colors.black54,
                ),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    showFloor =
                        !showFloor;
                  });
                },

                icon: Icon(
                  showFloor
                      ? Icons
                          .keyboard_arrow_up
                      : Icons
                          .keyboard_arrow_down,

                  color:
                      _primaryColor,
                ),
              ),
            ],
          ),

          Visibility(
            visible: showFloor,

            child: Container(
              constraints:
                  const BoxConstraints(
                maxHeight: 220,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),

                border: Border.all(
                  color:
                      _secondaryColor
                          .withOpacity(
                    0.5,
                  ),
                ),
              ),

              child:
                  ListView.separated(
                shrinkWrap: true,

                padding:
                    EdgeInsets.zero,

                itemCount:
                    totalFloor,

                separatorBuilder:
                    (
                  context,
                  index,
                ) {
                  return Divider(
                    height: 1,

                    color:
                        _secondaryColor
                            .withOpacity(
                      0.4,
                    ),
                  );
                },

                itemBuilder:
                    (
                  context,
                  index,
                ) {
                  final int floor =
                      index + 1;

                  final bool
                      available =
                      availableFloors
                          .contains(
                    floor,
                  );

                  return Padding(
                    padding:
                        const EdgeInsets
                            .all(
                      10,
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .apartment,

                          color:
                              _primaryColor,

                          size: 20,
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Text(
                          "Floor $floor",

                          style:
                              const TextStyle(
                            color:
                                _primaryColor,

                            fontWeight:
                                FontWeight
                                    .w500,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          available
                              ? "Available"
                              : "Not available",

                          style:
                              TextStyle(
                            color: available
                                ? const Color(
                                    0xFF16A34A,
                                  )
                                : Colors
                                    .black45,

                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Text(
          "Floor",

          style: TextStyle(
            fontSize: 17,

            fontWeight:
                FontWeight.w800,

            color:
                _primaryColor,
          ),
        ),

        const Spacer(),

        const Icon(
          Icons.layers_outlined,

          color:
              _primaryColor,

          size: 19,
        ),

        const SizedBox(width: 5),

        Text(
          "$totalFloor ${totalFloor == 1 ? "Floor" : "Floors"}",

          style:
              const TextStyle(
            color:
                _primaryColor,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildFacilities() {
    if (facilities.isEmpty) {
      return Container(
        width:
            double.infinity,

        padding:
            const EdgeInsets.all(
          16,
        ),

        decoration:
            BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(
            12,
          ),

          border: Border.all(
            color:
                _secondaryColor
                    .withOpacity(
              0.4,
            ),
          ),
        ),

        child: const Text(
          "No facilities listed",

          style: TextStyle(
            color:
                Colors.black54,

            fontSize: 13,
          ),
        ),
      );
    }

    return SizedBox(
      height: 70,

      child:
          ListView.separated(
        scrollDirection:
            Axis.horizontal,

        itemCount:
            facilities.length,

        separatorBuilder:
            (
          context,
          index,
        ) {
          return const SizedBox(
            width: 12,
          );
        },

        itemBuilder:
            (
          context,
          index,
        ) {
          final item =
              facilities[index];

          return Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 13,
            ),

            decoration:
                BoxDecoration(
              color:
                  _lightSecondaryColor,

              borderRadius:
                  BorderRadius
                      .circular(
                13,
              ),

              border: Border.all(
                color:
                    _secondaryColor,
              ),
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              children: [
                Icon(
                  item["icon"],

                  size: 20,

                  color:
                      _primaryColor,
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  item["text"],

                  style:
                      const TextStyle(
                    fontSize: 12,

                    color:
                        _primaryColor,

                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget adminInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,

          size: 20,

          color:
              _primaryColor,
        ),

        const SizedBox(width: 10),

        Text(
          "$title:",

          style:
              const TextStyle(
            fontSize: 13,

            color:
                Colors.black54,
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Text(
            value,

            textAlign:
                TextAlign.end,

            style:
                const TextStyle(
              fontSize: 13,

              fontWeight:
                  FontWeight.w700,

              color:
                  _primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}