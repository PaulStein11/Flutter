import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendFeedback extends StatefulWidget {
  String id;
  String name;
  String email;

  SendFeedback({this.id, this.name, this.email});

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
        title: Text("Send us your feedback", style: TextStyle(color: Theme.of(context).primaryColor),),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40.0,
                      ),
                      Form(
                        key: _formKeyApp,
                        onChanged: () {
                          _formKeyApp.currentState.save();
                        },
                        child: ExpansionTile(
                          title: Text(
                            "My app is not working",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6
                            ),
                          ),
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                              controller: app,
                              cursorColor: Theme.of(context).accentColor,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    "Let's find out! Tell us more about your problem",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 22.0),
                              child: OurFilledButton(
                                context: context,
                                text: "Send",
                                onPressed: () async {
                                  if (_formKeyApp.currentState.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    final Email email  = Email(
                                      body: app.text,
                                      subject: name,
                                      recipients: [
                                        "pablerillas.11.pb@gmail.com"
                                      ],
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
                                        backgroundColor:
                                            Theme.of(context).accentColor,
                                        content: Text(
                                            'Processing your request $name'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKeySecurity,
                        onChanged: () {
                          _formKeySecurity.currentState.save();
                        },
                        child: ExpansionTile(
                          title: Text(
                            "I'm having security issues",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6
                            ),
                          ),
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                              controller: security,
                              cursorColor: Theme.of(context).accentColor,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    "Please tell us as much detail as possible",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 22.0),
                              child: OurFilledButton(
                                context: context,
                                text: "Send",
                                onPressed: () async {
                                  if (_formKeySecurity.currentState
                                      .validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    final Email email = Email(
                                      body: security.text,
                                      subject: name,
                                      recipients: [
                                        "pablerillas.11.pb@gmail.com"
                                      ],
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
                                        backgroundColor:
                                        Theme.of(context).accentColor,
                                        content: Text(
                                            'Processing your request $name'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKeyLove,
                        onChanged: () {
                          _formKeyLove.currentState.save();
                        },
                        child: ExpansionTile(
                          title: Text(
                            "I'm loving Bonfire",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6
                            ),
                          ),
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                              controller: love,
                              cursorColor: Theme.of(context).accentColor,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    "Yay! We love to hear that! Share with us your experience so far",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 22.0),
                              child: OurFilledButton(
                                context: context,
                                text: "Send",
                                onPressed: () async {
                                  if (_formKeySecurity.currentState
                                      .validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    final Email email = Email(
                                      body: security.text,
                                      subject: name,
                                      recipients: [
                                        "pablerillas.11.pb@gmail.com"
                                      ],
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
                                        backgroundColor:
                                        Theme.of(context).accentColor,
                                        content: Text(
                                            'Processing your request $name'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                      Form(
                        key: _formKeyJoin,
                        onChanged: () {
                          _formKeyJoin.currentState.save();
                        },
                        child: ExpansionTile(
                          title: Text(
                            "I want to be part of Bonfire",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6
                            ),
                          ),
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                              controller: joinTeam,
                              cursorColor: Theme.of(context).accentColor,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    "Alright, tell us how do you want to contribute and we will contact you",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 22.0),
                              child: OurFilledButton(
                                context: context,
                                text: "Send",
                                onPressed: () async {
                                  if (_formKeyJoin.currentState.validate()) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    final Email email = Email(
                                      body: joinTeam.text,
                                      subject: name,
                                      recipients: [
                                        "pablerillas.11.pb@gmail.com"
                                      ],
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
                                        backgroundColor:
                                        Theme.of(context).accentColor,
                                        content: Text(
                                            'Processing your request $name'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
