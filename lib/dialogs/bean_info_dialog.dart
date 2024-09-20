// dialogs/bean_info_dialog.dart

import 'package:flutter/material.dart';
import '../models/green_bean.dart';

class BeanInfoDialog extends StatefulWidget {
  final GreenBean beanInfo;
  final Function(GreenBean) onSave;

  const BeanInfoDialog({Key? key, required this.beanInfo, required this.onSave}) : super(key: key);

  @override
  _BeanInfoDialogState createState() => _BeanInfoDialogState();
}

class _BeanInfoDialogState extends State<BeanInfoDialog> {
  late TextEditingController _nameController;
  late TextEditingController _originController;
  late TextEditingController _processController;
  late TextEditingController _varietyController;
  late TextEditingController _farmNameController;
  late TextEditingController _altitudeController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.beanInfo.name);
    _originController = TextEditingController(text: widget.beanInfo.origin);
    _processController = TextEditingController(text: widget.beanInfo.process);
    _varietyController = TextEditingController(text: widget.beanInfo.variety);
    _farmNameController = TextEditingController(text: widget.beanInfo.farmName);
    _altitudeController = TextEditingController(text: widget.beanInfo.altitude);
    _descriptionController = TextEditingController(text: widget.beanInfo.description);
    _notesController = TextEditingController(text: widget.beanInfo.notes);

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
            TextField(
              controller: _varietyController,
              decoration: const InputDecoration(labelText: 'Variety'),
            ),
            TextField(
              controller: _farmNameController,
              decoration: const InputDecoration(labelText: 'Farm Name'),
            ),
            TextField(
              controller: _altitudeController,
              decoration: const InputDecoration(labelText: 'Altitude'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),            
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
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
            widget.onSave(GreenBean(
              id: widget.beanInfo.id,
              createdAt: widget.beanInfo.createdAt,
              updatedAt: DateTime.now(),
              name: _nameController.text,
              origin: _originController.text,
              process: _processController.text,
              variety: _varietyController.text,
              farmName: _farmNameController.text,
              altitude: _altitudeController.text,
              description: _descriptionController.text,
              notes: _notesController.text,
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
