import 'package:flutter/material.dart';
import 'package:roast_logger/models/green_bean.dart';
import 'package:roast_logger/utils/dialogs.dart';
import '../dialogs/bean_info_dialog.dart';
import '../helper/database_helper.dart';
import '../widgets/bean_info_widget.dart';
import '../widgets/components_container.dart';
import 'roast_logger_screen.dart';

class GreenDetailScreen extends StatefulWidget {
  GreenBean beanInfo;

  GreenDetailScreen({required this.beanInfo});

  @override
  _GreenDetailScreenState createState() => _GreenDetailScreenState();
}

class _GreenDetailScreenState extends State<GreenDetailScreen> {

  @override
  void initState() {
    super.initState();
  }

  void _updateBeanInfo(GreenBean beanInfo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.updateBeanInfo(beanInfo);
    debugPrint('BeanInfo updated');
    
    dbHelper.printBeans();
  }

  void _editBeanInfo() async {
    final updatedBeanInfo = await showDialog<GreenBean>(
      context: context,
      builder: (context) {
        return BeanInfoDialog(
          beanInfo: widget.beanInfo,
          onSave: (GreenBean newBeanInfo) {
            setState(() {
              widget.beanInfo = newBeanInfo;
              _updateBeanInfo(widget.beanInfo);
            });
          },
        );
      },
    );
  }

  void _deleteBeanInfo() async {
    final bool? isDelete = await showConfirmDialog(context, 'Delete Bean Info', 'Are you sure you want to delete this bean info?', 'Delete', 'Cancel');
    if (isDelete != null && isDelete) {
      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.deleteBeanInfo(widget.beanInfo.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Green Details'),
          actions: [
            TextButton(
              onPressed: () async {
                final newRoastLog = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoastLoggerScreen()),
                );
              },
              child: const Text('Let\'s Roast!'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ComponentsContainer(
                labelTitle: 'Bean Info',
                child: BeanInfoWidget(beanInfo: widget.beanInfo),
                buttonTitle: 'Edit',
                buttonAction: _editBeanInfo,
                buttonTitle2: 'Delete',
                buttonAction2: _deleteBeanInfo,
              ),
            ],
          ),
        ),
      );
  }

}