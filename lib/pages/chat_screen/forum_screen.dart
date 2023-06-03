import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import '../../models/challenge.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // home: MyHomePage(),
        home: MyChatPage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String userName = '';
  IO.Socket? socket;

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setUserName2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username')!;
    notifyListeners();
  }

  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  void setIdandconnect(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.setUserName2();
    appState.socket = IO.io('http://localhost:4000');
    appState.socket!.connect()
      ..onConnectError((data) {
        print('Failed to connect to server: $data');
      })
      ..onConnect((data) {
        print('Connected to server');
      });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyChatPage()),
    );
  }

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('Welcome to the Flutter Chat Client !'),
          Text('Add your NAME to start :)'),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your name here',
            ),
            controller: _nameController,
          ),
          ElevatedButton(
            onPressed: () {
              // appState.setUserName(
              //     _nameController.text); // set the user name in app state
              appState.setUserName2();
              // setIdandconnect(context);
              appState.socket = IO.io('http://localhost:4000');
              appState.socket!.connect()
                ..onConnectError((data) {
                  print('Failed to connect to server: $data');
                })
                ..onConnect((data) {
                  print('Connected to server');
                  // Do something now that you know the connection is established
                });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyChatPage()),
              );
              // if (appState.userName.isNotEmpty) {
              // }
            },
            child: Text('START'),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String senderName;
  final String messageContent;
  final String timeSent;

  ChatMessage(
      {required this.senderName,
      required this.messageContent,
      required this.timeSent});
}

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  MyAppState? appState;
  String _currentRoom = '';
  List<ChatMessage> _messages = [];
  Map<String, String> roomNames = {};
  List<Challenge> challengeList = <Challenge>[];

  IO.Socket? socket;

  TextEditingController roomNameController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  void getChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/challenge/get/all';
    var response = await Dio().get(path,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
    var registros = response.data as List;
    for (var sub in registros) {
      challengeList.add(Challenge.fromJson(sub));
    }
    setState(() {
      challengeList = challengeList;
    });
    setChallengeRooms();
  }

  // void setChallengeRooms() {
  //   for (var challenge in challengeList) {
  //     if (challenge.name.isNotEmpty &&
  //         !roomNames.values.contains(challenge.name) &&
  //         (challenge.name !=
  //             roomNames.values.elementAt(challengeList.indexOf(challenge)))) {
  //       socket!.emit('CREATE_ROOM', {"roomName": challenge.name});
  //     }
  //   }
  // }

  void setChallengeRooms() {
    for (var challenge in challengeList) {
      if (challenge.name.isNotEmpty &&
          !roomNames.values.contains(challenge.name) &&
          !roomNames.values.any((value) => value == challenge.name)) {
        socket!.emit('CREATE_ROOM', {"roomName": challenge.name});
      }
    }
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

  String? getKeyFromValue(Map<String, String> map, String targetValue) {
    for (var entry in map.entries) {
      if (entry.value == targetValue) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    appState = context.read<MyAppState>();
    // socket = appState!.socket;

    appState?.setUserName2();
    socket = IO.io('http://localhost:4000');
    socket!.connect()
      ..onConnectError((data) {
        print('Failed to connect to server: $data');
      })
      ..onConnect((data) {
        print('Connected to server');
      });

    socket!.on("ROOMS", (rooms) {
      if (mounted) {
        setState(() {
          roomNames.clear();
          final roomsJsonString = jsonEncode(rooms);
          final roomsJson = jsonDecode(roomsJsonString);
          roomsJson.forEach((roomId, roomData) {
            roomNames[roomId] = roomData["name"];
            print(roomNames);
          });
        });
      }
    });

    socket!.on("ROOM_MESSAGE", (data) {
      final roomMessageJsonString = jsonEncode(data);
      final roomMessageJson = jsonDecode(roomMessageJsonString);
      ChatMessage chatMessage = ChatMessage(
        senderName: roomMessageJson['username'],
        messageContent: roomMessageJson['message'],
        timeSent: roomMessageJson['time'],
      );
      if (mounted) {
        setState(() {
          _messages.insert(0, chatMessage);
          _textController.clear();
        });
      }
    });

    if (mounted) getChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('FLUTTER CHAT CLIENT'),
      // ),
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: roomNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter a room name',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            createRoom(roomNameController.text);
                          },
                          child: Text('Create Room'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: roomNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_currentRoom !=
                                  roomNames.values.elementAt(index)) {
                                _currentRoom =
                                    roomNames.values.elementAt(index);
                                socket!.emit("JOIN_ROOM",
                                    getKeyFromValue(roomNames, _currentRoom));
                                _messages = [];
                              }
                            });
                          },
                          child: Text(roomNames.values.elementAt(index)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              color: Color.fromARGB(255, 252, 252, 252),
              child: Column(
                children: [
                  // Chat room header
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '$_currentRoom',
                      style: TextStyle(fontSize: 24.0),
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
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.senderName,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                message.messageContent,
                                style: TextStyle(fontSize: 16.0),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                message.timeSent,
                                style: TextStyle(
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
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Enter a message',
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_textController.text.isNotEmpty) {
                              _handleSubmitted(ChatMessage(
                                senderName: appState!.userName,
                                messageContent: _textController.text,
                                timeSent: DateTime.now().toString(),
                              ));
                            }
                          },
                          child: Text('Send'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//--------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late WebSocketChannel channel;
//   TextEditingController _controller = TextEditingController();
//   List<String> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:4000'));
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       String message = _controller.text;
//       channel.sink.add(message);
//       _controller.clear();
//       setState(() {
//         messages.add("You sent: $message");
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('EETACGo Forum'),
//         backgroundColor: Color.fromARGB(255, 25, 25, 25),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   return Text(messages[index]);
//                 },
//               ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(labelText: 'Send a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
