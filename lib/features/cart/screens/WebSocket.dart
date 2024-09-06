import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketExample extends StatefulWidget {
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState();
}

class _WebSocketExampleState extends State<WebSocketExample> {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('wss://ws.postman-echo.com/raw'), // Ensure this is the correct WebSocket URL
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live WebSocket Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Waiting for messages...'));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data.toString();
                    return Center(
                      child: Text(
                        'Last Message: $data',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else {
                    return Center(child: Text('No data received'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Close the WebSocket connection
          channel.sink.close();
        },
        tooltip: 'Close connection',
        child: Icon(Icons.close),
      ),
    );
  }

  @override
  void dispose() {
    // Always close the WebSocket connection when the widget is disposed
    channel.sink.close();
    super.dispose();
  }
}
