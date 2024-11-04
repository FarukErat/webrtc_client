import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketExample(),
    );
  }
}

class WebSocketExample extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    // Initialize the WebSocket connection
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8888'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // Send JSON message
      final message = jsonEncode({"text": _controller.text});
      _channel.sink.add(message);
      print("Sent message: $message");
      _controller.clear(); // Clear the input after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocket Text Sender"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
