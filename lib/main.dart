import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        //背景色
        scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250),
        // テキストのテーマ
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.squadaOne(fontSize: 48, color: const Color.fromARGB(255, 100,100,100)),
          headlineMedium: GoogleFonts.squadaOne(fontSize: 32, color: const Color.fromARGB(255, 100,100,100)),
          headlineSmall: GoogleFonts.squadaOne(fontSize: 16, color: const Color.fromARGB(255, 100,100,100)),
          labelLarge: GoogleFonts.squadaOne(fontSize: 24, color: const Color.fromARGB(255, 100,100,100)),
          labelMedium: GoogleFonts.squadaOne(fontSize: 18, color: const Color.fromARGB(255, 100,100,100)),
          labelSmall: GoogleFonts.squadaOne(fontSize: 12, color: const Color.fromARGB(255, 100,100,100)),
          bodyLarge: GoogleFonts.notoSansJavanese(fontSize: 24, color: const Color.fromARGB(255, 100,100,100)),
          bodyMedium: GoogleFonts.notoSansJavanese(fontSize: 18, color: const Color.fromARGB(255, 100,100,100)),
          bodySmall: GoogleFonts.notoSansJavanese(fontSize: 12, color: const Color.fromARGB(255, 100,100,100)),
        ),
        // ElevatedButtonのテーマ
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // 背景色
            foregroundColor: Colors.white, // テキスト色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // 角丸
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            textStyle: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        // TextButtonのテーマ
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // テキスト色
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            textStyle: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        // OutlinedButtonのテーマ
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black, // テキスト色
            side: BorderSide(color: Colors.black), // 枠線の色
            padding: EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: Theme.of(context).textTheme.labelSmall,
          ),
        ),
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
  int _currentTime = 0; // current time
  int _beansTemp = 0; // beans temperature
  int _envTemp = 0; // environment temperature
  int _interval = 10; // data summary interval
  int _inputTempMode = 0; // 0: manual, 1: auto
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
        title: Row(
          //左端にタイトル、右端にメニューと設定ボタンを配置
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Roast Logger',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Row(
              children: [
              TextButton(onPressed: (){}, child: Text('MENU')),
              TextButton(onPressed: (){}, child: Text('SETTINGS')),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: 
        SingleChildScrollView(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                        // beans info & roast info
            ComponentsContainer( 
              labalTitle: 'Beans Info',
              buttonTitle: 'Edit',
              buttonAction: () {
                // edit beans info
              },
              child: 
              Column(
                children: [
                  Text('Beans Info', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Name: ${_roastLog!.beanInfo.name}'),
                  Text('Origin: ${_roastLog!.beanInfo.origin}'),
                  Text('Process: ${_roastLog!.beanInfo.process}'),
                  Text('Roast Info', style: Theme.of(context).textTheme.headlineMedium),
                  Text('Date: ${_roastLog!.roastInfo.date}'),
                  Text('Time: ${_roastLog!.roastInfo.time}'),
                  Text('Roaster: ${_roastLog!.roastInfo.roaster}'),
                  Text('Pre-Roast Weight: ${_roastLog!.roastInfo.preRoastWeight}g'),
                  Text('Post-Roast Weight: ${_roastLog!.roastInfo.postRoastWeight}g'),
                  Text('Roast Time: ${_roastLog!.roastInfo.roastTime}min'),
                  Text('Roast Level: ${_roastLog!.roastInfo.roastLevelName}'),
                ],
              ),
            ),
            ComponentsContainer( 
              labalTitle: 'Timer',
              buttonTitle: 'Data Reset',
              // buttonAction: _timer == null ? _resetTimer : null,
              buttonAction: _timer == null ? () async {
                bool? ret = await _showConfirmDialog(context, 'Reset Data', 'Are you sure you want to reset the data?', 'Reset', 'Cancel');
                debugPrint('_showConfirmDialog: $ret');
                if (ret == true) {
                  debugPrint('_resetTimer');
                  _resetTimer();
                }
              } : null,
              child: 
                // timer display
                  TimerWidget(
                    currentTime: _currentTime,
                    timerState: _timer == null ? 0 : 1,
                    startTimer: _startTimer,
                    stopTimer: _stopTimer,
                    toggleTimer: _toggleTimer,
                    resetTimer: _resetTimer,
                  ),
            ),
            ComponentsContainer( 
              labalTitle: 'Input Temperature',
              buttonTitle: 'Change Mode',
              buttonAction: _timer == null ? () async {
                bool? ret = await _showConfirmDialog(context, 'Change Input Mode', 'Are you sure you want to change the input mode?\nCurrent mode: ${_inputTempMode == 0 ? 'Manual' : 'Auto'}', 'Change', 'Cancel');
                debugPrint('_showConfirmDialog: $ret');
                if (ret == true) {
                  setState(() {
                    _inputTempMode = _inputTempMode == 0 ? 1 : 0;
                    
                  });
                }
              } : null,
              child: _inputTempMode == 0 ?
              InputTemperature(
                inputTemperature: _inputTemperature,
              ) :
              WebSocketConroller(
                inputTemperature: _inputTemperature,
                updateTempDisplay: _updateTemperture,
              ),
            ),
            ComponentsContainer( 
              labalTitle: 'Input Phases',
              child: 
                // input events
              InputEvents(
                addEvent: _addEvent,
              ),
            ),
            ComponentsContainer( 
              labalTitle: 'Data Summary',
              buttonTitle: '${_interval} sec',
              buttonAction: () async {
                String? ret = await _showSelectDialog(context, 'Select Interval', 'Select the interval for data summary', ['0 sec', '10 sec', '30 sec', '60 sec', '120 sec']);
                debugPrint('_showSelectDialog: $ret');
                if (ret == null) return;
                if (ret == '0 sec')  _interval = 0;
                else if (ret == '10 sec') _interval = 10;
                else if (ret == '30 sec') _interval = 30;
                else if (ret == '60 sec') _interval = 60;
                else if (ret == '120 sec') _interval = 120;
                setState(() {
                  _updateAll();
                });

              },
              child:
              // timeline grid
              TimelineGrid(
                logEntries: _roastLog!.logEntries,
              ),
            ),
            // line chart
            Container(
              //丸角の枠線をつける
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
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

          ],
        ),
      ),
    )
    );
  }

  Function editDialogSample(BuildContext context) {
    return () async {
      // change input mode
      TextEditingController textCtl = TextEditingController(text: '1st crack');
      Widget child = TextField(
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          hintText: 'edit text test',
        ),
        style: Theme.of(context).textTheme.bodyLarge,
        controller: textCtl,
        onSubmitted: (value) {
          FocusScope.of(context).unfocus(); // 「完了」ボタンを押したときにキーボードを閉じる
        },
      );
      bool? ret = await _showEditDialog(context, 'Change Input Mode', 'Are you sure you want to change the input mode?', 'SAVE', 'CANCEL', child);
      debugPrint('_showEditDialog: $ret');
      if (ret == true) {
        //textCtl.textに入力されたテキストが取得できる
        debugPrint('text: ${textCtl.text}');                  
        
      }
    };

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

  void _inputTemperature(int temperature, {bool auto = false}) {
    debugPrint('input temperature: $temperature');
    double ror = calcROR(temperature);
    // rorを少数第一位までに丸める
    ror = (ror * 10).round() / 10;

    // interval check
    // データサマリー間隔内であれば、上書きする
    // そうでなければ、新規追加する
    // intervalが10の場合、前回のtimeが9であれば0として扱う
    // intervalが10の場合、前回のtimeが10であれば10として扱う
    int lastTime = _roastLog!.logEntries.isNotEmpty ? _roastLog!.logEntries.last.time : -1;
    int intervalTime = _currentTime - (_currentTime % _interval);

    debugPrint('_interval: $_interval, lastTime: $lastTime, intervalTime: $intervalTime, currentTime: $_currentTime');

    if (lastTime == intervalTime) {
      // auto modeの場合、interval毎に最初の値を採用するため、更新はしない
      if (auto) {
        return;
      }

      // update temp
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1].temperature = temperature;
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1].ror = ror;
    } else {
      // input temp
      _addLogEntry(LogEntry(
        time: intervalTime,
        temperature: temperature,
        ror: ror,
        event: Event.none,
      ));
    }

    //仮計算
    // current timeが9の場合、intervalが10の場合、
    // logEntriesの最後の値が time=0, temperature=100 だとする
    // この場合、_currentTime=9, _interval=10, lastTime=0, intervalTime=0
    // この場合、lastTime == intervalTime が成立するので、
    // logEntriesの最後の値を更新する
    
    // current timeが10の場合、intervalが10の場合、
    // logEntriesの最後の値が time=0, temperature=100 だとする
    // この場合、_currentTime=10, _interval=10, lastTime=0, intervalTime=10
    // この場合、lastTime == intervalTime が成立しないので、
    // 新しい値を追加する

    // current timeが11の場合、intervalが10の場合、
    // logEntriesの最後の値が time=0, temperature=100 だとする
    // この場合、_currentTime=11, _interval=10, lastTime=0, intervalTime=10
    // この場合、lastTime == intervalTime が成立しないので、 
    // 新しい値を追加する

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

// このアプリ用のカスタムボタン
// elevationbuttonを継承して、カスタムボタンを作成

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double paddingHorizontal;
  final double paddingVertical;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue, // デフォルトの背景色
    this.textColor = Colors.white,      // デフォルトのテキスト色
    this.borderRadius = 8.0,            // デフォルトの角丸サイズ
    this.paddingHorizontal = 16.0,      // デフォルトの左右のパディング
    this.paddingVertical = 12.0,        // デフォルトの上下のパディング
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // 背景色
        textStyle: TextStyle(color: textColor), // テキスト色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // 角丸の形状
        ),
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, // 横方向のパディング
          vertical: paddingVertical,     // 縦方向のパディング
        ),
      ),
      child: Text(text),
    );
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
        Row(
          //　等間隔で配置
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
              onPressed: () {
                addEvent(Event.none);
              },
              child: Text(Event.none),
            ),
            OutlinedButton(
              onPressed: () {
                addEvent(Event.maillard);
              },
              child: Text(Event.maillard),
            ),
            OutlinedButton(
              onPressed: () {
                addEvent(Event.firstCrack);
              },
              child: Text(Event.firstCrack),
            ),
            OutlinedButton(
              onPressed: () {
                addEvent(Event.secondCrack);
              },
              child: Text(Event.secondCrack),
            ),
            OutlinedButton(
              onPressed: () {
                addEvent(Event.drop);
              },
              child: Text(Event.drop),
            ),
          ],
        ),
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
    return Container(
      width: double.infinity,
      child: 
            Column(
              //　中央に配置
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [            
                TimeLabel(currentTime: currentTime),
                Row(
                  //　両端に配置
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: timerState == 0 ? startTimer : null,
                      child: const Text('START'),
                    ),
                    TextButton(
                      onPressed: timerState == 1 ? stopTimer : null,
                      child: const Text('STOP'),
                    ),
                  ],
                ),
              ],
        ),
    );
  }
}

//コンポーネントコンテナ
//機能ごとにコンポーネントをまとめる枠組み
class ComponentsContainer extends StatelessWidget {
  final Widget child;
  final String labalTitle;
  final String buttonTitle;
  final void Function()? buttonAction;
  const ComponentsContainer({Key? key, required this.child, this.labalTitle = '', this.buttonTitle = '', this.buttonAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //左にタイトルラベルと右にコンポーネント用のボタンを配置するRow
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //タイトルラベル
            Text(labalTitle, style: Theme.of(context).textTheme.labelMedium),
            //コンポーネント用のボタン
            TextButton(
              onPressed: buttonAction,
              child: Text(buttonTitle),
            ),
          ],
        ),
        //メインコンテンツ
        Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          alignment: Alignment.center,
          child: child,
        ),
        //下部に区切り線を表示
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          //80%の幅に区切り線を表示
          width: MediaQuery.of(context).size.width * 0.92,
          height: 1,
          color: Colors.grey,

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

    double height = 160;
    double fontSize = 120;
    // 大きめのフォントで、時間を表示
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(            
            height: height,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${minutes.toString().padLeft(2, '0')}',
              style: GoogleFonts.squadaOne(fontSize: fontSize, height: 0.8),
              
            ),
          ),
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: Text(
              ':',
              style: GoogleFonts.squadaOne(fontSize: fontSize, height: 0.8),
            ),
          ),
          Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: Text(
              '${seconds.toString().padLeft(2, '0')}',
              style: GoogleFonts.squadaOne(fontSize: fontSize, height: 0.8),
            ),
          ),
      ],)
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
    return SizedBox(
      width: double.infinity,
      height: 100,

      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(children: [
            SizedBox(
              width: 100,
              child:
                TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    
                    decoration: InputDecoration(
                      // helperText: 'Beans Temp',
                      // suffixText: '°C',
                      // ボーダーなし、背景色を指定
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],

                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    controller: _beansTempController,
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus(); // 「完了」ボタンを押したときにキーボードを閉じる
                    },
                ),
              ),
            Text("°C", style: Theme.of(context).textTheme.bodySmall),
            //温度を＋１するボタン
            TextButton(
              //ボタンの高さを指定
              onPressed: () {
                // 豆温度を+1
                _beansTempController.text = (int.parse(_beansTempController.text) + 1).toString();
              },
              child: Text('UP'),
            ), 
            // 温度を-1するボタン
            TextButton(
              onPressed: () {
                // 豆温度を-1
                _beansTempController.text = (int.parse(_beansTempController.text) - 1).toString();
              },
              child: Text('DOWN'),
            ),
          ],
          ),
            // 温度追加のボタン
            ElevatedButton(
              onPressed: () {
                // 豆温度を追加
                widget.inputTemperature(int.parse(_beansTempController.text));
              },
              child: Text('ADD'),
            ),
          ],
      ),
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
      // decoration: BoxDecoration(
      //   //背景色を指定
      //   color: Colors.grey[300],
      //   borderRadius: BorderRadius.circular(4.0),
      // ),
      decoration: BoxDecoration(
        //右側に線を引く
        border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.5))),
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
          getPhaseLabel(entry.event),
        ],
      )
    ); 
  }

  Widget getPhaseLabel(String? event) {
    Color color = Colors.black;
    if (event == null) return Container();
    
    switch (event) {
      case Event.maillard:
        color = Colors.green;
        break; 
      case Event.firstCrack:
        color = Colors.orange;
        break;
      case Event.secondCrack:
        color = Colors.red;
        break;
      case Event.drop:
        color = Colors.blue;
        break;
      default :
        color = Colors.black;
        return Container(
              height: 20,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4.0),
              child: Text('-', style: TextStyle(color: Colors.black, fontSize: 10), textAlign: TextAlign.center),
            );
    }

    return Container(
              height: 20,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(event, style: TextStyle(color: color, fontSize: 10), textAlign: TextAlign.center),
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
              minY: 0,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                style: Theme.of(context).textTheme.headlineMedium,
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
    );
  }
}

class WebSocketConroller extends StatefulWidget {
  final void Function(int temperature, {bool auto}) inputTemperature;
  final void Function(int beansTemp, int envTemp) updateTempDisplay;

  
  WebSocketConroller({Key? key, required this.inputTemperature, required this.updateTempDisplay}) : super(key: key);

  @override
  State<WebSocketConroller> createState() => _WebSocketConrollerState();
}

class _WebSocketConrollerState extends State<WebSocketConroller> {
  WebSocketChannel? _channel;
  String _receiveData = 'disconnected';
  String _url = 'ws://192.168.11.51:81';

  @override
  void initState() {
    super.initState();
    _channel = null;
  }

  Future<void> startConnection(String url) async {
    // connect to websocket
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
    updateReceiveData('connecting...');
    await _channel!.ready;
    // listen to websocket
    try {
      _channel!.stream.listen((event) {
        Map<String, dynamic> temps = jsonDecode(event);
        widget.updateTempDisplay(temps['BT'].toInt(), temps['ET'].toInt());
        widget.inputTemperature(temps['BT'].toInt(), auto: true);
      }, onError: (e) {
        _channel = null;
        updateReceiveData('error');
      }, onDone: () {
        _channel = null;
        updateReceiveData('disconnected');
      }, cancelOnError: true
      
      );
    } catch (e) {
      updateReceiveData('connection error');
      debugPrint('WebSocketChannelException: $e');
    }

    updateReceiveData('connected');

  }

  void stopConnection() {
    // disconnect from websocket
    _channel?.sink.close();
    _channel = null;
    updateReceiveData('disconnected');
  }

  void updateReceiveData(String data) {
    setState(() {
      _receiveData = data;
      debugPrint('receiveData: $_receiveData');
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController urlController = TextEditingController(text: _url);

    return Column( children: [
      Row(
        children: [
          // 接続先を編集するTextField
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ws://',
              ),
              controller: urlController,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus(); // 「完了」ボタンを押したときにキーボードを閉じる
              },
            ),
          ),
          // Connect/Disconnectボタン
          
            ElevatedButton(
              onPressed: () {
                // connect to websocket
                String url = urlController.text;
                debugPrint('start url: $url');
                startConnection(url);
              },
              child: const Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () {
                // disconnect from websocket
                stopConnection();
              },
              child: const Text('Disconnect'),
            ),
        ],
      ),
    // 接続状態を表示するText
    Text(_receiveData),
    ],
    );
  }
}

// ダイアログを表示するメソッド
// ダイアログのタイトルとメッセージを表示し、OKボタンを押すとtrue、キャンセルボタンを押すとfalseを返す
// 呼び出し側はonPressedをasyncで呼び、awaitで結果を受け取る
Future<bool?> _showConfirmDialog(BuildContext context, String title, String message, String okText, String cancelText) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        //　外枠のRoundedRectangleBorderを設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okText),
          ),
        ],
      );
    },
  );
}

//_showSelectDialog
// ダイアログを表示するメソッド
// ダイアログのタイトルとメッセージを表示し、選択肢をリストで表示する
// 選択肢の中から選択したものを返す
// 呼び出し側はonPressedをasyncで呼び、awaitで結果を受け取る
Future<String?> _showSelectDialog(BuildContext context, String title, String message, List<String> choices) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        //　外枠のRoundedRectangleBorderを設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          for (var choice in choices)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(choice);
              },
              child: Text(choice),
            ),
        ],
      );
    },
  );
}

Future<bool?> _showEditDialog(BuildContext context, String title, String message, String okText, String cancelText, Widget child) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: 
        Column(
          children: [
            Text(message),
            child,
          ],
        ),
        //　外枠のRoundedRectangleBorderを設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okText),
          ),
        ],
      );
    },
  );
}