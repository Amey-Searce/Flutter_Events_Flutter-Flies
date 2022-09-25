import 'package:ecard/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}


class _QrScreenState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 80),
                child: const Text(
                  "My QR Code",
                  style: TextStyle(fontSize: 50),
                )),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: const BorderRadius.all(Radius.circular(
                        5.0) //                 <--- border radius here
                    ),
              ),
              child: QrImage(
                data: "Piyush Linked In",
                size: 250.0,
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScannerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // <-- Radius
                      )),
                  child: const Text(
                    "Expand My Network",
                    style: TextStyle(fontSize: 25),
                  )),
            )
          ],
        ),
      );
  }
}
