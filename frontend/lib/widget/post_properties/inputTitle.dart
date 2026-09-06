import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF03045E);

Widget customInputTitle({required String title}) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: primaryColor,
    ),
  );
}
