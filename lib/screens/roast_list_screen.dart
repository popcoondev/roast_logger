import 'package:flutter/material.dart';
import '../models/cupping_result.dart';
import '../models/roast_log.dart';
import '../models/bean_info.dart';
import '../models/roast_info.dart';
import '../widgets/roast_list_item.dart';
import 'roast_detail_screen.dart';
import 'roast_logger_screen.dart'; // RoastLogger画面をインポート

class RoastListScreen extends StatefulWidget {
  const RoastListScreen({Key? key}) : super(key: key);

  @override
  State<RoastListScreen> createState() => _RoastListScreenState();
}

class _RoastListScreenState extends State<RoastListScreen> {
  List<RoastLog> _roastLogs = []; // ローストログのリスト

  // ソートオプション
  String _sortOption = 'Date';

  @override
  void initState() {
    super.initState();
    // ローストログのロードまたはサンプルデータの初期化
    _loadRoastLogs();
  }

  void _loadRoastLogs() {
    // サンプルデータを使用
    setState(() {
      _roastLogs = [
        // サンプルのローストログ
        RoastLog(
          logEntries: [],
          currentTime: 600,
          beanInfo: BeanInfo(
            name: 'Ethiopia Sidamo',
            origin: 'Ethiopia',
            process: 'Washed',
          ),
          roastInfo: RoastInfo(
            date: '2023-10-01',
            time: '10:00',
            roaster: 'Gene Cafe',
            preRoastWeight: '200',
            postRoastWeight: '170',
            roastTime: '10',
            roastLevel: 10.0,
            roastLevelName: 'Light',
          ),
          cuppingResults: [
            // サンプルのカッピング結果
            CuppingResult(
              date: DateTime(2023, 10, 02),
              cleancup: 8,
              sweetness: 8,
              acidity: 8,
              mousefeel: 8,
              flavor: 8,
              aftertaste: 8,
              balance: 8,
              overall: 8,
              notes: 'Fruity, floral, tea-like',
              flavors: ['Fruity', 'Floral', 'Tea-like'],
            ),
          ],
        ),
        // 他のサンプルデータ
      ];
    });
    _sortRoastLogs(); // ロード後にソート
  }

  void _sortRoastLogs() {
    setState(() {
      if (_sortOption == 'Date') {
        _roastLogs.sort((a, b) => b.roastInfo.date.compareTo(a.roastInfo.date));
      } else if (_sortOption == 'Bean Type') {
        _roastLogs.sort((a, b) => a.beanInfo.name.compareTo(b.beanInfo.name));
      }
    });
  }

  void _onSortOptionSelected(String? value) {
    if (value != null) {
      setState(() {
        _sortOption = value;
        _sortRoastLogs();
      });
    }
  }

  // 新しい焙煎データの作成（RoastLogger画面への遷移）
  void _navigateToRoastLogger() async {
    final newRoastLog = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoastLoggerScreen()),
    );

    if (newRoastLog != null && newRoastLog is RoastLog) {
      setState(() {
        _roastLogs.add(newRoastLog);
        _sortRoastLogs(); // ソートを更新
      });
    }
  }

  // 焙煎データの詳細表示（RoastDetailScreenへの遷移）
  void _navigateToRoastDetail(RoastLog roastLog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoastDetailScreen(roastLog: roastLog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roast Logs'),
        actions: [
          // ソートオプション
          PopupMenuButton<String>(
            onSelected: _onSortOptionSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Date', child: Text('Sort by Date')),
              const PopupMenuItem(value: 'Bean Type', child: Text('Sort by Bean Type')),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _roastLogs.length,
        itemBuilder: (context, index) {
          return RoastListItem(
            roastLog: _roastLogs[index],
            onTap: () => _navigateToRoastDetail(_roastLogs[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRoastLogger,
        child: const Icon(Icons.add),
      ),
    );
  }
}
