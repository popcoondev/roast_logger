// widgets/bean_info_widget.dart

import 'package:flutter/material.dart';
import '../models/bean_info.dart';

class BeanInfoWidget extends StatelessWidget {
  final BeanInfo beanInfo;

  const BeanInfoWidget({Key? key, required this.beanInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${beanInfo.name}'),
        Text('Origin: ${beanInfo.origin}'),
        Text('Process: ${beanInfo.process}'),
      ],
    );
  }
}
