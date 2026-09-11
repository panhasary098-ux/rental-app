import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color ownerPrimaryColor = Color(0xFF03045E);
const Color ownerBackgroundColor = Color(0xFFF4FCFE);
const Color ownerLightSecondaryColor = Color(0xFFE6F9FC);

class OwnerHomeScreen extends StatelessWidget {
  OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ownerBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              buildHeader(),

              const SizedBox(height: 22),

              // ==================================================
              // HERO
              // ==================================================
              buildHeroCard(),

              const SizedBox(height: 20),

              // ==================================================
              // SUMMARY GRID
              // ==================================================
              buildSummarySection(),
              const SizedBox(height: 10),

              // ==================================================
              // RECENT PROPERTIES TITLE
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Properties",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ownerPrimaryColor,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      // Navigate to My Properties later
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: ownerPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ==================================================
              // PROPERTY 1
              // ==================================================
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1564013799919-ab600027ffc6",
                title: "Modern Family House",
                location: "Sen Sok, Phnom Penh",
                price: "\$850 / month",
                rentalStatus: "Available",
                verificationStatus: "Approved",
              ),

              const SizedBox(height: 14),

              // ==================================================
              // PROPERTY 2
              // ==================================================
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
                title: "BKK1 City Apartment",
                location: "BKK1, Phnom Penh",
                price: "\$550 / month",
                rentalStatus: "Rented",
                verificationStatus: "Approved",
              ),

              const SizedBox(height: 14),

              // ==================================================
              // PROPERTY 3
              // ==================================================
              buildPropertyCard(
                image:
                    "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
                title: "Toul Kork Room",
                location: "Toul Kork, Phnom Penh",
                price: "\$180 / month",
                rentalStatus: "Available",
                verificationStatus: "Pending",
              ),
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
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: ownerLightSecondaryColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            "DS",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: ownerPrimaryColor,
            ),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Dara Sok",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ownerPrimaryColor,
                ),
              ),

              SizedBox(height: 2),

              Text(
                "House Owner",
                style: TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: Colors.grey.withOpacity(0.25)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: ownerPrimaryColor,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // HERO CARD
  // =========================================================

  Widget buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 235,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
          ),
          fit: BoxFit.cover,
        ),
      ),

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ownerPrimaryColor.withOpacity(0.95),
              ownerPrimaryColor.withOpacity(0.60),
              Colors.transparent,
            ],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "Manage Your\nProperties with\nEase",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: 230,
              child: Text(
                "Post, track and manage your rental "
                "properties all in one place.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.35,
                ),
              ),
            ),

            const SizedBox(height: 12),

            InkWell(
              onTap: () {
                // Navigate to Post Property later
              },

              borderRadius: BorderRadius.circular(30),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 20, color: ownerPrimaryColor),

                    SizedBox(width: 6),

                    Text(
                      "Post a New Property",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ownerPrimaryColor,
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

  // =========================================================
  // SUMMARY GRID
  // =========================================================

  Widget buildSummarySection() {
    return GridView.count(
      crossAxisCount: 2,

      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      crossAxisSpacing: 12,

      mainAxisSpacing: 12,

      childAspectRatio: 2.15,

      children: [
        buildSummaryCard(
          icon: Icons.home_rounded,
          number: "5",
          title: "Total",
          iconBackground: const Color(0xFFE6F0FF),
          iconColor: const Color(0xFF2563EB),
        ),

        buildSummaryCard(
          icon: Icons.schedule_rounded,
          number: "1",
          title: "Pending",
          iconBackground: const Color(0xFFFFF1D6),
          iconColor: const Color(0xFFF59E0B),
        ),

        buildSummaryCard(
          icon: Icons.check_circle_rounded,
          number: "3",
          title: "Available",
          iconBackground: const Color(0xFFE6F7EE),
          iconColor: const Color(0xFF16A34A),
        ),

        buildSummaryCard(
          icon: Icons.key_rounded,
          number: "1",
          title: "Rented",
          iconBackground: const Color(0xFFFFE8E8),
          iconColor: const Color(0xFFDC2626),
        ),
      ],
    );
  }

  // =========================================================
  // SUMMARY CARD
  // =========================================================

  Widget buildSummaryCard({
    required IconData icon,
    required String number,
    required String title,
    required Color iconBackground,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.18)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, size: 24, color: iconColor),
          ),

          const SizedBox(width: 13),

          // NUMBER + TITLE
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ownerPrimaryColor,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7D8990),
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
  // QUICK ACTION
  // =========================================================

  // =========================================================
  // PROPERTY CARD
  // =========================================================

  Widget buildPropertyCard({
    required String image,
    required String title,
    required String location,
    required String price,
    required String rentalStatus,
    required String verificationStatus,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: Colors.grey.withOpacity(0.22)),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),

                child: Image.network(
                  image,
                  width: 115,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                left: 7,
                top: 7,

                child: buildBadge(
                  rentalStatus,

                  rentalStatus == "Available"
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFDC2626),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ownerPrimaryColor,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: Color(0xFF667085),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF7D8990),
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7D8990),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  price,

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ownerPrimaryColor,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    buildBadge(
                      verificationStatus,

                      verificationStatus == "Approved"
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFF59E0B),
                    ),

                    const Spacer(),

                    InkWell(
                      onTap: () {
                        showStatusBottomSheet(title, rentalStatus);
                      },

                      borderRadius: BorderRadius.circular(10),

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                          border: Border.all(color: const Color(0xFF2563EB)),
                        ),

                        child: const Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              Icons.swap_horiz_rounded,
                              size: 15,
                              color: Color(0xFF2563EB),
                            ),

                            SizedBox(width: 3),

                            Text(
                              "Status",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
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

  // =========================================================
  // BADGE
  // =========================================================

  Widget buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

      decoration: BoxDecoration(
        color: color.withOpacity(0.10),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // =========================================================
  // CHANGE AVAILABILITY BOTTOM SHEET
  // =========================================================

  void showStatusBottomSheet(String propertyName, String currentStatus) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.30),

                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Change Availability",

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ownerPrimaryColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              propertyName,

              style: const TextStyle(fontSize: 12, color: Color(0xFF7D8990)),
            ),

            const SizedBox(height: 20),

            buildStatusOption(
              icon: Icons.check_circle_outline_rounded,

              title: "Available",

              subtitle: "This property is currently open for rent",

              color: const Color(0xFF16A34A),

              selected: currentStatus == "Available",

              onTap: () {
                Get.back();

                // Update property later
              },
            ),

            const SizedBox(height: 12),

            buildStatusOption(
              icon: Icons.key_rounded,

              title: "Rented",

              subtitle: "This property is currently occupied",

              color: const Color(0xFFDC2626),

              selected: currentStatus == "Rented",

              onTap: () {
                Get.back();

                // Update property later
              },
            ),
          ],
        ),
      ),

      isScrollControlled: true,
    );
  }

  // =========================================================
  // STATUS OPTION
  // =========================================================

  Widget buildStatusOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(
            color: selected ? color : Colors.grey.withOpacity(0.30),
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(0.10),

                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(icon, color: color, size: 22),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ownerPrimaryColor,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7D8990),
                    ),
                  ),
                ],
              ),
            ),

            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
