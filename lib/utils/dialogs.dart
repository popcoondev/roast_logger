// utils/dialogs.dart

import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(
    BuildContext context, String title, String message, String okText, String cancelText) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(okText),
          ),
        ],
      );
    },
  );
}

Future<String?> showSelectDialog(
    BuildContext context, String title, String message, List<String> choices) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: choices
            .map((choice) => SimpleDialogOption(
                  child: Text(choice),
                  onPressed: () => Navigator.pop(context, choice),
                ))
            .toList(),
      );
    },
  );
}
