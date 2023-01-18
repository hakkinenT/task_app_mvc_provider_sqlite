import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';

showErrorSnackbar(BuildContext context) {
  final errorMessage = context.watch<TaskController>().errorMessage;
  if (errorMessage != null) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(errorMessage),
          padding: const EdgeInsets.all(16),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
    });
  }
}

showSuccessSnackbar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      padding: const EdgeInsets.all(16),
    ));
}
