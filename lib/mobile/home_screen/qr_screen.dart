import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MyQR extends StatefulWidget {
  final String idChallenge;

  const MyQR({
    Key? key,
    required this.idChallenge,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyQRState();
}

class _MyQRState extends State<MyQR> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool showFloatingButton = true;

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
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (result != null && result!.code == widget.idChallenge)
                  Container(
                    height: 485,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 25, 25, 25),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                Row(
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
                          backgroundColor:
                              const Color.fromARGB(255, 222, 66, 66),
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
                          backgroundColor:
                              const Color.fromARGB(255, 222, 66, 66),
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
              ],
            ),
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
