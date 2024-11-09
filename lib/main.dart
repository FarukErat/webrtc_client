import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  WebSocketExampleState createState() => WebSocketExampleState();
}

class WebSocketExampleState extends State<WebSocketExample> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8321'),
    );
  }

  void _refreshConnection() {
    _channel.sink.close();
    _connectWebSocket();
    log("WebSocket connection refreshed");
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = jsonEncode({"text": _controller.text});
      _channel.sink.add(message);
      log("Sent message: $message");
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket Text Sender"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter text'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshConnection,
              child: const Text('Refresh Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
