import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

Widget customTypeContainer({
  required IconData icon,
  required String nameType,
  required String description,
  required bool isSeleted,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(15),

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),

      decoration: BoxDecoration(
        //color: isSeleted ? lightSecondaryColor : Colors.white,
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: isSeleted ? primaryColor : Colors.transparent,
          width: 1.8,
        ),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Row(
          children: [
            // ==================================================
            // ICON BOX
            // ==================================================
            Container(
              decoration: BoxDecoration(
                //color: isSeleted ? secondaryColor : lightSecondaryColor,
                color: lightSecondaryColor,

                borderRadius: BorderRadius.circular(8),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8),

                child: Icon(icon, size: 45, color: primaryColor),
              ),
            ),

            const SizedBox(width: 20),

            // ==================================================
            // TEXT
            // ==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    nameType,

                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    description,

                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,

                      color: isSeleted
                          ? primaryColor.withOpacity(0.75)
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // SELECTED CHECK
            // ==================================================
            if (isSeleted)
              const Icon(
                Icons.check_circle_rounded,
                color: primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    ),
  );
}
