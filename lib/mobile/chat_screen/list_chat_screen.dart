import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:page_transition/page_transition.dart';

import '../../models/challenge.dart';
import '../../widget/chat_screen/chat_card_widget.dart';
import 'chat_screen.dart';

void main() async {
  await dotenv.load();
}
// ignore_for_file: library_private_types_in_public_api

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
      if (mounted) {
        setState(() {
          roomNames.clear();
          final roomsJsonString = jsonEncode(rooms);
          final roomsJson = jsonDecode(roomsJsonString);
          roomsJson.forEach((roomId, roomData) {
            roomNames[roomId] = roomData["name"];
          });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: Column(
            children: <Widget>[
              Expanded(
                child: buildChats(context, challengeList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChats(BuildContext context, List<Challenge> challengeList) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // return MyCard(
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType
                            .rightToLeft, // Tipo de transición deseada
                        child: ChatWidget(
                          roomNameWidget: challengeList[index].name,
                          socketWidget: socket,
                          roomNamesWidget: roomNames,
                        ),
                      ),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ChatWidget(
                    //             roomNameWidget: challengeList[index].name,
                    //             socketWidget: socket,
                    //             roomNamesWidget: roomNames,
                    //           )),
                    // );
                  },
                  child: MyChatCard(
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
