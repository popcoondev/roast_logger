import 'package:flutter/material.dart';
import 'package:roast_logger/models/bean_info.dart';
import '../dialogs/bean_info_dialog.dart';
import '../widgets/bean_info_widget.dart';
import '../widgets/components_container.dart';

class GreenDetailScreen extends StatefulWidget {
  BeanInfo beanInfo;

  GreenDetailScreen({required this.beanInfo});

  @override
  _GreenDetailScreenState createState() => _GreenDetailScreenState();
}

class _GreenDetailScreenState extends State<GreenDetailScreen> {
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
  }

  void _editBeanInfo() async {
    final updatedBeanInfo = await showDialog<BeanInfo>(
      context: context,
      builder: (context) {
        return BeanInfoDialog(
          beanInfo: widget.beanInfo,
          onSave: (BeanInfo newBeanInfo) {
            setState(() {
              widget.beanInfo = newBeanInfo;
              _isEdited = true; // 編集フラグを立てる
            });
          },
        );
      },
    );

    if (updatedBeanInfo != null) {
      setState(() {
        widget.beanInfo = updatedBeanInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _isEdited ? widget.beanInfo : null);
        return false; // デフォルトの戻る動作をキャンセル
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Green Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editBeanInfo,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ComponentsContainer(
                labelTitle: 'Bean Info',
                child: BeanInfoWidget(beanInfo: widget.beanInfo),
              ),
            ],
          ),
        ),
      ),
    );
  }

}