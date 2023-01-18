import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/task.dart';
import 'package:theming/core/extensions/date_time_extension.dart';

class DismissibleTaskItem extends StatelessWidget {
  final Task task;

  final ValueChanged<DismissDirection>? onDismissed;
  final VoidCallback onTap;

  const DismissibleTaskItem({
    Key? key,
    required this.task,
    this.onDismissed,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: onDismissed,
      background: const _DismissDeleteBackground(),
      child: _TaskItemCard(onTap: onTap, task: task),
    );
  }
}

class _TaskItemCard extends StatelessWidget {
  const _TaskItemCard({
    Key? key,
    required this.onTap,
    required this.task,
  }) : super(key: key);

  final VoidCallback onTap;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _color(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: _TaskItemListTile(onTap: onTap, task: task),
    );
  }

  Color _color() {
    final index = Random().nextInt(Colors.primaries.length);
    return Colors.primaries[index].shade200;
  }
}

class _TaskItemListTile extends StatelessWidget {
  const _TaskItemListTile({
    Key? key,
    required this.onTap,
    required this.task,
  }) : super(key: key);

  final VoidCallback onTap;
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        isThreeLine: true,
        leading: const _TaskItemLeading(),
        title: _TaskItemTitle(task: task),
        subtitle: _TaskItemContent(task: task),
      ),
    );
  }
}

class _TaskItemLeading extends StatelessWidget {
  const _TaskItemLeading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Icon(
      Icons.task,
      color: primary,
    );
  }
}

class _TaskItemTitle extends StatelessWidget {
  const _TaskItemTitle({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Text(task.title,
        style: TextStyle(
          fontSize: 16,
          color: primary,
          fontWeight: FontWeight.w500,
        ));
  }
}

class _TaskItemContent extends StatelessWidget {
  const _TaskItemContent({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TaskItemSubtitle(task: task),
        const SizedBox(
          height: 18,
        ),
        task.scheduledDate != null
            ? _TaskItemScheduledDate(task: task)
            : const SizedBox()
      ],
    );
  }
}

class _TaskItemSubtitle extends StatelessWidget {
  const _TaskItemSubtitle({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Text(task.description,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: primary.withOpacity(0.8)));
  }
}

class _TaskItemScheduledDate extends StatelessWidget {
  const _TaskItemScheduledDate({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary.withOpacity(0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          task.frequence.isNone ? Icons.alarm : Icons.repeat,
          size: 14,
          color: primary,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          task.scheduledDate!.formatToDayMonthHourMin(),
          style: task.isCompleted
              ? TextStyle(
                  fontSize: 12,
                  color: primary,
                  decoration: TextDecoration.lineThrough)
              : TextStyle(fontSize: 12, color: primary),
        )
      ],
    );
  }
}

class _DismissDeleteBackground extends StatelessWidget {
  const _DismissDeleteBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 60,
      ),
      color: Colors.purple.shade100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete,
          color: Colors.purple.shade600,
          size: 28,
        ),
      ),
    );
  }
}
