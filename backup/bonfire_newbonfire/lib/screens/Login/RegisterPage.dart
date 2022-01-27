import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/textForm.dart';
import 'package:bonfire_newbonfire/service/cloud_storage_service.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/media_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/snackbar_service.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'VerificationPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey;
  AuthProvider _auth;
  String _name;
  String _email;
  String _password;
  bool _obscureText = true;
  File _image;

  final picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  _RegisterPageState(/*{this.name}*/) {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance,
            child: registerUI(),
          )),
    );
  }

  Widget registerUI() {
    return Builder(
      builder: (BuildContext _context) {
        SnackBarService.instance.buildContext = _context;
        _auth = Provider.of<AuthProvider>(_context);
        return Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState.save();
          },
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _openImagePicker,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(500),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _image != null
                                  ? FileImage(_image)
                                  : NetworkImage(""),
                            ),
                          ),
                          child: _image != null
                              ? Text("")
                              : Icon(
                                  MyFlutterApp.user,
                                  color: Colors.grey.shade200,
                                  size: 45.0,
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  OurTextForm("Username"),
                  TextFormField(
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.center,
                    onSaved: (_input) {
                      setState(() {
                        _name = _input;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(),
                    validator: (_input) {
                      return _input.length != 0 && _input.length > 6
                          ? null
                          : "Username need more than 6 characters";
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  OurTextForm("Email"),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.center,
                    onSaved: (_input) {
                      setState(() {
                        _email = _input;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(),
                    validator: (_input) {
                      return _input.length != 0 && _input.contains("@")
                          ? null
                          : "Please enter a valid email";
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  OurTextForm("Password"),
                  TextFormField(
                    obscureText: _obscureText,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.center,
                    onSaved: (_input) {
                      setState(() {
                        _password = _input;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(),
                    validator: (_input) {
                      return _input.length != 0 && _input.length > 6
                          ? null
                          : "Password need more than 6 characters";
                    },
                  ),
                  Padding(
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
                          style:
                              TextStyle(color: Colors.white70, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: registerButton(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By tapping 'Register account' you accept Bonfire ",
                      style:
                      TextStyle(color: Colors.white70, fontSize: 15.0,),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Privacy policy",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 15.0,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // code to open / launch terms of service link here
                            },
                        ),
                        TextSpan(
                            text: ' and ',
                            style: TextStyle(
                                fontSize: 15, color: Colors.white70),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // code to open / launch privacy policy link here
                                    })
                            ]),
                        TextSpan(
                            text: '. Check ',
                            style: TextStyle(
                                fontSize: 15, color: Colors.white70),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'easy peasy',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // code to open / launch privacy policy link here
                                    })
                            ]),
                        TextSpan(
                          text: ' version on how we manage your data in our platform and with respect of third party',
                          style: TextStyle(
                              fontSize: 15, color: Colors.white70),
                        ),
                      ],
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget registerButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : Center(
            child: OurFilledButton(
              context: context,
              text: "Register account",
              onPressed: () {
                //Implement registration functionality.
                if (_formKey.currentState.validate() != null) {
                  if (_image != null) {
                    _auth.registerUserWithEmailAndPassword(
                      context,
                      _email,
                      _password,
                      (String _uid) async {
                        var _result = await CloudStorageService.instance
                            .uploadUserImage(_uid, _image);
                        var _imageURL = await _result.ref.getDownloadURL();
                        var tokenId = await OneSignal.shared
                            .getDeviceState()
                            .then((deviceState) {
                          var userTokenId = deviceState.userId;
                          print("$userTokenId");
                          return userTokenId;
                        });
                        await FutureService.instance.createUserInDB(
                            _uid, _name, _email, "", _imageURL, tokenId);
                      },
                    );
                  }
                  if (_image == null) {
                    SnackBarService.instance
                        .showSnackBarError("User image missing", context);
                  }
                }
              },
            ),
          );
  }
}
