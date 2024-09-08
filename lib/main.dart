import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roast Logger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RoastLogger(),
    );
  }
}

class RoastLogger extends StatefulWidget {
  const RoastLogger({Key? key}) : super(key: key);
  @override
  State<RoastLogger> createState() => _RoastLoggerState();
}

class _RoastLoggerState extends State<RoastLogger> {
  int _counter = 0;
  int _currentTime = 0;
  int _beansTemp = 0;
  int _envTemp = 0;
  Timer? _timer;
  RoastLog? _roastLog;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    // initialize roast log
    _roastLog = RoastLog(
      logEntries: [],
      currentTime: 0,
      beanInfo: BeanInfo(
        name: 'Arabica',
        origin: 'Ethiopia',
        process: 'Washed',
      ),
      roastInfo: RoastInfo(
        date: '2021-10-01',
        time: '12:00',
        roaster: 'Gene Cafe',
        preRoastWeight: '100',
        postRoastWeight: '90',
        roastTime: '10',
        roastLevel: 10.0,
        roastLevelName: 'Light',
      ),
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roast Logger'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          // timer display
            TimeLabel(key: null, currentTime: _currentTime),
            // start/stop button
            ButtonRow(
              onPressed: () {
                // start/stop timer
                _toggleTimer();
              },
              label: 'Start/Stop',
            ),
            // imput ui
            InputTemp(
              currentTime: _currentTime,
              logEntries: _roastLog!.logEntries,
            ),
            // timeline grid
            TimelineGrid(
              logEntries: _roastLog!.logEntries,
            ),
            // line chart
            LineChart(
              currentTime: _currentTime,
              beansTemp: _beansTemp,
              envTemp: _envTemp,
            ), 
            // temp display
            TempDisplay(
              beansTemp: _beansTemp,
              envTemp: _envTemp,
            ),
            WebSocketConroller(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  @override
  void dispose() {
    // stop timer
    super.dispose();
  }

  void _updateTime() {
    // update time
  }

  void _updateTemp() {
    // update temp
  }

  void _updateTimeline() {
    // update timeline
  }

  void _updateChart() {
    // update chart
  }

  void _updateTempDisplay() {
    // update temp display
  }

  void _updateAll() {
    _updateTime();
    _updateTemp();
    _updateTimeline();
    _updateChart();
    _updateTempDisplay();
  }

  void _startTimer() {
    // start timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime++;
        _updateAll();
      });
    });
  }

  void _stopTimer() {
    // stop timer
    _timer?.cancel();
    _timer = null;
  }

  void _toggleTimer() {
    // toggle timer
    if (_timer == null) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _resetTimer() {
    // reset timer
    if (_timer != null) {
      _stopTimer();
    }
    _currentTime = 0;
  }
}

class TimeLabel extends StatelessWidget {
  final int currentTime;
  const TimeLabel({Key? key, required this.currentTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Time: $currentTime');
  }
}

class ButtonRow extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  const ButtonRow({Key? key, required this.onPressed, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class InputTemp extends StatelessWidget {
  // 豆温度の入力エリア、温度を上げ下げするボタン、温度追加のボタン
  final int currentTime;
  final List<LogEntry> logEntries;
  InputTemp({Key? key, required this.currentTime, required this.logEntries}) : super(key: key);

  // 豆温度の入力エリアのコントローラー
  final TextEditingController _beansTempController = TextEditingController(text: '100');

  @override
  Widget build(BuildContext context) {
    // 豆温度の入力エリア
    return Column(
        children: [
          // 豆温度の入力エリア
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Beans Temp',
            ),
            controller: _beansTempController,
          ),
          // 温度を上げ下げするボタン
          ElevatedButton(
            onPressed: () {
              // 豆温度を上げる
              _beansTempController.text = (int.parse(_beansTempController.text) + 1).toString();

            },
            child: Text('Up'),
          ),
          ElevatedButton(
            onPressed: () {
              // 豆温度を下げる
              _beansTempController.text = (int.parse(_beansTempController.text) - 1).toString();
            },
            child: Text('Down'),
          ),
          // 温度追加のボタン
          ElevatedButton(
            onPressed: () {
              // 豆温度を追加
              logEntries.add(LogEntry(
                time: currentTime,
                temperature: double.parse(_beansTempController.text),
                ror: // 豆温度の変化率を、一つ前のLogEntriesの豆温度との差分で計算
                    //時間を60秒の割合で計算
                  logEntries.isEmpty ? 0 : (int.parse(_beansTempController.text) - logEntries.last.temperature) / (currentTime - logEntries.last.time) * 60,


              ));
            },
            child: Text('Add'),
          ),
          
        ],
    );
  }
  
}

class TimelineGrid extends StatelessWidget {
  final List<LogEntry> logEntries;
  const TimelineGrid({Key? key, required this.logEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var entry in logEntries)
          Text('Time: ${entry.time}, Beans Temp: ${entry.temperature}, ROR: ${entry.ror}\n'),
      ],
    );
  }
}

class LineChart extends StatelessWidget {
  final int currentTime;
  final int beansTemp;
  final int envTemp;
  const LineChart({Key? key, required this.currentTime, required this.beansTemp, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Line Chart: $currentTime, $beansTemp, $envTemp');
  }
}

class TempDisplay extends StatelessWidget {
  final int beansTemp;
  final int envTemp;
  const TempDisplay({Key? key, required this.beansTemp, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Beans Temp: $beansTemp, Env Temp: $envTemp');
  }
}

class WebSocketConroller extends StatelessWidget {
  WebSocketConroller({Key? key}) : super(key: key);

  WebSocketChannel? _channel;
  String receiveData = '';
  

  @override
  void initState() {
    
  }

  startConnection() {
    // connect to websocket
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.11.51:81'),
    );
    debugPrint('connecting...');
    setState() {
      receiveData = 'connecting...';
    }
    _channel!.stream.listen((event) {
      debugPrint(event);
      // receive data
      setState() {
        receiveData = event;
      }
    });
  }

  stopConnection() {
    // disconnect from websocket
    _channel!.sink.close();
    debugPrint('disconnected');
    setState() {
      receiveData = 'disconnected';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // connect to websocket
            startConnection();
            
          },
          child: Text('Connect'),
        ),
        ElevatedButton(
          onPressed: () {
            // disconnect from websocket
            stopConnection();
          },
          child: Text('Disconnect'),
        ),
        Text('Receive: $receiveData'),
      ],
    );
  }
}