// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/const/consts.dart';
import 'package:qr_scanner/pages/resultScreen.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;

  @override
  Widget build(BuildContext context) {
    // controller?.resumeCamera();

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              QRView(
                key: qrKey,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 20,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8,
                ),
                overlayMargin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.3,
                ),
                formatsAllowed: [
                  BarcodeFormat.aztec,
                  BarcodeFormat.codabar,
                  BarcodeFormat.code39,
                  BarcodeFormat.code93,
                  BarcodeFormat.code128,
                  BarcodeFormat.dataMatrix,
                  BarcodeFormat.ean8,
                  BarcodeFormat.ean13,
                  BarcodeFormat.itf,
                  BarcodeFormat.maxicode,
                  BarcodeFormat.pdf417,
                  BarcodeFormat.qrcode,
                  BarcodeFormat.rss14,
                  BarcodeFormat.upcA,
                  BarcodeFormat.upcE,
                  BarcodeFormat.upcEanExtension,
                  BarcodeFormat.rssExpanded,
                  BarcodeFormat.unknown,
                ],
                onQRViewCreated: (controller) {
                  Consts.controller = controller;
                  controller.scannedDataStream.listen((scanData) {
                    controller.pauseCamera();
                    setState(() {
                      result = scanData;
                      if (result != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Resultscreen(result: result!.code),
                          ),
                        );
                      } else {
                        controller.resumeCamera();
                      }
                    });
                  });
                },
              ),
              // Bilgilendirme metni
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.35,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Point the camera at the target to scan the QR code.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // Flash button
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white70),
                    onPressed: () async {
                      await Consts.controller!.toggleFlash();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
