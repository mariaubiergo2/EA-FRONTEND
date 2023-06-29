import 'package:flutter/material.dart';

class MyChatCard extends StatelessWidget {
  final int? index;
  final String attr1;

  const MyChatCard({
    Key? key,
    this.index,
    required this.attr1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 20, 9, 4),
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(14, 11.5, 8, 11),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.5, right: 8.5),
              child: Text(
                "${index! + 1}",
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 222, 66, 66),
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
              child: Container(
                width: 0.75,
                height: 47.5,
                color: const Color.fromARGB(255, 222, 66, 66),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  attr1.length > 19 ? '${attr1.substring(0, 19)}...' : attr1,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 25, 25, 25),
                    fontSize: 17.5,
                  ),
                ),
              ),
            ),
            Container(),
            // Empty container to create space
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(Icons.chevron_right_rounded,
                  color: Color.fromARGB(255, 222, 66, 66), size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
