import 'package:flutter/material.dart';
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
  void _editCuppingResults() async {
    final updatedCuppingResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CuppingResultScreen(
          cuppingResult: widget.roastLog.cuppingResult,
        ),
      ),
    );

    if (updatedCuppingResult != null && updatedCuppingResult is CuppingResult) {
      setState(() {
        widget.roastLog.cuppingResult = updatedCuppingResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuppingResult = widget.roastLog.cuppingResult;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roast Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editCuppingResults,
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
                icon: const Icon(Icons.edit),
                onPressed: _editCuppingResults,
              ),
            ),
            cuppingResult != null
                ? Column(
                    children: [
                      ListTile(
                        title: const Text('Aroma'),
                        trailing: Text(cuppingResult.aroma.toString()),
                      ),
                      ListTile(
                        title: const Text('Flavor'),
                        trailing: Text(cuppingResult.flavor.toString()),
                      ),
                      ListTile(
                        title: const Text('Aftertaste'),
                        trailing: Text(cuppingResult.aftertaste.toString()),
                      ),
                      ListTile(
                        title: const Text('Acidity'),
                        trailing: Text(cuppingResult.acidity.toString()),
                      ),
                      ListTile(
                        title: const Text('Body'),
                        trailing: Text(cuppingResult.body.toString()),
                      ),
                      ListTile(
                        title: const Text('Balance'),
                        trailing: Text(cuppingResult.balance.toString()),
                      ),
                      ListTile(
                        title: const Text('Overall'),
                        trailing: Text(cuppingResult.overall.toString()),
                      ),
                      ListTile(
                        title: const Text('Notes'),
                        subtitle: Text(cuppingResult.notes),
                      ),
                    ],
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
