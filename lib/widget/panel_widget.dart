import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ea_frontend/models/challenge.dart';
import 'package:ea_frontend/widget/card_widget.dart';

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
    //http://IP_PC:3000/subject/all
    //String path = 'http://10.0.2.2:3002/challenge/get/all';
    String path = 'http://127.0.0.1:3002/challenge/get/all';
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
      body: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          buildDragHandle(),
          const SizedBox(height: 30),
          //const SizedBox(height: 36),
          //buildAboutText(),
          const SizedBox(height: 5),
          Expanded(
            child: buildChallenges12(context, challengeList),
          ),
        ],
      ),
    );
  }
}

@override
Widget buildChallenges11(BuildContext context, List<Challenge> challengeList) {
  return SizedBox(
    height:
        MediaQuery.of(context).size.height - 100, // ajustar según sea necesario
    width: MediaQuery.of(context).size.width,
    child: Viewport(
      axisDirection: AxisDirection.down,
      offset: ViewportOffset.zero(),
      //clipBehavior: Clip.hardEdge,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MyCard(
                  name: challengeList[index].name,
                  descr: challengeList[index].descr,
                  exp: challengeList[index].exp.toString(),
                );
              },
              childCount: challengeList.length,
            ),
          ),
        ),
      ],
    ),
  );
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
              return MyCard(
                name: challengeList[index].name,
                descr: challengeList[index].descr,
                exp: challengeList[index].exp.toString(),
              );
            },
            childCount: challengeList.length,
          ),
        ),
      ),
    ],
  );
}

Widget buildAboutText() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'Available challenges',
            style: TextStyle(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );

Widget buildDragHandle() => GestureDetector(
      onTap: togglePanel,
      child: Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

void togglePanel() => PanelController().isPanelOpen
    ? PanelController().close()
    : PanelController().open();
