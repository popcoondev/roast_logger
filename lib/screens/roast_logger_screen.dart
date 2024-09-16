// widgets/roast_logger.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roast_logger/widgets/timer_small_widget.dart';
import '../dialogs/chart_settings_dialog.dart';
import '../models/bean_info.dart';
import '../models/chart_settings.dart';
import '../models/roast_info.dart';
import '../models/log_entry.dart';
import '../models/roast_log.dart';

// 他の必要なインポート
import '../widgets/bean_info_widget.dart';
import '../widgets/roast_info_widget.dart';
import '../widgets/components_container.dart';
import '../widgets/timer_widget.dart';
import '../widgets/input_temperature.dart';
import '../widgets/input_events.dart';
import '../widgets/temp_display.dart';
import '../widgets/chart_display.dart';
import '../widgets/websocket_controller.dart';
import '../utils/dialogs.dart';
import '../widgets/timeline_grid.dart';
import '../dialogs/bean_info_dialog.dart';
import '../dialogs/roast_info_dialog.dart';
import '../utils/events.dart';

// 続きは既存のRoastLoggerクラスの内容をここに移動します。
class RoastLoggerScreen extends StatefulWidget {
  const RoastLoggerScreen({Key? key}) : super(key: key);

  @override
  State<RoastLoggerScreen> createState() => _RoastLoggerState();
}

class _RoastLoggerState extends State<RoastLoggerScreen> {
  int _currentTime = 0; // current time
  int _beansTemp = 0; // beans temperature
  int _envTemp = 0; // environment temperature
  int _interval = 10; // data summary interval
  int _inputTempMode = 0; // 0: manual, 1: auto
  Timer? _timer;
  RoastLog? _roastLog;
  ChartSettings _chartSettings = ChartSettings();
  ScrollController _scrollController = ScrollController();
  bool _showFloatingTimer = false;
  final GlobalKey _timerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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

  // スクロールリスナー
  void _scrollListener() {
    debugPrint('Scroll position: ${_scrollController.offset}'); 
    debugPrint('timerKey: ${_timerKey.currentContext}');
    if (_timerKey.currentContext != null) {
      RenderBox renderBox = _timerKey.currentContext!.findRenderObject() as RenderBox;
      Offset position = renderBox.localToGlobal(Offset.zero);
      debugPrint('TimerWidget position: ${position.dy}');
      // TimerWidgetが画面上から消えた場合
      if (position.dy + renderBox.size.height < kToolbarHeight) {
        if (!_showFloatingTimer) {
          setState(() {
            _showFloatingTimer = true;
            debugPrint('Show floating timer');
          });
        }
      } else {
        if (_showFloatingTimer) {
          setState(() {
            _showFloatingTimer = false;
            debugPrint('Hide floating timer');
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
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
      body: Stack(
      children: [
        LayoutBuilder(
        builder: (context, constraints) {
          if (isLandscape) {
            // Landscape layout with three columns
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column: Beans Info card and Roast Info card
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ComponentsContainer(
                          labelTitle: 'Beans Info',
                          buttonTitle: 'Edit',
                          buttonAction: () {
                            _editBeanInfo(context);
                          },
                          child: BeanInfoWidget(beanInfo: _roastLog!.beanInfo),
                        ),
                        ComponentsContainer(
                          labelTitle: 'Roast Info',
                          buttonTitle: 'Edit',
                          buttonAction: () {
                            _editRoastInfo(context);
                          },
                          child: RoastInfoWidget(roastInfo: _roastLog!.roastInfo),
                        ),
                        ComponentsContainer(
                          labelTitle: 'Timer',
                          buttonTitle: 'Data Reset',
                          buttonAction: _timer == null
                              ? () async {
                                  bool? ret = await showConfirmDialog(
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
                                  bool? ret = await showConfirmDialog(
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
                      ],
                    ),
                  ),
                ),
                // Center column: Timer, Input Temp, Input Phases
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ComponentsContainer(
                          labelTitle: 'Input Phases',
                          child: InputEvents(
                            addEvent: _addEvent,
                          ),
                        ),
                        ComponentsContainer(
                          labelTitle: 'Temperature Charts',
                          buttonTitle: 'Chart Settings',
                          buttonAction: () {
                            _openChartSettingsDialog(context);
                          },
                          child: Column(
                            children: [
                              // Temp display
                              TempDisplay(
                                beansTemp: _beansTemp,
                                envTemp: _envTemp,
                              ),
                              ChartDisplay(
                                logEntries: _roastLog!.logEntries,
                                chartSettings: _chartSettings,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right column: Data Summary, Temperature Charts
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ComponentsContainer(
                          labelTitle: 'Data Summary',
                          buttonTitle: '${_interval} sec',
                          buttonAction: () async {
                            String? ret = await showSelectDialog(
                                context, 'Select Interval', 'Select the interval for data summary', ['1 sec', '10 sec', '30 sec', '60 sec', '120 sec']);
                            if (ret == null) return;
                            setState(() {
                              switch (ret) {
                                case '1 sec':
                                  _interval = 1;
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
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  ComponentsContainer(
                    labelTitle: 'Beans Info',
                    buttonTitle: 'Edit',
                    buttonAction: () {
                      _editBeanInfo(context);
                    },
                    child: BeanInfoWidget(beanInfo: _roastLog!.beanInfo),
                  ),
                  ComponentsContainer(
                    labelTitle: 'Roast Info',
                    buttonTitle: 'Edit',
                    buttonAction: () {
                      _editRoastInfo(context);
                    },
                    child: RoastInfoWidget(roastInfo: _roastLog!.roastInfo),
                  ),
                  ComponentsContainer(
                    key: _timerKey,
                    labelTitle: 'Timer',
                    buttonTitle: 'Data Reset',
                    buttonAction: _timer == null
                        ? () async {
                            bool? ret = await showConfirmDialog(
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
                            bool? ret = await showConfirmDialog(
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
                    labelTitle: 'Temperature Charts',
                    buttonTitle: 'Chart Settings',
                    buttonAction: () {
                      _openChartSettingsDialog(context);
                    },
                    child: Column(
                      children: [
                        // Temp display
                        TempDisplay(
                          beansTemp: _beansTemp,
                          envTemp: _envTemp,
                        ),
                        ChartDisplay(
                          logEntries: _roastLog!.logEntries,
                          chartSettings: _chartSettings,
                        ),
                      ],
                    ),
                  ),
                  ComponentsContainer(
                    labelTitle: 'Data Summary',
                    buttonTitle: '${_interval} sec',
                    buttonAction: () async {
                      String? ret = await showSelectDialog(
                          context, 'Select Interval', 'Select the interval for data summary', ['1 sec', '10 sec', '30 sec', '60 sec', '120 sec']);
                      if (ret == null) return;
                      setState(() {
                        switch (ret) {
                          case '1 sec':
                            _interval = 1;
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
                ],
              ),
            );
          }
        },
      ),
      // フローティング表示されるTimerWidget
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: isLandscape
            ? const Offstage()
            :
        Offstage(
          offstage: !_showFloatingTimer,
          child: TimerSmallWidget(currentTime: _currentTime, timerState: _timer == null ? 0 : 1, startTimer: _startTimer, stopTimer: _stopTimer),
        ),
      ),
    ],
    ),
    );
  }

  void _openChartSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChartSettingsDialog(
          chartSettings: _chartSettings,
          onSave: (newSettings) {
            setState(() {
              _chartSettings = newSettings;
            });
          },
        );
      },
    );
  }

  void _addEvent(String event) {
    if (_roastLog!.logEntries.isNotEmpty) {
      setState(() {
        _roastLog!.logEntries[_roastLog!.logEntries.length - 1].event = event;
        if (event == Event.drop) {
          _roastLog?.roastInfo.roastTime = _formatTime(_currentTime);
        }
        _updateAll();
      });
    }
  }

  String _formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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

  // Edit Bean Info Dialog
  void _editBeanInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BeanInfoDialog(
          beanInfo: _roastLog!.beanInfo,
          onSave: (BeanInfo updatedBeanInfo) {
            setState(() {
              _roastLog!.beanInfo = updatedBeanInfo;
            });
          },
        );
      },
    );
  }

  // Edit Roast Info Dialog
  void _editRoastInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return RoastInfoDialog(
          roastInfo: _roastLog!.roastInfo,
          onSave: (RoastInfo updatedRoastInfo) {
            setState(() {
              _roastLog!.roastInfo = updatedRoastInfo;
            });
          },
        );
      },
    );
  }
}
