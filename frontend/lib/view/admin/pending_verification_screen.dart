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

class _PendingVerificationScreenState extends State<PendingVerificationScreen> {
  final AdminService adminService = AdminService();

  final TextEditingController searchController = TextEditingController();

  // =========================================================
  // COLORS
  // =========================================================

  static const Color primaryColor = Color(0xFF03045E);

  static const Color backgroundColor = Color(0xFFF8FAFC);

  static const Color cardColor = Colors.white;

  static const Color textColor = Color(0xFF111827);

  static const Color secondaryTextColor = Color(0xFF6B7280);

  static const Color borderColor = Color(0xFFE5E7EB);

  static const Color orangeAccent = Color(0xFFD97706);

  static const Color orangeSoft = Color(0xFFFFF7E6);

  static const Color blueAccent = Color(0xFF2563EB);

  static const Color blueSoft = Color(0xFFEFF6FF);

  static const Color purpleAccent = Color(0xFF7C3AED);

  static const Color purpleSoft = Color(0xFFF3E8FF);

  static const Color greenAccent = Color(0xFF16A34A);

  static const Color greenSoft = Color(0xFFECFDF3);

  static const Color redAccent = Color(0xFFDC2626);

  static const Color redSoft = Color(0xFFFEF2F2);

  // =========================================================
  // DATA
  // =========================================================

  List<Map<String, dynamic>> pendingProperties = [];

  List<Map<String, dynamic>> filteredProperties = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadPendingProperties();

    searchController.addListener(filterProperties);
  }

  @override
  void dispose() {
    searchController.removeListener(filterProperties);

    searchController.dispose();

    super.dispose();
  }

  Future<void> loadPendingProperties() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      final List<Map<String, dynamic>> properties = await adminService
          .getPendingProperties();

      if (!mounted) {
        return;
      }

      setState(() {
        pendingProperties = properties;

        filteredProperties = List<Map<String, dynamic>>.from(properties);

        isLoading = false;
      });

      filterProperties();
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

  // =========================================================
  // SEARCH
  // =========================================================

  void filterProperties() {
    if (!mounted) {
      return;
    }

    final String query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        filteredProperties = List<Map<String, dynamic>>.from(pendingProperties);
      });

      return;
    }

    setState(() {
      filteredProperties = pendingProperties.where((property) {
        final String title =
            property["title"]?.toString().toLowerCase() ??
            property["name"]?.toString().toLowerCase() ??
            "";

        final String owner = property["owner"]?.toString().toLowerCase() ?? "";

        final String location =
            property["location"]?.toString().toLowerCase() ??
            property["address"]?.toString().toLowerCase() ??
            "";

        return title.contains(query) ||
            owner.contains(query) ||
            location.contains(query);
      }).toList();
    });
  }

  // =========================================================
  // IMAGE URL
  // =========================================================

  String getImageUrl(dynamic value) {
    if (value == null) {
      return "";
    }

    String url = value.toString();

    url = url.replaceFirst("http://localhost:8000", "http://10.0.2.2:8000");

    url = url.replaceFirst("http://127.0.0.1:8000", "http://10.0.2.2:8000");

    return url;
  }

  // =========================================================
  // OPEN REVIEW
  // =========================================================

  Future<void> openReview(Map<String, dynamic> property) async {
    final dynamic result = await Get.to(
      () => PropertyReviewScreen(property: property),
    );

    if (result is Map && result["success"] == true) {
      await loadPendingProperties();
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,

          onRefresh: loadPendingProperties,

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            slivers: [
              // =================================================
              // HEADER
              // Scrolls normally
              // =================================================
              SliverToBoxAdapter(child: buildHeader()),

              const SliverToBoxAdapter(child: SizedBox(height: 18)),

              // =================================================
              // SUMMARY
              // Scrolls normally
              // =================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
                  child: buildSummaryCard(),
                ),
              ),

              // =================================================
              // STICKY SEARCH
              // This stays at the top when scrolling
              // =================================================
              SliverAppBar(
                pinned: true,

                floating: false,

                automaticallyImplyLeading: false,

                backgroundColor: backgroundColor,

                surfaceTintColor: backgroundColor,

                elevation: 0,

                scrolledUnderElevation: 2,

                toolbarHeight: 70,

                titleSpacing: 0,

                title: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  child: buildSearchField(),
                ),
              ),

              // =================================================
              // CONTENT
              // =================================================
              buildContentSliver(),

              const SliverToBoxAdapter(child: SizedBox(height: 25)),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget buildHeader() {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.fromLTRB(18, 30, 18, 0),

      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),

      decoration: BoxDecoration(
        color: primaryColor,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),

            blurRadius: 18,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Property Verification",

                  style: TextStyle(
                    fontSize: 20,

                    fontWeight: FontWeight.w600,

                    color: Colors.white,

                    letterSpacing: -0.4,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Review and verify submitted properties",

                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 42,

            height: 42,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),

              borderRadius: BorderRadius.circular(11),
            ),

            child: IconButton(
              onPressed: loadPendingProperties,

              icon: const Icon(
                Icons.refresh_rounded,

                color: Colors.white,

                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY
  // =========================================================

  Widget buildSummaryCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: borderColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 50,

            height: 50,

            decoration: BoxDecoration(
              //color: orangeSoft,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.pending_actions_rounded,

              color: Color.fromARGB(255, 253, 150, 15),

              size: 30,
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "${pendingProperties.length} submissions waiting",

                  style: const TextStyle(
                    fontSize: 16,

                    fontWeight: FontWeight.w800,

                    color: textColor,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Review property details and verification documents.",

                  style: TextStyle(
                    fontSize: 11.5,

                    height: 1.35,

                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SEARCH FIELD
  // =========================================================

  Widget buildSearchField() {
    return SizedBox(
      height: 54,

      child: TextField(
        controller: searchController,

        textAlignVertical: TextAlignVertical.center,

        decoration: InputDecoration(
          hintText: "Search property, owner or location",

          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),

          prefixIcon: const Icon(
            Icons.search_rounded,

            color: secondaryTextColor,

            size: 21,
          ),

          // suffixIcon: searchController.text.isNotEmpty
          //     ? IconButton(
          //         onPressed: () {
          //           searchController.clear();
          //         },

          //         icon: const Icon(
          //           Icons.close_rounded,

          //           color: secondaryTextColor,

          //           size: 20,
          //         ),
          //       )
          //     : Container(
          //         width: 38,

          //         margin: const EdgeInsets.all(8),

          //         decoration: BoxDecoration(
          //           color: blueSoft,

          //           borderRadius: BorderRadius.circular(9),
          //         ),
          //       ),
          filled: true,

          fillColor: cardColor,

          contentPadding: const EdgeInsets.symmetric(vertical: 14),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(color: borderColor),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(color: borderColor),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),

            borderSide: const BorderSide(color: Colors.black12, width: 1.4),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget buildContentSliver() {
    // -------------------------
    // Loading
    // -------------------------

    if (isLoading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 300,

          child: Center(child: CircularProgressIndicator(color: primaryColor)),
        ),
      );
    }

    // -------------------------
    // Error
    // -------------------------

    if (errorMessage != null) {
      return SliverToBoxAdapter(
        child: SizedBox(height: 320, child: buildErrorState()),
      );
    }

    // -------------------------
    // Empty
    // -------------------------

    if (filteredProperties.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(height: 300, child: buildEmptyState()),
      );
    }

    // -------------------------
    // Property List
    // -------------------------

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),

      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == filteredProperties.length - 1 ? 0 : 14,
            ),

            child: buildPropertyCard(filteredProperties[index]),
          );
        }, childCount: filteredProperties.length),
      ),
    );
  }

  // =========================================================
  // ERROR STATE
  // =========================================================

  Widget buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 70,

              height: 70,

              decoration: const BoxDecoration(
                color: redSoft,

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline_rounded,

                size: 34,

                color: redAccent,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "Unable to load pending properties",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 16,

                fontWeight: FontWeight.w700,

                color: textColor,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              errorMessage ?? "",

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 13, color: secondaryTextColor),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: loadPendingProperties,

              icon: const Icon(Icons.refresh_rounded),

              label: const Text("Try Again"),

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,

                foregroundColor: Colors.white,

                elevation: 0,

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

  // =========================================================
  // EMPTY STATE
  // =========================================================

  Widget buildEmptyState() {
    final bool searching = searchController.text.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              width: 72,

              height: 72,

              decoration: BoxDecoration(
                color: searching ? blueSoft : greenSoft,

                borderRadius: BorderRadius.circular(22),
              ),

              child: Icon(
                searching
                    ? Icons.search_off_rounded
                    : Icons.verified_user_outlined,

                size: 34,

                color: searching ? blueAccent : greenAccent,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              searching ? "No results found" : "No pending submissions",

              style: const TextStyle(
                fontSize: 16,

                fontWeight: FontWeight.w700,

                color: textColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              searching
                  ? "Try another property, owner or location."
                  : "New property submissions will appear here.",

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 12, color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PROPERTY CARD
  // =========================================================

  Widget buildPropertyCard(Map<String, dynamic> property) {
    final String imageUrl = getImageUrl(property["image"]);

    final String ownerProfileImageUrl =
        getImageUrl(property["owner_profile_image"]);

    return InkWell(
      onTap: () {
        openReview(property);
      },

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: borderColor),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),

              blurRadius: 12,

              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            // =================================================
            // PROPERTY INFO
            // =================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // -------------------------
                // IMAGE
                // -------------------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),

                  child: imageUrl.isEmpty
                      ? buildImagePlaceholder()
                      : Image.network(
                          imageUrl,

                          width: 105,

                          height: 105,

                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return buildImagePlaceholder();
                          },
                        ),
                ),

                const SizedBox(width: 13),

                // -------------------------
                // DETAILS
                // -------------------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // -----------------------
                      // STATUS
                      // -----------------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: orangeSoft,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.schedule_rounded,

                              size: 13,

                              color: orangeAccent,
                            ),

                            SizedBox(width: 4),

                            Text(
                              "Pending Verification",

                              style: TextStyle(
                                fontSize: 9.5,

                                fontWeight: FontWeight.w600,

                                color: orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // -----------------------
                      // TITLE
                      // -----------------------
                      Text(
                        property["title"]?.toString() ??
                            property["name"]?.toString() ??
                            "Property",

                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 16,

                          fontWeight: FontWeight.w700,

                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 7),

                      // -----------------------
                      // PRICE
                      // -----------------------
                      Text(
                        property["price"]?.toString() ?? "-",

                        style: const TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.w800,

                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 7),

                      // -----------------------
                      // LOCATION
                      // -----------------------
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,

                            size: 15,

                            color: secondaryTextColor,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              property["location"]?.toString() ??
                                  property["address"]?.toString() ??
                                  "-",

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 12,

                                color: secondaryTextColor,
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

            const Divider(color: borderColor, height: 1),

            const SizedBox(height: 13),

            // =================================================
            // OWNER
            // =================================================
            Row(
              children: [
                Container(
                  width: 40,

                  height: 40,

                  decoration: BoxDecoration(
                    color: blueSoft,

                    shape: BoxShape.circle,
                  ),

                  child: ClipOval(
                    child: ownerProfileImageUrl.isEmpty
                        ? Icon(
                            Icons.person_outline_rounded,

                            color: blueAccent,

                            size: 20,
                          )
                        : Image.network(
                            ownerProfileImageUrl,

                            width: 40,

                            height: 40,

                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person_outline_rounded,

                                color: blueAccent,

                                size: 20,
                              );
                            },
                          ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "House Owner",

                        style: TextStyle(
                          color: Color(0xFF9CA3AF),

                          fontSize: 10.5,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        property["owner"]?.toString() ?? "Unknown Owner",

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: textColor,

                          fontWeight: FontWeight.w600,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    const Text(
                      "Submitted",

                      style: TextStyle(
                        color: Color(0xFF9CA3AF),

                        fontSize: 10.5,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      property["submitted"]?.toString() ?? "-",

                      style: const TextStyle(
                        color: secondaryTextColor,

                        fontSize: 12,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // =================================================
            // REVIEW BUTTON
            // =================================================
            SizedBox(
              width: double.infinity,

              height: 46,

              child: ElevatedButton(
                onPressed: () {
                  openReview(property);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,

                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(Icons.fact_check_outlined, size: 19),

                    SizedBox(width: 8),

                    Text(
                      "Review Submission",

                      style: TextStyle(fontWeight: FontWeight.w700),
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

  // =========================================================
  // IMAGE PLACEHOLDER
  // =========================================================

  Widget buildImagePlaceholder() {
    return Container(
      width: 105,

      height: 105,

      decoration: BoxDecoration(
        color: purpleSoft,

        borderRadius: BorderRadius.circular(13),
      ),

      child: const Icon(
        Icons.home_work_outlined,

        color: purpleAccent,

        size: 34,
      ),
    );
  }
}
