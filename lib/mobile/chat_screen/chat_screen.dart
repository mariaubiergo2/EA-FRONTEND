import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/widget/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../models/challenge.dart';
import '../../models/message.dart';
import '../../widget/chat_screen/chat_title_widget.dart';
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
  String profilePic = " ";
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

    final prefs = await SharedPreferences.getInstance();
    profilePic = prefs.getString('imageURL') ?? '';

    print("//////////////////////////////////////// URL: ");
    print(profilePic);
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
      appState.sendMessage(chatMessage);
      setState(() {
        loadMessages();
        _textController.clear();
      });
    }
  }

  String changeDateTimeFormat(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd | hh:mm');
    final String formatted = formatter.format(date);
    return formatted;
  }

  Widget doMessageBubble(ChatMessage message, String username) {
    print("//////////////////////////////////////// Url sender: ");
    print(message.photoURL);
    final isSender = message.senderName == username;
    final visibility = !isSender;
    final alignment =
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final alignment2 =
        isSender ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(70, 0, 4, 0),
          child: Visibility(
            visible: visibility,
            child: Text(
              message.senderName,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: alignment2,
          crossAxisAlignment: alignment,
          children: [
            Visibility(
              visible: visibility,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 20, 0, 0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: message.photoURL != ""
                      ? Image.network(message.photoURL).image
                      : const AssetImage('images/default.png'),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: alignment2,
              crossAxisAlignment: alignment,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 4),
                  child: BubbleSpecialThree(
                    text: message.messageContent,
                    color: Color.fromARGB(255, 255, 255, 255),
                    tail: true,
                    isSender: isSender,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 2, 18, 4),
                  child: Text(
                    changeDateTimeFormat(message.timeSent.toDate()),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return const LoadingCircle();
    } else {
      return Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: Column(
            children: [
              const SizedBox(
                height: 14.0,
              ),
              MyChatTitleCard(attr1: _currentRoom),
              const SizedBox(
                height: 8.0,
              ),
              Expanded(
                  child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatMessage message = _messages[index];
                  return FutureBuilder<String>(
                    future: getUsername(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      String username = snapshot.data ?? '';
                      return doMessageBubble(message, username);
                    },
                  );
                },
              )),
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
                              photoURL: profilePic,
                            ));
                          }
                        },
                        child: const Icon(
                          IconData(0xe571,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
