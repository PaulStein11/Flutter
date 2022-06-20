import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/services/snackbar_service.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:bf_pagoda/widgets/TermsWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

AuthProvider? _auth;

class UnknownPage extends StatefulWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  State<UnknownPage> createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedback = "";
  late AuthStatus _status;

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
                    Container(
                      child: Text(
                        "Join the bonfire",
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 35.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    /*SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Get together and create",//"Gather, share and grow",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                            await _auth!.signInWithGoogle().whenComplete(() {
                              print("Method completed from AuthClass");
                            });
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        OurOutlineButton(
                          context: context,
                          text: 'Continue with email',
                          hasIcon: true,
                          icon: FontAwesomeIcons.envelope,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            navigatorKey?.currentState?.pushNamed("login");
                          }
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
                                onPressed: () {
                                  navigatorKey?.currentState?.pushNamed("register");
                                }),
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
