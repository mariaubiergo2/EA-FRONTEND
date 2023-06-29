import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'card_challenge_list_widget.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ea_frontend/models/itinerario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/widgets/home_screen/card_challenge_widget.dart';

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
  List<Itinerario> itinerarioList = <Itinerario>[];
  dynamic controller;
  dynamic panelController;
  String? _idUser;
  @override
  void initState() {
    super.initState();
    getChallenges();
    getItinerarios();
  }

  Future getChallenges() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    _idUser = prefs.getString('idUser');

    String path =
        'http://${dotenv.env['API_URL']}/challenge/get/available/$_idUser';
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

  Future getItinerarios() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? "";
    String path = 'http://${dotenv.env['API_URL']}/itinerario/get/all';
    var response = await Dio().get(path,
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }));
    var registros = response.data as List;
    for (var sub in registros) {
      itinerarioList.add(Itinerario.fromJson(sub));
    }
    setState(() {
      itinerarioList = itinerarioList;
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
              // child: buildChallenges12(context, challengeList),
              child: buildItinerario(context, itinerarioList),
            ),
          ],
        ),
      ),
    );
  }
}

@override
Widget buildItinerario(BuildContext context, List<Itinerario> itinerarioList) {
  return CustomScrollView(
    // MediaQuery.of(context).size.height - 100,
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // print(jsonDecode(itinerarioList[index].challenges).name);
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        title: Text(itinerarioList[index].name),
                        content: Column(
                          children: [
                            for (var item in itinerarioList[index].challenges)
                              MyChallengeListCard(
                                index: index,
                                attr1: item.name,
                                attr2: item.descr,
                                attr3: item.exp.toString(),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: MyChallengeCard(
                  index: index,
                  attr1: itinerarioList[index].name,
                  attr2: itinerarioList[index].descr,
                  attr3: "",
                  attr4: "",
                  attr5: [],
                ),
              );
            },
            childCount: itinerarioList.length,
          ),
        ),
      ),
    ],
  );
}

getChallengeInfo(String idChallenge) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token') ?? "";

  String path = 'http://${dotenv.env['API_URL']}/challenge/get/$idChallenge';
  var response = await Dio().get(path,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }));
  return response.data;
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
