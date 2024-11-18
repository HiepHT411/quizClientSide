import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizflutter/views/websocket/ws_message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final String username;
  ChatPage({super.key, required this.title, required this.username});
  final channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:3000/ws/quiz'));


  @override
  State createState() {
    return ChatPageState();
  }

}

class ChatPageState extends State<ChatPage> {

  final TextEditingController textController = TextEditingController();
  final List<WSMessage> messages = <WSMessage>[];

  Future<void> sendMessage() async {
    if (textController.text.isNotEmpty) {
      WSMessage message = WSMessage(widget.username, textController.text, DateTime.now().millisecondsSinceEpoch);
      widget.channel.sink.add(message.toString());
      // widget.channel.sink.add(textController.text);
      textController.clear();
    }
  }


  @override
  void initState() {
    super.initState();
    widget.channel.stream.listen((message) {
      setState(() {
        messages.add(WSMessage.fromJson(jsonDecode(message)));
        // messages.add(message);
      });
    });
    WSMessage joinMessage = WSMessage(widget.username, "JOIN", DateTime.now().millisecondsSinceEpoch);
    widget.channel.sink.add(joinMessage.toString());
  }

  @override
  void dispose() {
    widget.channel.sink.close(1000, "Normal closure");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(messages[index].message), subtitle: Text(messages[index].username));
                  }
              )
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(hintText: 'Type message')
                      )
                  ),
                  IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
                ]
              ),
          )
        ],
      ),
    );
  }
}
