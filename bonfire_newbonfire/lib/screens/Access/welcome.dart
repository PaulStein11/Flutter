import 'package:bonfire_newbonfire/screens/Access/widgets/amber_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.0,
                    ),
                    width: 160,
                    height: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: Text(
                      "Join the bonfire",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 35.0,
                          letterSpacing: 1.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Amber_Btn_Widget(
                      context: context,
                      text: 'Log In',
                      onPressed: () => Navigator.pushNamed(context, "login"),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Amber_Btn_Widget(
                      context: context,
                      text: 'Register',
                      onPressed: () => Navigator.pushNamed(context, "register"),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
