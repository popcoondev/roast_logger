// dialogs/roast_info_dialog.dart

import 'package:flutter/material.dart';
import '../models/roast_info.dart';

class RoastInfoDialog extends StatefulWidget {
  final RoastInfo roastInfo;
  final Function(RoastInfo) onSave;

  const RoastInfoDialog({Key? key, required this.roastInfo, required this.onSave}) : super(key: key);

  @override
  _RoastInfoDialogState createState() => _RoastInfoDialogState();
}

class _RoastInfoDialogState extends State<RoastInfoDialog> {
  late TextEditingController _roasterController;
  late TextEditingController _preRoastWeightController;
  late TextEditingController _postRoastWeightController;
  late TextEditingController _roastTimeController;
  late TextEditingController _roastLevelController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedRoastLevelName = 'ライトロースト';

  final List<String> _roastLevelNames = [
    'ライトロースト',
    'シナモンロースト',
    'ミディアムロースト',
    'ハイロースト',
    'シティロースト',
    'フルシティロースト',
    'フレンチロースト',
    'イタリアンロースト',
  ];

  @override
  void initState() {
    super.initState();
    _roasterController = TextEditingController(text: widget.roastInfo.roaster);
    _preRoastWeightController = TextEditingController(text: widget.roastInfo.preRoastWeight);
    _postRoastWeightController = TextEditingController(text: widget.roastInfo.postRoastWeight);
    _roastTimeController = TextEditingController(text: widget.roastInfo.roastTime);
    _roastLevelController = TextEditingController(text: widget.roastInfo.roastLevel.toString());

    // Parse the initial date and time
    try {
      _selectedDate = DateTime.parse(widget.roastInfo.date);
    } catch (e) {
      _selectedDate = DateTime.now();
    }
    try {
      final timeParts = widget.roastInfo.time.split(':');
      if (timeParts.length == 2) {
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      _selectedTime = TimeOfDay.now();
    }

    _selectedRoastLevelName = widget.roastInfo.roastLevelName;

    // Check if the initial roastLevelName is in the list; if not, set a default
    if (!_roastLevelNames.contains(_selectedRoastLevelName)) {
      _selectedRoastLevelName = _roastLevelNames.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Roast Info'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Picker
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date'),
              controller: TextEditingController(text: _selectedDate.toLocal().toString().split(' ')[0]),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            // Time Picker
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Time'),
              controller: TextEditingController(text: _selectedTime.format(context)),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
            ),
            TextField(
              controller: _roasterController,
              decoration: const InputDecoration(labelText: 'Roaster'),
            ),
            TextField(
              controller: _preRoastWeightController,
              decoration: const InputDecoration(labelText: 'Pre-Roast Weight (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _postRoastWeightController,
              decoration: const InputDecoration(labelText: 'Post-Roast Weight (g)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _roastTimeController,
              decoration: const InputDecoration(labelText: 'Roast Time (min)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _roastLevelController,
              decoration: const InputDecoration(labelText: 'Roast Level'),
              keyboardType: TextInputType.number,
            ),
            // Roast Level Name Dropdown
            DropdownButtonFormField<String>(
              value: _selectedRoastLevelName,
              decoration: const InputDecoration(labelText: 'Roast Level Name'),
              items: _roastLevelNames.map((String roastLevel) {
                return DropdownMenuItem<String>(
                  value: roastLevel,
                  child: Text(roastLevel),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoastLevelName = newValue!;
                });
              },
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
            // Format date and time
            String formattedDate = _selectedDate.toLocal().toString().split(' ')[0];
            String formattedTime = _selectedTime.format(context);

            widget.onSave(RoastInfo(
              date: formattedDate,
              time: formattedTime,
              roaster: _roasterController.text,
              preRoastWeight: _preRoastWeightController.text,
              postRoastWeight: _postRoastWeightController.text,
              roastTime: _roastTimeController.text,
              roastLevel: double.tryParse(_roastLevelController.text) ?? 0.0,
              roastLevelName: _selectedRoastLevelName,
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}