import 'package:ea_frontend/mobile/home_screen/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyChallengeListCard extends StatelessWidget {
  final int index;
  final String attr1;
  final String attr2;
  final String attr3;

  const MyChallengeListCard({
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
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(16), // Agregar bordes redondeados
          border: Border.all(
            color: Color.fromARGB(255, 255, 0, 0),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 2.5, 5, 0),
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
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Text(
                                attr2.length >= 60
                                    ? '${attr2.substring(0, 60)}...'
                                    : attr2,
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
          ],
        ),
      ),
    );
  }
}
