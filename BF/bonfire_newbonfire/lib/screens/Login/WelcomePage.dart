import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:provider/provider.dart';

import 'RegisterPage.dart';

AuthProvider _auth;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05,
                      ),
                      width: 150,
                      height: 140.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Join the bonfire",
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 32.0,
                            letterSpacing: 1.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Gather, share and grow",
                        style: TextStyle(
                            color: Colors.grey.shade400,//Theme.of(context).primaryColor,
                            fontSize: 17.0,
                            letterSpacing: 0.0,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    OurFilledButton(
                      context: context,
                      text: 'Log In',
                      onPressed: () => Navigator.pushNamed(context, "login"),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    OurOutlineButton(
                      context: context,
                      text: 'Register',
                      hasIcon: false,
                      color: Theme.of(context).primaryColor,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
