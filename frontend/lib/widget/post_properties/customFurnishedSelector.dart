import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class FurnishedSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FurnishedSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: secondaryColor.withOpacity(0.35),
        ),

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
          // ICON
          // ==================================================

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: lightSecondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),

            child: const Icon(
              Icons.chair_outlined,
              color: primaryColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // ==================================================
          // TEXT
          // ==================================================

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Furnished",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Furniture is included",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // SWITCH
          // ==================================================

          Switch(
            value: value,
            onChanged: onChanged,

            inactiveThumbColor: Colors.white,
            inactiveTrackColor: secondaryColor.withOpacity(0.45),

            activeColor: Colors.white,
            activeTrackColor: primaryColor,
          ),
        ],
      ),
    );
  }
}