//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:core';

import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

const String navigationActionId = 'id_0';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.scheduledDate,
      this.payload});
}

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  late AndroidNotificationDetails androidNotificationDetails;

  late BehaviorSubject<String?> selectNotificationStream;

  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    selectNotificationStream = BehaviorSubject<String?>();

    _setupAndroidDetails();

    _setUpNotifications();

    _checkForNotification();
  }

  Future<void> scheduledNotification(ReceivedNotification notification) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          _nextInstanceOfHour(notification.scheduledDate),
          NotificationDetails(
            android: androidNotificationDetails,
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: notification.payload);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> scheduleDailyNotification(
      ReceivedNotification notification) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          _nextInstanceOfHour(notification.scheduledDate),
          NotificationDetails(
            android: androidNotificationDetails,
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: notification.payload);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> scheduleWeeklyNotification(
      ReceivedNotification notification) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          _nextInstanceOfDay(notification.scheduledDate),
          NotificationDetails(
            android: androidNotificationDetails,
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: notification.payload);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> scheduleMonthlyNotification(
      ReceivedNotification notification) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          _nextInstanceOfDay(notification.scheduledDate),
          NotificationDetails(android: androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
          payload: notification.payload);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  tz.TZDateTime _nextInstanceOfDay(DateTime date) {
    tz.TZDateTime scheduledDate = _nextInstanceOfHour(date);
    while (scheduledDate.weekday != date.weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfHour(DateTime date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, date.year, date.month, date.day, date.hour, date.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  _checkForNotification() async {
    final NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      selectNotificationStream.add(details.notificationResponse!.payload!);
    }
  }

  _setupAndroidDetails() {
    androidNotificationDetails = const AndroidNotificationDetails(
      "lembretes_notifications_details",
      "Lembretes",
      channelDescription: "Este canal é para lembretes!",
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  _setUpNotifications() async {
    await _configureLocalTimeZone();
    _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }
}
