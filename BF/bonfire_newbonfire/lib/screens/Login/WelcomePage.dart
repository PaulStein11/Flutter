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
  bool isLoading = false;

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
                            setState(() {
                              isLoading = true;
                            });
                            await _auth.googleSignIn();
                            setState(() {
                              isLoading = false;
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
