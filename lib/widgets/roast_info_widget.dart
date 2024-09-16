// widgets/roast_info_widget.dart

import 'package:flutter/material.dart';
import '../models/roast_info.dart';

class RoastInfoWidget extends StatelessWidget {
  final RoastInfo roastInfo;

  const RoastInfoWidget({Key? key, required this.roastInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date: ${roastInfo.date}'),
        Text('Time: ${roastInfo.time}'),
        Text('Roaster: ${roastInfo.roaster}'),
        Text('Pre-Roast Weight: ${roastInfo.preRoastWeight}g'),
        Text('Post-Roast Weight: ${roastInfo.postRoastWeight}g'),
        Text('Roast Time: ${roastInfo.roastTime}'),
        Text('Roast Level: ${roastInfo.roastLevelName}'),
      ],
    );
  }
}
