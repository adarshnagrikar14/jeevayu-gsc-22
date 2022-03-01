// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrReader extends StatefulWidget {
  const QrReader({Key? key}) : super(key: key);

  @override
  _QrReaderState createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  final qrKey = GlobalKey();

  QRViewController? controller;
  Barcode? barcode;
  late bool _scanned;
  late bool _onn;
  late bool _searching;

  // value
  late String _QRvalue;

  static const method1 = MethodChannel('com.project/DeviceID');

  @override
  void initState() {
    super.initState();
    setState(() {
      _scanned = false;
      _onn = true;
      _searching = false;
      _QRvalue = "";
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Scan the QR'),
        backgroundColor: Colors.transparent,
        actions: [
          // settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              child: Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: "Flash",
                child: Icon(
                  _onn ? Icons.flash_on_outlined : Icons.flash_off_sharp,
                  size: 25.0,
                ),
              ),
              onTap: () {
                controller?.toggleFlash();
                setState(() {
                  _onn = !_onn;
                });
              },
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          // result: ${barcode!.code}
          _searching
              ? const CircularProgressIndicator(
                  strokeWidth: 5.0,
                  color: Colors.green,
                )
              : const Text(''),
        ],
      ),
    );
  }

  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderWidth: 10.0,
          cutOutSize: MediaQuery.of(context).size.width * 0.7,
          cutOutBottomOffset: 10.0,
          overlayColor: Colors.black54,
          borderLength: 25.0,
          borderRadius: 20.0,
          borderColor: Colors.green,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.first.then((value) async {
      setState(() {
        barcode = value;
        _scanned = true;
        _searching = true;
      });
      if (_scanned) {
        setState(() {
          _QRvalue = barcode!.code.toString();
        });
        await controller.pauseCamera();
        print(_QRvalue);
        searchFirebase(_QRvalue);
      }
    });
  }

  void searchFirebase(String qRvalue) async {
    var collection = FirebaseFirestore.instance.collection('Devices');
    var docSnapshot = await collection.doc(qRvalue).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String _value = data?['ID'];
      print(_value);
      sendData(_value);
    } else {
      restartACtivity();
    }
  }

  Future<void> sendData(String _value) async {
    var data = <String, dynamic>{"data": _value};
    String value = await method1.invokeMethod("setDeviceID", data);

    if (value == "Done") {
      Navigator.pop(context, _value);
    } else {
      Navigator.pop(context, "Failed");
    }
  }

  void restartACtivity() {
    print('No Data Found or Error');
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const QrReader(),
        ),
      );
    });
  }
}
