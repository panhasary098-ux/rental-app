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
          SizedBox(height: 10),

          // Title
          Text(
            "Payment",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Complete the payment to continue your property submission.",
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
              height: 1.4,
            ),
          ),

          SizedBox(height: 20),

          // Payment Information
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Color(0xFFE4E7F5),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Color(0xFFE9EAFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bakong KHQR Payment",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Scan the QR code using a supported banking app. "
                        "Your payment will be verified automatically.",
                        style: TextStyle(
                          fontSize: 13,
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

          SizedBox(height: 20),

          // Payment Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: borderColor,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Obx(
              () {
                return Column(
                  children: [
                    // Property Type
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF2F3F8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${controller.getPropertyTypeName()} Posting Fee",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Amount
                    Text(
                      "\$${getPaymentAmount()}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "USD",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),

                    SizedBox(height: 20),

                    // QR
                    if (controller.isGeneratingQr.value)
                      Container(
                        width: 230,
                        height: 230,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
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
                      )
                    else if (controller.bakongQr.value.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: QrImageView(
                          data: controller.bakongQr.value,
                          version: QrVersions.auto,
                          size: 220,
                          backgroundColor: Colors.white,
                        ),
                      )
                    else
                      Container(
                        width: 230,
                        height: 230,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              size: 60,
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
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 18),

                    Text(
                      "Scan to Pay",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "Use a Bakong KHQR supported banking app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                      ),
                    ),

                    SizedBox(height: 18),

                    // Payment Status
                    buildPaymentStatus(),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 16),

          // Security
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: primaryColor,
                  size: 20,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    "Payment confirmation is verified securely through Bakong. "
                    "You do not need to upload a payment screenshot.",
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: secondaryTextColor,
                    ),
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

  // Payment Status
  Widget buildPaymentStatus() {
    if (controller.paymentStatus.value == 'paid') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
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
                fontWeight: FontWeight.w700,
                color: Color(0xFF15803D),
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
        vertical: 12,
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
            Icons.schedule_rounded,
            color: Color(0xFFD97706),
            size: 20,
          ),

          SizedBox(width: 8),

          Text(
            "Waiting for Payment",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }
}