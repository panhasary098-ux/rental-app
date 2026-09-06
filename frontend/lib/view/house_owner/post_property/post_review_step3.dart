import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color backgroundColor = Color(0xFFF4FCFE);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PostReviewStep3 extends StatelessWidget {
  const PostReviewStep3({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // ======================================================
          // TITLE
          // ======================================================

          const Text(
            "Review Your Listing",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Check the details below before publishing.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // MAIN REVIEW CARD
          // ======================================================

          Container(
            width: double.infinity,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: secondaryColor.withOpacity(0.35),
              ),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // PROPERTY IMAGE
                // ==================================================

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),

                  child: Image.network(
                    "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============================================
                      // NAME
                      // ============================================

                      const Text(
                        "Cozy Family House",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // LOCATION
                      // ============================================

                      const Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: primaryColor,
                          ),

                          SizedBox(width: 5),

                          Expanded(
                            child: Text(
                              "Phnom Penh, Cambodia",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // PRICE
                      // ============================================

                      const Text(
                        "\$500 / month",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Divider(
                        color: secondaryColor.withOpacity(0.55),
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // PROPERTY INFORMATION
                      // ============================================

                      reviewRow(
                        title: "Property Type",
                        value: "House",
                      ),

                      reviewRow(
                        title: "Bedrooms",
                        value: "3",
                      ),

                      reviewRow(
                        title: "Bathrooms",
                        value: "2",
                      ),

                      reviewRow(
                        title: "Total Floors",
                        value: "2",
                      ),

                      reviewRow(
                        title: "Size",
                        value: "120 m²",
                      ),

                      reviewRow(
                        title: "Furnished",
                        value: "Furnished",
                      ),

                      reviewRow(
                        title: "Status",
                        value: "Available now",
                      ),

                      reviewRow(
                        title: "Contact",
                        value: "012 345 678",
                      ),

                      const SizedBox(height: 12),

                      // ============================================
                      // FACILITIES
                      // ============================================

                      const Text(
                        "Facilities",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,

                        children: [
                          FacilityChip(
                            icon: Icons.wifi,
                            text: "WiFi",
                          ),

                          FacilityChip(
                            icon: Icons.local_parking_outlined,
                            text: "Parking",
                          ),

                          FacilityChip(
                            icon: Icons.ac_unit,
                            text: "Air Con",
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Divider(
                        color: secondaryColor.withOpacity(0.55),
                      ),

                      const SizedBox(height: 8),

                      // ============================================
                      // DESCRIPTION
                      // ============================================

                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "A comfortable family house located in a quiet area.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ======================================================
// REVIEW ROW
// ======================================================

Widget reviewRow({
  required String title,
  required String value,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),

    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

// ======================================================
// FACILITY CHIP
// ======================================================

class FacilityChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const FacilityChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: lightSecondaryColor,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(
          color: secondaryColor,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 16,
            color: primaryColor,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}