import 'package:flutter/material.dart';

class MyChatTitleCard extends StatelessWidget {
  final String attr1;

  const MyChatTitleCard({
    Key? key,
    required this.attr1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 20, 9, 4),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(14, 11, 8, 11),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(width: 1, color: Colors.amber),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat_bubble,
              color:  Color.fromARGB(255, 222, 66, 66),
            ),
            Container(
              width: 8,
            ),
            Expanded(
              child: Text(
                attr1,
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 25, 25, 25),
                  fontSize: 20,
                ),
              ),
            ),
            Container(),
            // Empty container to create space
            const Text(
              'Chat room'
            )
          ],
        ),
      ),
    );
  }
}
