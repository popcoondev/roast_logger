import 'package:flutter/material.dart';
import 'package:roast_logger/models/green_bean.dart';

class GreenListItem extends StatelessWidget {
  final GreenBean beanInfo;
  final VoidCallback onTap;

  const GreenListItem({Key? key, required this.beanInfo, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(beanInfo.name),
      subtitle: Text('${beanInfo.origin} - ${beanInfo.farmName}'),
      trailing: Text('${beanInfo.process}'),
      onTap: onTap,
    );
  }
}
