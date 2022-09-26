import 'dart:convert';
import 'package:ecard/email_sender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' as IO;
import 'package:firebase_database/firebase_database.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String user_mail = '';
  String user_name = '';
  String user_url = '';
  getData() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    final uid = user?.uid;
    final ref = FirebaseDatabase.instance.ref("users");
    final snapshot = await ref.child('$uid/Email').get();
    print("==========================================" + uid!);
    if (snapshot.exists) {
      user_mail = snapshot.value.toString();
    } else {
      print('No data available.');
    }
    final snapshot2 = await ref.child('$uid/Name').get();
    if (snapshot2.exists) {
      user_name = snapshot2.value.toString();
    } else {
      print('No data available.');
    }
    final snapshot3 = await ref.child('$uid/url').get();
    if (snapshot3.exists) {
      user_url = snapshot3.value.toString();
    } else {
      print('No data available.');
    }
  }

  Future sendEmail(
      {required String name,
        required String email,
        required String subject,
        required String message}) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http.post(url,
        headers: {
          'origin': '*',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': 'service_wfzd22n',
          'template_id': 'template_0wvm5ia',
          'user_id': 'HLVRJFFGJXI14qN9J',
          'template_params': {
            'receiver': email,
            'to_name': name,
            'from_name': 'LinkUp',
            'message': message
          }
        }));
  }


  @override
  void reassemble() {
    super.reassemble();
    if (IO.Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  bool flash = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Data: ${result!.code}')
                  else
                    const Text(''),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                            },
                            child: Icon(
                              flash ? Icons.flash_on : Icons.flash_off,
                              color: flash ? Colors.blue : Colors.grey,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            child: Text('Send Request'),
                            onPressed: () {
                            sendEmail(name: user_name, email: user_name, subject: '$user_name wants to connect to you', message: " Click on ${user_url} to accept ${user_name}\'s request");
                            },
                            ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 0,
          borderLength: 40,
          borderWidth: 20,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
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
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
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
