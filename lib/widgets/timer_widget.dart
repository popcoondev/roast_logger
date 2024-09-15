// widgets/timer_widget.dart

import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int currentTime;
  final int timerState; // 0: stop, 1: start
  final void Function() startTimer;
  final void Function() stopTimer;

  const TimerWidget({
    Key? key,
    required this.currentTime,
    required this.timerState,
    required this.startTimer,
    required this.stopTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(currentTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: timerState == 0 ? startTimer : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
            ElevatedButton.icon(
              onPressed: timerState == 1 ? stopTimer : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
