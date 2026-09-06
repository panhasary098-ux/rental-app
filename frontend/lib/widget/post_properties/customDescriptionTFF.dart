import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);

class CustomDescriptionField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const CustomDescriptionField({
    super.key,
    required this.hintText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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

      child: TextFormField(
        controller: controller,

        maxLines: 5,

        cursorColor: primaryColor,

        style: const TextStyle(fontSize: 15, color: primaryColor, height: 1.4),

        decoration: InputDecoration(
          // Use the value passed to the widget
          hintText: hintText,

          hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
