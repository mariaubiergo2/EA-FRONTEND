


import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class PanelWidget extends StatelessWidget{
  final ScrollController controller;
  final PanelController panelController;

  const PanelWidget({
    Key? key,
    required this.controller,
    required this.panelController,
  }) : super(key: key);


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
    ],
  );


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


}

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