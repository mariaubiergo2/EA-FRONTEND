import 'package:flutter/material.dart';

class MyChallengePage extends StatelessWidget {
  const MyChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 350,
        decoration: const BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'images/marker.png',
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Do you want to exit?',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16, left: 16),
              child: Text(
                'If back button is pressed by mistake then click on no to continue.',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // FlatButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Text('No'),
                //   textColor: Colors.white,
                // ),
                const SizedBox(
                  width: 8,
                ),
                // RaisedButton(
                //   onPressed: () {
                //     return Navigator.of(context).pop(true);
                //   },
                //   child: const Text('Yes'),
                //   color: Colors.white,
                //   textColor: Colors.redAccent,
                // )
              ],
            )
          ],
        ),
      );
}
