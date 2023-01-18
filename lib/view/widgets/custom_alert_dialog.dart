import 'package:flutter/material.dart';

AlertDialog alertDialogError(BuildContext context,
    {required String errorMessage, VoidCallback? onPressed}) {
  final errorColor = Theme.of(context).colorScheme.error;

  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.surface,
    title: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          color: errorColor,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          'Error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        )
      ],
    ),
    content: Text(
      errorMessage,
      //style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
    ),
    actions: [TextButton(onPressed: onPressed, child: const Text("OK"))],
  );
}

AlertDialog alertDialogSuccess(BuildContext context,
    {required String message, VoidCallback? onPressed}) {
  return AlertDialog(
    backgroundColor: Theme.of(context).colorScheme.surface,
    title: Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green.shade200,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          'Sucesso!',
          style: TextStyle(
            color: Colors.green.shade200,
          ),
        )
      ],
    ),
    content: Text(
      message,
      style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87)),
    ),
    actions: [TextButton(onPressed: onPressed, child: const Text("OK"))],
  );
}
