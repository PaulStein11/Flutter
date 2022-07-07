import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/future_services.dart';
import 'package:bf_pagoda/services/snackbar_service.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurTextForm.dart';
import 'package:bf_pagoda/widgets/TermsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late GlobalKey<FormState> _formKey;
  late AuthProvider _auth;
  late String _name;
  late String _email;
  late String _password;
  late bool _obscureText = true;
  var image;
  final picker = ImagePicker();

  // Implementing the image picker
  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        File image = File(pickedImage.path);
      });
    }
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
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
        title: Text("Sign up"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey.shade200,
            size: 22.0,
          ),
        ),
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
            _formKey.currentState!.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*GestureDetector(
                        onTap: _getFromGallery,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(500),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.file(
                                image,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.fitHeight,
                              ) as ImageProvider
                            ),
                          ),
                          child:Icon(
                            FontAwesomeIcons.user,
                            color: Colors.grey.shade200,
                            size: 45.0,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  OurTextForm("Username"),
                  TextFormField(
                    autofillHints: [AutofillHints.name],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.left,
                    onSaved: (_input) {
                      setState(() {
                        _name = _input!;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(),
                    validator: (_input) {
                      return _input!.length != 0 && _input!.length > 6
                          ? null
                          : "Username need more than 6 characters";
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  OurTextForm("Email"),
                  TextFormField(
                    autofillHints: [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.left,
                    onSaved: (_input) {
                      setState(() {
                        _email = _input!;
                      });
                    },
                    decoration: kTextFieldDecoration.copyWith(),
                    validator: (_input) {
                      return _input!.length != 0 && _input!.contains("@")
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
                    textAlign: TextAlign.left,
                    onSaved: (_input) {
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
                    validator: (_input) {
                      return _input!.length != 0 && _input!.length > 6
                          ? null
                          : "Password need more than 6 characters";
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: registerButton(),
              ),
              TermsOfPrivacyForUsers(context),
            ],
          ),
        );
      },
    );
  }

  Widget registerButton() {
    return _auth.status == AuthStatus.Authenticating
        ? Align(
            alignment: Alignment.center,
            child: Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                color: Theme.of(context).accentColor,
                size: 28.0,
              ),
            ),
          )
        : Center(
            child: OurFilledButton(
              context: context,
              text: "Register account",
              onPressed: () {
                //Implement registration functionality.
                if (_formKey.currentState!.validate() != null) {
                  _auth.registerUserWithEmailAndPassword(
                    context,
                    _email,
                    _password,
                    (String _uid) async {
                      /*var _result = await CloudStorageService.instance
                            .uploadUserImage(_uid, _image);
                        var _imageURL = await _result.ref.getDownloadURL();
                        var tokenId = await OneSignal.shared
                            .getDeviceState()
                            .then((deviceState) {
                          var userTokenId = deviceState.userId;
                          print("$userTokenId");
                          return userTokenId;
                        });*/
                      await FutureServices.instance
                          .createUserInDB(_uid, _name, _email, "", "", "");
                    },
                  );
                  /*if (image == null) {
                    print("user image missing");
                    SnackBarService.instance
                        .showSnackBarError("User image missing", context);
                  }*/
                }
              },
            ),
          );
  }
}
