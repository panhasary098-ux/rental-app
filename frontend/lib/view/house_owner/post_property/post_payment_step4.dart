import 'package:final_project/controller/post_properties_controller.dart';
import 'package:final_project/widget/post_properties/customSingleImagePicker.dart';
import 'package:final_project/widget/post_properties/customTextFormField.dart';
import 'package:final_project/widget/post_properties/inputTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ======================================================
// APP COLORS
// ======================================================

const Color primaryColor = Color(0xFF03045E);
const Color secondaryColor = Color(0xFF90E0EF);
const Color lightSecondaryColor = Color(0xFFE6F9FC);

class PostPaymentStep4 extends StatelessWidget {
  PostPaymentStep4({super.key});

  final PostPropertyController controller = Get.find<PostPropertyController>();

  // ======================================================
  // GET QR BASED ON PROPERTY TYPE
  // ======================================================

  String getQrImage() {
    switch (controller.selectIndex.value) {
      // House
      case 0:
        return 'assets/images/payment_qr/ABA_QR_50_dollar.jpg';

      // Apartment
      case 1:
        return 'assets/images/payment_qr/ABA_QR_40_dollar.jpg';

      // Room
      case 2:
        return 'assets/images/payment_qr/ABA_QR_30_dollar.jpg';

      default:
        return 'assets/images/payment_qr/ABA_QR_30_dollar.jpg';
    }
  }

  // ======================================================
  // PROPERTY TYPE NAME
  // ======================================================

  String getPropertyTypeName() {
    switch (controller.selectIndex.value) {
      case 0:
        return "House";

      case 1:
        return "Apartment / Flat";

      case 2:
        return "Room";

      default:
        return "Property";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // ======================================================
          // TITLE
          // ======================================================
          const Text(
            "Payment",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Complete the payment before submitting your property.",
            style: TextStyle(fontSize: 14, color: Colors.black45),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // PAYMENT INFORMATION
          // ======================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: lightSecondaryColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: secondaryColor),
            ),

            child: const Row(
              children: [
                Icon(Icons.info_outline, color: primaryColor),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Scan the QR code below to complete your payment. "
                    "After payment, upload your payment proof for admin review.",
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // PAYMENT QR
          // ======================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              border: Border.all(color: secondaryColor.withOpacity(0.5)),

              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              children: [
                // ================================================
                // PROPERTY TYPE
                // ================================================
                Text(
                  "${getPropertyTypeName()} Payment",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 15),

                // ================================================
                // QR IMAGE
                // ================================================
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(
                    getQrImage(),
                    width: 230,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Scan to Pay",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Use your banking app to scan this QR code",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // TRANSACTION REFERENCE
          // ======================================================
          customInputTitle(title: "Transaction Reference (Optional)"),

          const SizedBox(height: 5),

          CustomTextFormField(
            hintText: "Enter transaction reference",
            controller: controller.transactionReferenceController,
            prefixIcon: Icons.receipt_long_outlined,
          ),

          const SizedBox(height: 20),

          // ======================================================
          // PAYMENT PROOF
          // ======================================================
          customInputTitle(title: "Payment Proof"),

          const SizedBox(height: 5),

          Obx(
            () => SingleImagePicker(
              title: "Upload Payment Proof",
              subtitle: "Tap to select your payment screenshot",
              icon: Icons.receipt_outlined,

              image: controller.paymentProofImage.value,

              onTap: () {
                controller.pickPaymentProofImage();
              },

              onRemove: () {
                controller.removePaymentProofImage();
              },
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
