import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyChallengeCard extends StatelessWidget {
  final int index;
  final String attr1;
  final String attr2;
  final String attr3;

  const MyChallengeCard({
    Key? key,
    required this.index,
    required this.attr1, //name of the challenge
    required this.attr2, //description of the challenge
    required this.attr3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 20, 9, 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 222, 66, 66),
          borderRadius: BorderRadius.circular(16), // Agregar bordes redondeados
        ),
        child: Column(
          children: [
            Slidable(
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.27,
                children: [
                  SlidableAction(
                    onPressed: (BuildContext context) {
                      Navigator.pushNamed(context, '/qr_screen');
                    },
                    backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                    icon: Icons.camera_alt_rounded,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 5,
                            backgroundColor: Color.fromARGB(255, 248, 188, 6),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            attr3,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 25, 25),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 222, 66, 66),
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(30, 17.5, 15, 17.5),
                          child: Container(
                            width: 1.35,
                            height: 65,
                            color: const Color.fromARGB(255, 222, 66, 66),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 2.5, 5, 0),
                                child: Text(
                                  attr1,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 25, 25, 25),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 12, 0),
                                child: Text(
                                  '${attr2.substring(0, 60)}...',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.normal,
                                    color: Color.fromARGB(255, 25, 25, 25),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
