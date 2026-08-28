import 'package:flutter/material.dart';

Widget stepNumber({
  required Color Num1,
  required Color contNum1,
  required Color line1,
  required Color Num2,
  required Color contNum2,
  required Color line2,
  required Color Num3,
  required Color contNum3,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      //num1
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: contNum1,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "1",
            style: TextStyle(fontWeight: FontWeight.w700, color: Num1),
          ),
        ),
      ),
      Container(height: 3, width: 80, color: line1),

      // num2
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: contNum2,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "2",
            style: TextStyle(fontWeight: FontWeight.w700, color: Num2),
          ),
        ),
      ),
      Container(height: 3, width: 80, color: line2),

      //num3
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: contNum3,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "3",
            style: TextStyle(fontWeight: FontWeight.w700, color: Num3),
          ),
        ),
      ),
    ],
  );
}
