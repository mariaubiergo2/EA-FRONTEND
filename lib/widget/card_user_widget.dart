import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'credential_button.dart';

class MyUserCard extends StatelessWidget {
  final String attr1;
  final String attr2;
  final String attr3;

  const MyUserCard(
      {Key? key, 
      required this.attr1, //photo url of the user
      required this.attr2, //username
      required this.attr3}) //exp or level of the user
      
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(            
          children: <Widget>[ 
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(16),
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
                        'images/google.png', //attr1 in the future, when the profile has an image      
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ), 
                    ),
                  ), 
                  Padding(padding: EdgeInsets.fromLTRB(30,0,20,0),
                  child: Container(
                    width: 1,
                    height: 100,
                      color: const Color.fromARGB(255, 222, 66, 66),
                  ),),               
                         
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attr2,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Level ' +attr3,
                        style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14),
                      ),
                    ],
                  ),
                  CredentialButton(
                    buttonText: "Follow?",
                    onTap: null,
                  )
                  ],)),],
        ));
  }
}
