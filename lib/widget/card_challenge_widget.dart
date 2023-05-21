import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyChallengeCard extends StatelessWidget {
  final int index;
  final String attr1;
  final String attr2;
  final String attr3;

  const MyChallengeCard(
      {Key? key,
      required this.index,
      required this.attr1, //name of the challenge
      required this.attr2, //description of the challenge
      required this.attr3}) //experience the challenge gives
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Slidable(
          startActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, '/qr_screen');
                },
                backgroundColor: Colors.red,
                icon: Icons.qr_code,
                borderRadius: BorderRadius.circular(12),
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(30.0, 8, 8, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                      child: ClipOval(
                        child: Text(
                          (this.index + 1).toString(),
                          style: const TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 34,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 12, 0),
                      child: Container(
                        width: 1,
                        height: 100,
                        color: const Color.fromARGB(255, 222, 66, 66),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            attr1,
                            style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attr2,
                            style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.amber,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            attr3,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
