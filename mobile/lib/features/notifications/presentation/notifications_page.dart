import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../notifications/data/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return "${difference.inDays}d ago";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifications = ref.watch(notificationsProvider);

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
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              icon: Icon(Icons.done_all_rounded,
                  color: theme.iconTheme.color?.withValues(alpha: 0.5)),
              tooltip: "Mark all as read",
            ),
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).clearAll();
              },
              icon: Icon(Icons.delete_outline_rounded,
                  color: theme.iconTheme.color?.withValues(alpha: 0.5)),
              tooltip: "Clear All",
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
                final item = notifications[index];
                return _NotificationCard(
                  item: item,
                  theme: theme,
                  isDark: isDark,
                  timeLabel: _formatTime(item.timestamp),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                    .slideX(begin: 0.1, end: 0);
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
          ).animate().scale(),
          const SizedBox(height: 24),
          Text(
            "You're all caught up!",
            style: GoogleFonts.outfit(
              color: theme.textTheme.titleLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            "No new notifications at the moment.",
            style: GoogleFonts.outfit(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification item;
  final ThemeData theme;
  final bool isDark;
  final String timeLabel;

  const _NotificationCard(
      {required this.item,
      required this.theme,
      required this.isDark,
      required this.timeLabel});

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
          color:
              theme.dividerColor.withValues(alpha: item.isUnread ? 0.3 : 0.1),
        ),
        boxShadow: item.isUnread
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
              color: _getColor(item.type).withValues(alpha: 0.1),
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
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: theme.textTheme.titleLarge?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeLabel,
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
                    color: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.8),
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

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return const Color(0xFF00C853);
      case NotificationType.info:
        return Colors.blueAccent;
      case NotificationType.alert:
        return Colors.orangeAccent;
      case NotificationType.error:
        return Colors.redAccent;
    }
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline_rounded;
      case NotificationType.info:
        return Icons.info_outline_rounded;
      case NotificationType.alert:
        return Icons.notifications_active_outlined;
      case NotificationType.error:
        return Icons.error_outline_rounded;
    }
  }
}
