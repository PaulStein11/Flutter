import "dart:io";
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/service/cloud_storage_service.dart';
import 'package:bonfire_newbonfire/service/media_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _usernameIsValid = true;
  bool _bioIsValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "My profile",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: isLoading
          ? OurLoadingWidget(context)
          : ChangeNotifierProvider<AuthProvider>.value(
              value: AuthProvider.instance,
              child: Builder(
                builder: (BuildContext context) {
                  var _auth = Provider.of<AuthProvider>(context);
                  return StreamBuilder<MyUserModel>(
                    stream: StreamService.instance.getUserData(_auth.user.uid),
                    builder: (context, snapshot) {
                      var _userData = snapshot.data;
                      if (!snapshot.hasData) {
                        return OurLoadingWidget(context);
                      }
                      return Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 1.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(25.0),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _textEditorTitle("Your username"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white70),
                                              controller: displayNameController,
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    // width: 0.0 produces a thin "hairline" border
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey,
                                                            width: 0.0),
                                                  ),
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  hintText:
                                                      displayNameController
                                                              .text =
                                                          _userData.name,
                                                  errorText: _usernameIsValid
                                                      ? null
                                                      : "Display name too short"),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _textEditorTitle("Bio"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.multiline,
                                              minLines: 1,
                                              //Normal textInputField will be displayed
                                              maxLines: 5,
                                              // when user presses enter it will adapt to it
                                              style: TextStyle(
                                                  color: Colors.white70),
                                              controller: bioController,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  // width: 0.0 produces a thin "hairline" border
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.0),
                                                ),
                                                labelText: "Update Bio",
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintText: bioController.text =
                                                    _userData.bio,
                                                errorText: _bioIsValid
                                                    ? null
                                                    : "Bio is too long",
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                OurFilledButton(
                                  context: context,
                                  text: "Update",
                                  onPressed: () async {
                                    setState(() {
                                      displayNameController.text.trim().length <
                                                  3 ||
                                              displayNameController.text.isEmpty
                                          ? _usernameIsValid = false
                                          : _usernameIsValid = true;
                                      bioController.text.trim().length > 120
                                          ? _bioIsValid = false
                                          : _bioIsValid = true;
                                    });

                                    if (_usernameIsValid & _bioIsValid) {
                                      await Firestore.instance
                                          .collection("Users")
                                          .document(_auth.user.uid)
                                          .updateData({
                                        "name": displayNameController.text,
                                        "bio": bioController.text,
                                      });
                                      SnackBar snackbar = SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.all(
                                            new Radius.circular(12),
                                          ),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        content: Text(
                                          "Profile updated",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .cardColor
                                                  .withOpacity(0.85),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                      );
                                      _scaffoldKey.currentState
                                          .showSnackBar(snackbar);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  _textEditorTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3),
      ),
    );
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _textEditorTitle("Your username"),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextField(
            style: TextStyle(color: Colors.white70),
            controller: displayNameController,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                labelText: "Update username",
                labelStyle: TextStyle(color: Colors.grey),
                hintText: "Update Username",
                errorText: _usernameIsValid ? null : "Display name too short"),
          ),
        )
      ],
    );
  }
}
/*Container(
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        kAmberColor,
                                        Colors.red,
                                      ],
                                    ),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: _userData.image != "" ? NetworkImage(_userData.image) : AssetImage("assets/images/flame_icon1.png")
                                    ),
                                  ),
                                ),*/
/*
  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Bio",
              style: TextStyle(color: kBelongMarineBlue),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextField(
            style: TextStyle(color: kBelongMarineBlue),
            controller: bioController,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Colors.grey, width: 0.0),
              ),
              labelText: "Update Bio",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: bioController.text = _userData.name,
              errorText: _bioIsValid ? null : "Bio is too long",
            ),
          ),
        )
      ],
    );
  }*/
