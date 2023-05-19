import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCard extends StatelessWidget {
  final String attr1;
  final String attr2;
  final String attr3;

  const MyCard(
      {Key? key, required this.attr1, required this.attr2, required this.attr3})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(            
          children: <Widget>[ 
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(
                //   width: 4,
                //   color: Colors.amber,
                // ),
              ),
              width: MediaQuery.of(context).size.width, 
              padding: const EdgeInsets.fromLTRB(30.0, 8,8,8),
              child: Row (
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ 
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        'images/google.png',      
                        fit: BoxFit.cover,
                  ), 
                    ),
                  ), 
                  Padding(padding: EdgeInsets.fromLTRB(30,0,12,0),
                  child: Container(
                    width: 1,
                    height: 100,
                      color: const Color.fromARGB(255, 222, 66, 66),
                  ),),               
                         
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attr1,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        attr2,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          fontSize: 14),
                      ),
                    ],
                  )],)),],
        ));
  }
}
