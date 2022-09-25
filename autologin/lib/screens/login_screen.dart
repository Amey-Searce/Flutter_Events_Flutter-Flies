
import 'package:autologin/controller/auth_controller.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _loginUserData = {
    'email': '',
    'password': '',
  };

  _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    print(_loginUserData);
    AuthController.login(_loginUserData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Login Now'),
      ),
      body: Form(
        key: _formKey,
        child: Card(
          elevation: 5,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: 100,
                    child: Image.network(
                      "https://www.clipartmax.com/png/full/22-224447_neukundengewinnung-kundenbindung-icono-login.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _loginUserData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password required!';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _loginUserData['password'] = value!;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text("Login Now"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print("sing");
                        
                        
                        },
                        child: Text("SignUp Now"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
