// widgets/input_events.dart

import 'package:flutter/material.dart';
import '../utils/events.dart';

class InputEvents extends StatelessWidget {
  final void Function(String event) addEvent;

  const InputEvents({Key? key, required this.addEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        OutlinedButton(
          onPressed: () => addEvent(Event.none),
          child: const Text('-'),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.maillard),
          child: const Text(Event.maillard),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.firstCrack),
          child: const Text(Event.firstCrack),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.secondCrack),
          child: const Text(Event.secondCrack),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.drop),
          child: const Text(Event.drop),
        ),
      ],
    );
  }
}
