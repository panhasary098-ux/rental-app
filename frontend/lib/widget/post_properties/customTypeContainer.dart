
import 'package:flutter/material.dart';

Widget customTypeContainer({
  required IconData icon,
  required String nameType,
  required String description,
  required bool isSeleted,
  required VoidCallback onPressed,
}) {
  return InkWell(
    onTap: onPressed,

    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: isSeleted ? Colors.lightBlue : Colors.transparent,
          width: 2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(25.0),

        child: Row(
          children: [
            Icon(
              icon,
              size: 50,
              color: isSeleted ? Colors.lightBlue : Colors.black,
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    nameType,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isSeleted ? Colors.lightBlue : Colors.black,
                    ),
                  ),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSeleted ? Colors.lightBlue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
