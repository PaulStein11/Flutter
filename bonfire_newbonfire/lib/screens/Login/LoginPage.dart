import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/snackbar_service.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurTextForm.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState>? _formKey;
  late AuthProvider _auth;
  late String _email;
  late String _password;
  late bool _obscureText = true;

  _LoginPageState() {
    _formKey = GlobalKey<FormState>();
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = _obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Sign in"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200, size: 22.0,),
        ),
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
            _formKey!.currentState!.save();
          },
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
                  return _input!.length != 0 && _input!.contains("@")
                      ? null
                      : "Please enter a valid email";
                },
                onSaved: (_input) {
                  setState(() {
                    _email = _input!;
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
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
                validator: (_input) {
                  return _input!.length != 0 && _input!.length > 6
                      ? null
                      : "Password need more than 6 characters";
                },
                onSaved: (_input) {
                  //Do something with the user input.
                  setState(() {
                    _password = _input!;
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
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: () {
                  navigatorKey?.currentState?.pushReplacementNamed("password");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: loginButton()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget loginButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).indicatorColor,
      ),
    )
        : OurFilledButton(
      context: context,
      text: "Sign into account",
      onPressed: () async {
        if (_formKey!.currentState!.validate()) {
          _auth!.loginUserWithEmailAndPassword(_email, _password, context);
        }
      },
    );
  }
}