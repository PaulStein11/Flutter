import 'dart:io';

import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/stream_services.dart';
import '../../widgets/OurFilledButton.dart';
import '../../widgets/OurLoadingWidget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AuthProvider _auth;

  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _usernameIsValid = true;
  bool _bioIsValid = true;
  late File _image;
  final picker = ImagePicker();

  /*Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
    var _result = await FirebaseStorage.instance
        .uploadUserImage(_auth.user!.uid, _image);
    var _imageURL = await _result.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.user!.uid)
        .update({
      "profileImage": _imageURL.toString(),
    });
  }*/

  @override
  Widget build(BuildContext context) {
    /*---------------------------*/
    //TODO: CHANGE WILLPOPSCREEN TO GUIDE USER TO PREVIOUS SCREEN INSTEAD OF HOMESCREEN
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit profile", style: Theme.of(context).textTheme.headline6,),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200, size: 22.0,),
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
              stream: StreamServices.instance.getUserData(_auth.user!.uid),
              builder: (context, snapshot) {
                var _userData = snapshot.data;
                if (!snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(25.0),
                                      child: Column(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              /*Padding(
                                                        padding: const EdgeInsets.only(bottom: 20.0),
                                                        child: Center(
                                                          child: AppUserProfile(
                                                            icon: Icons.person,
                                                            hasImage: _userData.profileImage.isEmpty ? false : true,
                                                            size: 43.0,
                                                            imageFile: _userData.profileImage,
                                                            color:
                                                            _userData.name[0] == "P" ? Colors.orangeAccent : Colors.blueAccent,
                                                            iconSize: 35.0,
                                                            onPressed: _openImagePicker,
                                                          ),
                                                        ),
                                                      ),*/
                                              SizedBox(height: 30.0,),
                                              _textEditorTitle("Username"),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(top: 5.0),
                                                child: TextField(
                                                  style: TextStyle(
                                                      color: Colors.grey.shade300),
                                                  controller: displayNameController,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0.0),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey.shade600),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey.shade400),
                                                      ),
                                                      border: UnderlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey.shade400),
                                                      ),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey.shade600),
                                                      hintText:
                                                      displayNameController
                                                          .text =
                                                          _userData!.name,
                                                      errorText: _usernameIsValid
                                                          ? null
                                                          : "Display name too short"),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
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
                                                      color: Colors.grey.shade600),
                                                  controller: bioController,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0.0),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey.shade600),
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                                    ),
                                                    border: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: Colors.grey.shade400),
                                                    ),
                                                    hintStyle: TextStyle(
                                                        color: Theme.of(context).primaryColor),
                                                    hintText: _userData.bio.isEmpty ? "Hi there!" : bioController.text =
                                                        _userData!.bio,
                                                    errorText: _bioIsValid
                                                        ? null
                                                        : "Bio is too long",
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  _textEditorTitle("Email"),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Text(_userData!.email, style: TextStyle(color: Colors.grey.shade300, fontSize: 16.0),),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                      MediaQuery.of(context).size.height * 0.18,
                                    ),
                                    OurFilledButton(
                                      context: context,
                                      text: "Save",
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
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(_auth.user!.uid)
                                              .update({
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
                                          navigatorKey?.currentState?.pushReplacementNamed("profile");
                                          /*_scaffoldKey.currentState
                                              .showSnackBar(snackbar);*/
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
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
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _textEditorTitle("Username"),
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
                labelStyle: TextStyle(color: Colors.grey.shade300),
                hintText: "Update Username",
                errorText: _usernameIsValid ? null : "Display name too short"),
          ),
        )
      ],
    );
  }
}