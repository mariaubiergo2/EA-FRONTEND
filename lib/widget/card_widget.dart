import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyCard extends StatelessWidget {
  final String name;
  final String descr;
  final String exp;

  const MyCard(
      {Key? key, required this.name, required this.descr, required this.exp})
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
                onPressed: (BuildContext context) {},
                backgroundColor: Colors.red,
                icon: Icons.delete,
              )
            ],
          ),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descr,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exp: $exp',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ));
  }
}
