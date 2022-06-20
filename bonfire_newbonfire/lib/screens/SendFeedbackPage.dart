import 'package:bf_pagoda/widgets/OurLeadingIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/OurFilledButton.dart';

class SendFeedback extends StatefulWidget {
  String id;
  String name;
  String email;

  SendFeedback({required this.id, required this.name, required this.email});

  @override
  _SendFeedbackState createState() =>
      _SendFeedbackState(this.id, this.name, this.email);
}

class _SendFeedbackState extends State<SendFeedback> {
  String id;
  String name;
  String email;
  final _formKeyApp = new GlobalKey<FormState>();
  final _formKeySecurity = new GlobalKey<FormState>();
  final _formKeyLove = new GlobalKey<FormState>();
  final _formKeyJoin = new GlobalKey<FormState>();

  TextEditingController app = TextEditingController();
  TextEditingController security = TextEditingController();
  TextEditingController love = TextEditingController();
  TextEditingController joinTeam = TextEditingController();

  _SendFeedbackState(this.id, this.name, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Send feedback",
          style:
             Theme.of(context).textTheme.headline6
        ),
        leading: OurLeadingIcon(context),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKeyApp,
            onChanged: () {
              _formKeyApp.currentState!.save();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Text(
                    "Want to share something?",
                    style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Tell us about it!",
                    style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                    controller: app,
                    cursorColor: Theme.of(context).accentColor,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Start writing here",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OurFilledButton(
                        context: context,
                        text: "Send",
                        onPressed: () async {
                          if (_formKeyApp.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            final Email email = Email(
                              body: app.text,
                              subject: "Feedback sent by - " + name,
                              recipients: ["pablerillas.11.pb@gmail.com"],
                            );

                            String platformResponse;

                            try {
                              await FlutterEmailSender.send(email);
                              platformResponse = 'success';
                            } catch (error) {
                              platformResponse = error.toString();
                            }

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Theme.of(context).accentColor,
                                content: Text('Processing your request $name'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
