import 'package:ecard/email_sender.dart';
import 'package:ecard/linkedin_login.dart';
import 'package:ecard/qr_screen.dart';
import 'package:ecard/scan_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tabs = [QrScreen(), ScannerScreen()];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: QrScreen(),
    );
  }
}
