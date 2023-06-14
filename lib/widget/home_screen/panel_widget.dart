//import 'dart:js';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/widget/home_screen/card_challenge_widget.dart';

void main() async {
  await dotenv.load();
}

class PanelWidget extends StatefulWidget {
  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

  final ScrollController controller;
  final PanelController panelController;

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];
  dynamic controller;
  dynamic panelController;

  @override
  void initState() {
    super.initState();
    getChallenges();
  }

  Future getChallenges() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            buildDragHandle(context),
            const SizedBox(height: 25), //AQUI IRÁ LOS MODOS
            Expanded(
              child: buildChallenges12(context, challengeList),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildChallenges12(BuildContext context, List<Challenge> challengeList) {
  return CustomScrollView(
    // MediaQuery.of(context).size.height - 100,
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // return MyCard(
              return MyChallengeCard(
                index: index,
                attr1: challengeList[index].name,
                attr2: challengeList[index].descr,
                attr3: challengeList[index].exp.toString(),
              );
            },
            childCount: challengeList.length,
          ),
        ),
      ),
    ],
  );
}

Widget buildDragHandle(context) => GestureDetector(
      onTap: togglePanel,
      child: Center(
        child: Container(
          width: 150,
          height: 3.75,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

void togglePanel() => PanelController().isPanelOpen
    ? PanelController().close()
    : PanelController().open();
