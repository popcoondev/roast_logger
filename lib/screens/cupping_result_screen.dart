// screens/cupping_result_screen.dart

import 'package:flutter/material.dart';
import '../models/cupping_result.dart';
import '../widgets/flavor_wheel.dart';

class CuppingResultScreen extends StatefulWidget {
  final CuppingResult? cuppingResult;

  const CuppingResultScreen({super.key, this.cuppingResult});

  @override
  _CuppingResultScreenState createState() => _CuppingResultScreenState();
}

class _CuppingResultScreenState extends State<CuppingResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late double _flavor;
  late double _aftertaste;
  late double _acidity;
  late double _sweetness;
  late double _cleancup;
  late double _mousefeel;
  late double _balance;
  late double _overall;
  late double _score;
  late DateTime _date;
  late TextEditingController _notesController;
  List<String> _selectedFlavors = [];

  @override
  void initState() {
    super.initState();
    final cuppingResult = widget.cuppingResult;
    _date = cuppingResult?.date ?? DateTime.now();
    _flavor = cuppingResult?.flavor ?? 6.0;
    _aftertaste = cuppingResult?.aftertaste ?? 6.0;
    _acidity = cuppingResult?.acidity ?? 6.0;
    _sweetness = cuppingResult?.sweetness ?? 6.0;
    _cleancup = cuppingResult?.cleancup ?? 6.0;
    _mousefeel = cuppingResult?.mousefeel ?? 6.0;
    _balance = cuppingResult?.balance ?? 6.0;
    _overall = cuppingResult?.overall ?? 6.0;
    _score = cuppingResult?.score ?? 0.0;
    _notesController = TextEditingController(text: cuppingResult?.notes);
    _selectedFlavors = cuppingResult?.flavors ?? [];

    _calcScore();
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
        flavor: _flavor,
        aftertaste: _aftertaste,
        acidity: _acidity,
        sweetness: _sweetness,
        cleancup: _cleancup,
        mousefeel: _mousefeel,
        balance: _balance,
        overall: _overall,
        score: _score,
        notes: _notesController.text,
        flavors: _selectedFlavors,
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
        title: const Text('Cupping Form'),
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
              _buildSlider('Clean Cup', _cleancup, (value) {
                setState(() {
                  _cleancup = value;
                  _calcScore();                  
                });
              }),
              _buildSlider('Sweetness', _sweetness, (value) {
                setState(() {
                  _sweetness = value;
                  _calcScore();
                });
              }),
              _buildSlider('Flavor', _flavor, (value) {
                setState(() {
                  _flavor = value;
                  _calcScore();
                });
              }),
              _buildSlider('Acidity', _acidity, (value) {
                setState(() {
                  _acidity = value;
                  _calcScore();
                });
              }),
              _buildSlider('Mousefeel', _mousefeel, (value) {
                setState(() {
                  _mousefeel = value;
                  _calcScore();
                });
              }),
              _buildSlider('Aftertaste', _aftertaste, (value) {
                setState(() {
                  _aftertaste = value;
                  _calcScore();
                });
              }),
              _buildSlider('Balance', _balance, (value) {
                setState(() {
                  _balance = value;
                  _calcScore();
                });
              }),
              _buildSlider('Overall', _overall, (value) {
                setState(() {
                  _overall = value;
                  _calcScore();
                });
              }),
              Text('Score: ${_score.toStringAsFixed(1)}'),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Flavor Wheel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FlavorWheel(
                onSelectionChanged: (selectedFlavors) {
                  setState(() {
                    _selectedFlavors = selectedFlavors;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcScore() {
    double total = _flavor + _aftertaste + _acidity + _sweetness + _cleancup + _mousefeel + _balance + _overall;
    _score = total * (100 / 80);
  }
}
