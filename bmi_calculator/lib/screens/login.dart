import 'package:bmi_calculator/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthProvider _auth = AuthProvider();

  @override
  void initState() {
    super.initState();
    _auth.getUser.then((user) {
      if(user != null) {
        print("User exists");
        Navigator.pushReplacementNamed(context, "/topics");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlutterLogo(
              size: 150,
            ),
            Text(
              'Login to Start',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Text('Your Tagline'),
            LoginButton(
              text: 'LOGIN WITH GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.black45,
              loginMethod: _auth.googleSignIn,
            ),
            /*FutureBuilder<Object>(
              future: _auth.appleSignInAvailable,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return AppleSignInButton(
                    onPressed: () async {
                      User user = await auth.appleSignIn();
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/topics');
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),*/
            LoginButton(text: 'Continue as Guest', loginMethod: _auth.anonLogin)
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key, this.text, this.icon, this.color, this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: Colors.white),
        color: color,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/topics');
          }
        },
        label: Expanded(
          child: Text('$text', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}