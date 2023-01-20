import 'dart:convert';
import 'dart:core';
import 'package:rxdart/rxdart.dart';
import 'package:theming/core/local_notification/local_notification_service.dart';

import '../../models/task.dart';

class TaskNotificationAdapter {
  final NotificationService notificationService;

  TaskNotificationAdapter({required this.notificationService});

  BehaviorSubject<String?> get selectNotificationStream =>
      notificationService.selectNotificationStream;

  Future<void> scheduledNotification(Task task) => notificationService
      .scheduledNotification(_convertToReceivedNotification(task));

  Future<void> scheduleDailyNotification(Task task) => notificationService
      .scheduleDailyNotification(_convertToReceivedNotification(task));

  Future<void> scheduleWeeklyNotification(Task task) => notificationService
      .scheduleWeeklyNotification(_convertToReceivedNotification(task));

  Future<void> scheduleMonthlyNotification(Task task) => notificationService
      .scheduleWeeklyNotification(_convertToReceivedNotification(task));

  Future<void> cancelAllNotifications() =>
      notificationService.cancelAllNotifications();

  Future<void> cancelNotification(int id) =>
      notificationService.cancelNotification(id);

  CustomNotification _convertToReceivedNotification(Task task) {
    return CustomNotification(
        id: task.id!,
        title: task.title,
        body: task.description,
        scheduledDate: task.scheduledDate!,
        payload: json.encode(task.toJson()));
  }
}
