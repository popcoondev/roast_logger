import 'package:flutter/material.dart';
import '../dialogs/roast_info_dialog.dart';
import '../helper/database_helper.dart';
import '../models/cupping_result.dart';
import '../models/roast_log.dart';
import '../models/green_bean.dart';
import '../models/roast_bean.dart';
import '../widgets/roast_list_item.dart';
import 'roast_detail_screen.dart';
import 'roast_logger_screen.dart'; // RoastLogger画面をインポート

class RoastListScreen extends StatefulWidget {
  const RoastListScreen({Key? key}) : super(key: key);

  @override
  State<RoastListScreen> createState() => _RoastListScreenState();
}

class _RoastListScreenState extends State<RoastListScreen> {
  List<RoastBean> _roastInfos = []; // ロースト情報のリスト

  // ソートオプション
  String _sortOption = 'Date';

  @override
  void initState() {
    super.initState();
    // ローストログのロードまたはサンプルデータの初期化
    _loadRoastBeanInfos();
  }
  
  void _loadRoastBeanInfos() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<RoastBean> roastList = await dbHelper.getRoastBeans();
    setState(() {
      _roastInfos = roastList;
      _sortRoastBeanInfo();
    });
  }

    void _addRoastBeanInfo(RoastBean roastInfo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.insertRoastBean(roastInfo);
    _loadRoastBeanInfos();
  }

  void _deleteRoastBeanInfo(RoastBean roastInfo) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.deleteRoastBeanInfo(roastInfo.id);
    _loadRoastBeanInfos();
  }



  void _sortRoastBeanInfo() {
    setState(() {
      if (_sortOption == 'Date') {
        _roastInfos.sort((a, b) => b.date.compareTo(a.date));
      } else if (_sortOption == 'Roast Level') {
        _roastInfos.sort((a, b) => a.roastLevelName.compareTo(b.roastLevelName));
      }
    });
  }

  void _onSortOptionSelected(String? value) {
    if (value != null) {
      setState(() {
        _sortOption = value;
        _sortRoastBeanInfo();
      });
    }
  }

  // 新しい焙煎データの作成（RoastLogger画面への遷移）
  void addRoastBeanInfo() {
    RoastBean roastInfo = RoastBean();
    showDialog(
      context: context,
      builder: (context) {
        return RoastInfoDialog(roastInfo: roastInfo, 
          onSave: (newRoastInfo) {
            setState(() {
              _roastInfos.add(newRoastInfo);
              _sortRoastBeanInfo();
              _addRoastBeanInfo(newRoastInfo);
            });
          });
      },
    );
  }

  // 焙煎データの詳細表示（RoastDetailScreenへの遷移）
  void _navigateToRoastDetail(RoastBean roastBean) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoastDetailScreen(roastBean: roastBean)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roast Beans'),
        actions: [
          // ソートオプション
          PopupMenuButton<String>(
            onSelected: _onSortOptionSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Date', child: Text('Date')),
              const PopupMenuItem(value: 'Roast Level', child: Text('Roast Level')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _roastInfos.length,
        itemBuilder: (context, index) {
          return RoastListItem(
            roastBean: _roastInfos[index],
            onTap: () => _navigateToRoastDetail(_roastInfos[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addRoastBeanInfo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
