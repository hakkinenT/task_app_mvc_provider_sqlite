import 'package:flutter/material.dart';
import 'package:theming/routes/page_transition/slide_up_route.dart';

import '../core/constants/constants.dart';
import '../models/models.dart';
import '../view/pages/pages.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final task = settings.arguments as Task?;

    switch (settings.name) {
      case home:
        return SlideUpRoute(page: const Home(), routeName: home);
      case addTaskPage:
        return SlideUpRoute(
            page: AddTaskPage(task: task), routeName: addTaskPage);
      case detailsPage:
        return SlideUpRoute(
            page: TaskDetailsPage(
              task: task,
            ),
            routeName: detailsPage);
      case notificationSettingsPage:
        return SlideUpRoute(
            page: NotificationPage(
              task: task,
            ),
            routeName: notificationSettingsPage);
      default:
        return SlideUpRoute(page: const _ErrorRoute());
    }
  }
}

class _ErrorRoute extends StatelessWidget {
  const _ErrorRoute();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Rota desconhecida'),
      ),
    );
  }
}
