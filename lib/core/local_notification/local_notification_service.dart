import 'dart:core';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//* Define o formato da notificação
class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final DateTime scheduledDate;
  final String? payload;

  CustomNotification(
      {required this.id,
      this.title,
      this.body,
      required this.scheduledDate,
      this.payload});
}

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //* Receberá os detalhes específicos da notificação para o android
  late AndroidNotificationDetails androidNotificationDetails;

  //* Stream que armazenará o último payload recebido
  late BehaviorSubject<String?> selectNotificationStream;

  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    selectNotificationStream = BehaviorSubject<String?>();

    _setupAndroidDetails();

    _setUpNotifications();
  }

  //* Agenda uma notificação que será apresentada uma única vez
  //* Em data e hora específicas
  Future<void> scheduledNotification(CustomNotification notification) async {
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

  //* Agenda uma notificação que se repetirá diariamente
  //* A partir de data e hora específicas
  Future<void> scheduleDailyNotification(
      CustomNotification notification) async {
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

  //* Agenda uma notificação que se repetirá semanalmente
  //* A partir de data e hora específicas
  Future<void> scheduleWeeklyNotification(
      CustomNotification notification) async {
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

  //* Agenda uma notificação que se repetirá mensalmente
  //* A partir de data e hora específicas
  Future<void> scheduleMonthlyNotification(
      CustomNotification notification) async {
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

  //* Cancela todas as notificações cadastradas
  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  //* Cancela uma determinada notificação pelo seu id
  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  //* Especifica os detalhes da notificação para o Android
  _setupAndroidDetails() {
    androidNotificationDetails = const AndroidNotificationDetails(
      "task_notifications_details",
      "Tasks",
      channelDescription: "Este canal é para notificação de tarefas!",
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  //* Chama o método de configuração do timezone
  //* E o método que inicializa o plugin de notificações
  _setUpNotifications() async {
    await _configureLocalTimeZone();
    _initializeNotification();
  }

  Future<void> _configureLocalTimeZone() async {
    //* Inicializa o banco de dados de timezones
    tz.initializeTimeZones();

    //* Obtém o timezone local
    //* Configurado no sistema Android
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    //* Define a localização atual do usuário
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    //* Inicializa as configurações específicas para o Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //* Inicializa as configurações do(s) sistemas operacionais
    //* Nesse caso apenas o Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //* Inicializa o plugin, passando as configurações para cada sistema
    //* Também é passado o método que deverá ser chamado
    //* quando a notificação for selecionada pelo usuário
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  }

  //* Método chamado quando a notificação for selecionada pelo usuário
  _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotification) {
      _onSelectNotification(notificationResponse.payload);
    }
  }

  //* Verifica se o DIA DA SEMANA atual é igual ao DIA DA SEMANA da data agendada
  //* Se for igual, a notificação é disparada na data e hora especificada
  //* Se não, é adicionado mais um dia a data agendada
  tz.TZDateTime _nextInstanceOfDay(DateTime date) {
    tz.TZDateTime scheduledDate = _nextInstanceOfHour(date);
    while (scheduledDate.weekday != date.weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //* Verifica se a DATA E HORA AGENDADA é anterior a DATA E HORA ATUAL
  //* Se sim, é adicionado mais um dia a DATA E HORA agendada
  //* Se não, a notificação é disparada na DATA E HORA agendada
  tz.TZDateTime _nextInstanceOfHour(DateTime date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, date.year, date.month, date.day, date.hour, date.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //* Método chamdo para recuperar uma notificação quando o app é aberto
  checkForNotification() async {
    //* Obtém os detalhes da notificação
    final NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    //* Verifica se details não é nulo e se existe alguma notificação
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse!.payload!);
    }
  }

  //* Define o que acontecerá qundo o usuário selecionar a notificação
  _onSelectNotification(String? payload) {
    selectNotificationStream.add(payload);
  }
}
