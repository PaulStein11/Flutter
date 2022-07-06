// @dart=2.9

import 'dart:async';

import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Login/UnknownPage.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
        'assets/images/logo.png'); //<- Creates an object that fetches an image.
    var image = new Image(
        image: assetsImage,
        height: 100); //<- Creates a widget that displays an image.

    return Scaffold(
      /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
      body: Container(
        decoration: new BoxDecoration(color: Theme.of(context).backgroundColor),
        child: new Center(
          child: image,
        ),
      ), //<- place where the image appears
    );
  }
}
