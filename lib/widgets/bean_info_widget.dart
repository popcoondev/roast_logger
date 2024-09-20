// widgets/bean_info_widget.dart

import 'package:flutter/material.dart';
import '../models/green_bean.dart';

class BeanInfoWidget extends StatelessWidget {
  final GreenBean beanInfo;

  const BeanInfoWidget({Key? key, required this.beanInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${beanInfo.name}'),
        Text('Origin: ${beanInfo.origin}'),
        Text('Process: ${beanInfo.process}'),
        Text('Variety: ${beanInfo.variety}'),
        Text('Farm Name: ${beanInfo.farmName}'),
        Text('Altitude: ${beanInfo.altitude}'),
        Text('Description: ${beanInfo.description}'),
        Text('Notes: ${beanInfo.notes}'),
      ],
    );
  }
}
