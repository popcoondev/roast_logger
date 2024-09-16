// dialogs/chart_settings_dialog.dart

import 'package:flutter/material.dart';
import '../models/chart_settings.dart';

class ChartSettingsDialog extends StatefulWidget {
  final ChartSettings chartSettings;
  final Function(ChartSettings) onSave;

  const ChartSettingsDialog({Key? key, required this.chartSettings, required this.onSave}) : super(key: key);

  @override
  _ChartSettingsDialogState createState() => _ChartSettingsDialogState();
}

class _ChartSettingsDialogState extends State<ChartSettingsDialog> {
  late TextEditingController _tempYMaxController;
  late TextEditingController _tempYMinController;
  late TextEditingController _rorYMaxController;
  late TextEditingController _rorYMinController;
  late TextEditingController _xMaxController;
  late bool _isCurved;
  late TextEditingController _lineWidthController;

  @override
  void initState() {
    super.initState();
    _tempYMaxController = TextEditingController(text: widget.chartSettings.tempYMax.toString());
    _tempYMinController = TextEditingController(text: widget.chartSettings.tempYMin.toString());
    _rorYMaxController = TextEditingController(text: widget.chartSettings.rorYMax.toString());
    _rorYMinController = TextEditingController(text: widget.chartSettings.rorYMin.toString());
    _isCurved = widget.chartSettings.isCurved;
    _lineWidthController = TextEditingController(text: widget.chartSettings.lineWidth.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chart Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 温度Y軸の最大値
            TextField(
              controller: _tempYMaxController,
              decoration: const InputDecoration(labelText: 'Temperature Y-axis Max (°C)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            // 温度Y軸の最小値
            TextField(
              controller: _tempYMinController,
              decoration: const InputDecoration(labelText: 'Temperature Y-axis Min (°C)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            // ROR Y軸の最大値
            TextField(
              controller: _rorYMaxController,
              decoration: const InputDecoration(labelText: 'ROR Y-axis Max'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            // ROR Y軸の最小値
            TextField(
              controller: _rorYMinController,
              decoration: const InputDecoration(labelText: 'ROR Y-axis Min'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            // 曲線/直線表示の切り替え
            SwitchListTile(
              title: const Text('Curved Lines'),
              value: _isCurved,
              onChanged: (value) {
                setState(() {
                  _isCurved = value;
                });
              },
            ),
            // 折れ線の幅
            TextField(
              controller: _lineWidthController,
              decoration: const InputDecoration(labelText: 'Line Width'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // 設定を保存
            final newSettings = ChartSettings(
              tempYMax: double.tryParse(_tempYMaxController.text) ?? 280,
              tempYMin: double.tryParse(_tempYMinController.text) ?? 0,
              rorYMax: double.tryParse(_rorYMaxController.text) ?? 30,
              rorYMin: double.tryParse(_rorYMinController.text) ?? -30,
              isCurved: _isCurved,
              lineWidth: double.tryParse(_lineWidthController.text) ?? 2,
            );
            widget.onSave(newSettings);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
