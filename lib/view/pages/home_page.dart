import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:theming/core/utils/show_snackbars.dart';

import '../../controllers/controllers.dart';
import '../../core/constants/constants.dart';
import '../../core/local_notification/local_notification_service.dart';
import '../../injection_container.dart';
import '../../models/models.dart';

import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late NotificationService notificationService;
  late StreamSubscription<String?> notificationListen;

  @override
  void initState() {
    super.initState();

    notificationService = sl<NotificationService>();

    _listenNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showErrorSnackbar(context);
  }

  @override
  void dispose() {
    notificationListen.cancel();

    super.dispose();
  }

  void _listenNotification() {
    notificationListen = notificationService.selectNotificationStream.stream
        .listen(_onClickedNotification);
  }

  void _onClickedNotification(String? payload) {
    if (payload != null) {
      final task = Task.fromJson(json.decode(payload));

      Navigator.pushNamed(context, detailsPage, arguments: task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: const [_ClearAllTasksButton()],
      ),
      body: _HomeBody(
        child: Consumer<TaskController>(
          builder: (context, controller, _) {
            return FutureBuilder(
              future: controller.tasks,
              builder: (context, snapshot) {
                final tasks = snapshot.data;

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (tasks != null) {
                  return _TaskList(tasks: tasks, taskController: controller);
                }

                return const Center(
                  child: Text('Não há tasks cadastradas!'),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: const _HomeFloatingActionButton(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final Widget child;
  const _HomeBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: child,
    );
  }
}

class _HomeFloatingActionButton extends StatelessWidget {
  const _HomeFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onPressed(context),
      child: const Icon(Icons.add),
    );
  }

  _onPressed(BuildContext context) {
    Navigator.pushNamed(context, addTaskPage);
  }
}

class _ClearAllTasksButton extends StatelessWidget {
  const _ClearAllTasksButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.clear_all));
  }

  _onPressed(BuildContext context) {
    Provider.of<TaskController>(context, listen: false).removeAll();

    /*ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text("A lista de tarefas está vazia!"),
        padding: EdgeInsets.all(10),
      ));*/

    showSuccessSnackbar(context, message: "A lista de tarefas está vazia!");
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    Key? key,
    required this.tasks,
    required this.taskController,
  }) : super(key: key);

  final List<Task> tasks;
  final TaskController taskController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: tasks.length,
        separatorBuilder: (context, index) => _separator,
        itemBuilder: (context, index) {
          return DismissibleTaskItem(
            task: tasks[index],
            onDismissed: (_) => _onDismissed(context, tasks[index]),
            onTap: () => _onTap(context, tasks[index]),
          );
        });
  }

  final _separator = const SizedBox(
    height: 5,
  );

  _onDismissed(BuildContext context, Task task) {
    taskController.removeTask(task);
    /*ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text("A tarefa foi excluída com sucesso!"),
        padding: EdgeInsets.all(10),
      ));*/
    showSuccessSnackbar(context, message: 'A Tarefa foi excluída com sucesso!');
  }

  _onTap(BuildContext context, Task task) {
    Navigator.pushNamed(context, detailsPage, arguments: task);
  }
}
