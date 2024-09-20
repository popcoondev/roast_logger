import 'package:flutter/material.dart';
import 'package:roast_logger/dialogs/bean_info_dialog.dart';
import '../helper/database_helper.dart';
import '../models/bean_info.dart';
import '../widgets/green_list_item.dart';
import 'green_detail_screen.dart';
import 'roast_logger_screen.dart'; // RoastLogger画面をインポート

class GreenListScreen extends StatefulWidget {
  const GreenListScreen({Key? key}) : super(key: key);

  @override
  State<GreenListScreen> createState() => _GreenListScreenState();
}

class _GreenListScreenState extends State<GreenListScreen> {
  List<BeanInfo> _beanInfos = []; // ローストログのリスト

  // ソートオプション
  String _sortOption = 'Date';

  @override
  void initState() {
    super.initState();
    // Greenのロードまたはサンプルデータの初期化
    _loadBeanInfos();
    
  }

  void _loadBeanInfos() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<BeanInfo> beanList = await dbHelper.getBeans();
    setState(() {
      _beanInfos = beanList;
      _sortBeanInfo();
    });
  }

  void _addBeanInfo(BeanInfo beanInfo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.insertGreenBean(beanInfo);
    _loadBeanInfos();
  }

  void _deleteBeanInfo(BeanInfo beanInfo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteBeanInfo(beanInfo.id);
    _loadBeanInfos();
  }

  void _sortBeanInfo() {
    setState(() {
      if (_sortOption == 'Name') {
        _beanInfos.sort((a, b) => a.name.compareTo(b.name));
      } else if (_sortOption == 'Origin') {
        _beanInfos.sort((a, b) => a.origin.compareTo(b.origin));
      } else if (_sortOption == 'Process') {
        _beanInfos.sort((a, b) => a.process.compareTo(b.process));
      }
    });
  }

  void _onSortOptionSelected(String? value) {
    if (value != null) {
      setState(() {
        _sortOption = value;
        _sortBeanInfo();
      });
    }
  }

  // 新しい生豆データの作成 showDialogでBeanInfoFormを表示
  void addBeanInfo() {
    BeanInfo beanInfo = BeanInfo(name: '', origin: '', process: '');
    showDialog(
      context: context,
      builder: (context) {
        return BeanInfoDialog(beanInfo: beanInfo, 
          onSave: (newBeanInfo) {
            setState(() {
              _beanInfos.add(newBeanInfo);
              _sortBeanInfo();
              _addBeanInfo(newBeanInfo);
            });
          });
      },
    );
  }


  // 生豆データの詳細表示（GreenDetailScreenへの遷移）
  // void _navigateToRoastDetail(RoastLog roastLog) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => RoastDetailScreen(roastLog: roastLog)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Beans'),
        actions: [
          // ソートオプション
          PopupMenuButton<String>(
            onSelected: _onSortOptionSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Name',
                child: Text('Name'),
              ),
              const PopupMenuItem(
                value: 'Origin',
                child: Text('Origin'),
              ),
              const PopupMenuItem(
                value: 'Process',
                child: Text('Process'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _beanInfos.length,
        itemBuilder: (context, index) {
          return GreenListItem(
            beanInfo: _beanInfos[index],
            onTap: () async {
              BeanInfo? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GreenDetailScreen(beanInfo: _beanInfos[index]),
                ),
              );

              _loadBeanInfos();
              },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addBeanInfo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
