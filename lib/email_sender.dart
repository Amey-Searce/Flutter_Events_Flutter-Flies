import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(EmailSender());

class EmailSender extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<EmailSender> {
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
            'from_name': 'Linkedin',
            'message': message
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("fkvskjn"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sendEmail(
                name: 'Piyush',
                email: 'rnrn24rn@gmail.com',
                subject: 'subject',
                message: 'Someone wants to connect to you');
          },
          child: Text('Send Email'),
        ),
      ),
    );
  }
}
