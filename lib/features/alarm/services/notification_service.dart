import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initFuture = _initializeNotifications();
  }

  late final Future<void> _initFuture;

  Future<void> _initializeNotifications() async {
    // Timezone is initialized in main.dart now
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  Future<void> scheduleAlarm(int id, DateTime scheduledTime, String title, String body) async {
    await _initFuture;
    final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);
    debugPrint("Scheduling alarm $id for $scheduledTime");
    debugPrint("Converted TZDateTime: $tzDateTime");
    debugPrint("Current TZ Time: ${tz.TZDateTime.now(tz.local)}");
    
    try {
    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDateTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel_id_v2',
          'Alarms',
          channelDescription: 'Channel for Alarm Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    debugPrint("Alarm scheduled successfully");
    debugPrint("Alarm scheduled successfully");
    } catch (e) {
      debugPrint("Error scheduling alarm: $e");
    }
  }

  Future<void> cancelAlarm(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  Future<void> showInstantNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel_id_v2',
      'Alarms',
      channelDescription: 'Channel for Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
