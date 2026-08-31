import 'package:flutter/material.dart';

class StepNumber extends StatefulWidget {
  final int currentStep;

  const StepNumber({super.key, required this.currentStep});

  @override
  State<StepNumber> createState() => _StepNumberState();
}

class _StepNumberState extends State<StepNumber> {
  double line1Progress = 0;
  double line2Progress = 0;

  bool step2Active = false;
  bool step3Active = false;

  @override
  void initState() {
    super.initState();

    if (widget.currentStep >= 2) {
      line1Progress = 1;
      step2Active = true;
    }

    if (widget.currentStep >= 3) {
      line2Progress = 1;
      step3Active = true;
    }
  }

  @override
  void didUpdateWidget(covariant StepNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentStep == 1 && widget.currentStep == 2) {
      animateToStep2();
    }

    if (oldWidget.currentStep == 2 && widget.currentStep == 1) {
      animateBackToStep1();
    }

    if (oldWidget.currentStep == 2 && widget.currentStep == 3) {
      animateToStep3();
    }

    if (oldWidget.currentStep == 3 && widget.currentStep == 2) {
      animateBackToStep2();
    }
  }

  Future<void> animateToStep2() async {
    // First animate line 1 → 2
    setState(() {
      line1Progress = 1;
    });

    // Wait until line animation finishes
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Then turn number 2 blue
    setState(() {
      step2Active = true;
    });
  }

  Future<void> animateToStep3() async {
    setState(() {
      line2Progress = 1;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      step3Active = true;
    });
  }

  Future<void> animateBackToStep1() async {
    // First turn step 2 gray
    setState(() {
      step2Active = false;
    });

    await Future.delayed(const Duration(milliseconds: 180));

    if (!mounted) return;

    // Then shrink the blue line
    setState(() {
      line1Progress = 0;
    });
  }

  Future<void> animateBackToStep2() async {
    // First turn step 2 gray
    setState(() {
      step3Active = false;
    });

    await Future.delayed(const Duration(milliseconds: 180));

    if (!mounted) return;

    // Then shrink the blue line
    setState(() {
      line2Progress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Step 1
        _circle(number: "1", active: true),

        // Line 1 → 2
        Expanded(child: _animatedLine(progress: line1Progress)),

        // Step 2
        _circle(number: "2", active: step2Active),

        // Line 2 → 3
        Expanded(child: _animatedLine(progress: line2Progress)),

        // Step 3
        _circle(number: "3", active: step3Active),
      ],
    );
  }

  Widget _circle({required String number, required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 25,
      height: 25,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.lightBlue : Colors.grey.shade300,
      ),

      alignment: Alignment.center,

      child: Text(
        number,
        style: TextStyle(
          color: active ? Colors.white : Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _animatedLine({required double progress}) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Gray line
        Container(height: 3, color: Colors.grey.shade300),

        // Blue animated line
        AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: Alignment.centerLeft,

          widthFactor: progress,

          child: Container(height: 3, color: Colors.lightBlue),
        ),
      ],
    );
  }
}

// Widget stepNumber({
//   required Color Num1,
//   required Color contNum1,
//   required Color line1,
//   required Color Num2,
//   required Color contNum2,
//   required Color line2,
//   required Color Num3,
//   required Color contNum3,
// }) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       //num1
//       Container(
//         height: 25,
//         width: 25,
//         decoration: BoxDecoration(
//           color: contNum1,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             "1",
//             style: TextStyle(fontWeight: FontWeight.w700, color: Num1),
//           ),
//         ),
//       ),
//       Container(height: 3, width: 80, color: line1),

//       // num2
//       Container(
//         height: 25,
//         width: 25,
//         decoration: BoxDecoration(
//           color: contNum2,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             "2",
//             style: TextStyle(fontWeight: FontWeight.w700, color: Num2),
//           ),
//         ),
//       ),
//       Container(height: 3, width: 80, color: line2),

//       //num3
//       Container(
//         height: 25,
//         width: 25,
//         decoration: BoxDecoration(
//           color: contNum3,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             "3",
//             style: TextStyle(fontWeight: FontWeight.w700, color: Num3),
//           ),
//         ),
//       ),
//     ],
//   );
// }
