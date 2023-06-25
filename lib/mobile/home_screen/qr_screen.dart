import 'dart:developer';
import 'dart:io';
import 'dart:ui';

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
            bottom: 30,
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
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.5),
                    child: Container(
                      height: 475,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 25, 25, 25),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Reto escaneado correctamente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Espacio entre el texto y el contenedor
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.questions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final question = widget.questions[index];
                                  if (index == 0) {
                                    // First item: bold text
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 17.5, right: 17.5, bottom: 25),
                                      child: Text(
                                        question,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    );
                                  } else {
                                    return ListTile(
                                      minVerticalPadding: 1,
                                      title: Text(
                                        question,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.start,
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
                                              _selectedQuestionIndex =
                                                  value as int;
                                              selectedAnswer = question;
                                            });
                                          },
                                          activeColor: const Color.fromARGB(
                                              255,
                                              222,
                                              66,
                                              66), // Set the selected (dot) color of the radial button
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap, // Adjust the size of the radial button
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 32.5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        sendAnswer(
                                            selectedAnswer, widget.idChallenge);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      backgroundColor: const Color.fromARGB(
                                          255, 222, 66, 66),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                    child: const Icon(
                                      Icons.send_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (result != null && result!.code != widget.idChallenge)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Builder(
                    builder: (context) => Center(
                      child: AlertDialog(
                        content: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      const Text(
                                        '¡ERROR!',
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(width: 15),
                                      Container(
                                        width: 32.5,
                                        height: 32.5,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 222, 66, 66),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            color: Colors.white, size: 22.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 35),
                            const Text(
                              'El reto que has escaneado no coincide con el esperado 😢',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                                height: 5), // Espacio entre el texto y la fila
                          ],
                        ),
                        actions: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              label: Text('Volver',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 222, 66, 66),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Ajusta el valor para controlar el nivel de redondez
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                        ],
                        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Ajusta el valor para controlar el nivel de redondez
                        ),
                      ),
                    ),
                  ),
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
