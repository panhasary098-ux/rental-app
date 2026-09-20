import 'package:final_project/controller/post_properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

Color primaryColor = Color(0xFF03045E);
Color backgroundColor = Color(0xFFF7F7F9);
Color borderColor = Color(0xFFE5E7EB);
Color textColor = Color(0xFF111827);
Color secondaryTextColor = Color(0xFF6B7280);

class PostPaymentStep4 extends StatelessWidget {
  PostPaymentStep4({super.key});

  final PostPropertyController controller =
      Get.find<PostPropertyController>();

  String getPaymentAmount() {
    return controller.paymentAmount.value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),

          // Title
          Text(
            "Complete Payment",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: primaryColor,
              letterSpacing: -0.4,
            ),
          ),

          SizedBox(height: 6),

          Text(
            "Scan the KHQR below to complete your property posting payment.",
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
              height: 1.45,
            ),
          ),

          SizedBox(height: 20),

          // Payment Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Obx(
              () {
                return Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF03045E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(21),
                          topRight: Radius.circular(21),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),

                          SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bakong KHQR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),

                                SizedBox(height: 2),

                                Text(
                                  "Secure digital payment",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.72),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "KHQR",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        22,
                        20,
                        20,
                      ),
                      child: Column(
                        children: [
                          // Property Fee
                          Text(
                            "${controller.getPropertyTypeName()} Posting Fee",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                            ),
                          ),

                          SizedBox(height: 6),

                          // Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "\$${getPaymentAmount()}",
                                style: TextStyle(
                                  fontSize: 34,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  color: textColor,
                                  letterSpacing: -1,
                                ),
                              ),

                              SizedBox(width: 7),

                              Padding(
                                padding: EdgeInsets.only(bottom: 3),
                                child: Text(
                                  "USD",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 22),

                          // QR
                          buildQrArea(),

                          SizedBox(height: 18),

                          Text(
                            controller.paymentStatus.value == 'paid'
                                ? "Payment Verified"
                                : "Scan to Pay",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            controller.paymentStatus.value == 'paid'
                                ? "Your payment has been confirmed successfully."
                                : "Use a KHQR-supported banking app to scan this code.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: secondaryTextColor,
                            ),
                          ),

                          if (controller.paymentStatus.value != 'paid' &&
                              controller.bakongQr.value.isNotEmpty) ...[
                            SizedBox(height: 16),

                            buildExpiry(),
                          ],

                          SizedBox(height: 18),

                          buildPaymentStatus(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 16),

          // Automatic Verification
          Obx(
            () {
              if (controller.paymentStatus.value == 'paid') {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Color(0xFFDCFCE7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF16A34A),
                          size: 21,
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment verified",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF166534),
                              ),
                            ),

                            SizedBox(height: 3),

                            Text(
                              "Your property payment has been successfully confirmed.",
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Color(0xFFE4E7F5),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE9EAFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: controller.isAutoCheckingPayment.value
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.3,
                                  color: primaryColor,
                                ),
                              )
                            : Icon(
                                Icons.sync_rounded,
                                color: primaryColor,
                                size: 21,
                              ),
                      ),
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.isQrExpired.value
                                ? "QR code expired"
                                : "Automatic verification",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            controller.isQrExpired.value
                                ? "Generate a new QR code to continue payment."
                                : "JoulNow is checking your payment automatically. No button is required.",
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 12),

          // Security
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F3F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: primaryColor,
                    size: 19,
                  ),
                ),

                SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Secure payment",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        "Payment confirmation is verified through Bakong. "
                        "You do not need to upload a payment screenshot.",
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25),
        ],
      ),
    );
  }

  // QR
  Widget buildQrArea() {
    if (controller.paymentStatus.value == 'paid') {
      return Container(
        width: 230,
        height: 230,
        decoration: BoxDecoration(
          color: Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFDCFCE7),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 45,
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Payment Successful",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF166534),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.isGeneratingQr.value) {
      return Container(
        width: 230,
        height: 230,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primaryColor,
              ),
            ),

            SizedBox(height: 14),

            Text(
              "Generating KHQR...",
              style: TextStyle(
                fontSize: 13,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      );
    }

    if (controller.bakongQr.value.isNotEmpty &&
        !controller.isQrExpired.value) {
      return Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFDDE0E6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: QrImageView(
          data: controller.bakongQr.value,
          version: QrVersions.auto,
          size: 215,
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(4),
        ),
      );
    }

    if (controller.isQrExpired.value) {
      return Container(
        width: 230,
        height: 230,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFFDE68A),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_off_outlined,
              size: 48,
              color: Color(0xFFD97706),
            ),

            SizedBox(height: 12),

            Text(
              "QR Expired",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),

            SizedBox(height: 5),

            Text(
              "Generate a new KHQR to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
              ),
            ),

            SizedBox(height: 14),

            TextButton(
              onPressed: controller.isGeneratingQr.value
                  ? null
                  : () async {
                      await controller.generateBakongQr();
                    },
              child: Text(
                "Generate New QR",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: 230,
      height: 230,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_2_rounded,
            size: 55,
            color: Color(0xFF9CA3AF),
          ),

          SizedBox(height: 12),

          Text(
            "QR code is not available",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: secondaryTextColor,
            ),
          ),

          SizedBox(height: 14),

          TextButton(
            onPressed: controller.isGeneratingQr.value
                ? null
                : () async {
                    await controller.generateBakongQr();
                  },
            child: Text(
              "Generate Again",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Expiry
  Widget buildExpiry() {
    if (controller.isQrExpired.value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_off_outlined,
            color: Color(0xFFD97706),
            size: 17,
          ),

          SizedBox(width: 6),

          Text(
            "QR code expired",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB45309),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            color: primaryColor,
            size: 16,
          ),

          SizedBox(width: 6),

          Text(
            "QR expires in ${controller.getQrRemainingTimeText()}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Payment Status
  Widget buildPaymentStatus() {
    if (controller.paymentStatus.value == 'paid') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFBBF7D0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF16A34A),
              size: 20,
            ),

            SizedBox(width: 8),

            Text(
              "Payment Confirmed",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF15803D),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.isQrExpired.value) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFFDE68A),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD97706),
              size: 20,
            ),

            SizedBox(width: 8),

            Text(
              "QR Expired",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFFB45309),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE4E7F5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 17,
            height: 17,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryColor,
            ),
          ),

          SizedBox(width: 9),

          Text(
            "Waiting for Payment",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}