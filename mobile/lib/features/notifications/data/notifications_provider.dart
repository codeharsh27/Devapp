import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/websocket_service.dart';

enum NotificationType { success, info, alert, error }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isUnread;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isUnread = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'type': type.index,
        'isUnread': isUnread,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        timestamp: DateTime.parse(json['timestamp']),
        type: NotificationType.values[json['type']],
        isUnread: json['isUnread'],
      );
}

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super([]) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? list = prefs.getStringList('notifications');
    if (list != null) {
      state = list
          .map((item) => AppNotification.fromJson(jsonDecode(item)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
  }) async {
    final newNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    );

    state = [newNotification, ...state];
    _saveNotifications();
  }

  Future<void> markAllAsRead() async {
    state = state.map((n) {
      n.isUnread = false;
      return n;
    }).toList();
    _saveNotifications();
  }

  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList('notifications', list);
  }

  Future<void> handleWebSocketEvent(Map<String, dynamic> event) async {
    final type = event['type'];
    final data = event['data'];

    if (type == 'submission_update') {
      final status = data['status'];
      final dropTitle = data['drop_title'] ?? 'Drop';
      final score = data['score'];

      String title = '';
      String message = '';
      NotificationType notifType = NotificationType.info;

      if (status == 'completed') {
        title = 'Mission Accomplished';
        message =
            'You successfully verified "$dropTitle". Score: $score XP obtained.';
        notifType = NotificationType.success;
      } else if (status == 'failed') {
        title = 'Mission Failed';
        message =
            'Verification for "$dropTitle" failed. Check feedback and retry.';
        notifType = NotificationType.error;
      } else {
        return; // Ignore others
      }

      await addNotification(
        title: title,
        message: message,
        type: notifType,
      );

      // Trigger System Notification
      await NotificationService().showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/
            1000, // Unique ID based on time
        title: title,
        body: message,
      );
    }
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  final notifier = NotificationsNotifier();

  // Listen to WebSocket Events
  ref.listen(webSocketEventsProvider, (previous, next) {
    next.whenData((event) {
      notifier.handleWebSocketEvent(event);
    });
  });

  return notifier;
});
