import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theming/core/extensions/extensions.dart';
import 'package:theming/view/animation/custom_fade_transition.dart';

import '../../controllers/controllers.dart';
import '../../core/theme/theme.dart';
import '../../models/models.dart';
import '../widgets/widgets.dart';

class NotificationPage extends StatefulWidget {
  final Task? task;

  const NotificationPage({super.key, this.task});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late TaskFormController taskFormController;

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
      taskFormController.initializeEdittingFields(widget.task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificação'),
        leading: BackButton(
          onPressed: () => _onBackButtonPressed(context),
        ),
        actions: const [_SaveNotificationButton()],
      ),
      body: const _NotificationPageBody(
        children: [
          _ChooseDateSession(),
          SizedBox(
            height: 24,
          ),
          _ChooseTimeSession(),
          SizedBox(
            height: 24,
          ),
          _ChooseRepeatSession()
        ],
      ),
    );
  }

  _onBackButtonPressed(BuildContext context) {
    Provider.of<TaskFormController>(context, listen: false).clear();
    Navigator.pop(context);
  }
}

class _ChooseDateSession extends StatelessWidget {
  const _ChooseDateSession();

  @override
  Widget build(BuildContext context) {
    return const CustomFadeTransition(
      child: _NotificationPageSession(
        title: "Escolher Data",
        child: _CalendarInput(),
      ),
    );
  }
}

class _ChooseTimeSession extends StatelessWidget {
  const _ChooseTimeSession();

  @override
  Widget build(BuildContext context) {
    return const CustomFadeTransition(
      child: _NotificationPageSession(
        title: "Escolher Hora",
        child: _TimeInput(),
      ),
    );
  }
}

class _ChooseRepeatSession extends StatelessWidget {
  const _ChooseRepeatSession();

  @override
  Widget build(BuildContext context) {
    return const CustomFadeTransition(
      child: _NotificationPageSession(
        title: "Repetir",
        child: _FrequenceInput(),
      ),
    );
  }
}

class _SaveNotificationButton extends StatelessWidget {
  const _SaveNotificationButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => _onSaveButtonPressed(context),
        icon: const Icon(Icons.save));
  }

  _onSaveButtonPressed(BuildContext context) {
    Provider.of<TaskFormController>(context, listen: false).onScheduledDate();

    Navigator.pop(context);
  }
}

class _NotificationPageBody extends StatelessWidget {
  final List<Widget> children;
  const _NotificationPageBody({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: children,
      ),
    );
  }
}

class _NotificationPageSession extends StatelessWidget {
  final String title;
  final Widget child;
  const _NotificationPageSession({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(title: title),
        const SizedBox(
          height: 16,
        ),
        child
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 9),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            letterSpacing: 1, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _CalendarInput extends StatefulWidget {
  const _CalendarInput();

  @override
  State<_CalendarInput> createState() => __CalendarInputState();
}

class __CalendarInputState extends State<_CalendarInput> {
  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2035, 12, 31),
      builder: (context, child) =>
          Theme(data: PickerTheme.datePickerTheme(context), child: child!),
    );
  }

  late TaskFormController taskFormController;

  @override
  void initState() {
    super.initState();

    taskFormController =
        Provider.of<TaskFormController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () => _onTap(context),
      icon: Icons.calendar_today,
      child: Consumer<TaskFormController>(
        builder: (context, controller, _) => Text(
          controller.initialDate.formatToWeekdayDayMonth(),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }

  _onTap(BuildContext context) async {
    final date = await _showDatePicker(context);

    if (date != null) {
      taskFormController.onInitialDateChanged(date);
    }
  }
}

class _TimeInput extends StatefulWidget {
  const _TimeInput();

  @override
  State<_TimeInput> createState() => __TimeInputState();
}

class __TimeInputState extends State<_TimeInput> {
  Future<TimeOfDay?> _showTimePicker(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  late TaskFormController taskFormController;

  @override
  void initState() {
    super.initState();

    taskFormController =
        Provider.of<TaskFormController>(context, listen: false);
  }

  _onTap(BuildContext context) async {
    final time = await _showTimePicker(context);

    if (time != null) {
      taskFormController.onInitialTimeChanged(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap: () => _onTap(context),
      icon: Icons.alarm,
      child: Consumer<TaskFormController>(
        builder: (context, controller, _) => Text(
          controller.initialTime.format(context),
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}

class _FrequenceInput extends StatelessWidget {
  const _FrequenceInput();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 210,
        child: ListView(
          children: const [
            _NoneInput(),
            _DailyInput(),
            _WeeklyInput(),
            _MonthlyInput(),
          ],
        ));
  }
}

class _NoneInput extends StatelessWidget {
  const _NoneInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
      builder: (context, controller, _) => CustomSwitchListTile(
          value: controller.isNone,
          onChanged: (bool value) => controller.onNoneChanged(value),
          title: 'Não se repete'),
    );
  }
}

class _MonthlyInput extends StatelessWidget {
  const _MonthlyInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
      builder: (context, controller, _) => CustomSwitchListTile(
          value: controller.isMonthly,
          onChanged: (bool value) => controller.onMonthlyChanged(value),
          title: 'Mensalmente'),
    );
  }
}

class _WeeklyInput extends StatelessWidget {
  const _WeeklyInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
      builder: (context, controller, _) => CustomSwitchListTile(
          value: controller.isWeekly,
          onChanged: (bool value) => controller.onWeeklyChanged(value),
          title: 'Semanalmente'),
    );
  }
}

class _DailyInput extends StatelessWidget {
  const _DailyInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskFormController>(
      builder: (context, controller, _) => CustomSwitchListTile(
          value: controller.isDaily,
          onChanged: (bool value) => controller.onDailyChanged(value),
          title: 'Diariamente'),
    );
  }
}
