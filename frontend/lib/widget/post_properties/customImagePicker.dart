import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class Imagepicker extends StatelessWidget {
  final VoidCallback onTap;

  const Imagepicker({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: secondaryColor.withOpacity(0.6)),

          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: const Column(
          children: [
            // ==================================================
            // ICON
            // ==================================================
            DecoratedBox(
              decoration: BoxDecoration(
                color: lightSecondaryColor,
                shape: BoxShape.circle,
              ),

              child: Padding(
                padding: EdgeInsets.all(12),

                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 34,
                  color: primaryColor,
                ),
              ),
            ),

            SizedBox(height: 10),

            // ==================================================
            // TITLE
            // ==================================================
            Text(
              "Add property photos",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),

            SizedBox(height: 5),

            // ==================================================
            // SUBTITLE
            // ==================================================
            Text(
              "Tap to select images",
              style: TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
