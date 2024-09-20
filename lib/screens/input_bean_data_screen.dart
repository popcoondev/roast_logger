
import 'package:flutter/material.dart';
import 'package:roast_logger/dialogs/bean_info_dialog.dart';
import 'package:roast_logger/models/green_bean.dart';
import 'package:roast_logger/models/roast_bean.dart';
import 'package:roast_logger/widgets/bean_info_widget.dart';

import '../dialogs/roast_info_dialog.dart';

class InputBeanDataScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Green'),
              Tab(text: 'Roast'),
              Tab(text: 'Drink'),
            ],
          ),
          title: Text('Coffee Management'),
        ),
        body: TabBarView(
          children: [
            Tab(
              child: BeanInfoDialog(beanInfo: GreenBean(name: ''), onSave: (GreenBean newBeanInfo) {}),
            ),
            Tab(
              child: RoastInfoDialog(roastInfo: RoastBean(date: ''), onSave: (RoastBean newRoastInfo) {}),
            ),
            Tab(
              child: Text('Drink Management'),
            ),
          ],
        ),
      ),
    );
  }
}
