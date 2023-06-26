import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/widget/loading_circle.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    socket = widget.socketWidget;
    roomNames = widget.roomNamesWidget!;
    createRoom(widget.roomNameWidget!);
    loadMessages().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> loadMessages() async {
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
    final DateFormat formatter = DateFormat('hh:mm | dd - MM - yyyy');

    //final DateFormat formatter = DateFormat('yyyy-MM-dd | hh:mm');
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: alignment,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(79.5, 4, 4, 0),
            child: Visibility(
              visible: visibility,
              child: Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 252, 197, 31),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: alignment2,
            //crossAxisAlignment: CrossAxisAlignment.end,
            crossAxisAlignment: alignment,
            children: [
              Visibility(
                visible: visibility,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(17.5, 6, 5, 17.5),
                  child: CircleAvatar(
                    radius: 17.5,
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
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 4),
                    child: BubbleSpecialOne(
                      text: message.messageContent,
                      color: Color.fromARGB(255, 255, 255, 255),
                      tail: true,
                      isSender: isSender,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(19.5, 2, 18, 4),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingCircle();
    } else {
      return Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Column(
              children: [
                MyChatTitleCard(attr1: _currentRoom),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      ChatMessage message = _messages[index];
                      return FutureBuilder<String>(
                        future: getUsername(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 52, 52, 52),
                  height: 0.05,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(19, 18, 14, 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 49.5,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 242, 242, 242),
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: TextFormField(
                            controller: _textController,
                            cursorColor: const Color.fromARGB(255, 222, 66, 66),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 25, 25, 25)),
                            decoration: const InputDecoration(
                              hintText: 'Send a message...',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 146, 146, 146)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(20, 1, 20, 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
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
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor:
                              const Color.fromARGB(255, 222, 66, 66),
                          padding: const EdgeInsets.all(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 2.0),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
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
  }
}
