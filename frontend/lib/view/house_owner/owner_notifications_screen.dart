import 'package:flutter/material.dart';

const Color _primaryColor = Color(0xFF03045E);
const Color _screenBackground = Color(0xFFF7F8FA);
const Color _cardColor = Colors.white;
const Color _borderColor = Color(0xFFE5E7EB);
const Color _textColor = Color(0xFF111827);
const Color _secondaryTextColor = Color(0xFF7B8497);

const Color _approvedColor = Color(0xFF16A34A);
const Color _rejectedColor = Color(0xFFDC2626);

class OwnerAdminFeedback {
  final int id;
  final int propertyId;

  final String propertyName;
  final String propertyImage;
  final String location;

  // Property notifications use approved/rejected.
  // Request notifications use request_reply.
  final String type;

  // "property" or "request".
  final String notificationKind;

  final String? reason;
  final String? note;

  final int? requestId;
  final String? requestSubject;
  final String? requestMessage;
  final String? adminReply;

  final DateTime createdAt;
  final bool isNew;

  const OwnerAdminFeedback({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.type,
    required this.createdAt,
    required this.isNew,
    this.notificationKind = "property",
    this.reason,
    this.note,
    this.requestId,
    this.requestSubject,
    this.requestMessage,
    this.adminReply,
  });

  bool get isPropertyFeedback {
    return notificationKind.toLowerCase() == "property";
  }

  bool get isRequestReply {
    return notificationKind.toLowerCase() == "request" ||
        type.toLowerCase() == "request_reply";
  }

  bool get isApproved {
    return isPropertyFeedback && type.toLowerCase() == "approved";
  }

  bool get isRejected {
    return isPropertyFeedback && type.toLowerCase() == "rejected";
  }

  factory OwnerAdminFeedback.fromJson(Map<String, dynamic> json) {
    return OwnerAdminFeedback(
      id: int.tryParse(json["id"]?.toString() ?? "") ?? 0,
      propertyId: int.tryParse(json["property_id"]?.toString() ?? "") ?? 0,
      propertyName:
          json["property_name"]?.toString() ??
          json["name"]?.toString() ??
          "Property",
      propertyImage:
          json["property_image"]?.toString() ?? json["image"]?.toString() ?? "",
      location:
          json["location"]?.toString() ?? json["address"]?.toString() ?? "-",
      type: json["type"]?.toString() ?? "",
      notificationKind: json["notification_kind"]?.toString() ?? "property",
      reason: json["reason"]?.toString(),
      note: json["note"]?.toString(),
      requestId: int.tryParse(json["request_id"]?.toString() ?? ""),
      requestSubject: json["request_subject"]?.toString(),
      requestMessage: json["request_message"]?.toString(),
      adminReply: json["admin_reply"]?.toString(),
      createdAt:
          DateTime.tryParse(json["created_at"]?.toString() ?? "") ??
          DateTime.now(),
      isNew: json["is_new"] == true || json["is_new"]?.toString() == "1",
    );
  }
}

class OwnerNotificationsScreen extends StatefulWidget {
  final List<OwnerAdminFeedback> notifications;

  final VoidCallback? onNotificationsSeen;

  final void Function(OwnerAdminFeedback notification)? onViewProperty;

  final void Function(OwnerAdminFeedback notification)? onEditAndResubmit;

  final void Function(OwnerAdminFeedback notification)? onViewRequest;

  const OwnerNotificationsScreen({
    super.key,
    required this.notifications,
    this.onNotificationsSeen,
    this.onViewProperty,
    this.onEditAndResubmit,
    this.onViewRequest,
  });

  @override
  State<OwnerNotificationsScreen> createState() =>
      _OwnerNotificationsScreenState();
}

class _OwnerNotificationsScreenState extends State<OwnerNotificationsScreen> {
  bool get hasNewNotifications {
    return widget.notifications.any((notification) => notification.isNew);
  }

  List<OwnerAdminFeedback> get newNotifications {
    return widget.notifications
        .where((notification) => notification.isNew)
        .toList();
  }

  List<OwnerAdminFeedback> get oldNotifications {
    return widget.notifications
        .where((notification) => !notification.isNew)
        .toList();
  }

  @override
  void dispose() {
    if (hasNewNotifications) {
      widget.onNotificationsSeen?.call();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBackground,

      appBar: AppBar(
        backgroundColor: _screenBackground,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_rounded,
            color: _primaryColor,
            size: 27,
          ),
        ),

        title: const Text(
          "Notifications",

          style: TextStyle(
            color: _primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: widget.notifications.isEmpty
            ? buildEmptyState()
            : RefreshIndicator(
                color: _primaryColor,

                onRefresh: () async {},

                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),

                  children: [
                    const Text(
                      "Updates from the admin about your property submissions and support requests.",

                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: _secondaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (newNotifications.isNotEmpty) ...[
                      buildSectionHeader("New"),

                      const SizedBox(height: 14),

                      ...newNotifications.map(
                        (notification) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),

                          child: buildNotificationCard(notification),
                        ),
                      ),
                    ],

                    if (newNotifications.isNotEmpty &&
                        oldNotifications.isNotEmpty) ...[
                      const SizedBox(height: 4),

                      buildSectionHeader("Earlier"),

                      const SizedBox(height: 14),
                    ],

                    if (newNotifications.isEmpty &&
                        oldNotifications.isNotEmpty) ...[
                      buildSectionHeader("Earlier"),

                      const SizedBox(height: 14),
                    ],

                    ...oldNotifications.map(
                      (notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),

                        child: buildNotificationCard(notification),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,

          style: const TextStyle(
            color: _primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: 14),

        const Expanded(child: Divider(height: 1, color: Color(0xFFD5D9E1))),
      ],
    );
  }

  Widget buildNotificationCard(OwnerAdminFeedback notification) {
    if (notification.isRequestReply) {
      return buildRequestReplyCard(notification);
    }

    final bool approved = notification.isApproved;

    final Color statusColor = approved ? _approvedColor : _rejectedColor;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: _cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: _borderColor),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          buildPropertyImage(notification.propertyImage),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    buildStatusIcon(approved),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        approved ? "Approved" : "Rejected",

                        style: TextStyle(
                          color: statusColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Text(
                      formatDate(notification.createdAt),

                      style: const TextStyle(
                        color: _secondaryTextColor,

                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  notification.propertyName,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.location_on_outlined,

                      size: 18,

                      color: _secondaryTextColor,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        notification.location,

                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: _secondaryTextColor,

                          fontSize: 13,

                          height: 1.35,

                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Divider(height: 1, color: _borderColor),

                const SizedBox(height: 12),

                if (notification.isRejected)
                  buildRejectedContent(notification)
                else
                  buildApprovedContent(notification),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRequestReplyCard(OwnerAdminFeedback notification) {
    final String subject =
        notification.requestSubject?.trim().isNotEmpty == true
        ? notification.requestSubject!.trim()
        : "Owner Request";

    final String reply = notification.adminReply?.trim().isNotEmpty == true
        ? notification.adminReply!.trim()
        : "The admin has replied to your request.";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: _primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Request Replied",
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          formatDate(notification.createdAt),
                          style: const TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subject,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          const Divider(height: 1, color: _borderColor),
          const SizedBox(height: 12),
          const Text(
            "Admin Reply",
            style: TextStyle(
              color: _textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            reply,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _secondaryTextColor,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                widget.onViewRequest?.call(notification);
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text(
                "View Request",
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryColor,
                side: const BorderSide(color: _primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRejectedContent(OwnerAdminFeedback notification) {
    final String reason = notification.reason?.trim() ?? "";

    final String note = notification.note?.trim() ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (reason.isNotEmpty) ...[
          const Text(
            "Reason",

            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            reason,

            style: const TextStyle(
              color: _secondaryTextColor,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        if (reason.isNotEmpty && note.isNotEmpty) const SizedBox(height: 12),

        if (note.isNotEmpty) ...[
          const Text(
            "Admin Note",

            style: TextStyle(
              color: _textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            note,

            style: const TextStyle(
              color: _secondaryTextColor,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],

        if (reason.isEmpty && note.isEmpty)
          const Text(
            "Your property submission was not approved. Please review the property and make the necessary changes.",

            style: TextStyle(
              color: _secondaryTextColor,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerRight,

          child: ElevatedButton.icon(
            onPressed: () {
              widget.onEditAndResubmit?.call(notification);
            },

            icon: const Icon(Icons.edit_outlined, size: 17),

            label: const Text(
              "Edit & Resubmit",

              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,

              foregroundColor: Colors.white,

              elevation: 0,

              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildApprovedContent(OwnerAdminFeedback notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          "Your property has been approved and is now visible to renters.",

          style: TextStyle(
            color: _secondaryTextColor,
            fontSize: 13,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 16),

        Align(
          alignment: Alignment.centerRight,

          child: OutlinedButton.icon(
            onPressed: () {
              widget.onViewProperty?.call(notification);
            },

            icon: const Icon(Icons.visibility_outlined, size: 17),

            label: const Text(
              "View Property",

              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),

            style: OutlinedButton.styleFrom(
              foregroundColor: _primaryColor,

              side: const BorderSide(color: _primaryColor),

              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPropertyImage(String image) {
    if (image.trim().isEmpty) {
      return Container(
        width: 105,
        height: 115,

        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F5),

          borderRadius: BorderRadius.circular(14),
        ),

        child: const Icon(
          Icons.home_work_outlined,

          color: _primaryColor,

          size: 32,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),

      child: Image.network(
        image,

        width: 105,
        height: 115,

        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 105,
            height: 115,

            color: const Color(0xFFF0F2F5),

            child: const Icon(
              Icons.home_work_outlined,

              color: _primaryColor,

              size: 32,
            ),
          );
        },
      ),
    );
  }

  Widget buildStatusIcon(bool approved) {
    final Color color = approved ? _approvedColor : _rejectedColor;

    return Container(
      width: 20,
      height: 20,

      decoration: BoxDecoration(color: color, shape: BoxShape.circle),

      child: Icon(
        approved ? Icons.check_rounded : Icons.close_rounded,

        color: Colors.white,

        size: 18,
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(
              Icons.notifications_none_rounded,

              size: 52,

              color: _primaryColor,
            ),

            const SizedBox(height: 16),

            const Text(
              "No notifications yet",

              style: TextStyle(
                color: _textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Property feedback and replies to your support requests will appear here.",

              textAlign: TextAlign.center,

              style: TextStyle(
                color: _secondaryTextColor,

                fontSize: 13,

                height: 1.4,

                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    final DateTime now = DateTime.now();

    final Duration difference = now.difference(date.toLocal());

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      final int hours = difference.inHours;

      return hours == 1 ? "1 hour ago" : "$hours hours ago";
    }

    if (difference.inDays < 7) {
      final int days = difference.inDays;

      return days == 1 ? "Yesterday" : "$days days ago";
    }

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

    return "${local.day} ${months[local.month - 1]} ${local.year}";
  }
}
