// @dart=2.9

import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
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
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35.0,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage("assets/images/flame_sharp_white.png")
                      )
                  ),
                ),
                CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
