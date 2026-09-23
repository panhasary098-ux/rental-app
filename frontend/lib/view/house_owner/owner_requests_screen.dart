import 'dart:convert';

import 'package:final_project/service/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  static const Color primaryColor = Color(0xFF03045E);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

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

      final response = await propertyService.getOwnerRequests();

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

      String message = "Unable to load requests.";

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
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
        ),

        title: const Text(
          "My Requests",
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
    final String subject = request["subject"]?.toString() ?? "Request";

    final String message = request["message"]?.toString() ?? "";

    final String status =
        request["status"]?.toString().toLowerCase() ?? "pending";

    final String adminReply = request["admin_reply"]?.toString().trim() ?? "";

    final String createdAt = request["created_at"]?.toString() ?? "";

    final bool resolved = status == "resolved";

    final Color statusColor = resolved
        ? const Color(0xFF16A34A)
        : const Color(0xFFF59E0B);

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
              Expanded(
                child: Text(
                  subject,

                  style: const TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 10),

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

          const SizedBox(height: 7),

          Text(
            formatDate(createdAt),

            style: const TextStyle(fontSize: 11, color: secondaryTextColor),
          ),

          const SizedBox(height: 14),

          const Text(
            "Your message",

            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            message,

            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: secondaryTextColor,
            ),
          ),

          if (adminReply.isNotEmpty) ...[
            const SizedBox(height: 16),

            const Divider(color: borderColor, height: 1),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.support_agent_rounded,
                  size: 18,
                  color: primaryColor,
                ),

                const SizedBox(width: 7),

                const Text(
                  "Admin Reply",

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            Text(
              adminReply,

              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: secondaryTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,

          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Icon(
                    Icons.support_agent_rounded,
                    size: 54,
                    color: primaryColor,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "No requests yet",

                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: 7),

                  Text(
                    "Requests you send to the admin will appear here.",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Color(0xFFDC2626),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Unable to load requests",

                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    errorMessage ?? "Something went wrong.",

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
