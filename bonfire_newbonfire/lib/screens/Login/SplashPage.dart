// @dart=2.9

import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class SplashPage extends StatelessWidget {
  bool isAuth = false;
  int duration = 0;
  //Widget goToPage;

  //SplashScreen({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    /*Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => this.goToPage),
      );
    });*/
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(
          builder: (BuildContext context) {
            _auth = Provider.of<AuthProvider>(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(color: Theme.of(context).primaryColor,)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
