// widgets/temp_display.dart

import 'package:flutter/material.dart';

class TempDisplay extends StatelessWidget {
  final int beansTemp;
  final int envTemp;

  const TempDisplay({Key? key, required this.beansTemp, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle tempStyle = Theme.of(context).textTheme.headlineSmall!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('BT: ${beansTemp.toStringAsFixed(1)}°C', style: tempStyle),
        Text('ET: ${envTemp.toStringAsFixed(1)}°C', style: tempStyle),
      ],
    );
  }
}
