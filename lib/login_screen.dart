import 'package:ecard/ReusableTextField.dart';
import 'package:ecard/registration_screen.dart';
import 'package:ecard/linkedin_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' ;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key); //?

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/LinkUp.gif'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '',
            style: TextStyle(color: Colors.white, fontSize: 33),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 15,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 30,
                ),

                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LinkedInProfileExamplePage()));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                const SizedBox(
                  height: 20,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have account?",
                    style: TextStyle(color: Colors.white70)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyRegister()));
                  },
                  child: const Text(
                    " Sign Up",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

