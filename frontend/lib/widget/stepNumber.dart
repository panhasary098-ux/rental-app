import 'package:flutter/material.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class StepNumber extends StatefulWidget {
  final int currentStep;

  const StepNumber({
    super.key,
    required this.currentStep,
  });

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

    // Step 1 → Step 2
    if (oldWidget.currentStep == 1 &&
        widget.currentStep == 2) {
      animateToStep2();
    }

    // Step 2 → Step 1
    if (oldWidget.currentStep == 2 &&
        widget.currentStep == 1) {
      animateBackToStep1();
    }

    // Step 2 → Step 3
    if (oldWidget.currentStep == 2 &&
        widget.currentStep == 3) {
      animateToStep3();
    }

    // Step 3 → Step 2
    if (oldWidget.currentStep == 3 &&
        widget.currentStep == 2) {
      animateBackToStep2();
    }
  }

  // ======================================================
  // FORWARD ANIMATION
  // ======================================================

  Future<void> animateToStep2() async {
    // First fill line 1 → 2
    setState(() {
      line1Progress = 1;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Then activate step 2
    setState(() {
      step2Active = true;
    });
  }

  Future<void> animateToStep3() async {
    // First fill line 2 → 3
    setState(() {
      line2Progress = 1;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Then activate step 3
    setState(() {
      step3Active = true;
    });
  }

  // ======================================================
  // BACKWARD ANIMATION
  // ======================================================

  Future<void> animateBackToStep1() async {
    // First deactivate step 2
    setState(() {
      step2Active = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    // Then shrink line
    setState(() {
      line1Progress = 0;
    });
  }

  Future<void> animateBackToStep2() async {
    // First deactivate step 3
    setState(() {
      step3Active = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    // Then shrink line
    setState(() {
      line2Progress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ==================================================
        // STEP 1
        // ==================================================

        _circle(
          number: "1",
          active: true,
        ),

        // Line 1 → 2
        Expanded(
          child: _animatedLine(
            progress: line1Progress,
          ),
        ),

        // ==================================================
        // STEP 2
        // ==================================================

        _circle(
          number: "2",
          active: step2Active,
        ),

        // Line 2 → 3
        Expanded(
          child: _animatedLine(
            progress: line2Progress,
          ),
        ),

        // ==================================================
        // STEP 3
        // ==================================================

        _circle(
          number: "3",
          active: step3Active,
        ),
      ],
    );
  }

  // ======================================================
  // STEP CIRCLE
  // ======================================================

  Widget _circle({
    required String number,
    required bool active,
  }) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 200,
      ),

      width: 28,
      height: 28,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        // Active = Navy
        // Inactive = Light cyan
        color: active
            ? primaryColor
            : lightSecondaryColor,

        border: Border.all(
          color: active
              ? primaryColor
              : secondaryColor,
          width: 1.3,
        ),

        boxShadow: active
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),

      alignment: Alignment.center,

      child: Text(
        number,
        style: TextStyle(
          color: active
              ? Colors.white
              : primaryColor.withOpacity(0.55),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ======================================================
  // ANIMATED LINE
  // ======================================================

  Widget _animatedLine({
    required double progress,
  }) {
    return Stack(
      alignment: Alignment.centerLeft,

      children: [
        // ==================================================
        // INACTIVE LINE
        // ==================================================

        Container(
          height: 3,
          color: secondaryColor.withOpacity(0.45),
        ),

        // ==================================================
        // ACTIVE ANIMATED LINE
        // ==================================================

        AnimatedFractionallySizedBox(
          duration: const Duration(
            milliseconds: 500,
          ),

          curve: Curves.easeInOut,

          alignment: Alignment.centerLeft,

          widthFactor: progress,

          child: Container(
            height: 3,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
}