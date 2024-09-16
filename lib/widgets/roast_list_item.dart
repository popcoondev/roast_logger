import 'package:flutter/material.dart';
import '../models/roast_log.dart';

class RoastListItem extends StatelessWidget {
  final RoastLog roastLog;
  final VoidCallback onTap;

  const RoastListItem({Key? key, required this.roastLog, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(roastLog.beanInfo.name),
      subtitle: Text('Roasted on: ${roastLog.roastInfo.date}'),
      trailing: Text(roastLog.roastInfo.roastLevelName),
      onTap: onTap, // ここで onTap を設定
    );
  }
}
