import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

// @TODO IMPORTANT - you need to change variable values below
// You need to add your own data from LinkedIn application
// From: https://www.linkedin.com/developers/
// Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
const String redirectUrl = 'https://httpbin.org/';
const String clientId = '78wn08td41odqy';
const String clientSecret = 'OWzUId85qYnXyHID';

class MyApp extends StatelessWidget {
  const MyApp({final Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinkedIn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Profile',
                ),
                Tab(icon: Icon(Icons.text_fields), text: 'Auth code')
              ],
            ),
            title: const Text('LinkedIn Authorization'),
            backgroundColor: Colors.black,
          ),
          body: const TabBarView(
            children: [
              LinkedInProfileExamplePage(),
              LinkedInAuthCodeExamplePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedInProfileExamplePage extends StatefulWidget {
  const LinkedInProfileExamplePage({final Key key}) : super(key: key);

  @override
  State createState() => _LinkedInProfileExamplePageState();
}

class _LinkedInProfileExamplePageState
    extends State<LinkedInProfileExamplePage> {
  UserObject user;
  bool logoutUser = false;

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) => LinkedInUserWidget(
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
                    onGetUserProfile: (final UserSucceededAction linkedInUser) {
                      print(
                        'Access token ${linkedInUser.user.token.accessToken}',
                      );

                      print('User id: ${linkedInUser.user.userId}');

                      user = UserObject(
                        firstName:
                        linkedInUser?.user?.firstName?.localized?.label,
                        lastName:
                        linkedInUser?.user?.lastName?.localized?.label,
                        email: linkedInUser?.user?.email?.elements[0]
                            ?.handleDeep?.emailAddress,
                        profileImageUrl: linkedInUser
                            ?.user
                            ?.profilePicture
                            ?.displayImageContent
                            ?.elements[0]
                            ?.identifiers[0]
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
            onTap: () {
              setState(() {
                user = null;
                logoutUser = true;
              });
            },
            buttonText: 'Logout',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('First: ${user?.firstName} '),
              Text('Last: ${user?.lastName} '),
              Text('Email: ${user?.email}'),
              Text('Profile image: ${user?.profileImageUrl}'),
            ],
          ),
        ],
      ),
    );
  }
}

class LinkedInAuthCodeExamplePage extends StatefulWidget {
  const LinkedInAuthCodeExamplePage({final Key key}) : super(key: key);

  @override
  State createState() => _LinkedInAuthCodeExamplePageState();
}

class _LinkedInAuthCodeExamplePageState
    extends State<LinkedInAuthCodeExamplePage> {
  AuthCodeObject authorizationCode;
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

  final String code;
  final String state;
  final String dummyresponse;
}

class UserObject {
  UserObject({
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
}
