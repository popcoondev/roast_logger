// widgets/web_socket_controller.dart

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

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
