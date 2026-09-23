import 'dart:convert';

import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminOwnerRequestsScreen extends StatefulWidget {
  const AdminOwnerRequestsScreen({super.key});

  @override
  State<AdminOwnerRequestsScreen> createState() =>
      _AdminOwnerRequestsScreenState();
}

class _AdminOwnerRequestsScreenState extends State<AdminOwnerRequestsScreen> {
  static const Color primaryColor = Color(0xFF03045E);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  static const Color pendingColor = Color(0xFFF59E0B);
  static const Color resolvedColor = Color(0xFF16A34A);

  final PropertyService propertyService = PropertyService();

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();

    loadRequests();
  }

  Future<void> loadRequests() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await propertyService.getAdminOwnerRequests();

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Map<String, dynamic>> loaded = [];

        if (decoded is Map<String, dynamic>) {
          final dynamic rawRequests = decoded["requests"];

          if (rawRequests is List) {
            loaded = rawRequests
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .toList();
          }
        }

        if (!mounted) {
          return;
        }

        setState(() {
          requests = loaded;
          isLoading = false;
        });

        return;
      }

      String message = "Unable to load owner requests.";

      if (decoded is Map && decoded["message"] != null) {
        message = decoded["message"].toString();
      }

      throw Exception(message);
    } catch (e) {
      if (!mounted) {
        return;
      }

      String message = e.toString();

      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }

      setState(() {
        isLoading = false;
        errorMessage = message;
      });
    }
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
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
        ),

        title: const Text(
          "Owner Requests",
          style: TextStyle(
            color: primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: loadRequests,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (errorMessage != null) {
      return buildErrorState();
    }

    if (requests.isEmpty) {
      return buildEmptyState();
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),

      itemCount: requests.length,

      separatorBuilder: (context, index) {
        return const SizedBox(height: 14);
      },

      itemBuilder: (context, index) {
        return buildRequestCard(requests[index]);
      },
    );
  }

  Widget buildRequestCard(Map<String, dynamic> request) {
    final int requestId = int.tryParse(request["id"]?.toString() ?? "") ?? 0;

    final String subject = request["subject"]?.toString() ?? "Request";

    final String message = request["message"]?.toString() ?? "";

    final String status =
        request["status"]?.toString().toLowerCase() ?? "pending";

    final String adminReply = request["admin_reply"]?.toString().trim() ?? "";

    final String createdAt = request["created_at"]?.toString() ?? "";

    Map<String, dynamic> owner = {};

    if (request["owner"] is Map) {
      owner = Map<String, dynamic>.from(request["owner"]);
    }

    final String ownerName = owner["name"]?.toString() ?? "House Owner";

    final String ownerEmail = owner["email"]?.toString() ?? "";

    final String ownerPhone = owner["phone"]?.toString() ?? "";

    final bool resolved = status == "resolved";

    final Color statusColor = resolved ? resolvedColor : pendingColor;

    final Color statusBackground = resolved
        ? const Color(0xFFECFDF3)
        : const Color(0xFFFFF7E6);

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: borderColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.person_outline_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      ownerName,

                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    if (ownerEmail.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),

                        child: Text(
                          ownerEmail,

                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: statusBackground,

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  resolved ? "Resolved" : "Pending",

                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            subject,

            style: const TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            formatDate(createdAt),

            style: const TextStyle(color: secondaryTextColor, fontSize: 11),
          ),

          const SizedBox(height: 14),

          Text(
            message,

            style: const TextStyle(
              color: secondaryTextColor,
              fontSize: 13,
              height: 1.45,
            ),
          ),

          if (ownerPhone.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.phone_outlined,
                  size: 16,
                  color: secondaryTextColor,
                ),

                const SizedBox(width: 6),

                Text(
                  ownerPhone,

                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],

          if (resolved && adminReply.isNotEmpty) ...[
            const SizedBox(height: 16),

            const Divider(height: 1, color: borderColor),

            const SizedBox(height: 14),

            const Text(
              "Your Reply",

              style: TextStyle(
                color: primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              adminReply,

              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ],

          if (!resolved) ...[
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 44,

              child: ElevatedButton.icon(
                onPressed: () {
                  showReplyDialog(
                    requestId: requestId,
                    subject: subject,
                    ownerName: ownerName,
                  );
                },

                icon: const Icon(Icons.reply_rounded, size: 18),

                label: const Text(
                  "Reply to Request",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void showReplyDialog({
    required int requestId,
    required String subject,
    required String ownerName,
  }) {
    final TextEditingController replyController = TextEditingController();

    bool isSending = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),

            contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 10),

            actionsPadding: const EdgeInsets.fromLTRB(22, 4, 22, 20),

            title: const Text(
              "Reply to Owner",

              style: TextStyle(
                color: primaryColor,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "$ownerName • $subject",

                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: replyController,

                  minLines: 4,
                  maxLines: 7,

                  maxLength: 2000,

                  decoration: InputDecoration(
                    hintText: "Write your response...",

                    filled: true,
                    fillColor: backgroundColor,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),

                      borderSide: const BorderSide(color: borderColor),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),

                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Sending this reply will mark the request as resolved.",

                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),

            actions: [
              TextButton(
                onPressed: isSending
                    ? null
                    : () {
                        Get.back();
                      },

                child: const Text(
                  "Cancel",

                  style: TextStyle(color: secondaryTextColor),
                ),
              ),

              ElevatedButton(
                onPressed: isSending
                    ? null
                    : () async {
                        final String reply = replyController.text.trim();

                        if (reply.isEmpty) {
                          Get.snackbar(
                            "Reply Required",
                            "Please enter a reply.",
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          return;
                        }

                        try {
                          setDialogState(() {
                            isSending = true;
                          });

                          final response = await propertyService
                              .replyOwnerRequest(
                                requestId: requestId,
                                reply: reply,
                              );

                          dynamic decoded;

                          try {
                            decoded = jsonDecode(response.body);
                          } catch (_) {
                            decoded = null;
                          }

                          if (response.statusCode >= 200 &&
                              response.statusCode < 300) {
                            Get.back();

                            Get.snackbar(
                              "Reply Sent",
                              "The request has been resolved.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFFECFDF3),
                              colorText: const Color(0xFF166534),
                            );

                            await loadRequests();

                            return;
                          }

                          String message = "Unable to send reply.";

                          if (decoded is Map && decoded["message"] != null) {
                            message = decoded["message"].toString();
                          }

                          Get.snackbar(
                            "Reply Failed",
                            message,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } catch (e) {
                          Get.snackbar(
                            "Reply Failed",
                            e.toString().replaceFirst("Exception: ", ""),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } finally {
                          setDialogState(() {
                            isSending = false;
                          });
                        }
                      },

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),

                child: isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Send Reply"),
              ),
            ],
          );
        },
      ),

      barrierDismissible: false,
    );
  }

  Widget buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,

          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(
                  Icons.support_agent_rounded,
                  size: 54,
                  color: primaryColor,
                ),

                SizedBox(height: 15),

                Text(
                  "No owner requests",

                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Requests sent by house owners will appear here.",

                  style: TextStyle(color: secondaryTextColor, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildErrorState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,

          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: Color(0xFFDC2626),
                ),

                const SizedBox(height: 12),

                Text(
                  errorMessage ?? "Unable to load requests.",

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 18),

                ElevatedButton.icon(
                  onPressed: loadRequests,

                  icon: const Icon(Icons.refresh_rounded),

                  label: const Text("Retry"),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String value) {
    final DateTime? parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return "";
    }

    final DateTime date = parsed.toLocal();

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

    return "${date.day} "
        "${months[date.month - 1]} "
        "${date.year}";
  }
}
