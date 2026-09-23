import 'dart:convert';

import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendOwnerRequestScreen extends StatefulWidget {
  const SendOwnerRequestScreen({super.key});

  @override
  State<SendOwnerRequestScreen> createState() => _SendOwnerRequestScreenState();
}

class _SendOwnerRequestScreenState extends State<SendOwnerRequestScreen> {
  static const Color primaryColor = Color(0xFF03045E);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color greenAccent = Color(0xFF16A34A);
  static const Color redAccent = Color(0xFFDC2626);

  final PropertyService propertyService = PropertyService();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isSending = false;

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendRequest() async {
    final String subject = subjectController.text.trim();
    final String message = messageController.text.trim();

    if (subject.isEmpty) {
      showError(
        title: "Subject Required",
        message: "Please enter a subject for your request.",
      );
      return;
    }

    if (message.isEmpty) {
      showError(
        title: "Message Required",
        message: "Please describe what you need help with.",
      );
      return;
    }

    if (isSending) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final response = await propertyService.sendOwnerRequest(
        subject: subject,
        message: message,
      );

      dynamic decoded;

      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String successMessage = "Your request has been sent to the admin.";

        if (decoded is Map && decoded["message"] != null) {
          successMessage = decoded["message"].toString();
        }

        if (!mounted) {
          return;
        }

        Get.back(result: true);

        Get.snackbar(
          "Request Sent",
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: textColor,
          borderColor: const Color(0xFFBBF7D0),
          borderWidth: 1,
          margin: const EdgeInsets.all(16),
          icon: const Icon(
            Icons.check_circle_outline_rounded,
            color: greenAccent,
          ),
        );

        return;
      }

      String errorMessage = "Unable to send your request.";

      if (decoded is Map && decoded["message"] != null) {
        errorMessage = decoded["message"].toString();
      }

      if (!mounted) {
        return;
      }

      showError(title: "Request Failed", message: errorMessage);
    } catch (e) {
      if (!mounted) {
        return;
      }

      String errorMessage = e.toString();

      if (errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.replaceFirst("Exception: ", "");
      }

      showError(title: "Request Failed", message: errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: textColor,
      borderColor: const Color(0xFFFECACA),
      borderWidth: 1,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.error_outline_rounded, color: redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
        ),
        title: const Text(
          "Send a Request",
          style: TextStyle(
            color: primaryColor,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      color: primaryColor,
                      size: 26,
                    ),
                    SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How can we help?",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Send your question or issue to the admin. You can check the reply later from your requests.",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Subject",
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subjectController,
                maxLength: 255,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Example: Payment problem",
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.subject_rounded,
                    color: secondaryTextColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Message",
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: messageController,
                minLines: 6,
                maxLines: 10,
                maxLength: 2000,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Explain your request to the admin...",
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: primaryColor,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isSending ? null : sendRequest,
                  icon: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 19),
                  label: Text(
                    isSending ? "Sending..." : "Send Request",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primaryColor.withOpacity(0.55),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
