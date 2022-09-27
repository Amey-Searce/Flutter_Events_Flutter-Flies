import 'package:ecard/registration_screen.dart';
import 'package:ecard/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final authController = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(
        image: Image.asset(
          'assets/images/LinkUp.gif',
          height: 400,
          width: 400,
          scale: 2,
        ),
        seconds: 2,
        navigateAfterSeconds: FutureBuilder(
            builder: (context, authResult) {
                if (authResult.data == true) {
                  return MyRegister();
                }
                return Login();
              }

  ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyRegister(),
    );
  }
}
