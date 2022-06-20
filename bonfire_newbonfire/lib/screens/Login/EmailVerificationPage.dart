import 'dart:async';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late bool _isUserEmailVerified;
  late Timer _timer;
  late AuthProvider _auth;

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        _timer = Timer.periodic(
          Duration(seconds: 8),
          (timer) async {
            (await FirebaseAuth.instance.currentUser)!..reload();
            var user = await FirebaseAuth.instance.currentUser;
            if (user!.emailVerified == true) {
              navigatorKey?.currentState?.pushReplacementNamed("onboarding");
              timer.cancel();
            } else {
              print("Routing not taking me to OnboardingPage");
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "Create account",
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "We have sent you an email",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 45.0),
                  Icon(
                    FontAwesomeIcons.envelopeOpenText,
                    size: 50.0,
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                  SizedBox(height: 45.0),
                  Text(
                    "Verify the link to continue",
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        //Theme.of(context).accentColor,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
