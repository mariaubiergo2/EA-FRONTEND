import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../models/challenge.dart';
import '../../widget/chat_screen/chat_challenge_widget.dart';

void main() async {
  await dotenv.load();
}
// ignore_for_file: library_private_types_in_public_api

class ChatMessage {
  ChatMessage(
      {required this.senderName,
      required this.messageContent,
      required this.timeSent});

  final String messageContent;
  final String senderName;
  final String timeSent;
}

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  State<StatefulWidget> createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  Challenge? challenge;
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

    socket = IO.io('http://${dotenv.env['API_URL_SOCKET']}');
    socket!.connect()
      ..onConnectError((data) {
        print('Failed to connect to server: $data');
      })
      ..onConnect((data) {
        print('Connected to server');
      });

    socket!.on("ROOMS", (rooms) {
      setState(() {
        roomNames.clear();
        final roomsJsonString = jsonEncode(rooms);
        final roomsJson = jsonDecode(roomsJsonString);
        roomsJson.forEach((roomId, roomData) {
          roomNames[roomId] = roomData["name"];
          print(roomNames);
        });
      });
      // if (mounted) {

      // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),

            const SizedBox(height: 25), //AQUI IRÁ LOS MODOS
            Expanded(
              child: buildChats(context, challengeList),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChats(BuildContext context, List<Challenge> challengeList) {
    return CustomScrollView(
      // MediaQuery.of(context).size.height - 100,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // return MyCard(
                return GestureDetector(
                  onTap: () => (setState(() {
                    if (_currentRoom != roomNames.values.elementAt(index)) {
                      _currentRoom = roomNames.values.elementAt(index);
                      socket!.emit(
                        "JOIN_ROOM",
                        getKeyFromValue(roomNames, _currentRoom),
                      );
                      _messages = [];
                    }
                    Navigator.pushNamed(context, '/chat');
                  })),
                  child: MyChatChallengeCard(
                    index: index,
                    attr1: challengeList[index].name,
                  ),
                );
              },
              childCount: challengeList.length,
            ),
          ),
        ),
      ],
    );
  }
}
