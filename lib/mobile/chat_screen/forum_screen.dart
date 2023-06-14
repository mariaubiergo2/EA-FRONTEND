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
  var current = WordPair.random();
  IO.Socket? socket;
  String userName = '';

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setUserName2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username')!;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  final _nameController = TextEditingController();

  void setIdandconnect(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.setUserName2();
    appState.socket = IO.io('http://${dotenv.env['API_URL_SOCKET']}');
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
              appState.socket = IO.io('http://${dotenv.env['API_URL_SOCKET']}');
              appState.socket!.connect()
                ..onConnectError((data) {
                  debugPrint('Failed to connect to server: $data');
                })
                ..onConnect((data) {
                  debugPrint('Connected to server');
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
  ChatMessage(
      {required this.senderName,
      required this.messageContent,
      required this.timeSent});

  final String messageContent;
  final String senderName;
  final String timeSent;
}

class MyChatPage extends StatefulWidget {
  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
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

    appState = context.read<MyAppState>();
    // socket = appState!.socket;

    appState?.setUserName2();
    socket = IO.io('http://${dotenv.env['API_URL_SOCKET']}');
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
    if (mounted) {
      setState(() {
        challengeList = challengeList;
      });
    }
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
      body: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              color: Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                        // children: [
                        //   Expanded(
                        //     child: TextField(
                        //       controller: roomNameController,
                        //       style: const TextStyle(color: Colors.white),
                        //       decoration: const InputDecoration(
                        //         hintText: 'Enter a room name',
                        //         hintStyle: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ),
                        //   SizedBox(width: 16.0),
                        //   ElevatedButton(
                        //     onPressed: () {
                        //       createRoom(roomNameController.text);
                        //     },
                        //     child: Text('Create Room'),
                        //   ),
                        // ],
                        ),
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: roomNames.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return ElevatedButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             if (_currentRoom !=
                  //                 roomNames.values.elementAt(index)) {
                  //               _currentRoom =
                  //                   roomNames.values.elementAt(index);
                  //               socket!.emit("JOIN_ROOM",
                  //                   getKeyFromValue(roomNames, _currentRoom));
                  //               _messages = [];
                  //             }
                  //           });
                  //         },
                  //         child: Text(roomNames.values.elementAt(index)),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: roomNames.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 12.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.normal),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_currentRoom !=
                                  roomNames.values.elementAt(index)) {
                                _currentRoom =
                                    roomNames.values.elementAt(index);
                                socket!.emit(
                                  "JOIN_ROOM",
                                  getKeyFromValue(roomNames, _currentRoom),
                                );
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
                              border: Border.all(color: Colors.redAccent)),
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
