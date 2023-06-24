import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MyQR extends StatefulWidget {
  final String idChallenge;
  final List<String> questions;
  const MyQR({
    Key? key,
    required this.idChallenge,
    required this.questions,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  Barcode? result;
  String? answer;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showFloatingButton = true;
  int _selectedQuestionIndex = -1;
  String selectedAnswer = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    void sendAnswer(String answer, String idChallenge) async {
      try {
        var response = await Dio().post(
          'http://${dotenv.env['API_URL']}/challenge/post/solve',
          data: {"idChallenge": idChallenge, "answer": answer},
        );
        print(
            "DATA DEL RESPONSE DE LA RESPUESTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        print(response.data);
      } catch (e) {}
    }

    return SafeArea(
      child: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color.fromARGB(255, 222, 66, 66),
              borderRadius: 20,
              borderLength: 35,
              borderWidth: 13,
              cutOutSize: scanArea + 20,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          if (showFloatingButton)
            Positioned(
              top: 25,
              left: 25,
              child: FloatingActionButton(
                onPressed: () async {
                  await controller?.pauseCamera();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/navbar');
                },
                backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 30, 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                      foregroundColor: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Icon(
                            snapshot.data == true
                                ? Icons.flash_on
                                : Icons.flash_off,
                            size: 24,
                          );
                        } else {
                          return const Icon(
                            Icons.access_time_filled,
                            size: 24,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 222, 66, 66),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color.fromARGB(255, 222, 66, 66),
                      foregroundColor: Colors.white,
                    ),
                    child: FutureBuilder(
                      future: controller?.getCameraInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return const Icon(
                            Icons.sync_rounded,
                            size: 24,
                          );
                        } else {
                          return const Icon(
                            Icons.access_time_filled,
                            size: 24,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (result != null && result!.code == widget.idChallenge)
                //AQUI LOGICA DE SI TODO GUCCI
                Container(
                  height: 485,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 25, 25, 25),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final question = widget.questions[index];
                        if (index == 0) {
                          // First item: bold text
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              question,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return ListTile(
                            title: Text(
                              question,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            leading: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors
                                    .white, // Set the unselected (background) color of the radial button
                              ),
                              child: Radio(
                                value: index,
                                groupValue: _selectedQuestionIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedQuestionIndex = value as int;
                                    selectedAnswer = question;
                                    print(
                                        'RESPUESTA A ENVIAR!!!!!! --------------------------> $selectedAnswer');
                                  });
                                },
                                activeColor: Colors
                                    .red, // Set the selected (dot) color of the radial button
                                materialTapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // Adjust the size of the radial button
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                )
              else if (result != null && result!.code != widget.idChallenge)
                Builder(
                  builder: (context) => Center(
                    child: AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'El resultado no coincide con el desafío esperado.'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: const Text('Cerrar'),
                        ),
                      ],
                      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  sendAnswer(selectedAnswer, widget.idChallenge);
                },
                child: Text('Send Petition'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
