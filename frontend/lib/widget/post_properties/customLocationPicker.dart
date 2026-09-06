import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PropertyLocationPicker extends StatelessWidget {
  final String? address;
  final VoidCallback onTap;

  const PropertyLocationPicker({
    super.key,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = address != null && address!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: secondaryColor.withOpacity(0.35)),

          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            // ==================================================
            // LOCATION ICON
            // ==================================================
            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: lightSecondaryColor,
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Icon(
                Icons.location_on_outlined,
                color: primaryColor,
                //color: Colors.red,
              ),
            ),

            const SizedBox(width: 12),

            // ==================================================
            // LOCATION TEXT
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    hasLocation ? address! : "Select property location",

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,

                      color: hasLocation ? primaryColor : Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    hasLocation
                        ? "Selected location"
                        : "Choose the exact spot on map",

                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
            ),

            // ==================================================
            // ARROW
            // ==================================================
            const Icon(Icons.chevron_right, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
