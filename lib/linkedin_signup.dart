import 'dart:convert';
import 'package:ecard/ReusableTextField.dart';
import 'package:ecard/scan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

const String redirectUrl = process.env.redirectUrl;
const String clientId = process.env.clientId;
const String clientSecret = process.env.clientSecret;

class LinkedInProfileExamplePage extends StatefulWidget {
  const LinkedInProfileExamplePage({Key? key}) : super(key: key);

  @override
  State createState() => _LinkedInProfileExamplePageState();
}


Container createQR(String email) => Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2.0),
        borderRadius: const BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
            ),
      ),
      child: QrImage(
        data: email,
        size: 250.0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
    );

class _LinkedInProfileExamplePageState
    extends State<LinkedInProfileExamplePage> {

  String qrLink = '';

  getData() async{
    final uid = userUid;
    final ref = FirebaseDatabase.instance.ref("users");
    final snapshot = await ref.child('$uid/Url').get();
    print("==========================================" + uid!);
    if (snapshot.exists) {
      qrLink = snapshot.value.toString();
    } else {
      print('No data available.');
    }
  }

  @override
  initState() {
    super.initState();
    getData();
  }


  String sharedEmail = '';

  UserObject? user;
  bool logoutUser = false;
  AuthCodeObject? authorizationCode;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          user?.profileImageUrl != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            )),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage('${user?.profileImageUrl}'),
                            radius: 25),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('${user?.firstName} ${user?.lastName}',
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white
                              )),
                        )
                      ],
                    ),
                  ),
                )
              :  Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Image.asset('assets/images/LinkUp.png'),
          ),
          user?.email != null
              ? Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 160),
                      child: createQR('${user?.email}'),
                    )
                  ],
                )
              : const SizedBox.shrink(),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  LinkedInButtonStandardWidget(
                    textPadding: EdgeInsets.all(10),
                    iconHeight: 40.5,
                    iconWeight: 40,
                    buttonText: "Generate QR",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (final BuildContext context) =>
                              LinkedInUserWidget(
                            appBar: AppBar(
                              title: const Text('OAuth User'),
                              backgroundColor: Colors.black,
                            ),
                            destroySession: logoutUser,
                            redirectUrl: redirectUrl,
                            clientId: clientId,
                            clientSecret: clientSecret,
                            projection: const [
                              ProjectionParameters.id,
                              ProjectionParameters.localizedFirstName,
                              ProjectionParameters.localizedLastName,
                              ProjectionParameters.firstName,
                              ProjectionParameters.lastName,
                              ProjectionParameters.profilePicture,
                            ],
                            onError: (final UserFailedAction e) {
                              print('Error: ${e.toString()}');
                              print('Error: ${e.stackTrace.toString()}');
                            },
                            onGetUserProfile:
                                (final UserSucceededAction linkedInUser) {
                              print(
                                'Access token ${linkedInUser.user.token.accessToken}',
                              );

                              print('User id: ${linkedInUser.user.userId}');

                              user = UserObject(
                                firstName: linkedInUser
                                    .user.firstName?.localized?.label
                                    .toString(),
                                lastName: linkedInUser
                                    .user.lastName?.localized?.label,
                                email: linkedInUser.user.email?.elements![0]
                                    ?.handleDeep?.emailAddress,
                                profileImageUrl: linkedInUser
                                    .user
                                    .profilePicture
                                    ?.displayImageContent
                                    ?.elements![0]
                                    ?.identifiers![0]
                                    ?.identifier,
                              );

                              setState(() {
                                logoutUser = false;
                              });
                              Navigator.pop(context);
                            },
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                  ),
                  LinkedInButtonStandardWidget(
                    textPadding: EdgeInsets.all(10),
                    iconHeight: 40.5,
                    iconWeight: 40,
                    buttonText: 'Get Token',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (final BuildContext context) =>
                              LinkedInAuthCodeWidget(

                            destroySession: logoutUser,
                            redirectUrl: redirectUrl,
                            clientId: clientId,
                            onError: (final AuthorizationFailedAction e) {
                              print('Error: ${e.toString()}');
                              print('Error: ${e.stackTrace.toString()}');
                            },
                            onGetAuthCode:
                                (final AuthorizationSucceededAction response) {
                              // print('resp:json.decode(${response.codeResponse})');
                              print('resp ${response}');
                              print('Auth code ${response.codeResponse.code}');
                              print('State: ${response.codeResponse.state}');

                              authorizationCode = AuthCodeObject(
                                code: response.codeResponse.code,
                                state: response.codeResponse.state,
                                dummyresponse: response.toString(),
                              );
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      print(authorizationCode?.code);
                    },
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
                child: LinkedInButtonStandardWidget(
                  textPadding: EdgeInsets.all(10),
                  iconHeight: 40.5,
                  iconWeight: 40,
                  onTap: () {
                    setState(() {
                      user = null;
                      logoutUser = true;
                      authorizationCode = null;
                    });
                  },
                  buttonText: 'Logout',
                ),
              ),
            ],
          ),
          user?.email != null
              ? ElevatedButton(

                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScannerScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                      primary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    ),
                  child: const Text(
                    "Expand My Network",
                    style: TextStyle(fontSize: 25),
                  ))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class LinkedInAuthCodeExamplePage extends StatefulWidget {
  const LinkedInAuthCodeExamplePage({final Key? key}) : super(key: key);

  @override
  State createState() => _LinkedInAuthCodeExamplePageState();
}

class _LinkedInAuthCodeExamplePageState
    extends State<LinkedInAuthCodeExamplePage> {
  AuthCodeObject? authorizationCode;
  bool logoutUser = false;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        LinkedInButtonStandardWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (final BuildContext context) => LinkedInAuthCodeWidget(
                  destroySession: logoutUser,
                  redirectUrl: redirectUrl,
                  clientId: clientId,
                  onError: (final AuthorizationFailedAction e) {
                    print('Error: ${e.toString()}');
                    print('Error: ${e.stackTrace.toString()}');
                  },
                  onGetAuthCode: (final AuthorizationSucceededAction response) {
                    // print('resp:json.decode(${response.codeResponse})');
                    print('resp ${response}');
                    print('Auth code ${response.codeResponse.code}');
                    print('State: ${response.codeResponse.state}');

                    authorizationCode = AuthCodeObject(
                      code: response.codeResponse.code,
                      state: response.codeResponse.state,
                      dummyresponse: response.toString(),
                    );
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        LinkedInButtonStandardWidget(
          onTap: () {
            setState(() {
              authorizationCode = null;
              logoutUser = true;
            });
          },
          buttonText: 'Logout user',
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Auth code: ${authorizationCode?.code} '),
              Text('State: ${authorizationCode?.state} '),
              Text('resp: ${authorizationCode?.dummyresponse} '),
              // Text('Response:' json.decode(authorizationCode?)),
            ],
          ),
        ),
      ],
    );
  }
}

class AuthCodeObject {
  AuthCodeObject({this.code, this.state, this.dummyresponse});

  final String? code;
  final String? state;
  final String? dummyresponse;
}

class UserObject {
  UserObject({
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}
