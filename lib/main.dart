import 'dart:async';
import 'dart:convert';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black87,
                displayColor: Colors.black87,
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
    // Initialize roast log
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

    // Test data
    for (int i = 0; i < 600; i += 30) {
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
        title: Text(
          'Roast Logger',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('MENU')),
          TextButton(onPressed: () {}, child: const Text('SETTINGS')),
        ],
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Beans info & roast info
              ComponentsContainer(
                labelTitle: 'Beans Info',
                buttonTitle: 'Edit',
                buttonAction: () {
                  // Edit beans info
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Beans Info', style: Theme.of(context).textTheme.titleLarge),
                    Text('Name: ${_roastLog!.beanInfo.name}'),
                    Text('Origin: ${_roastLog!.beanInfo.origin}'),
                    Text('Process: ${_roastLog!.beanInfo.process}'),
                    const SizedBox(height: 16),
                    Text('Roast Info', style: Theme.of(context).textTheme.titleLarge),
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
                labelTitle: 'Timer',
                buttonTitle: 'Data Reset',
                buttonAction: _timer == null
                    ? () async {
                        bool? ret = await _showConfirmDialog(
                            context, 'Reset Data', 'Are you sure you want to reset the data?', 'Reset', 'Cancel');
                        if (ret == true) {
                          _resetTimer();
                        }
                      }
                    : null,
                child: TimerWidget(
                  currentTime: _currentTime,
                  timerState: _timer == null ? 0 : 1,
                  startTimer: _startTimer,
                  stopTimer: _stopTimer,
                ),
              ),
              ComponentsContainer(
                labelTitle: 'Input Temperature',
                buttonTitle: _inputTempMode == 0 ? 'Switch to Auto' : 'Switch to Manual',
                buttonAction: _timer == null
                    ? () async {
                        bool? ret = await _showConfirmDialog(
                            context,
                            'Change Input Mode',
                            'Are you sure you want to change the input mode?\nCurrent mode: ${_inputTempMode == 0 ? 'Manual' : 'Auto'}',
                            'Change',
                            'Cancel');
                        if (ret == true) {
                          setState(() {
                            _inputTempMode = _inputTempMode == 0 ? 1 : 0;
                          });
                        }
                      }
                    : null,
                child: _inputTempMode == 0
                    ? InputTemperature(
                        inputTemperature: _inputTemperature,
                      )
                    : WebSocketController(
                        inputTemperature: _inputTemperature,
                        updateTempDisplay: _updateTemperture,
                      ),
              ),
              ComponentsContainer(
                labelTitle: 'Input Phases',
                child: InputEvents(
                  addEvent: _addEvent,
                ),
              ),
              ComponentsContainer(
                labelTitle: 'Data Summary',
                buttonTitle: '${_interval} sec',
                buttonAction: () async {
                  String? ret = await _showSelectDialog(context, 'Select Interval', 'Select the interval for data summary',
                      ['0 sec', '10 sec', '30 sec', '60 sec', '120 sec']);
                  if (ret == null) return;
                  setState(() {
                    switch (ret) {
                      case '0 sec':
                        _interval = 0;
                        break;
                      case '10 sec':
                        _interval = 10;
                        break;
                      case '30 sec':
                        _interval = 30;
                        break;
                      case '60 sec':
                        _interval = 60;
                        break;
                      case '120 sec':
                        _interval = 120;
                        break;
                    }
                    _updateAll();
                  });
                },
                child: TimelineGrid(
                  logEntries: _roastLog!.logEntries,
                ),
              ),
              // Line chart
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Temp display
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
      ),
    );
  }

  void _addEvent(String event) {
    if (_roastLog!.logEntries.isNotEmpty) {
      setState(() {
        _roastLog!.logEntries[_roastLog!.logEntries.length - 1].event = event;
        _updateAll();
      });
    }
  }

  void _updateTemperture(int beansTemp, int envTemp) {
    setState(() {
      _beansTemp = beansTemp;
      _envTemp = envTemp;
    });
  }

  void _inputTemperature(int temperature, {bool auto = false}) {
    double ror = calcROR(temperature);
    ror = (ror * 10).round() / 10;

    int lastTime = _roastLog!.logEntries.isNotEmpty ? _roastLog!.logEntries.last.time : -1;
    int intervalTime = _currentTime - (_currentTime % _interval);

    if (lastTime == intervalTime) {
      if (auto) {
        return;
      }
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1].temperature = temperature;
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1].ror = ror;
    } else {
      _addLogEntry(LogEntry(
        time: intervalTime,
        temperature: temperature,
        ror: ror,
        event: Event.none,
      ));
    }
  }

  double calcROR(int temperature) {
    if (_roastLog!.logEntries.length < 2) {
      return 0;
    }

    int lastTemperature = _roastLog!.logEntries[_roastLog!.logEntries.length - 2].temperature;
    int lastTime = _roastLog!.logEntries[_roastLog!.logEntries.length - 2].time;

    int diffTime = _currentTime - lastTime;
    int diffTemp = temperature - lastTemperature;

    if (diffTime == 0) {
      return 0;
    }

    return ((diffTemp / diffTime) * 60 * 10).round() / 10;
  }

  void _addLogEntry(LogEntry logEntry) {
    if (_roastLog!.logEntries.isNotEmpty && _roastLog!.logEntries.last.time == logEntry.time) {
      _roastLog!.logEntries[_roastLog!.logEntries.length - 1] = logEntry;
    } else {
      _roastLog!.logEntries.add(logEntry);
    }
    setState(() {
      _updateAll();
    });
  }

  void _updateAll() {
    // Update logic if needed
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime++;
        _updateAll();
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _updateAll();
    });
  }

  void _resetTimer() {
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

// ComponentsContainer
class ComponentsContainer extends StatelessWidget {
  final Widget child;
  final String labelTitle;
  final String buttonTitle;
  final void Function()? buttonAction;
  const ComponentsContainer({
    Key? key,
    required this.child,
    this.labelTitle = '',
    this.buttonTitle = '',
    this.buttonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  labelTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (buttonTitle.isNotEmpty && buttonAction != null)
                  TextButton(
                    onPressed: buttonAction,
                    child: Text(buttonTitle),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Main content
            child,
          ],
        ),
      ),
    );
  }
}

// TimerWidget
class TimerWidget extends StatelessWidget {
  final int currentTime;
  final int timerState; // 0: stop, 1: start
  final void Function() startTimer;
  final void Function() stopTimer;

  const TimerWidget({
    Key? key,
    required this.currentTime,
    required this.timerState,
    required this.startTimer,
    required this.stopTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = _formatTime(currentTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: timerState == 0 ? startTimer : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
            ElevatedButton.icon(
              onPressed: timerState == 1 ? stopTimer : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// InputTemperature
class InputTemperature extends StatefulWidget {
  final void Function(int temperature) inputTemperature;

  const InputTemperature({Key? key, required this.inputTemperature}) : super(key: key);

  @override
  State<InputTemperature> createState() => _InputTemperatureState();
}

class _InputTemperatureState extends State<InputTemperature> {
  int _temperature = 0;
  final _beansTempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _beansTempController.text = _temperature.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _beansTempController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Beans Temperature (°C)',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.inputTemperature(int.parse(_beansTempController.text));
          },
          child: const Text('Add Temperature'),
        ),
      ],
    );
  }
}

// InputEvents
class InputEvents extends StatelessWidget {
  final void Function(String event) addEvent;
  const InputEvents({Key? key, required this.addEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: [
        OutlinedButton(
          onPressed: () => addEvent(Event.none),
          child: const Text(Event.none),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.maillard),
          child: const Text(Event.maillard),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.firstCrack),
          child: const Text(Event.firstCrack),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.secondCrack),
          child: const Text(Event.secondCrack),
        ),
        OutlinedButton(
          onPressed: () => addEvent(Event.drop),
          child: const Text(Event.drop),
        ),
      ],
    );
  }
}

// Event constants
class Event {
  static const String none = 'None';
  static const String maillard = 'Maillard';
  static const String firstCrack = '1st Crack';
  static const String secondCrack = '2nd Crack';
  static const String drop = 'Drop';
}

// TimelineGrid
class TimelineGrid extends StatelessWidget {
  final List<LogEntry> logEntries;
  const TimelineGrid({Key? key, required this.logEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Temp (°C)')),
          DataColumn(label: Text('ROR')),
          DataColumn(label: Text('Event')),
        ],
        rows: logEntries.map((entry) {
          return DataRow(cells: [
            DataCell(Text('${entry.time ~/ 60}:${(entry.time % 60).toString().padLeft(2, '0')}')),
            DataCell(Text('${entry.temperature}')),
            DataCell(Text('${entry.ror}')),
            DataCell(Text(entry.event ?? '-')),
          ]);
        }).toList(),
      ),
    );
  }
}

// TempDisplay
class TempDisplay extends StatelessWidget {
  final int beansTemp;
  final int envTemp;
  const TempDisplay({Key? key, required this.beansTemp, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle tempStyle = Theme.of(context).textTheme.headlineSmall!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('BT: ${beansTemp.toStringAsFixed(1)}°C', style: tempStyle),
        Text('ET: ${envTemp.toStringAsFixed(1)}°C', style: tempStyle),
      ],
    );
  }
}

// ChartDisplay
class ChartDisplay extends StatelessWidget {
  final List<LogEntry> logEntries;
  const ChartDisplay({Key? key, required this.logEntries}) : super(key: key);

  List<FlSpot> _getTemperatureSpots() {
    return logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.temperature.toDouble());
    }).toList();
  }

  List<FlSpot> _getRorSpots() {
    return logEntries.map((entry) {
      return FlSpot(entry.time.toDouble(), entry.ror!.toDouble());
    }).toList();
  }

  String _formatTime(double value) {
    int time = value.toInt();
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (logEntries.isEmpty) {
      return const Text('No data available');
    }

    List<FlSpot> temperatureSpots = _getTemperatureSpots();
    List<FlSpot> rorSpots = _getRorSpots();

    return Column(
      children: [
        // Temperature chart
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 120,
                    getTitlesWidget: (value, meta) {
                      return Text(_formatTime(value));
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 40),
                ),
              ),
              minX: 0,
              maxX: temperatureSpots.last.x,
              minY: 0,
              maxY: 280,
              lineBarsData: [
                LineChartBarData(
                  spots: temperatureSpots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
        // ROR chart
        SizedBox(
          height: 100,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 15),
                ),
              ),
              minX: 0,
              maxX: rorSpots.last.x,
              minY: -30,
              maxY: 30,
              lineBarsData: [
                LineChartBarData(
                  spots: rorSpots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// WebSocketController
class WebSocketController extends StatefulWidget {
  final void Function(int temperature, {bool auto}) inputTemperature;
  final void Function(int beansTemp, int envTemp) updateTempDisplay;

  const WebSocketController({Key? key, required this.inputTemperature, required this.updateTempDisplay})
      : super(key: key);

  @override
  State<WebSocketController> createState() => _WebSocketControllerState();
}

class _WebSocketControllerState extends State<WebSocketController> {
  WebSocketChannel? _channel;
  String _receiveData = 'Disconnected';
  final TextEditingController _urlController = TextEditingController(text: 'ws://192.168.11.51:81');

  Future<void> startConnection(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      setState(() {
        _receiveData = 'Connected';
      });
      _channel!.stream.listen((event) {
        Map<String, dynamic> temps = jsonDecode(event);
        widget.updateTempDisplay(temps['BT'].toInt(), temps['ET'].toInt());
        widget.inputTemperature(temps['BT'].toInt(), auto: true);
      }, onError: (e) {
        setState(() {
          _receiveData = 'Error: $e';
        });
      }, onDone: () {
        setState(() {
          _receiveData = 'Disconnected';
        });
      });
    } catch (e) {
      setState(() {
        _receiveData = 'Connection Error';
      });
    }
  }

  void stopConnection() {
    _channel?.sink.close();
    _channel = null;
    setState(() {
      _receiveData = 'Disconnected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            labelText: 'WebSocket URL',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => startConnection(_urlController.text),
              child: const Text('Connect'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: stopConnection,
              child: const Text('Disconnect'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Status: $_receiveData'),
      ],
    );
  }
}

// Dialog methods
Future<bool?> _showConfirmDialog(
    BuildContext context, String title, String message, String okText, String cancelText) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(okText),
          ),
        ],
      );
    },
  );
}

Future<String?> _showSelectDialog(
    BuildContext context, String title, String message, List<String> choices) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(title),
        children: choices
            .map((choice) => SimpleDialogOption(
                  child: Text(choice),
                  onPressed: () => Navigator.pop(context, choice),
                ))
            .toList(),
      );
    },
  );
}
