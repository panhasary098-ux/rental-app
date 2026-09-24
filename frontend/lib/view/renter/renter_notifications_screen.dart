import 'package:flutter/material.dart';

const Color renterNotificationPrimaryColor = Color(0xFF080B78);
const Color renterNotificationBackgroundColor = Color(0xFFF8FAFC);
const Color renterNotificationBorderColor = Color(0xFFF0F1F5);
const Color renterNotificationMutedTextColor = Color(0xFF85899B);

class RenterPropertyNotification {
  final int id;
  final int propertyId;
  final String propertyName;
  final String propertyImage;
  final String location;
  final String type;
  final String title;
  final String message;
  final String oldStatus;
  final String newStatus;
  final DateTime createdAt;
  final bool isNew;

  const RenterPropertyNotification({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.location,
    required this.type,
    required this.title,
    required this.message,
    required this.oldStatus,
    required this.newStatus,
    required this.createdAt,
    required this.isNew,
  });
}

class RenterNotificationsScreen extends StatelessWidget {
  final List<RenterPropertyNotification> notifications;
  final void Function(RenterPropertyNotification notification) onViewProperty;

  const RenterNotificationsScreen({
    super.key,
    required this.notifications,
    required this.onViewProperty,
  });

  @override
  Widget build(BuildContext context) {
    final newNotifications = notifications.where((item) => item.isNew).toList();

    final earlierNotifications = notifications
        .where((item) => !item.isNew)
        .toList();

    return Scaffold(
      backgroundColor: renterNotificationBackgroundColor,
      appBar: AppBar(
        backgroundColor: renterNotificationBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: renterNotificationPrimaryColor,
          ),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: renterNotificationPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (newNotifications.isNotEmpty) ...[
                    _buildSectionTitle("New"),
                    const SizedBox(height: 10),
                    ...newNotifications.map(
                      (notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildNotificationCard(notification),
                      ),
                    ),
                  ],
                  if (newNotifications.isNotEmpty &&
                      earlierNotifications.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Divider(
                      color: renterNotificationBorderColor,
                      height: 1,
                    ),
                    const SizedBox(height: 18),
                  ],
                  if (earlierNotifications.isNotEmpty) ...[
                    _buildSectionTitle("Earlier"),
                    const SizedBox(height: 10),
                    ...earlierNotifications.map(
                      (notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildNotificationCard(notification),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: renterNotificationPrimaryColor,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildNotificationCard(RenterPropertyNotification notification) {
    final bool isAvailable =
        notification.newStatus.toLowerCase() == "available";

    final Color statusColor = isAvailable
        ? const Color(0xFF16A34A)
        : const Color(0xFFDC2626);

    final Color statusBackground = isAvailable
        ? const Color(0xFFF0FDF4)
        : const Color(0xFFFEF2F2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: notification.isNew
              ? renterNotificationPrimaryColor.withOpacity(0.14)
              : renterNotificationBorderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertyImage(notification.propertyImage),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: renterNotificationPrimaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (notification.isNew) ...[
                          const SizedBox(width: 7),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.propertyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        color: renterNotificationMutedTextColor,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _capitalize(notification.newStatus),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(notification.createdAt),
                style: const TextStyle(
                  color: renterNotificationMutedTextColor,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
          if (notification.location.trim().isNotEmpty &&
              notification.location != "-") ...[
            const SizedBox(height: 11),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: renterNotificationMutedTextColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    notification.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: renterNotificationMutedTextColor,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () => onViewProperty(notification),
              style: OutlinedButton.styleFrom(
                foregroundColor: renterNotificationPrimaryColor,
                side: const BorderSide(color: renterNotificationBorderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "View Property",
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return _buildImagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Image.network(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F8),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(
        Icons.home_work_outlined,
        color: renterNotificationPrimaryColor,
        size: 28,
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFFF0F1F8),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 32,
                color: renterNotificationPrimaryColor,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "No notifications yet",
              style: TextStyle(
                color: renterNotificationPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Updates about your saved properties will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: renterNotificationMutedTextColor,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String value) {
    final String clean = value.trim().toLowerCase();

    if (clean.isEmpty) {
      return "-";
    }

    return "${clean[0].toUpperCase()}${clean.substring(1)}";
  }

  String _formatDate(DateTime date) {
    final Duration difference = DateTime.now().difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
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

    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
