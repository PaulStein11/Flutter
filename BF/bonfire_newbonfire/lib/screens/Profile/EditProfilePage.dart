import "dart:io";
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/screens/Home/HomePage.dart';
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

AuthProvider _auth;

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
  File _image;
  final picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
    var _result = await CloudStorageService.instance
        .uploadUserImage(_auth.user.uid, _image);
    var _imageURL = await _result.ref.getDownloadURL();
    await Firestore.instance
        .collection("Users")
        .document(_auth.user.uid)
        .updateData({
      "profileImage": _imageURL.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    /*---------------------------*/
    //TODO: CHANGE WILLPOPSCREEN TO GUIDE USER TO PREVIOUS SCREEN INSTEAD OF HOMESCREEN
    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false),
      child: Scaffold(
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
                        return CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                          height: MediaQuery.of(context).size.height * 0.01),
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
                                                              color: Theme.of(context).primaryColor),
                                                          controller: displayNameController,
                                                          decoration: InputDecoration(
                                                              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0.0),
                                                              enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey.shade400),
                                                              ),
                                                              focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey.shade400),
                                                              ),
                                                              border: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey.shade400),
                                                              ),
                                                              hintStyle: TextStyle(
                                                                  color: Theme.of(context).primaryColor),
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
                                                              color: Theme.of(context).primaryColor),
                                                          controller: bioController,
                                                          decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 0.0),
                                                            enabledBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey.shade400),
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey.shade400),
                                                            ),
                                                            border: UnderlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.grey.shade400),
                                                            ),
                                                            hintStyle: TextStyle(
                                                                color: Theme.of(context).primaryColor),
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
                                                            child: Text(_userData.email, style: TextStyle(color: Colors.grey.shade300, fontSize: 16.0),),
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
