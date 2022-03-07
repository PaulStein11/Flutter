import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/textForm.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/service/snackbar_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  String _email;
  String _password;
  bool _obscureText = true;

  _LoginPageState() {
    _formKey = GlobalKey<FormState>();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Sign in"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: ChangeNotifierProvider<AuthProvider>.value(
          value: AuthProvider.instance,
          child: _loginUI(),
        ),
      ),
    );
  }

  Widget _loginUI() {
    return Builder(
      builder: (BuildContext _context) {
        SnackBarService.instance.buildContext = _context;
        _auth = Provider.of<AuthProvider>(_context);
        return Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState.save();
          },
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                OurTextForm("Email"),
                TextFormField(
                  autofillHints: [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 20.0),
                  textAlign: TextAlign.left,
                  validator: (_input) {
                    return _input.length != 0 && _input.contains("@")
                        ? null
                        : "Please enter a valid email";
                  },
                  onSaved: (_input) {
                    setState(() {
                      _email = _input;
                    });
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration,
                ),
                SizedBox(
                  height: 20.0,
                ),
                OurTextForm("Password"),
                TextFormField(
                  obscureText: _obscureText,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 20.0,),
                  textAlign: TextAlign.left,
                  validator: (_input) {
                    return _input.length != 0 && _input.length > 6
                        ? null
                        : "Password need more than 6 characters";
                  },
                  onSaved: (_input) {
                    //Do something with the user input.
                    setState(() {
                      _password = _input;
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    suffixIcon: IconButton(
                      iconSize: 20.0,
                      onPressed: _toggle,
                      icon: _obscureText
                          ? Icon(
                        FontAwesomeIcons.solidEye,
                        color: Colors.grey,
                      )
                          : Icon(
                        FontAwesomeIcons.solidEyeSlash,
                        color: Colors.white70,
                      ),
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                /*Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        splashRadius: 0.1,
                        onPressed: _toggle,
                        icon: _obscureText
                            ? Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.white70,
                              )
                            : Icon(
                                Icons.check_box,
                                color: Colors.white70,
                              ),
                      ),
                      Text(
                        "Show password",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),*/
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Center(child: loginButton()),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loginButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : OurFilledButton(
            context: context,
            text: "Sign into account",
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _auth.loginUserWithEmailAndPassword(_email, _password, context);
              }
            },
          );
  }
}
