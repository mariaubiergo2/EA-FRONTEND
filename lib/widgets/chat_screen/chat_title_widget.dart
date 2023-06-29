import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ea_frontend/screens/navbar_mobile.dart';

class MyChatTitleCard extends StatelessWidget {
  final String attr1;

  const MyChatTitleCard({
    Key? key,
    required this.attr1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          padding: const EdgeInsets.fromLTRB(17.5, 18.5, 17.5, 18.5),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 11),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: const NavBar()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Text(
                    attr1.length > 40 ? '${attr1.substring(0, 40)}...' : attr1,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 23,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Color.fromARGB(255, 52, 52, 52),
          height: 0.05,
        ),
      ],
    );
  }
}
