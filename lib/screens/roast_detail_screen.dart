import 'package:flutter/material.dart';
import 'package:roast_logger/screens/roast_logger_screen.dart';
import 'package:roast_logger/utils/dialogs.dart';
import '../data/flavor_wheel_data.dart';
import '../dialogs/roast_info_dialog.dart';
import '../helper/database_helper.dart';
import '../models/roast_bean.dart';
import '../models/roast_log.dart';
import '../models/cupping_result.dart';
import '../widgets/components_container.dart';
import '../widgets/roast_info_widget.dart';
import 'cupping_result_screen.dart'; // カッピング結果の編集画面

class RoastDetailScreen extends StatefulWidget {
  RoastBean roastBean;

  RoastDetailScreen({required this.roastBean});

  @override
  _RoastDetailScreenState createState() => _RoastDetailScreenState();
}

class _RoastDetailScreenState extends State<RoastDetailScreen> {
  List<CuppingResult> cuppingResults = [];

  @override
  void initState() {
    super.initState();
    // TODO: cupping_resultsテーブルからroast_idに一致するカッピング結果を取得
  }

  // 焙煎情報を編集
  void _updateRoastBeanInfo(RoastBean roastBean) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.updateRoastBeanInfo(roastBean);
    debugPrint('RoastBean updated');
    
    dbHelper.printRoastBeans();    
  }

  // RoastInfoDialogを表示して、編集した情報を保存
  void _editRoastInfo() async {
    final updatedRoastBean = await showDialog(
      context: context,
      builder: (context) {
        return RoastInfoDialog(roastInfo: widget.roastBean, onSave: (roastBean ) { 
          setState(() {
            widget.roastBean = roastBean;
            _updateRoastBeanInfo(widget.roastBean);
          });
         },);
      },
    );
  }

  void _deleteRoastInfo() async {
    // 確認ダイアログを表示
    bool? delete = await showConfirmDialog(context, 'Delete', 'Are you sure you want to delete this roast log?', 'Delete', 'Cancel');

  }

  // カッピング結果を日付順に取得
  List<CuppingResult> get _sortedCuppingResults {
    var results = List<CuppingResult>.from(cuppingResults as Iterable);
    results.sort((a, b) => b.date.compareTo(a.date));
    return results;
  }

  // 新しいカッピング結果を追加
  void _addCuppingResult() async {
    debugPrint('Adding new cupping result'); 
    CuppingResult newResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CuppingResultScreen(),
      ),      
    );

    if (newResult != null && newResult is CuppingResult) {
      setState(() {
        cuppingResults.add(newResult);
        //TODO: cupping_resultsテーブルに新しいカッピング結果を追加
      });
    }
  }

  // カッピング結果を編集
  void _editCuppingResult(CuppingResult result) async {
    final updatedResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CuppingResultScreen(cuppingResult: result),
      ),
    );

    if (updatedResult != null && updatedResult is CuppingResult) {
      setState(() {
        int index = cuppingResults.indexOf(result);
        cuppingResults[index] = updatedResult;
        //TODO: cupping_resultsテーブルのカッピング結果を更新
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roast Details'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // RoastInfo
            ComponentsContainer(
              labelTitle: 'Roast Info',
              buttonTitle: 'Edit',
              buttonAction: _editRoastInfo,
              buttonTitle2: 'Delete',
              buttonAction2: _deleteRoastInfo,
              child: RoastInfoWidget(roastInfo: widget.roastBean),              
            ),
            //TODO: roast_logsテーブルからroast_idに一致するカッピング結果を取得
            // ListTile(
            //   title: const Text('Roast Log'),
            //   onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => RoastLoggerScreen(roastLog: widget.roastLog, isEdit: true),
            //     ),
            //   ),
            // ),
            ListTile(
              title: const Text('Cupping Results'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addCuppingResult,
              ),
            ),
            
            // カッピング結果のリスト
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cuppingResults.length,
              itemBuilder: (context, index) {
                final result = cuppingResults[index];
                return ListTile(
                  title: 
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date: ${result.date.toLocal().toString().split(' ')[0]}'),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            bool? delete = await showConfirmDialog(context, 'Delete', 'Are you sure you want to delete this cupping result?', 'Delete', 'Cancel');
                            if (delete == true) {
                              setState(() {
                                cuppingResults.remove(result);
                                //TODO: cupping_resultsテーブルからカッピング結果を削除
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  subtitle: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Overall: ${result.overall}'),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: result.flavors.map((flavorName) {
                          // フレーバーノードを検索して色を取得
                          FlavorNode? flavorNode = findFlavorNodeByName(flavorWheelData, flavorName);
                          return Chip(
                            label: Text(flavorName),
                            backgroundColor: flavorNode?.color ?? Colors.grey[200],
                            // 背景色と対比するテキスト色を設定
                            labelStyle: TextStyle(
                              color: ThemeData.estimateBrightnessForColor(flavorNode?.color ?? Colors.grey[200]!) == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  onTap: () => _editCuppingResult(result),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  FlavorNode? findFlavorNodeByName(List<FlavorNode> nodes, String name) {
  for (var node in nodes) {
    if (node.name == name) {
      return node;
    } else if (node.children.isNotEmpty) {
      var childResult = findFlavorNodeByName(node.children, name);
      if (childResult != null) {
        return childResult;
      }
    }
  }
  return null;
}
}