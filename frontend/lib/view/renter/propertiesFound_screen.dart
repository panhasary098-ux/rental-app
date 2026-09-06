import 'package:final_project/model/property.dart';
import 'package:final_project/view/renter/property_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertiesfoundScreen extends StatefulWidget {
  const PropertiesfoundScreen({super.key});

  @override
  State<PropertiesfoundScreen> createState() => _PropertiesfoundScreenState();
}

class _PropertiesfoundScreenState extends State<PropertiesfoundScreen> {
  List<String> favorites = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        title: Padding(
          padding: const EdgeInsets.only(right: 10),

          child: SizedBox(
            height: 50,

            child: Container(
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
                style: const TextStyle(
                  fontSize: 15,
                  color: primaryColor,
                ),

                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: primaryColor,
                  ),

                  hintText: 'Search Property name....',

                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,

        itemBuilder: (context, index) {
          final item = properties[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 15),

            child: customitemShow(
              image: item.images[0],
              name: item.name,
              location: item.location.address.toString(),
              price: item.price,
            ),
          );
        },
      ),
    );
  }

  // ======================================================
  // PROPERTY ITEM
  // ======================================================

  Widget customitemShow({
    required String image,
    required String name,
    required String location,
    required double price,
  }) {
    bool isFavorite = favorites.contains(name);

    return Container(
      height: 150,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          // ======================================================
          // IMAGE
          // ======================================================

          Padding(
            padding: const EdgeInsets.all(10),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),

              child: SizedBox(
                width: 140,
                height: double.infinity,

                child: Stack(
                  fit: StackFit.expand,

                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => PropertyDetailScreen());
                      },

                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // ======================================================
                    // AVAILABLE BADGE
                    // ======================================================

                    Positioned(
                      top: 5,
                      left: 5,

                      child: Container(
                        height: 22,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        alignment: Alignment.center,

                        child: const Text(
                          "Available",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // INFORMATION
          // ======================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 10,
                bottom: 8,
                right: 8,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // Property name
                  Text(
                    name,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Location
                  Text(
                    location,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // ======================================================
                  // PRICE
                  // ======================================================

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "\$${price.toStringAsFixed(0)}",

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      const Text(
                        '/Month',

                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // ======================================================
                  // DISTANCE + FAVORITE
                  // ======================================================

                  SizedBox(
                    height: 30,

                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 18,
                        ),

                        const SizedBox(width: 2),

                        const Text(
                          "1 Km",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isFavorite) {
                                favorites.remove(name);
                              } else {
                                favorites.add(name);
                              }
                            });
                          },

                          padding: EdgeInsets.zero,

                          constraints: const BoxConstraints(
                            minWidth: 30,
                            minHeight: 30,
                          ),

                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,

                            color: isFavorite
                                ? primaryColor
                                : primaryColor.withOpacity(0.75),

                            size: 20,
                          ),
                        ),
                      ],
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
}
