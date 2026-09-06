import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class RoomDetail extends StatelessWidget {
  final int totalFloor;
  final List<int> availableFloors;

  final VoidCallback onFloorIncrease;
  final VoidCallback onFloorDecrease;

  final VoidCallback onAvailableFloorsTap;

  const RoomDetail({
    super.key,
    required this.totalFloor,
    required this.availableFloors,
    required this.onFloorDecrease,
    required this.onFloorIncrease,
    required this.onAvailableFloorsTap,
  });

  Widget detailRow({
    required IconData icon,
    required String title,
    required int value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      children: [
        // Icon
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: lightSecondaryColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),

        // Minus button
        IconButton(
          onPressed: onDecrease,
          style: IconButton.styleFrom(
            backgroundColor: lightSecondaryColor,
            foregroundColor: primaryColor,
          ),
          icon: const Icon(
            Icons.remove,
            size: 18,
          ),
        ),

        SizedBox(
          width: 30,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ),

        // Plus button
        IconButton(
          onPressed: onIncrease,
          style: IconButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(
            Icons.add,
            size: 18,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

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

      child: Column(
        children: [
          // ======================================================
          // TOTAL FLOOR
          // ======================================================

          detailRow(
            icon: Icons.apartment_outlined,
            title: "Total Floors",

            // Use actual value
            value: totalFloor,

            onDecrease: onFloorDecrease,
            onIncrease: onFloorIncrease,
          ),

          Divider(
            color: secondaryColor.withOpacity(0.45),
          ),

          // ======================================================
          // AVAILABLE FLOOR
          // ======================================================

          Row(
            children: [
              Container(
                width: 38,
                height: 38,

                decoration: BoxDecoration(
                  color: lightSecondaryColor,
                  borderRadius: BorderRadius.circular(9),
                ),

                child: const Icon(
                  Icons.layers_outlined,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Available Floors",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      availableFloors.isEmpty
                          ? "Select available floors"
                          : "${availableFloors.length} floor(s) selected",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onAvailableFloorsTap,
                icon: const Icon(
                  Icons.chevron_right,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}