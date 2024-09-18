import 'package:flutter/material.dart';
import 'package:roast_logger/screens/roast_logger_screen.dart';
import 'package:roast_logger/utils/dialogs.dart';
import '../data/flavor_wheel_data.dart';
import '../dialogs/roast_info_dialog.dart';
import '../models/roast_info.dart';
import '../models/roast_log.dart';
import '../models/cupping_result.dart';
import '../widgets/components_container.dart';
import '../widgets/roast_info_widget.dart';
import 'cupping_result_screen.dart'; // カッピング結果の編集画面

class RoastDetailScreen extends StatefulWidget {
  RoastLog roastLog;

  RoastDetailScreen({required this.roastLog});

  @override
  _RoastDetailScreenState createState() => _RoastDetailScreenState();
}

class _RoastDetailScreenState extends State<RoastDetailScreen> {

  @override
  void initState() {
    super.initState();
    // ログのカッピング結果がnullの場合、空のリストを作成
    widget.roastLog.cuppingResults ??= [];
  }

  // 焙煎情報を編集
  // RoastInfoDialogを表示して、編集した情報を保存
  void _editRoastInfo() async {
    final updatedRoastInfo = await showDialog(
      context: context,
      builder: (context) {
        return RoastInfoDialog(roastInfo: widget.roastLog.roastInfo, onSave: (RoastInfo ) { 
          Navigator.pop(context, RoastInfo);
         },);
      },
    );

    if (updatedRoastInfo != null && updatedRoastInfo is RoastInfo) {
      setState(() {
        widget.roastLog.roastInfo = updatedRoastInfo;
      });
    }

  }


  // カッピング結果を日付順に取得
  List<CuppingResult> get _sortedCuppingResults {
    var results = List<CuppingResult>.from(widget.roastLog.cuppingResults as Iterable);
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
        widget.roastLog.cuppingResults!.add(newResult);
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
        int index = widget.roastLog.cuppingResults!.indexOf(result);
        widget.roastLog.cuppingResults![index] = updatedResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuppingResult = widget.roastLog.cuppingResults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roast Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editRoastInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // RoastInfo
            ComponentsContainer(
              labelTitle: 'Roast Info',
              buttonTitle: 'Roast Log',
              // roast_logger_screenでroastlogを表示
              buttonAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoastLoggerScreen(roastLog: widget.roastLog, isEdit: true),
                ),
              ),
              child: RoastInfoWidget(roastInfo: widget.roastLog.roastInfo),              
            ),

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
              itemCount: cuppingResult!.length,
              itemBuilder: (context, index) {
                final result = cuppingResult[index];
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
                                widget.roastLog.cuppingResults!.remove(result);
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
            // _sortedCuppingResults.isNotEmpty
            //     ? ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: _sortedCuppingResults.length,
            //         itemBuilder: (context, index) {
            //           final result = _sortedCuppingResults[index];
            //           return ListTile(
            //             title: Text(
            //               'Date: ${result.date.toLocal().toString().split(' ')[0]}',
            //             ),
            //             subtitle: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text('Overall: ${result.overall}'),
            //                 Wrap(
            //                   spacing: 4.0,
            //                   runSpacing: 4.0,
            //                   children: result.flavors.map((flavorName) {
            //                     // フレーバーノードを検索して色を取得
            //                     FlavorNode? flavorNode = findFlavorNodeByName(flavorWheelData, flavorName);
            //                     return Chip(
            //                       label: Text(flavorName),
            //                       backgroundColor: flavorNode?.color ?? Colors.grey[200],
            //                     );
            //                   }).toList(),
            //                 ),
            //               ],
            //             ),
            //             onTap: () => _editCuppingResult(result),
            //           );
            //         },
            //       )
            //     : const ListTile(
            //         title: Text('No cupping results yet'),
            //       ),
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