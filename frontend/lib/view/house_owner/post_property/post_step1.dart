import 'package:final_project/widget/stepNumber.dart';
import 'package:flutter/material.dart';

class PostStep1 extends StatelessWidget {
  const PostStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post Your Property",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            stepNumber(
              Num1: Colors.white,
              contNum1: Colors.lightBlue,
              line1: Colors.black12,
              Num2: Colors.black54,
              contNum2: Colors.black12,
              line2: Colors.black12,
              Num3: Colors.black54,
              contNum3: Colors.black12,
            ),
            SizedBox(height: 20),
            stepNumber(
              Num1: Colors.white,
              contNum1: Colors.lightBlue,
              line1: Colors.lightBlue,
              Num2: Colors.white,
              contNum2: Colors.lightBlue,
              line2: Colors.black12,
              Num3: Colors.black54,
              contNum3: Colors.black12,
            ),
            SizedBox(height: 20),
            stepNumber(
              Num1: Colors.white,
              contNum1: Colors.lightBlue,
              line1: Colors.lightBlue,
              Num2: Colors.white,
              contNum2: Colors.lightBlue,
              line2: Colors.lightBlue,
              Num3: Colors.white,
              contNum3: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}
