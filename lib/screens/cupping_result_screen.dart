// screens/cupping_result_screen.dart

import 'package:flutter/material.dart';
import '../models/cupping_result.dart';

class CuppingResultScreen extends StatefulWidget {
  final CuppingResult? cuppingResult;

  const CuppingResultScreen({super.key, this.cuppingResult});

  @override
  _CuppingResultScreenState createState() => _CuppingResultScreenState();
}

class _CuppingResultScreenState extends State<CuppingResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late double _aroma;
  late double _flavor;
  late double _aftertaste;
  late double _acidity;
  late double _body;
  late double _balance;
  late double _overall;
  late DateTime _date;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final cuppingResult = widget.cuppingResult;
    _date = cuppingResult?.date ?? DateTime.now();
    _aroma = cuppingResult?.aroma ?? 0.0;
    _flavor = cuppingResult?.flavor ?? 0.0;
    _aftertaste = cuppingResult?.aftertaste ?? 0.0;
    _acidity = cuppingResult?.acidity ?? 0.0;
    _body = cuppingResult?.body ?? 0.0;
    _balance = cuppingResult?.balance ?? 0.0;
    _overall = cuppingResult?.overall ?? 0.0;
    _notesController = TextEditingController(text: cuppingResult?.notes);
  }

    // 日付ピッカーの追加
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  void _saveCuppingResult() {
    if (_formKey.currentState!.validate()) {
      final newCuppingResult = CuppingResult(
        date: _date,
        aroma: _aroma,
        flavor: _flavor,
        aftertaste: _aftertaste,
        acidity: _acidity,
        body: _body,
        balance: _balance,
        overall: _overall,
        notes: _notesController.text,
      );
      Navigator.pop(context, newCuppingResult);
    }
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          value: value,
          min: 0.0,
          max: 10.0,
          divisions: 20,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cupping Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveCuppingResult,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 日付ピッカーの追加
              ListTile(
                title: const Text('Date'),
                subtitle: Text(_date.toLocal().toString().split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ),
              _buildSlider('Aroma', _aroma, (value) {
                setState(() {
                  _aroma = value;
                });
              }),
              _buildSlider('Flavor', _flavor, (value) {
                setState(() {
                  _flavor = value;
                });
              }),
              _buildSlider('Aftertaste', _aftertaste, (value) {
                setState(() {
                  _aftertaste = value;
                });
              }),
              _buildSlider('Acidity', _acidity, (value) {
                setState(() {
                  _acidity = value;
                });
              }),
              _buildSlider('Body', _body, (value) {
                setState(() {
                  _body = value;
                });
              }),
              _buildSlider('Balance', _balance, (value) {
                setState(() {
                  _balance = value;
                });
              }),
              _buildSlider('Overall', _overall, (value) {
                setState(() {
                  _overall = value;
                });
              }),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
