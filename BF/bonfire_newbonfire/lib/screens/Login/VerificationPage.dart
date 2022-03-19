import 'dart:async';
import 'package:bonfire_newbonfire/screens/screens.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';

class EmailVerificationScreen extends StatefulWidget {


  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState(
      );
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isUserEmailVerified;
  Timer _timer;


  @override
  void initState() {
    super.initState();
    Future(
      () async {
        _timer = Timer.periodic(
          Duration(seconds: 2),
          (timer) async {
            await FirebaseAuth.instance.currentUser()
              ..reload();
            var user = await FirebaseAuth.instance.currentUser();
            if (user.isEmailVerified) {
              setState(
                () {
                  _isUserEmailVerified = user.isEmailVerified;
                  NavigationService.instance.navigateToReplacement("onboarding");
                },
              );
              timer.cancel();
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
                  SizedBox(height: 25.0),
                  Container(
                    decoration: BoxDecoration(
                      //color: Colors.grey,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/email1.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.0),
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
