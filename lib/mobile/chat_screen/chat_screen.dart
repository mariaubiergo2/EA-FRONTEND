import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/challenge.dart';
import '../../models/message.dart';

void main() async {
  await dotenv.load();
}

class ChatWidget extends StatefulWidget {
  final String? roomNameWidget;
  final IO.Socket? socketWidget;
  final Map<String, String>? roomNamesWidget;

  const ChatWidget({
    Key? key,
    this.roomNameWidget,
    this.socketWidget,
    this.roomNamesWidget,
  }) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  IO.Socket? socket;
  String? userName;

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setUserName2() async {
    userName = await getUsername(); // Esperar el resultado del Future<String>
    notifyListeners();
  }
}

Future<String> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var userName = prefs.getString('username');
  return userName ?? '';
}

class _ChatWidgetState extends State<ChatWidget> {
  MyAppState? appState;
  List<Challenge> challengeList = <Challenge>[];
  TextEditingController roomNameController = TextEditingController();
  Map<String, String> roomNames = {};
  IO.Socket? socket;
  String _currentRoom = '';
  List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.roomNameWidget);
    socket = widget.socketWidget;
    roomNames = widget.roomNamesWidget!;
    createRoom(widget.roomNameWidget!);
  }

  void createRoom(String roomName) {
    if (roomName.isNotEmpty && !roomNames.values.contains(roomName)) {
      socket!.emit('CREATE_ROOM', {"roomName": roomName});
      setState(() {
        roomNameController.clear(); // clear the input field
        _currentRoom = roomName;
        socket!.emit("JOIN_ROOM", getKeyFromValue(roomNames, _currentRoom));
        _messages = [];
      });
    }
  }

  String? getKeyFromValue(Map<String, String> map, String targetValue) {
    for (var entry in map.entries) {
      if (entry.value == targetValue) {
        return entry.key;
      }
    }
    return null;
  }

  void _handleSubmitted(ChatMessage chatMessage) {
    if (_currentRoom.isNotEmpty) {
      socket!.emit("SEND_ROOM_MESSAGE", {
        "roomId": getKeyFromValue(roomNames, _currentRoom),
        "message": chatMessage.messageContent,
        "username": chatMessage.senderName
      });
      setState(() {
        _messages.insert(0, chatMessage);
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 252, 252, 252),
        child: Column(
          children: [
            // Chat room header
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _currentRoom,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            // Messages list
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatMessage message = _messages[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.redAccent)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.senderName,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          message.messageContent,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          message.timeSent,
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Message input field and send button
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_textController.text.isNotEmpty) {
                        _handleSubmitted(ChatMessage(
                          senderName: await getUsername(),
                          messageContent: _textController.text,
                          timeSent: DateTime.now().toString(),
                        ));
                      }
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
