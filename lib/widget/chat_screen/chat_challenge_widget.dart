import 'package:flutter/material.dart';

class MyChatChallengeCard extends StatelessWidget {
  final int? index;
  final String? attr1;

  const MyChatChallengeCard({
    Key? key,
    this.index,
    this.attr1, 
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(30, 8, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      attr1!,
                      style: const TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 25, 25, 25),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
