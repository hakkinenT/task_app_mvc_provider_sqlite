import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/show_snackbars.dart';
import '../../models/models.dart';
import '../animation/animation.dart';
import '../widgets/widgets.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TaskFormController taskFormController;

  String label = "Cadastrar Tarefa";

  @override
  void initState() {
    super.initState();
    taskFormController =
        Provider.of<TaskFormController>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.task != null) {
      label = "Editar Tarefa";
      taskFormController.initializeEdittingFields(widget.task);
    }

    showErrorSnackbar(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        leading: BackButton(
          onPressed: () => _onBackButtonPressed(context),
        ),
        actions: [_NotificationButton(task: widget.task)],
      ),
      body: _AddTaskBody(
        child: _AddTaskForm(
          children: [
            const _TitleInput(),
            const SizedBox(
              height: 16,
            ),
            const _DescriptionInput(),
            const SizedBox(
              height: 24,
            ),
            const _ShowNotificationInfo(),
            const SizedBox(
              height: 36,
            ),
            _AddButton(task: widget.task, label: label)
          ],
        ),
      ),
    );
  }

  _onBackButtonPressed(BuildContext context) {
    taskFormController.clear();

    Navigator.pop(context);
  }
}

class _AddTaskBody extends StatelessWidget {
  final Widget child;
  const _AddTaskBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}

class _AddTaskForm extends StatelessWidget {
  final List<Widget> children;
  const _AddTaskForm({required this.children});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ));
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task? task;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onPressed(context, task),
        icon: const Icon(Icons.notification_add));
  }

  _onPressed(BuildContext context, Task? task) {
    Navigator.pushNamed(context, notificationSettingsPage, arguments: task);
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
      builder: (context, controller, _) => CustomFadeTransition(
        child: CustomTextFormField(
          hintText: "Título",
          initialValue: controller.title,
          onChanged: (value) => controller.onTitleChanged(value),
        ),
      ),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
        builder: (context, controller, _) => CustomFadeTransition(
              child: CustomTextFormField(
                  onChanged: (value) => controller.onDescriptionChanged(value),
                  initialValue: controller.description,
                  hintText: "Descrição"),
            ));
  }
}

class _AddButton extends StatefulWidget {
  final Task? task;
  final String label;

  const _AddButton({
    Key? key,
    required this.task,
    required this.label,
  }) : super(key: key);

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  late TaskFormController taskFormController;

  late TaskController taskController;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFadeTransition(
      child: CustomElevatedButton(
          onPressed: () => _onPressed(context), child: Text(widget.label)),
    );
  }

  _initState() {
    taskFormController =
        Provider.of<TaskFormController>(context, listen: false);

    taskController = Provider.of<TaskController>(context, listen: false);
  }

  void _onPressed(BuildContext context) async {
    final date = taskFormController.scheduledDate;
    final frequence = taskFormController.frequence;
    final title = taskFormController.title;
    final description = taskFormController.description;

    Task task = Task(
        id: widget.task?.id,
        title: title,
        description: description,
        scheduledDate: date,
        frequence: frequence);

    taskController.saveTask(task);

    /*ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
        content: Text("A Tarefa foi salva com sucesso!"),
        padding: EdgeInsets.all(16),
      ));
    taskFormController.clear();
    Navigator.pop(context);*/

    showSuccessSnackbar(context, message: "A Tarefa foi salva com sucesso!");
    taskFormController.clear();
    Navigator.pop(context);
  }
}

class _ShowNotificationInfo extends StatelessWidget {
  const _ShowNotificationInfo();

  @override
  Widget build(BuildContext context) {
    final scheduledDate = context
        .select((TaskFormController controller) => controller.scheduledDate);
    final frequence =
        context.select((TaskFormController controller) => controller.frequence);

    return CustomFadeTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (scheduledDate != null)
              ? ShowScheduledDate(
                  date: scheduledDate,
                  frequence: frequence,
                )
              : const Center(child: Text('Não há notificação cadastrada!')),
        ],
      ),
    );
  }
}
