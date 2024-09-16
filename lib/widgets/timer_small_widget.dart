// widgets/timer_small_widget.dart

import 'package:flutter/material.dart';

class TimerSmallWidget extends StatelessWidget {
  final int currentTime;
  final int timerState; // 0: stop, 1: start
  final void Function() startTimer;
  final void Function() stopTimer;

  const TimerSmallWidget({
    Key? key,
    required this.currentTime,
    required this.timerState,
    required this.startTimer,
    required this.stopTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.brown[700], // 背景色を変更して目立たせる
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // タイマー表示
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // ボタン
          Row(
            children: [
              IconButton(
                onPressed: timerState == 0 ? startTimer : null,
                icon: Icon(Icons.play_arrow, color: Colors.white),
              ),
              IconButton(
                onPressed: timerState == 1 ? stopTimer : null,
                icon: Icon(Icons.stop, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
