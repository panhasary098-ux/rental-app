import 'package:final_project/model/property.dart';
import 'package:final_project/view/renter/filter_screen.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class HomeScreen extends StatelessWidget {
  final List<Property> properties;

  HomeScreen({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 27,
                      color: primaryColor,
                    ),
                  ),

                  appName(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 27,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // ==================================================
              // HEADLINE
              // ==================================================
              headline(),

              const SizedBox(height: 20),

              // ==================================================
              // SEARCH
              // ==================================================
              searchBox(),

              const SizedBox(height: 20),

              // ==================================================
              // LOCATION
              // ==================================================
              filterLocation(),

              const SizedBox(height: 12),

              // ==================================================
              // BUDGET + TYPE
              // ==================================================
              Row(
                children: [
                  Expanded(child: filterPrice()),

                  const SizedBox(width: 12),

                  Expanded(child: filterType()),
                ],
              ),

              const SizedBox(height: 20),

              // ==================================================
              // RECOMMENDED TITLE
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recommended for you",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},

                    child: const Text(
                      "See all",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // ==================================================
              // PROPERTY LIST
              // ==================================================
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: properties.length,

                itemBuilder: (context, index) {
                  final property = properties[index];

                  return Container(
                    width: 300,

                    margin: const EdgeInsets.only(bottom: 15),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: primaryColor.withOpacity(0.08),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: InkWell(
                      onTap: () {
                        Get.to(() => const PropertyDetailScreen());
                      },

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ========================================
                          // IMAGE
                          // ========================================
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(18),
                                ),

                                child: Image.network(
                                  property.images[0],
                                  height: 190,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // ====================================
                              // FAVORITE
                              // ====================================
                              Positioned(
                                top: 10,
                                right: 10,

                                child: Container(
                                  width: 36,
                                  height: 36,

                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.favorite_border_rounded,
                                    color: primaryColor,
                                  ),
                                ),
                              ),

                              // ====================================
                              // PROPERTY STATUS
                              // ====================================
                              Positioned(
                                top: 10,
                                left: 10,

                                child: buildStatusBadge(property.status),
                              ),
                            ],
                          ),

                          // ========================================
                          // PROPERTY INFORMATION
                          // ========================================
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NAME
                                Text(
                                  property.name,

                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // LOCATION
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 15,
                                      color: primaryColor,
                                    ),

                                    const SizedBox(width: 3),

                                    Expanded(
                                      child: Text(
                                        "${property.location.address}",

                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                // PRICE
                                Text(
                                  "\$${property.price.toInt()} / month",

                                  style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// PROPERTY STATUS BADGE
// ======================================================

Widget buildStatusBadge(String status) {
  Color statusColor;

  if (status.toLowerCase() == "available" ||
      status.toLowerCase() == "available now") {
    statusColor = const Color(0xFF16A34A);
  } else if (status.toLowerCase() == "rented") {
    statusColor = const Color(0xFFDC2626);
  } else {
    statusColor = const Color(0xFFF59E0B);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),

      borderRadius: BorderRadius.circular(20),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // STATUS DOT
        Container(
          width: 7,
          height: 7,

          decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
        ),

        const SizedBox(width: 5),

        // STATUS TEXT
        Text(
          status,

          style: TextStyle(
            color: statusColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

// ======================================================
// APP NAME
// ======================================================

Widget appName() {
  return RichText(
    text: const TextSpan(
      children: [
        TextSpan(
          text: "Joul",
          style: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextSpan(
          text: "Now",
          style: TextStyle(
            color: Color.fromARGB(255, 2, 216, 253),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

// ======================================================
// HEADLINE
// ======================================================

Widget headline() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Find a place",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),

      Row(
        children: [
          Text(
            "near your ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          Text(
            "school",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 216, 253),
            ),
          ),

          Text(
            " or ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          Text(
            "work",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 2, 216, 253),
            ),
          ),
        ],
      ),
    ],
  );
}

// ======================================================
// SEARCH BOX
// ======================================================

Widget searchBox() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),

      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.08),
          blurRadius: 8,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ],
    ),

    child: TextFormField(
      style: const TextStyle(color: primaryColor),

      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: primaryColor),

        hintText: 'Search Property name....',

        hintStyle: const TextStyle(color: Colors.black38),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),

        suffixIcon: Tooltip(
          waitDuration: const Duration(milliseconds: 500),

          showDuration: const Duration(seconds: 2),

          preferBelow: false,

          message: "Filter",

          child: IconButton(
            onPressed: () {
              Get.to(() => const FilterScreen());
            },

            icon: const Icon(Icons.tune, color: primaryColor),
          ),
        ),
      ),
    ),
  );
}

// ======================================================
// LOCATION FILTER
// ======================================================

Widget filterLocation() {
  return Container(
    padding: const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(17),

      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: lightSecondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),

          child: const Icon(Icons.location_on_outlined, color: primaryColor),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Near", style: TextStyle(fontSize: 12, color: Colors.grey)),

              SizedBox(height: 3),

              Text(
                "Phnom Penh",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),

        const Icon(Icons.chevron_right_rounded, color: primaryColor),
      ],
    ),
  );
}

// ======================================================
// PRICE FILTER
// ======================================================

Widget filterPrice() {
  return Container(
    height: 67,

    padding: const EdgeInsets.symmetric(horizontal: 13),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(17),

      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.07),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),

    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,

          decoration: BoxDecoration(
            color: lightSecondaryColor,
            borderRadius: BorderRadius.circular(9),
          ),

          child: const Icon(
            Icons.account_balance_wallet_outlined,
            size: 22,
            color: primaryColor,
          ),
        ),

        const SizedBox(width: 9),

        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Budget",
                style: TextStyle(color: Color(0xFF6F6F6F), fontSize: 11),
              ),

              SizedBox(height: 3),

              Text(
                "Price range",
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// ======================================================
// PROPERTY TYPE FILTER
// ======================================================

Widget filterType() {
  return Container(
    height: 67,

    padding: const EdgeInsets.symmetric(horizontal: 13),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius: BorderRadius.circular(17),

      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.07),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),

    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,

          decoration: BoxDecoration(
            color: lightSecondaryColor,
            borderRadius: BorderRadius.circular(9),
          ),

          child: const Icon(Icons.home_outlined, size: 23, color: primaryColor),
        ),

        const SizedBox(width: 9),

        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Filters",
                style: TextStyle(color: Color(0xFF6F6F6F), fontSize: 11),
              ),

              SizedBox(height: 3),

              Text(
                "Rooms",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
