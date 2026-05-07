import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    _initialized = true;

    // Request permission once at startup
    await _requestPermissionOnce();
  }

  /// Request notification permission (only asks if not already granted)
  static Future<void> _requestPermissionOnce() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.areNotificationsEnabled() ?? false;
      if (!granted) {
        await androidPlugin.requestNotificationsPermission();
      }
    }
  }

  static Future<void> scheduleTaskReminder(Task task) async {
    await cancelTaskNotification(task.id);

    if (task.reminderOption == ReminderOption.none) return;
    if (task.isCompleted) return;

    Duration reminderDuration;
    switch (task.reminderOption) {
      case ReminderOption.satujam:
        reminderDuration = const Duration(hours: 1);
        break;
      case ReminderOption.satuHari:
        reminderDuration = const Duration(days: 1);
        break;
      case ReminderOption.tigaHari:
        reminderDuration = const Duration(days: 3);
        break;
      case ReminderOption.none:
        return;
    }

    final reminderTime = task.deadline.subtract(reminderDuration);

    // If reminder time already passed, send notification in 5 seconds instead
    if (reminderTime.isBefore(DateTime.now())) {
      // Still show a notification for tasks with near deadlines
      final nearDeadline = DateTime.now().add(const Duration(seconds: 5));
      final scheduledDate = tz.TZDateTime.from(nearDeadline, tz.local);

      final androidDetails = AndroidNotificationDetails(
        'studyplan_reminders',
        'Pengingat Tugas',
        channelDescription: 'Notifikasi pengingat tugas sekolah',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF6D5DE6),
        styleInformation: BigTextStyleInformation(
          'Tugas "${task.title}" untuk ${task.subject} sudah mendekati deadline! Segera kerjakan ya!',
          contentTitle: '⚠️ Deadline Dekat: ${task.title}',
          summaryText: task.subject,
        ),
      );

      final notifDetails = NotificationDetails(android: androidDetails);

      await _plugin.zonedSchedule(
        id: task.id.hashCode,
        title: '⚠️ Deadline Dekat: ${task.title}',
        body: 'Tugas ${task.subject} harus segera diselesaikan!',
        scheduledDate: scheduledDate,
        notificationDetails: notifDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: task.id,
      );
      return;
    }

    final scheduledDate = tz.TZDateTime.from(reminderTime, tz.local);

    final androidDetails = AndroidNotificationDetails(
      'studyplan_reminders',
      'Pengingat Tugas',
      channelDescription: 'Notifikasi pengingat tugas sekolah',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF6D5DE6),
      styleInformation: BigTextStyleInformation(
        'Tugas "${task.title}" untuk mata pelajaran ${task.subject} akan jatuh tempo. Jangan sampai telat ya!',
        contentTitle: '📚 Pengingat: ${task.title}',
        summaryText: task.subject,
      ),
    );

    final notifDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id: task.id.hashCode,
      title: '📚 Pengingat: ${task.title}',
      body: 'Deadline ${task.reminderLabel}! Jangan lupa kerjakan tugas ${task.subject}.',
      scheduledDate: scheduledDate,
      notificationDetails: notifDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: task.id,
    );
  }

  static Future<void> cancelTaskNotification(String taskId) async {
    await _plugin.cancel(id: taskId.hashCode);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
