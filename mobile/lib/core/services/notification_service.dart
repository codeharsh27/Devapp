import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../features/drops/domain/drop.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings (Basic)
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    await Permission.notification.request();
  }

  Future<void> showMissionTimer(Drop drop, DateTime endTime) async {
    final int endTimeMs = endTime.millisecondsSinceEpoch;

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'mission_timer_channel_v7', // Version 7: Fresh "Professional" Channel
      'Mission Timer',
      channelDescription: 'Active mission status and timer',
      importance: Importance.max,
      priority: Priority.max,
      ongoing: true,
      autoCancel: false,
      showWhen: true,
      when: endTimeMs,
      usesChronometer: true,
      chronometerCountDown: true,

      // Visual Aesthetic: Standard Professional Android
      // We use the app's primary like color or a dark grey, but let system handle text contrast
      color: const Color(
          0xFF2196F3), // Standard Blue/Framework color for "Active" status
      colorized:
          false, // Let system handle the background for better readability

      // Large Icon adds visual weight and context (The "Proper" way)
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),

      styleInformation: const MediaStyleInformation(
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),

      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'view_mission',
          'Pause',
          icon: DrawableResourceAndroidBitmap('ic_custom_pause'),
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          'cancel_mission',
          'Cancel',
          icon: DrawableResourceAndroidBitmap('ic_custom_cancel'),
          showsUserInterface: true,
        ),
      ],
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      888,
      drop.title, // Title: The Mission Name
      'Time Remaining', // Body: Clear Context
      notificationDetails,
    );
  }

  Future<void> cancelMissionTimer() async {
    await flutterLocalNotificationsPlugin.cancel(888);
  }
}
