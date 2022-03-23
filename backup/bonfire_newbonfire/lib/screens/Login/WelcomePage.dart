import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/TermsWidget.dart';
import 'package:bonfire_newbonfire/screens/Privacy/TermsPrivacyPage.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isAuth = false;
  final _formKey = GlobalKey<FormState>();
  String _feedback = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onDoubleTap: () {
                          print("Hello world");
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "Sharing feedback",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 30.0),
                                            child: Form(
                                              key: _formKey,
                                              onChanged: () =>
                                                  _formKey.currentState.save(),
                                              child: TextFormField(
                                                maxLines: 3,
                                                style: TextStyle(color: Colors.grey.shade200, fontSize: 15.0),
                                                validator: (input) {
                                                  return input.isEmpty
                                                      ? "Need to add something"
                                                      : null;
                                                },
                                                onSaved: (input) {
                                                  _feedback = input;
                                                },
                                              ),
                                            ),
                                          ),
                                          OurFilledButton(
                                            context: context,
                                            text: "Submit",
                                            onPressed: () async {
                                              if(_formKey.currentState.validate()) {
                                                final Email email  = Email(
                                                  body: _feedback,
                                                  subject: "Feedback - Welcome Screen",
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

                                                /*if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                    Theme.of(context).accentColor,
                                                    content: Text(
                                                        'Thanks for your feedback!'),
                                                  ),
                                                );    */                                          }
                                            }
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: Container(
                          width: 100,
                          height: 90.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Join the bonfire",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Gather, share and grow",
                      style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 17,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OurOutlineButton(
                          context: context,
                          text: 'Continue with Google',
                          hasIcon: true,
                          icon: FontAwesomeIcons.google,
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            await _auth.googleSignIn();
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        OurOutlineButton(
                          context: context,
                          text: 'Continue with email',
                          hasIcon: true,
                          icon: Icons.email,
                          color: Theme.of(context).primaryColor,
                          onPressed: () =>
                              Navigator.pushNamed(context, "login"),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            color: Theme.of(context).primaryColor,
                          )),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Or",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.7)),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            color: Theme.of(context).primaryColor,
                          )),
                        ]),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0),
                            ),
                            FlatButton(
                              minWidth: 0,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () =>
                                  Navigator.pushNamed(context, "register"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                TermsOfPrivacyForUsers(context)
              ],
            ),
          );
        }),
      ),
    );
  }
}
