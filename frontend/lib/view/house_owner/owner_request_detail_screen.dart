import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color _requestPrimaryColor = Color(0xFF03045E);
const Color _requestBackgroundColor = Color(0xFFF7F8FA);
const Color _requestTextColor = Color(0xFF111827);
const Color _requestSecondaryTextColor = Color(0xFF7B8497);
const Color _requestBorderColor = Color(0xFFE5E7EB);

class OwnerRequestDetailScreen extends StatelessWidget {
  final int requestId;
  final String subject;
  final String message;
  final String adminReply;
  final DateTime repliedAt;

  const OwnerRequestDetailScreen({
    super.key,
    required this.requestId,
    required this.subject,
    required this.message,
    required this.adminReply,
    required this.repliedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _requestBackgroundColor,
      appBar: AppBar(
        backgroundColor: _requestBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: _requestPrimaryColor,
          ),
        ),
        title: const Text(
          "Request Details",
          style: TextStyle(
            color: _requestPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _requestBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F3F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.support_agent_rounded,
                            color: _requestPrimaryColor,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Admin Reply",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _requestSecondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formatDate(repliedAt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _requestTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Resolved",
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      subject,
                      style: const TextStyle(
                        color: _requestPrimaryColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Request #$requestId",
                      style: const TextStyle(
                        color: _requestSecondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              buildSection(
                title: "Your Message",
                icon: Icons.chat_bubble_outline_rounded,
                text: message,
              ),
              const SizedBox(height: 16),
              buildSection(
                title: "Admin Reply",
                icon: Icons.reply_rounded,
                text: adminReply,
                emphasized: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required IconData icon,
    required String text,
    bool emphasized = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emphasized ? const Color(0xFFF9FAFD) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _requestBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: _requestPrimaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _requestTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text.trim().isEmpty ? "-" : text,
            style: const TextStyle(
              color: _requestSecondaryTextColor,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final DateTime local = date.toLocal();

    final String hour = local.hour > 12
        ? (local.hour - 12).toString()
        : (local.hour == 0 ? "12" : local.hour.toString());

    final String minute = local.minute.toString().padLeft(2, "0");
    final String period = local.hour >= 12 ? "PM" : "AM";

    return "${local.day} ${months[local.month - 1]} ${local.year}, $hour:$minute $period";
  }
}
