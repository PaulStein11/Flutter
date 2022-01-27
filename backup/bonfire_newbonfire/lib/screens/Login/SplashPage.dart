import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class SplashScreen extends StatelessWidget {
  bool isAuth = false;
  int duration = 0;
  Widget goToPage;

  SplashScreen({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => this.goToPage),
      );
    });
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(
          builder: (BuildContext context) {
            _auth = Provider.of<AuthProvider>(context);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 80.0),
              child:Container(
                alignment: Alignment.center,
                child: DecoratedIcon(
                  MyFlutterApp.fire_alt,
                  color: Theme.of(context).cardColor.withOpacity(0.85),
                  size: 60.0,
                  shadows: [
                    BoxShadow(
                      blurRadius: 7.0,
                      color: Colors.amber.shade300,
                      offset: Offset(0, -6.0),

                    ),
                    BoxShadow(
                      blurRadius: 12.0,
                      color: Colors.amber.shade500,
                      offset: Offset(5, 6.0),
                    ),
                    BoxShadow(
                      blurRadius: 12.0,
                      color: Colors.amber.shade800,
                      offset: Offset(0, 6.0),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
