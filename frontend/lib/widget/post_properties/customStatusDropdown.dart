import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);

class CustomStatusDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomStatusDropdown({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),

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

      child: DropdownButtonFormField<String>(
        value: value,

        dropdownColor: Colors.white,

        style: const TextStyle(
          color: primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        decoration: const InputDecoration(
          border: InputBorder.none,

          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
          ),

          prefixIcon: Icon(
            Icons.access_time_rounded,
            color: primaryColor,
            size: 22,
          ),
        ),

        hint: const Text(
          "Select property status",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black45,
          ),
        ),

        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: primaryColor,
        ),

        items: const [
          DropdownMenuItem(
            value: "available",
            child: Text("Available"),
          ),

          DropdownMenuItem(
            value: "rented",
            child: Text("Rented"),
          ),
        ],

        onChanged: onChanged,
      ),
    );
  }
}