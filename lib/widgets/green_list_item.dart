import 'package:flutter/material.dart';
import 'package:roast_logger/models/bean_info.dart';

class GreenListItem extends StatelessWidget {
  final BeanInfo beanInfo;
  final VoidCallback onTap;

  const GreenListItem({Key? key, required this.beanInfo, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(beanInfo.name),
      subtitle: Text('${beanInfo.origin}'),
      trailing: Text('${beanInfo.process}'),
      onTap: onTap, // ここで onTap を設定
    );
  }
}
