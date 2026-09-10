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
  // ======================================================
  // LINE PROGRESS
  // ======================================================

  double line1Progress = 0;
  double line2Progress = 0;
  double line3Progress = 0;

  // ======================================================
  // ACTIVE STEPS
  // ======================================================

  bool step2Active = false;
  bool step3Active = false;
  bool step4Active = false;

  @override
  void initState() {
    super.initState();

    // If screen starts from a later step,
    // show previous lines/steps as completed.

    if (widget.currentStep >= 2) {
      line1Progress = 1;
      step2Active = true;
    }

    if (widget.currentStep >= 3) {
      line2Progress = 1;
      step3Active = true;
    }

    if (widget.currentStep >= 4) {
      line3Progress = 1;
      step4Active = true;
    }
  }

  // ======================================================
  // DETECT STEP CHANGES
  // ======================================================

  @override
  void didUpdateWidget(covariant StepNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ==================================================
    // STEP 1 → STEP 2
    // ==================================================

    if (oldWidget.currentStep == 1 &&
        widget.currentStep == 2) {
      animateToStep2();
    }

    // ==================================================
    // STEP 2 → STEP 1
    // ==================================================

    if (oldWidget.currentStep == 2 &&
        widget.currentStep == 1) {
      animateBackToStep1();
    }

    // ==================================================
    // STEP 2 → STEP 3
    // ==================================================

    if (oldWidget.currentStep == 2 &&
        widget.currentStep == 3) {
      animateToStep3();
    }

    // ==================================================
    // STEP 3 → STEP 2
    // ==================================================

    if (oldWidget.currentStep == 3 &&
        widget.currentStep == 2) {
      animateBackToStep2();
    }

    // ==================================================
    // STEP 3 → STEP 4
    // ==================================================

    if (oldWidget.currentStep == 3 &&
        widget.currentStep == 4) {
      animateToStep4();
    }

    // ==================================================
    // STEP 4 → STEP 3
    // ==================================================

    if (oldWidget.currentStep == 4 &&
        widget.currentStep == 3) {
      animateBackToStep3();
    }
  }

  // ======================================================
  // FORWARD ANIMATION
  // ======================================================

  Future<void> animateToStep2() async {
    // Fill line 1 → 2
    setState(() {
      line1Progress = 1;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Activate Step 2
    setState(() {
      step2Active = true;
    });
  }

  Future<void> animateToStep3() async {
    // Fill line 2 → 3
    setState(() {
      line2Progress = 1;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Activate Step 3
    setState(() {
      step3Active = true;
    });
  }

  Future<void> animateToStep4() async {
    // Fill line 3 → 4
    setState(() {
      line3Progress = 1;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    // Activate Step 4
    setState(() {
      step4Active = true;
    });
  }

  // ======================================================
  // BACKWARD ANIMATION
  // ======================================================

  Future<void> animateBackToStep1() async {
    // Deactivate Step 2
    setState(() {
      step2Active = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    // Shrink line 1
    setState(() {
      line1Progress = 0;
    });
  }

  Future<void> animateBackToStep2() async {
    // Deactivate Step 3
    setState(() {
      step3Active = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    // Shrink line 2
    setState(() {
      line2Progress = 0;
    });
  }

  Future<void> animateBackToStep3() async {
    // Deactivate Step 4
    setState(() {
      step4Active = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 180),
    );

    if (!mounted) return;

    // Shrink line 3
    setState(() {
      line3Progress = 0;
    });
  }

  // ======================================================
  // UI
  // ======================================================

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

        // Line 3 → 4
        Expanded(
          child: _animatedLine(
            progress: line3Progress,
          ),
        ),

        // ==================================================
        // STEP 4
        // ==================================================

        _circle(
          number: "4",
          active: step4Active,
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
        // Inactive line
        Container(
          height: 3,
          color: secondaryColor.withOpacity(0.45),
        ),

        // Active line
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