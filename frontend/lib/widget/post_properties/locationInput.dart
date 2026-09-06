import 'package:flutter/material.dart';

class LocationInputCard extends StatelessWidget {
  final String? address;
  final VoidCallback onTap;

  const LocationInputCard({super.key, this.address, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = address != null && address!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Location icon
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF2196F3),
              size: 26,
            ),

            const SizedBox(width: 12),

            // Location text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasLocation ? address! : "Select property location",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: hasLocation ? Colors.black87 : Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hasLocation
                        ? "Selected location"
                        : "Choose the exact spot on map",
                    style: const TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(Icons.chevron_right, color: Colors.black38, size: 26),
          ],
        ),
      ),
    );
  }
}
