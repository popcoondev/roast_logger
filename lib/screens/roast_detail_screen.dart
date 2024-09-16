import 'package:flutter/material.dart';
import '../dialogs/roast_info_dialog.dart';
import '../models/roast_info.dart';
import '../models/roast_log.dart';
import '../models/cupping_result.dart';
import 'cupping_result_screen.dart'; // カッピング結果の編集画面

class RoastDetailScreen extends StatefulWidget {
  final RoastLog roastLog;

  const RoastDetailScreen({Key? key, required this.roastLog}) : super(key: key);

  @override
  _RoastDetailScreenState createState() => _RoastDetailScreenState();
}

class _RoastDetailScreenState extends State<RoastDetailScreen> {
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
    var results = List<CuppingResult>.from(widget.roastLog.cuppingResults);
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

    debugPrint('New result: $newResult');
    debugPrint('New result type: ${newResult.runtimeType}');
    debugPrint('New result aroma: ${(newResult as CuppingResult).aroma}');
    if (newResult != null && newResult is CuppingResult) {
      setState(() {
        widget.roastLog.cuppingResults.add(newResult);
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
        int index = widget.roastLog.cuppingResults.indexOf(result);
        widget.roastLog.cuppingResults[index] = updatedResult;
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
            // 焙煎情報の表示
            ListTile(
              title: const Text('Bean Name'),
              subtitle: Text(widget.roastLog.beanInfo.name),
            ),
            ListTile(
              title: const Text('Origin'),
              subtitle: Text(widget.roastLog.beanInfo.origin),
            ),
            ListTile(
              title: const Text('Process'),
              subtitle: Text(widget.roastLog.beanInfo.process),
            ),
            ListTile(
              title: const Text('Roast Date'),
              subtitle: Text(widget.roastLog.roastInfo.date),
            ),
            ListTile(
              title: const Text('Roast Level'),
              subtitle: Text(widget.roastLog.roastInfo.roastLevelName),
            ),
            // カッピング結果の表示
            const Divider(),
            ListTile(
              title: const Text('Cupping Results'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addCuppingResult,
              ),
            ),
            _sortedCuppingResults.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _sortedCuppingResults.length,
                    itemBuilder: (context, index) {
                      final result = _sortedCuppingResults[index];
                      return ListTile(
                        title: Text(
                          'Date: ${result.date.toLocal().toString().split(' ')[0]}',
                        ),
                        subtitle: Text('Overall: ${result.overall}'),
                        onTap: () => _editCuppingResult(result),
                      );
                    },
                  )
                : const ListTile(
                    title: Text('No cupping results yet'),
                  ),
          ],
        ),
      ),
    );
  }
}