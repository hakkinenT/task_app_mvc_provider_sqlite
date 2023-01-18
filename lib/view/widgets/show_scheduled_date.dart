import 'package:flutter/material.dart';

import 'package:theming/models/task.dart';
import 'package:theming/core/extensions/date_time_extension.dart';

class ShowScheduledDate extends StatelessWidget {
  final DateTime date;
  final Frequence frequence;

  const ShowScheduledDate({
    Key? key,
    required this.date,
    required this.frequence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Icon(
            frequence.isNone ? Icons.alarm : Icons.repeat,
            size: 14,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            date.formatToDayMonthYearHourMin(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ],
      ),
    );
  }
}
