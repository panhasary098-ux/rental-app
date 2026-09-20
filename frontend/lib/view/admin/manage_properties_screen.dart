import 'package:final_project/service/admin_service.dart';
import 'package:final_project/view/admin/admin_property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Color _primaryColor = Color(0xFF03045E);
Color _backgroundColor = Color(0xFFF5F6FA);
Color _textColor = Color(0xFF111827);
Color _secondaryTextColor = Color(0xFF6B7280);
Color _borderColor = Color(0xFFE8EAF0);
Color _softGrey = Color(0xFFF5F6F8);

Color _greenColor = Color(0xFF15803D);
Color _greenSoft = Color(0xFFF0FDF4);

Color _redColor = Color(0xFFDC2626);
Color _redSoft = Color(0xFFFEF2F2);

class ManagePropertiesScreen extends StatefulWidget {
  ManagePropertiesScreen({super.key});

  @override
  State<ManagePropertiesScreen> createState() =>
      _ManagePropertiesScreenState();
}

class _ManagePropertiesScreenState extends State<ManagePropertiesScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

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

  // Load Properties
  Future<void> loadProperties() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final result = await adminService.getManagedProperties();

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
        message = message.replaceFirst("Exception: ", "");
      }

      setState(() {
        isLoading = false;
        errorMessage = message;
      });
    }
  }

  // Search
  List<Map<String, dynamic>> get filteredProperties {
    final String query = searchController.text.trim().toLowerCase();

    return properties.where((property) {
      final String title =
          property["title"]?.toString().toLowerCase() ?? "";

      final String owner =
          property["owner"]?.toString().toLowerCase() ?? "";

      final String location =
          property["location"]?.toString().toLowerCase() ?? "";

      final String postStatus =
          property["post_status"]?.toString().toLowerCase() ?? "";

      final bool matchesSearch =
          query.isEmpty ||
          title.contains(query) ||
          owner.contains(query) ||
          location.contains(query);

      bool matchesFilter = true;

      if (selectedFilter == "Active") {
        matchesFilter = postStatus == "active";
      }

      if (selectedFilter == "Removed") {
        matchesFilter = postStatus == "removed";
      }

      return matchesSearch && matchesFilter;
    }).toList();
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
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "active") {
      return "Active";
    }

    if (status == "removed") {
      return "Removed";
    }

    return status.isEmpty ? "-" : status;
  }

  String formatRentalStatus(dynamic value) {
    final String status = value?.toString().toLowerCase() ?? "";

    if (status == "available") {
      return "Available";
    }

    if (status == "rented") {
      return "Rented";
    }

    return status.isEmpty ? "-" : status;
  }

  String getPrice(Map<String, dynamic> property) {
    final dynamic price = property["price"];

    if (price != null && price.toString().isNotEmpty) {
      return price.toString();
    }

    final dynamic rawPrice = property["raw_price"];

    if (rawPrice != null) {
      return "\$$rawPrice / month";
    }

    return "-";
  }

  int getActiveCount() {
    return properties.where((property) {
      return formatPostStatus(property["post_status"]) == "Active";
    }).length;
  }

  int getRemovedCount() {
    return properties.where((property) {
      return formatPostStatus(property["post_status"]) == "Removed";
    }).length;
  }

  int getRentedCount() {
    return properties.where((property) {
      return formatRentalStatus(property["rental_status"]) == "Rented";
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final displayedProperties = filteredProperties;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Column(
              children: [
                // Header
                buildHeader(),
            
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 18),
            
                      // Search
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: buildSearchField(),
                      ),
            
                      SizedBox(height: 13),
            
                      // Filters
                      buildFilters(),
            
                      SizedBox(height: 8),
            
                      Expanded(
                        child: buildContent(displayedProperties),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header
  Widget buildHeader() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(18, 18, 18, 22),
        decoration: BoxDecoration(
          color: _primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manage Properties",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Control your marketplace listings",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: IconButton(
                    onPressed: loadProperties,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 23),

            // Stats
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: buildHeaderStat(
                      properties.length.toString(),
                      "Total",
                      Icons.apartment_rounded,
                    ),
                  ),
                  buildHeaderDivider(),
                  Expanded(
                    child: buildHeaderStat(
                      getActiveCount().toString(),
                      "Active",
                      Icons.visibility_outlined,
                    ),
                  ),
                  buildHeaderDivider(),
                  Expanded(
                    child: buildHeaderStat(
                      getRentedCount().toString(),
                      "Rented",
                      Icons.key_outlined,
                    ),
                  ),
                  buildHeaderDivider(),
                  Expanded(
                    child: buildHeaderStat(
                      getRemovedCount().toString(),
                      "Removed",
                      Icons.visibility_off_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderStat(
    String value,
    String title,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: _primaryColor,
          size: 17,
        ),
        SizedBox(height: 7),
        Text(
          value,
          style: TextStyle(
            color: _textColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 2),
        Text(
          title,
          style: TextStyle(
            color: _secondaryTextColor,
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget buildHeaderDivider() {
    return Container(
      width: 1,
      height: 47,
      color: _borderColor,
    );
  }

  // Search
  Widget buildSearchField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(
          fontSize: 13,
          color: _textColor,
        ),
        decoration: InputDecoration(
          hintText: "Search property, owner, location...",
          hintStyle: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _secondaryTextColor,
            size: 21,
          ),
          suffixIcon: searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: searchController.clear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: _secondaryTextColor,
                    size: 18,
                  ),
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: _primaryColor,
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
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 18),
        children: [
          buildFilterChip(
            "All",
            properties.length,
          ),
          SizedBox(width: 8),
          buildFilterChip(
            "Active",
            getActiveCount(),
          ),
          SizedBox(width: 8),
          buildFilterChip(
            "Removed",
            getRemovedCount(),
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(
    String title,
    int count,
  ) {
    final bool isSelected = selectedFilter == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryColor : _borderColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryColor.withValues(alpha: 0.14),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : _secondaryTextColor,
              ),
            ),
            SizedBox(width: 7),
            Container(
              width: 21,
              height: 21,
              padding: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.14)
                    : _softGrey,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : _secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Content
  Widget buildContent(
    List<Map<String, dynamic>> displayedProperties,
  ) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: _primaryColor,
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
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: _redSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 30,
                  color: _redColor,
                ),
              ),
              SizedBox(height: 14),
              Text(
                "Unable to load properties",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 7),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _secondaryTextColor,
                ),
              ),
              SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: loadProperties,
                icon: Icon(
                  Icons.refresh_rounded,
                ),
                label: Text(
                  "Try Again",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _borderColor,
                ),
              ),
              child: Icon(
                Icons.home_work_outlined,
                color: _primaryColor,
                size: 30,
              ),
            ),
            SizedBox(height: 14),
            Text(
              "No properties found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textColor,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Try changing your search or filter.",
              style: TextStyle(
                fontSize: 12,
                color: _secondaryTextColor,
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
        padding: EdgeInsets.fromLTRB(
          18,
          12,
          18,
          28,
        ),
        itemCount: displayedProperties.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 18);
        },
        itemBuilder: (context, index) {
          return buildPropertyCard(
            displayedProperties[index],
          );
        },
      ),
    );
  }

  // Property Card
  Widget buildPropertyCard(
    Map<String, dynamic> property,
  ) {
    final String imageUrl = getImageUrl(property["image"]);

    final String postStatus =
        formatPostStatus(property["post_status"]);

    final String rentalStatus =
        formatRentalStatus(property["rental_status"]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: postStatus == "Removed"
              ? Color(0xFFFEE2E2)
              : _borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21),
                  topRight: Radius.circular(21),
                ),
                child: imageUrl.isEmpty
                    ? buildLargeImagePlaceholder()
                    : Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 185,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return buildLargeImagePlaceholder();
                        },
                      ),
              ),

              // Image Shade
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.04),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.28),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Post Status
              Positioned(
                top: 13,
                left: 13,
                child: buildPostStatusBadge(
                  postStatus,
                ),
              ),

              // Rental Status
              Positioned(
                top: 13,
                right: 13,
                child: buildRentalStatusBadge(
                  rentalStatus,
                ),
              ),

              // Image Label
              Positioned(
                left: 15,
                bottom: 13,
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "JoulNow Property",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Information
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              17,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property["title"]?.toString() ?? "Property",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: _textColor,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 9),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        getPrice(property),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _softGrey,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 13,
                            color: _secondaryTextColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Admin",
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: _secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                Container(
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: _softGrey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      buildPropertyInfoRow(
                        Icons.person_outline_rounded,
                        "Owner",
                        property["owner"]?.toString() ??
                            "Unknown Owner",
                      ),
                      SizedBox(height: 11),
                      buildPropertyInfoRow(
                        Icons.location_on_outlined,
                        "Location",
                        property["location"]?.toString() ?? "-",
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Container(
                  height: 1,
                  color: _borderColor,
                ),

                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 49,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showPropertyPost(property);
                          },
                          icon: Icon(
                            Icons.visibility_outlined,
                            size: 18,
                          ),
                          label: Text(
                            "View Property",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 54,
                      height: 49,
                      child: OutlinedButton(
                        onPressed: () {
                          showManagePostSheet(property);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: _primaryColor,
                          side: BorderSide(
                            color: _borderColor,
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 23,
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
    );
  }

  Widget buildPropertyInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 16,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  color: _secondaryTextColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLargeImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 185,
      decoration: BoxDecoration(
        color: Color(0xFFEDEEF6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -20,
            bottom: -25,
            child: Icon(
              Icons.apartment_rounded,
              size: 150,
              color: _primaryColor.withValues(alpha: 0.04),
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Icon(
              Icons.home_work_outlined,
              color: _primaryColor,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPostStatusBadge(String status) {
    final bool active = status == "Active";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: active
            ? _primaryColor.withValues(alpha: 0.92)
            : _redColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white,
            size: 12,
          ),
          SizedBox(width: 5),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRentalStatusBadge(String status) {
    final bool available = status == "Available";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: available ? _greenColor : _redColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: available ? _greenColor : _redColor,
            ),
          ),
        ],
      ),
    );
  }

  // Property Detail
  void showPropertyPost(Map<String, dynamic> property) {
    Get.to(
      () => AdminPropertyDetailScreen(
        property: property,
        onManagePost: () {
          showManagePostSheet(property);
        },
      ),
    );
  }

  // Manage Post
  void showManagePostSheet(Map<String, dynamic> property) {
    final String postStatus =
        formatPostStatus(property["post_status"]);

    final String rentalStatus =
        formatRentalStatus(property["rental_status"]);

    final String imageUrl =
        getImageUrl(property["image"]);

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sheet Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    18,
                    12,
                    18,
                    19,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: imageUrl.isEmpty
                                ? buildSheetImagePlaceholder()
                                : Image.network(
                                    imageUrl,
                                    width: 67,
                                    height: 67,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return buildSheetImagePlaceholder();
                                    },
                                  ),
                          ),
                          SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Manage Property",
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.62,
                                    ),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  property["title"]?.toString() ??
                                      "Property",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      getPrice(property),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.45,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      rentalStatus,
                                      style: TextStyle(
                                        color: rentalStatus == "Available"
                                            ? Color(0xFF86EFAC)
                                            : Color(0xFFFCA5A5),
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(
                    18,
                    18,
                    18,
                    25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VISIBILITY CONTROL",
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),

                      SizedBox(height: 11),

                      // Keep Post
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();

                            if (postStatus != "Active") {
                              updatePostStatus(
                                property: property,
                                postStatus: "active",
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(17),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: postStatus == "Active"
                                    ? _primaryColor.withValues(alpha: 0.25)
                                    : _borderColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.025,
                                  ),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 43,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF0F1FA),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    color: _primaryColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Keep Property",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _textColor,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Visible to JoulNow renters",
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: _secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (postStatus == "Active")
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _greenSoft,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: _greenColor,
                                      size: 17,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFFB4B8C2),
                                    size: 14,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 11),

                      // Remove Post
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();

                            if (postStatus != "Removed") {
                              showRemoveConfirmation(property);
                            }
                          },
                          borderRadius: BorderRadius.circular(17),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17),
                              border: Border.all(
                                color: postStatus == "Removed"
                                    ? _redColor.withValues(alpha: 0.25)
                                    : _borderColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: 0.025,
                                  ),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 43,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: _redSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.visibility_off_outlined,
                                    color: _redColor,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Remove Property",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: _redColor,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Hide from public listings",
                                        style: TextStyle(
                                          fontSize: 10.5,
                                          color: _secondaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (postStatus == "Removed")
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _redSoft,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: _redColor,
                                      size: 17,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFFB4B8C2),
                                    size: 14,
                                  ),
                              ],
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
      isScrollControlled: true,
    );
  }

  Widget buildSheetImagePlaceholder() {
    return Container(
      width: 67,
      height: 67,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        Icons.home_work_outlined,
        color: Colors.white,
        size: 25,
      ),
    );
  }

  // Remove Confirmation
  void showRemoveConfirmation(
    Map<String, dynamic> property,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: _redSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.visibility_off_outlined,
                color: _redColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "Remove Property?",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          "This property will be hidden from public listings. You can activate it again later.",
          style: TextStyle(
            fontSize: 13,
            height: 1.45,
            color: _secondaryTextColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              "Cancel",
              style: TextStyle(
                color: _secondaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              updatePostStatus(
                property: property,
                postStatus: "removed",
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _redColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              "Remove",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Update Status
  Future<void> updatePostStatus({
    required Map<String, dynamic> property,
    required String postStatus,
  }) async {
    final int? propertyId = int.tryParse(
      property["id"].toString(),
    );

    if (propertyId == null) {
      Get.snackbar(
        "Error",
        "Property ID is missing.",
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(
            color: _primaryColor,
          ),
        ),
        barrierDismissible: false,
      );

      final bool success =
          await adminService.updatePropertyPostStatus(
        propertyId: propertyId,
        postStatus: postStatus,
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (!mounted) {
        return;
      }

      if (success) {
        setState(() {
          property["post_status"] = postStatus;
        });

        Get.snackbar(
          postStatus == "active"
              ? "Post Activated"
              : "Post Removed",
          postStatus == "active"
              ? "The property is visible to renters again."
              : "The property has been removed from public listings.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: postStatus == "active"
              ? _primaryColor
              : _redColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst(
          "Exception: ",
          "",
        );
      }

      Get.snackbar(
        "Update Failed",
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: _redColor,
        colorText: Colors.white,
      );
    }
  }
}