// @dart=2.9

import 'dart:async';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Login/UnknownPage.dart';

import 'package:flutter/material.dart';


AuthProvider _auth;

class SplashPage extends StatefulWidget {
  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashPage>  {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => UnknownPage())));


    var assetsImage = new AssetImage(
        'assets/images/logo.png');
    var image = new Image(
        image: assetsImage,
        height: 100);

    return Scaffold(

      body: Container(
        decoration: new BoxDecoration(color: Theme.of(context).backgroundColor),
        child: new Center(
          child: image,
        ),
      ),
    );
  }
}
