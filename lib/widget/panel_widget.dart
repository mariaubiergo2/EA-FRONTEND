import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    getSubjects();
  }

  Future getSubjects() async {
    //http://IP_PC:3000/subject/all
    String path = 'http://127.0.0.1:3002/challenge/get/all';
    var response = await Dio().get(path);
    var registros = response.data as List;
    for (var sub in registros) {
      challengeList.add(Challenge.fromJson(sub));
    }
    setState(() {
      challengeList = challengeList;
    });
  }
/*
  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          const SizedBox(height: 12),
          buildDragHandle(),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Challenges',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 36),
          buildAboutText(),
          const SizedBox(height: 24),
          buildChallenges5(context, challengeList),
          /*
Scaffold(
  body:Column(children: [
            ListView.builder(
              itemCount: challengeList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Color.fromARGB(255, 197, 162, 226),
                  child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: ListTile(
                        title: Text(challengeList[index].name,
                            style: const TextStyle(fontSize: 30.0)),
                        subtitle: Text(challengeList[index].exp.toString(),
                            style: const TextStyle(fontSize: 20.0)),
                        trailing: Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   deleteSubject(challengeList[index].id);
                                    //   challengeList.removeAt(index);
                                    // });
                                  },
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        ),
                      )),
                );
              }),
          
          ]
          ),



)

*/
        ],
  );*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          buildDragHandle(),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'Challenges',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(height: 36),
          buildAboutText(),
          const SizedBox(height: 24),
          buildChallenges11(context, challengeList),
        ],
      ),
    );
  }
}

@override
Widget buildChallenges11(BuildContext context, List<Challenge> challengeList) {
  return SizedBox(
    height:
        MediaQuery.of(context).size.height - 200, // ajustar según sea necesario
    child: Viewport(
      axisDirection: AxisDirection.down,
      offset: ViewportOffset.zero(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MyCard(
                  child: challengeList[index].exp.toString(),
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

Widget buildChallenges6(BuildContext context, List<Challenge> challengeList) {
  return Column(
    children: [
      for (var challenge in challengeList)
        MyCard(
          child: challenge.name.toString(),
        ),
    ],
  );
}

//--------------no funciona-------------------
@override
Widget buildChallenges7(BuildContext context, List<Challenge> challengeList) {
  return Scaffold(
    body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: challengeList.length,
              itemBuilder: (context, index) {
                return MyCard(
                  child: challengeList[index].exp.toString(),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

//----------------------funciona------------------
@override
Widget buildChallenges8(BuildContext context, List<Challenge> challengeList) {
  return SizedBox(
    height: 400,
    child: ListView.builder(
      itemCount: challengeList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          child: MyCard(
            child: challengeList[index].exp.toString(),
          ),
        );
      },
    ),
  );
}

@override
Widget buildChallenges9(BuildContext context, List<Challenge> challengeList) {
  return SizedBox(
    height: 400,
    child: ListView.builder(
      itemCount: challengeList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MyCard(
              child: challengeList[index].exp.toString(),
            ),
          ),
        );
      },
    ),
  );
}

@override
Widget buildChallenges10(BuildContext context, List<Challenge> challengeList) {
  return Expanded(
    child: ListView.builder(
      itemCount: challengeList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 100,
          child: MyCard(
            child: challengeList[index].exp.toString(),
          ),
        );
      },
    ),
  );
}

/*
  Widget build (BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    controller: controller,
    children: <Widget>[
      SizedBox(height: 12),
      buildDragHandle(),
      SizedBox(height: 18),
      Center(
        child: Text(
          'Challenges',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      SizedBox(height: 36),
      buildAboutText(),
      SizedBox(height: 24),
      buildChallenges(),
    ],
  );*/

Widget buildAboutText() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text('data')
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

Widget buildChallenges(List<Challenge> challengeList) => ListView.builder(
    itemCount: challengeList.length,
    itemBuilder: (BuildContext context, int index) {
      return Text(challengeList[index].exp.toString());
    });

@override
Widget buildChallenges4(BuildContext context, List<Challenge> challengeList) {
  return Scaffold(
    body: Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: challengeList.length,
                itemBuilder: (context, index) {
                  return MyCard(
                    child: challengeList[index].exp.toString(),
                  );
                }))
      ],
    ),
  );
}

// Widget buildChallenges2(List<Challenge> challengeList) => Column(
//   children: <Widget>[
//         SizedBox(
//           height: double.infinity,
//           child: Column(children: [
//             ListView.builder(
//               itemCount: challengeList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   color: Color.fromARGB(255, 197, 162, 226),
//                   child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: ListTile(
//                         title: Text(challengeList[index].name,
//                             style: const TextStyle(fontSize: 30.0)),
//                         subtitle: Text(challengeList[index].exp.toString(),
//                             style: const TextStyle(fontSize: 20.0)),
//                         trailing: Container(
//                           width: double.infinity,
//                           child: Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     // setState(() {
//                                     //   deleteSubject(challengeList[index].id);
//                                     //   challengeList.removeAt(index);
//                                     // });
//                                   },
//                                   icon: const Icon(Icons.delete))
//                             ],
//                           ),
//                         ),
//                       )),
//                 );
//               }),

//           ],)
//         )
//       ]);

Widget buildChallenges3(List<Challenge> challengeList) => ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: challengeList.length,
    itemBuilder: (BuildContext context, int index) {
      return MyCard(
        child: challengeList[index].exp.toString(),
      );
    });

@override
Widget buildChallenges5(BuildContext context, List<Challenge> challengeList) {
  return Expanded(
    child: ListView.builder(
        itemCount: challengeList.length,
        itemBuilder: (context, index) {
          return MyCard(
            child: challengeList[index].exp.toString(),
          );
        }),
  );
}
