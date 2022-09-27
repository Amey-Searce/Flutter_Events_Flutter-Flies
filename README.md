# LinkUp application



## Getting Started



## How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
git clone https://github.com/Amey-Searce/Flutter_Events_Flutter-Flies
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

To run the Application:

```
flutter run
```


## App Features:

* Registration
* Login
* Home Screen 
  * Qr code generation
  * Qr Scanning 
  * Expand my network
* LinkedIn Page
  * Get Profile
  * Get Access Token
  
### Dependencies

Depepndecies specify other packages that your package needs for the application to work.

* flutter:
* sdk: flutter
* linkedin_login: ^2.2.1
* cupertino_icons: ^1.0.2
* barcode_scanner: ^3.2.1
* qr_flutter: ^4.0.0
* path_provider: ^2.0.11
* flutter_vector_icons: ^2.0.0
* qr_code_scanner: ^0.7.0
* flutter_email_sender: ^5.1.0
* http: ^0.13.5
* splashscreen: ^1.3.5
* shared_preferences: ^2.0.6
* get: ^4.1.4
* firebase_core: ^1.10.5
* firebase_auth: ^3.3.3
* firebase_database: ^9.1.5
* dev_dependencies:
* flutter_test
* sdk: flutter

### The "flutter_lints" package below contains a set of recommended lints to encourage good coding practices. 
* flutter_lints: ^1.0.0


### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- ios
|- lib
|- test
|- web
|- windows

```

Here is the folder structure we have been using in this project

```
lib
|- ReusableTextField.dart
|- email_sender.dart
|- linked_login.dart
|- linked_signup.dart
|- login_screen.dart.dart
|- main.dart
|- qr_screen.dart
|- registration_screen.dart
|- scan_screen.dart
```

### Main

This is the starting point of the application.

```
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
```


