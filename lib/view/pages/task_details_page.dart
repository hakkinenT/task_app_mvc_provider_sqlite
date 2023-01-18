import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../core/constants/constants.dart';
import '../../models/models.dart';
import '../animation/animation.dart';
import '../widgets/widgets.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task? task;
  const TaskDetailsPage({super.key, this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _EditTaskButton(task: widget.task),
          _ConcludeTaskButton(task: widget.task)
        ],
      ),
      body: _TaskDetailsPageBody(
        children: [
          _TaskTitle(title: widget.task?.title),
          const SizedBox(
            height: 32,
          ),
          _TaskDescription(description: widget.task?.description),
          const SizedBox(
            height: 32,
          ),
          if (widget.task?.scheduledDate != null)
            ShowScheduledDate(
              date: widget.task!.scheduledDate!,
              frequence: widget.task!.frequence,
            )
        ],
      ),
    );
  }
}

class _TaskDescription extends StatelessWidget {
  const _TaskDescription({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String? description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description ?? "Descrição",
      style: const TextStyle(fontSize: 15),
    );
  }
}

class _TaskTitle extends StatelessWidget {
  const _TaskTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return CustomFadeTransition(
      child: Text(
        title ?? 'Título',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TaskDetailsPageBody extends StatelessWidget {
  final List<Widget> children;
  const _TaskDetailsPageBody({required this.children});

  @override
  Widget build(BuildContext context) {
    return CustomFadeTransition(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _EditTaskButton extends StatelessWidget {
  final Task? task;
  const _EditTaskButton({required this.task});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onEditPressed(context), icon: const Icon(Icons.edit));
  }

  _onEditPressed(BuildContext context) {
    Navigator.pushReplacementNamed(context, addTaskPage, arguments: task);
  }
}

class _ConcludeTaskButton extends StatelessWidget {
  const _ConcludeTaskButton({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task? task;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _onPressed(context),
      style: TextButton.styleFrom(
          foregroundColor: const Color.fromRGBO(255, 255, 255, 0.87)),
      child: const Text(
        'Concluir',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  _onPressed(BuildContext context) {
    Provider.of<TaskController>(context, listen: false)
        .onCompletedToggled(true, task!);

    Navigator.pop(context);
  }
}
