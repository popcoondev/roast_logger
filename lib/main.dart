import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'model.dart';
import 'package:fl_chart/fl_chart.dart';

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
            TimerWidget(
              currentTime: _currentTime,
              startTimer: _startTimer,
              stopTimer: _stopTimer,
              toggleTimer: _toggleTimer,
              resetTimer: _resetTimer,
            ),
            // imput ui
            InputTemperature(
              inputTemperature: _inputTemperature,
            ),
            // timeline grid
            TimelineGrid(
              logEntries: _roastLog!.logEntries,
            ),
            // line chart
            ChartDisplay(
              logEntries: _roastLog!.logEntries,
            ), 
            // temp display
            TempDisplay(
              beansTemp: _beansTemp,
              envTemp: _envTemp,
            ),
            WebSocketConroller(
              inputTemperature: _inputTemperature,
            ),
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

  void _inputTemperature(int temperature) {
    debugPrint('input temperature: $temperature');
    double ror = calcROR(temperature);
    // rorを少数第一位までに丸める
    ror = (ror * 10).round() / 10;

    // input temp
    _addLogEntry(LogEntry(
      time: _currentTime,
      temperature: temperature,
      ror: ror,
    ));
  }

  double calcROR(int temperature) {
    // LogEntryの直近の前回値の温度からRORを計算する
    // 60秒換算での温度変化を計算する
    if (_roastLog!.logEntries.length < 2) {
      return 0;
    }

    int lastTemperature = _roastLog!.logEntries[_roastLog!.logEntries.length - 2].temperature;
    int lastTime = _roastLog!.logEntries[_roastLog!.logEntries.length - 2].time;

    int diffTime = _currentTime - lastTime;
    int diffTemp = temperature - lastTemperature;

    if (diffTime == 0) {
      // 時間差が0の場合、変化率が計算できないので0を返す
      return 0;
    }

    // diffTempやdiffTimeをdoubleに変換して計算
    return (diffTemp / diffTime) * 60;
  }


  void _addLogEntry(LogEntry logEntry) {
    // add log entry
    _roastLog!.logEntries.add(logEntry);  
    setState(() {
      _updateAll();
    });
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
    setState(() {
      _currentTime = 0;
      _roastLog?.logEntries.clear();
      _updateAll();
    });
    
  }
}

class TimerWidget extends StatelessWidget {
  final int currentTime;
  final void Function() startTimer;
  final void Function() stopTimer;
  final void Function() toggleTimer;
  final void Function() resetTimer;
  const TimerWidget({Key? key, required this.currentTime, required this.startTimer, required this.stopTimer, required this.toggleTimer, required this.resetTimer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeLabel(currentTime: currentTime),
        ButtonRow(
          onPressed: () {
            toggleTimer();
          },
          label: 'Start/Stop',
        ),
        ButtonRow(
          onPressed: () {
            resetTimer();
          },
          label: 'Reset',
        ),
      ],
    );
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

class InputTemperature extends StatefulWidget {
  final void Function(int temperature) inputTemperature;

  InputTemperature({Key? key, required this.inputTemperature}) : super(key: key);

  @override
  State<InputTemperature> createState() => _InputTemperatureState();
}

class _InputTemperatureState extends State<InputTemperature> {
  int _temperature = 0;
  // 豆温度の入力エリアのコントローラー
  final _beansTempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 豆温度の入力エリアの初期値
    _beansTempController.text = _temperature.toString();
  }

  @override
  Widget build(BuildContext context) {
    // 豆温度の入力エリア
    return Column(
        children: [
          // 豆温度の入力エリア
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Beans Temp',
            ),
            controller: _beansTempController,
          ),
          Row(
            children:[
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
            ],
          ),
          // 温度追加のボタン
          ElevatedButton(
            onPressed: () {
              // 豆温度を追加
              widget.inputTemperature(int.parse(_beansTempController.text));
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
          // グリッドとして横一列に追加していく。
          // 一つのグリッドは、時間、豆温度、ROR、イベントを表示する。
          TimelineGridItem(entry: entry),
          // Text('Time: ${entry.time}, Beans Temp: ${entry.temperature}, ROR: ${entry.ror}\n'),
      ],
    );
  }
}

class TimelineGridItem extends StatelessWidget {
  final LogEntry entry;
  const TimelineGridItem({Key? key, required this.entry}) : super(key: key);

  // グリッドは横スクロールするので、Columnで表示する。
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child:
        Column(
        children: [
          Text('Time: ${entry.time}'),
          Text('Beans Temp: ${entry.temperature}'),
          Text('ROR: ${entry.ror}'),
          Text('Event: ${entry.event}'),
        ],
      )
    ); 
  }
}

class ChartDisplay extends StatelessWidget {
  final List<LogEntry> logEntries;
  const ChartDisplay({Key? key, required this.logEntries}) : super(key: key);


  String _formatTime(int time) {
    // 時間を分と秒に変換する
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:$seconds';
  }

  // fl_chartを使ってliner chartを表示する
  // logEntriesから、時間,豆温度,RORを取得して、それを2軸グラフに表示する。
  @override
  Widget build(BuildContext context) {
    // logEntriesが空の場合、空のコンテナを表示する
    if (logEntries.isEmpty) {
      return Container(
        child: Center(
          child: Text('No Data Available'),
        ),
      );
    }

    // グラフデータを作成する前に、値がNaNやInfinityでないことを確認する
    List<FlSpot> temperatureSpots = logEntries
        .where((entry) => entry.temperature != null && !entry.temperature.isNaN && !entry.temperature.isInfinite)
        .map((entry) => FlSpot(entry.time.toDouble(), entry.temperature.toDouble()))
        .toList();

    List<FlSpot> rorSpots = logEntries
        .where((entry) => entry.ror != null && !entry.ror!.isNaN && !entry.ror!.isInfinite)
        .map((entry) => FlSpot(entry.time.toDouble(), entry.ror!.toDouble()))
        .toList();

    return Container(
        height: 300, // 明示的な高さを指定
          child: LineChart(
            LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(_formatTime(value.toInt())),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            lineBarsData: [
              // 温度データのライン
              LineChartBarData(
                spots: temperatureSpots,
                isCurved: true,
                color: Colors.blue,
              ),
              // RORデータのライン
              LineChartBarData(
                spots: rorSpots,
                isCurved: true,
                color: Colors.red,
              ),
            ],
          ),
        ),
      
    );
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
  final void Function(int temperature) inputTemperature;
  WebSocketConroller({Key? key, required this.inputTemperature}) : super(key: key);

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
        Map<String, dynamic> temps = jsonDecode(event);
        receiveData = temps['BT'].toString();
        
        // { "BT": 26.75, "ET": 28.38 }形式
        // debugPrint("__" + receiveData);
        
        inputTemperature(temps['BT'].toInt());
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