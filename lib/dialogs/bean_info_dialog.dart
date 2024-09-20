// dialogs/bean_info_dialog.dart

import 'package:flutter/material.dart';
import '../models/bean_info.dart';

class BeanInfoDialog extends StatefulWidget {
  final BeanInfo beanInfo;
  final Function(BeanInfo) onSave;

  const BeanInfoDialog({Key? key, required this.beanInfo, required this.onSave}) : super(key: key);

  @override
  _BeanInfoDialogState createState() => _BeanInfoDialogState();
}

class _BeanInfoDialogState extends State<BeanInfoDialog> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late TextEditingController _processController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.beanInfo.name);
    _originController = TextEditingController(text: widget.beanInfo.origin);
    _processController = TextEditingController(text: widget.beanInfo.process);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Bean Info'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Bean Name'),
            ),
            TextField(
              controller: _originController,
              decoration: const InputDecoration(labelText: 'Origin'),
            ),
            TextField(
              controller: _processController,
              decoration: const InputDecoration(labelText: 'Process'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(BeanInfo(
              id: widget.beanInfo.id,
              name: _nameController.text,
              origin: _originController.text,
              process: _processController.text,
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
