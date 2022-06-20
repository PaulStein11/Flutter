import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/snackbar_service.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurTextForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/navigation_service.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  //late AuthProvider _auth;
  late String resetEmail;
  GlobalKey<FormState>? _resetKey;

  _ForgotPassPageState() {
    _resetKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Reset password"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade200,
              size: 22.0,
            ),
          ),
        ),
        body: _resetPasswordUI());
  }

  Widget _resetPasswordUI() {
    return Builder(builder: (BuildContext context) {
      SnackBarService.instance.buildContext = context;
      return Form(
        key: _resetKey,
        onChanged: () => _resetKey!.currentState!.save(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Enter your email",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade200),
              ),
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
                onSaved: (input) {
                  setState(() {
                    resetEmail = input!;
                  });
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration,
              ),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(child: resetButton()),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget resetButton() {
    return OurFilledButton(
      context: context,
      text: "Reset password",
      onPressed: () async {
        if (_resetKey!.currentState!.validate()) {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: resetEmail);
            SnackBarService.instance.showSnackBarSuccess(
                "An email was sent to reset your password", context);
          } on FirebaseAuthException catch (err) {
            if (err.code == 'user-not-found') {
              SnackBarService.instance
                  .showSnackBarError("Email doesn't exist", context);
              print('No user found for that email.');
            }
          } catch (e) {
            SnackBarService.instance
                .showSnackBarError("Not able to reset new password", context);
            print(e);
          }
        }
      },
    );
  }
}
