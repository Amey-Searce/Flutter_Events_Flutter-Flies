import 'package:ecard/ReusableTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'linkedin_signup.dart';
import 'login_screen.dart';
import 'package:firebase_database/firebase_database.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({ Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  SharedPreferences? prefs;
  final databaseReference = FirebaseDatabase.instance.ref();

  void writeData(String email, String name, String url) async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    final uid = user?.uid;
    final ref = FirebaseDatabase.instance.ref("users");

    ref.child(uid!).set({
      'Name': name,
      'Email': email,
      'Url ': url
    });
  }

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _urlTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      ),
      child: Scaffold(
        backgroundColor: Colors.black,

        body: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,

            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 180, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("SIGN UP",
                        style: TextStyle(fontSize: 35, color: Colors.white),),
                      const SizedBox(
                        height: 40,
                      ),
                      reusableTextField(
                          "Enter LinkedIn url", Icons.share, false,
                          _urlTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Enter Name", Icons.person_outline, false,
                          _userNameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Enter Email Id", Icons.person_outline, false,
                          _emailTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          "Enter Password", Icons.lock_outlined, true,
                          _passwordTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      firebaseUIButton(context, "Sign Up", () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: _emailTextController.text.trim(),
                            password: _passwordTextController.text)
                            .then((value) {
                          print("Created New Account");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  LinkedInProfileExamplePage()));
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                        writeData(_emailTextController.text,_userNameTextController.text,_urlTextController.text);

                      }),

                      TextButton(
                        onPressed: () {
                          //Navigator.pushNamed(context, 'register');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (
                                context) => const Login()),
                          );
                        },
                        child: const Text(
                          'Or Login',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                        style: ButtonStyle(),
                      )
                    ],
                  ),
                ))),

      ),
    );
  }
  }
