import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? suffixText;
  final IconData? prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixText,
    this.prefixIcon,
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
        keyboardType: keyboardType,

        style: const TextStyle(
          color: primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        cursorColor: primaryColor,

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),

          suffixText: suffixText,

          suffixStyle: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: primaryColor, size: 22)
              : null,
        ),
      ),
    );
  }
}
