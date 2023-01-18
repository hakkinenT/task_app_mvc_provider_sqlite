import 'package:get_it/get_it.dart';
import 'package:theming/core/local_notification/task_notification_adapter.dart';

import 'controllers/controllers.dart';

import 'core/local_notification/local_notification_service.dart';
import 'data/database/database.dart';
import 'data/repositories/repositories.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
      () => TaskController(notificationService: sl(), repository: sl()));
  sl.registerFactory(() => TaskFormController());

  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(taskDao: sl()));

  sl.registerLazySingleton<TaskDao>(() => TaskDaoImpl());

  sl.registerLazySingleton(
      () => TaskNotificationAdapter(notificationService: sl()));

  sl.registerLazySingleton(() => NotificationService());
}
