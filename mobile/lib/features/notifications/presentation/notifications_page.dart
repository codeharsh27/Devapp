import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Mock Data for UI Demonstration
    final notifications = [
      _NotificationItem(
        title: "Mission Completed!",
        message:
            "You successfully completed 'Backend API Setup'. Reward: +200 XP",
        time: "2 mins ago",
        type: _NotificationType.success,
        isUnread: true,
      ),
      _NotificationItem(
        title: "New Drop Available",
        message:
            "A new standard drop 'Flutter UI Challenge' is now live. Check it out!",
        time: "1 hour ago",
        type: _NotificationType.info,
        isUnread: true,
      ),
      _NotificationItem(
        title: "System Update",
        message:
            "We have updated our terms of service regarding professional integrity.",
        time: "1 day ago",
        type: _NotificationType.alert,
        isUnread: false,
      ),
      _NotificationItem(
        title: "Submission Reviewed",
        message:
            "Your submission for 'Database Migration' has been reviewed. Grade: 9/10.",
        time: "2 days ago",
        type: _NotificationType.success,
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text(
          "Notifications",
          style: GoogleFonts.outfit(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done_all_rounded,
                color: theme.iconTheme.color?.withOpacity(0.5)),
            tooltip: "Mark all as read",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _NotificationCard(
                    item: notifications[index], theme: theme, isDark: isDark);
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor),
            ),
            child: Icon(Icons.notifications_none_rounded,
                size: 48, color: theme.disabledColor),
          ),
          const SizedBox(height: 24),
          Text(
            "You're all caught up!",
            style: GoogleFonts.outfit(
              color: theme.textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "No new notifications at the moment.",
            style: GoogleFonts.outfit(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

enum _NotificationType { success, info, alert }

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final _NotificationType type;
  final bool isUnread;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.isUnread,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  final ThemeData theme;
  final bool isDark;

  const _NotificationCard(
      {required this.item, required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isUnread
            ? (isDark ? const Color(0xFF161616) : Colors.white)
            : Colors.transparent, // Highlight unread
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withOpacity(item.isUnread ? 0.3 : 0.1),
        ),
        boxShadow: item.isUnread
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getColor(item.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(item.type),
              color: _getColor(item.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.time,
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Unread Dot
          if (item.isUnread)
            Container(
              margin: const EdgeInsets.only(left: 8, top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Color _getColor(_NotificationType type) {
    switch (type) {
      case _NotificationType.success:
        return const Color(0xFF00C853);
      case _NotificationType.info:
        return Colors.blueAccent;
      case _NotificationType.alert:
        return Colors.orangeAccent;
    }
  }

  IconData _getIcon(_NotificationType type) {
    switch (type) {
      case _NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case _NotificationType.info:
        return Icons.info_outline_rounded;
      case _NotificationType.alert:
        return Icons.notifications_active_outlined;
    }
  }
}
