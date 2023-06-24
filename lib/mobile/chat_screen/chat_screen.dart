import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/challenge.dart';
import '../../models/message.dart';
import 'chat_service.dart';

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

Future<String> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var userName = prefs.getString('username');
  return userName ?? '';
}

class _ChatWidgetState extends State<ChatWidget> {
  ChatService appState = ChatService();

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
    socket = widget.socketWidget;
    roomNames = widget.roomNamesWidget!;
    createRoom(widget.roomNameWidget!);
    loadMessages();
  }

  void loadMessages() async {
    List<ChatMessage> messages = await appState.getMessages(_currentRoom);
    setState(() {
      _messages = messages;
    });
  }

  void createRoom(String roomName) {
    setState(() {
      roomNameController.clear(); // clear the input field
      _currentRoom = roomName;
      socket!.emit("JOIN_ROOM", getKeyFromValue(roomNames, _currentRoom));
    });
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
      // socket!.emit("SEND_ROOM_MESSAGE", {
      //   "roomId": getKeyFromValue(roomNames, _currentRoom),
      //   "message": chatMessage.messageContent,
      //   "username": chatMessage.senderName
      // });
      appState.sendMessage(chatMessage);
      setState(() {
        loadMessages();
        _textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            // Chat room header
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _currentRoom,
                style: const TextStyle(fontSize: 24.0, color: Colors.redAccent),
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
                          message.timeSent.toString(),
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
                          timeSent: Timestamp.now(),
                          roomId: _currentRoom,
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
