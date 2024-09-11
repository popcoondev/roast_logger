import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _currentTime = 0;
  int _beansTemp = 0;
  int _envTemp = 0;
  Timer? _timer;
  RoastLog? _roastLog;

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

    //テスト用データを追加
    //30秒ごとに温度を追加、10分間
    for (int i = 0; i < 600; i += 30) {
      //100度から220度までだんだん上がっていくデータにする
      int t = 100 + (i * 120) ~/ 600;
      _addLogEntry(LogEntry(
        time: i,
        temperature: i == 30 ? 100 : t,
        ror: calcROR(t),
        event: Event.none,
      ));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roast Logger'),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          // timer display
            TimerWidget(
              currentTime: _currentTime,
              timerState: _timer == null ? 0 : 1,
              startTimer: _startTimer,
              stopTimer: _stopTimer,
              toggleTimer: _toggleTimer,
              resetTimer: _resetTimer,
            ),
            // imput ui
            InputTemperature(
              inputTemperature: _inputTemperature,
            ),
            InputEvents(
              addEvent: _addEvent,
            ),
            // timeline grid
            TimelineGrid(
              logEntries: _roastLog!.logEntries,
            ),
            // line chart
            Container(
              //丸角の枠線をつける
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.all(8.0),
              // margin: const EdgeInsets.all(8.0),
              child: 
                Column(
                  children: [
                    // temp display
                    TempDisplay(
                      beansTemp: _beansTemp,
                      envTemp: _envTemp,
                    ),
                    ChartDisplay(
                      logEntries: _roastLog!.logEntries,
                    ), 
                  ],
                ),
            ),
            Row(
              children: [
                WebSocketConroller(
                  inputTemperature: _inputTemperature,
                  updateTemperture: _updateTemperture,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    // stop timer
    super.dispose();
  }

  void _addEvent(String event) {
    //　直近のLogEntryにeventを追加する
    debugPrint('add event: $event');
    if (_roastLog!.logEntries.isNotEmpty) {
      setState(() {
        _roastLog!.logEntries[_roastLog!.logEntries.length - 1].event = event;
        _updateAll();
      });
    }
    else {
      debugPrint('logEntries is empty');
    }
  }

  void _updateTemperture(int beansTemp, int envTemp) {
    // update temperture
    setState(() {
      _beansTemp = beansTemp;
      _envTemp = envTemp;
    });
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
      event: Event.none,
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
    // return (diffTemp / diffTime) * 60;
    return ((diffTemp / diffTime) * 60 * 10).round() / 10;
  }


  void _addLogEntry(LogEntry logEntry) {
    // もし前回値と同じ時刻の場合は、更新する
    if (_roastLog!.logEntries.isNotEmpty && _roastLog!.logEntries.last.time == logEntry.time) {
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1] = logEntry;
    } else {
      // それ以外の場合は、新規追加
      _roastLog!.logEntries.add(logEntry);
    }
    setState(() {
      _updateAll();
    });
  }

  void _updateAll() {
    // 更新用に設けているメソッドだが、現状は何もしない
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
    setState(() {
      _updateAll();
    });
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

class InputEvents extends StatelessWidget {
  final void Function(String event) addEvent;
  const InputEvents({Key? key, required this.addEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // イベントボタンを配置
        // none, maillard, first crack, second crack, drop
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                addEvent(Event.none);
              },
              child: Text(Event.none),
            ),
            ElevatedButton(
              onPressed: () {
                addEvent(Event.maillard);
              },
              child: Text(Event.maillard),
            ),
            ElevatedButton(
              onPressed: () {
                addEvent(Event.firstCrack);
              },
              child: Text(Event.firstCrack),
            ),
            ElevatedButton(
              onPressed: () {
                addEvent(Event.secondCrack);
              },
              child: Text(Event.secondCrack),
            ),
            ElevatedButton(
              onPressed: () {
                addEvent(Event.drop);
              },
              child: Text(Event.drop),
            ),
          ],
        ),
      ],
    );
  }
}

class Event {
  static const String none = '-';
  static const String maillard = 'Maillard';
  static const String firstCrack = '1st';
  static const String secondCrack = '2nd';
  static const String drop = 'Drop';
}

class TimerWidget extends StatelessWidget {
  final int currentTime;
  final int timerState; // 0: stop, 1: start
  final void Function() startTimer;
  final void Function() stopTimer;
  final void Function() toggleTimer;
  final void Function() resetTimer;
  const TimerWidget({Key? key, required this.currentTime, required this.timerState, required this.startTimer, required this.stopTimer, required this.toggleTimer, required this.resetTimer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [            
            TimeLabel(currentTime: currentTime),
            ElevatedButton(
              onPressed: () {
                toggleTimer();
              },
              child: Text(timerState == 0 ? 'Start' : 'Stop'),
            ),
          ],
        ),
        ElevatedButton(
          //timerStateが1の場合は非活性
          onPressed: timerState == 1 ? null : () {
            resetTimer();
          },
          // timeStateが1の場合は灰色、それ以外は赤色
          style: ElevatedButton.styleFrom(
            backgroundColor: timerState == 1 ? Colors.grey : Colors.red,
          ),
          child: const Text('Reset'),
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
    // return Text('Time: $currentTime');
    // '00:00'形式に変換
    int minutes = currentTime ~/ 60;
    int seconds = currentTime % 60;
    // return Text('${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
    // 大きめのフォントで、時間を表示
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      // margin: const EdgeInsets.all(8.0),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey),
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      child: Text(
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: GoogleFonts.roboto(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              SizedBox(
                width: 100,
                child:
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Beans Temp',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    controller: _beansTempController,
                  ),
              ),
              ToggleButtons(
                borderColor: Colors.grey,
                borderWidth: 2,
                borderRadius: BorderRadius.circular(5.0),
                selectedBorderColor: Colors.red,
                onPressed: (index){
                  if(index == 0){
                    // 豆温度を上げる
                    _beansTempController.text = (int.parse(_beansTempController.text) + 1).toString();  
                  }else{
                    // 豆温度を下げる
                    _beansTempController.text = (int.parse(_beansTempController.text) - 1).toString();
                  }
                },
                isSelected: [false,false],
                children: [
                  Padding(padding: EdgeInsets.all(4.0), child: Text('▲')),
                  Padding(padding: EdgeInsets.all(4.0), child: Text('▼')),
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
          ),
        ],
    );
  }
  
}

class TimelineGrid extends StatelessWidget {
  final List<LogEntry> logEntries;
  TimelineGrid({Key? key, required this.logEntries}) : super(key: key);
  // グリッド表示間隔のデフォルト値


  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [
        
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var entry in logEntries)
                  TimelineGridItem(entry: entry),
              ],
            ),
          ),
        
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child:
        Column(
        children: [
          // Text('Time: ${entry.time}'),
          // Text('Beans Temp: ${entry.temperature}'),
          // Text('ROR: ${entry.ror}'),
          // Text('Event: ${entry.event}'),
          Text('${entry.time ~/ 60}:${(entry.time % 60).toString().padLeft(2, '0')}'),
          Text('${entry.temperature}'),
          Text('${entry.ror}'),
          Text('${entry.event}'),
        ],
      )
    ); 
  }
}

class ChartDisplay extends StatelessWidget {
  final List<LogEntry> logEntries;
  List<FlSpot>? temperatureSpots;
  List<FlSpot>? rorSpots;
  ChartDisplay({Key? key, required this.logEntries}) : super(key: key);

  void init() {
    // ログエントリーからグラフ用のデータを作成
    temperatureSpots = logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.temperature.toDouble());
    }).toList();

    rorSpots = logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.ror!.toDouble());
    }).toList();
  }

  // 時間を分と秒に変換するメソッド
  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Column(
      children: [
        // 温度グラフ
        Container(
          height: 200, // 明示的な高さを指定
          padding: const EdgeInsets.only(top: 20, right: 40, bottom: 0, left: 40),
          child: LineChart(
            
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: false,
                horizontalInterval: 20,
                verticalInterval: 60,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 120, // 2分（120秒）ごとにラベリング
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(_formatTime(value.toInt())),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 40, // 温度データ用のスケール調整
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text('${value.toInt()}'),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              minX: 0,
              maxX: temperatureSpots!.last.x,
              minY: 80,
              maxY: 280, // 温度グラフの最大値
              lineBarsData: [
                LineChartBarData(
                  spots: temperatureSpots == null ? [] : temperatureSpots!,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                ),
              ],
              clipData: FlClipData.all(),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 200,
                    color: Colors.red.withOpacity(0.5),
                    strokeWidth: 2,
                    // dashArray: [5, 5], // ダッシュラインで右軸最大値を視覚化
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // RORグラフ
        Container(
          height: 100, // 明示的な高さを指定
          padding: const EdgeInsets.only(top: 0, right: 40, bottom: 20, left: 40),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: false,
                horizontalInterval: 5,
                verticalInterval: 60,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 20,
                    interval: 120, // 2分（120秒）ごとにラベリング
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(_formatTime(value.toInt())),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 15, // RORデータ用のスケール調整
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text('${value.toInt()}'),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              minX: 0,
              maxX: rorSpots!.last.x,
              minY: -30,
              maxY: 30, // RORグラフの最大値
              lineBarsData: [
                LineChartBarData(
                  spots: rorSpots == null ? [] : rorSpots!,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.red.withOpacity(0.2),
                  ),
                ),
              ],
              clipData: FlClipData.all(),
            ),
          ),
        ),
      ],
    );
  }
}


class TempDisplay extends StatelessWidget {
  int beansTemp;
  int envTemp;
  TempDisplay({Key? key, required this.beansTemp, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Text('Beans Temp: $beansTemp, Env Temp: $envTemp');
    // 大きめのフォントで、豆温度と環境温度を表示
    // 豆温度が200度を超えたら赤色にする
    // 'BT: 200.0℃'という枠、'ET: 30.0℃'という枠を表示
    return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
              child: Text( //00.0℃の形式に変更
                'BT: ${beansTemp.toStringAsFixed(1)}℃',
                style: TextStyle(
                  fontSize: 24,
                  color: beansTemp > 200 ? Colors.red : Colors.black,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
              child: Text(
                'ET: ${envTemp.toStringAsFixed(1)}℃',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ],
    );
  }
}

class WebSocketConroller extends StatelessWidget {
  final void Function(int temperature) inputTemperature;
  final void Function(int beansTemp, int envTemp) updateTemperture;
  WebSocketConroller({Key? key, required this.inputTemperature, required this.updateTemperture}) : super(key: key);

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
        
        updateTemperture(temps['BT'].toInt(), temps['ET'].toInt());
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
    return Row(
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
      ],
    );
  }
}