// ignore_for_file: unnecessary_import, unused_import

import 'package:dio/dio.dart';
import 'package:ea_frontend/widget/maps_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:ea_frontend/widget/card_widget.dart';
import 'package:ea_frontend/widget/card_challenge_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  await dotenv.load();
}

class PanelWidget extends StatefulWidget {
  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
    required this.mapa,
  }) : super(key: key);

  final ScrollController controller;
  final PanelController panelController;
  final MapsWidget mapa;

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];

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
        decoration: const BoxDecoration(color: Color.fromARGB(255, 25, 25, 25)),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            buildDragHandle(),
            const SizedBox(height: 30),
            const SizedBox(height: 5),
            Expanded(
              child: buildChallenges12(context, challengeList),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChallenges12(
      BuildContext context, List<Challenge> challengeList) {
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
                  //controller: ScrollController(),
                  panelController: widget.panelController,
                  lat: challengeList[index].lat,
                  long: challengeList[index].long,
                  mapsWidget: widget.mapa,
                );
              },
              childCount: challengeList.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDragHandle() => GestureDetector(
        onTap: togglePanel,
        child: Center(
          child: Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  void togglePanel() => widget.panelController.isPanelOpen
      ? widget.panelController.close()
      : widget.panelController.open();
}
