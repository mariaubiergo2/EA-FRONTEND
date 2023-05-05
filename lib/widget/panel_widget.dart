


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ea_frontend/models/challenge.dart';




class PanelWidget extends StatefulWidget{
  final ScrollController controller;
  final PanelController panelController;


  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);

 @override
  State<PanelWidget> createState()=> _PanelWidgetState();

}

class _PanelWidgetState extends State<PanelWidget> {
  dynamic controller;
  dynamic panelController;
  
  Challenge? challenge;
  List<Challenge> challengeList = <Challenge>[];

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
      print(challengeList.length);
    });
  }



  @override
  Widget build(BuildContext context) => ListView(
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
      buildChallenges(challengeList),
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


  Widget buildAboutText () => Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
  onTap: togglePanel,
);

void togglePanel() => PanelController().isPanelOpen ? PanelController().close(): PanelController().open();



Widget buildChallenges(List<Challenge> challengeList) => 
    ListView.builder(
              itemCount: challengeList.length,
              itemBuilder: (BuildContext context, int index) {
                return  Text(challengeList[index].exp.toString());
                }
        
        );


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