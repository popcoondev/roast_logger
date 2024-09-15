// widgets/input_temperature.dart

import 'package:flutter/material.dart';

class InputTemperature extends StatefulWidget {
  final void Function(int temperature) inputTemperature;

  const InputTemperature({Key? key, required this.inputTemperature}) : super(key: key);

  @override
  State<InputTemperature> createState() => _InputTemperatureState();
}

class _InputTemperatureState extends State<InputTemperature> {
  int _temperature = 0;
  final _beansTempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beansTempController.text = _temperature.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _beansTempController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Beans Temperature (°C)',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int temp = int.parse(_beansTempController.text);
                  temp++;
                  _beansTempController.text = temp.toString();
                });
              },
              child: const Icon(Icons.arrow_upward),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int temp = int.parse(_beansTempController.text);
                  temp--;
                  _beansTempController.text = temp.toString();
                });
              },
              child: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.inputTemperature(int.parse(_beansTempController.text));
          },
          child: const Text('Add Temperature'),
        ),
      ],
    );
  }
}
