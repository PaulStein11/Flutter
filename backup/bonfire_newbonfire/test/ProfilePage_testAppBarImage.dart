import "dart:io";

import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/screens/Profile/EditProfilePage.dart';
import 'package:bonfire_newbonfire/screens/Profile/Settings.dart';
import 'package:bonfire_newbonfire/service/cloud_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../my_flutter_app_icons.dart';
import '../Home/HomePage.dart';

AuthProvider _auth;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  final picker = ImagePicker();
  final double coverHeight = 130;
  final double profileHeight = 43;


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
    return WillPopScope(
        onWillPop: () =>
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false)
        ,
        child: Scaffold(
          body: ChangeNotifierProvider<AuthProvider>.value(
            value: AuthProvider.instance,
            child: Builder(
                builder: (BuildContext _context) {
                  _auth = Provider.of<AuthProvider>(_context);
                  return StreamBuilder<MyUserModel>(
                      stream: StreamService.instance.getUserData(
                          _auth.user.uid),
                      builder: (_context, _snapshot) {
                        var _userData = _snapshot.data;
                        if (!_snapshot.hasData) {
                          return Text(""); //OurLoadingWidget(context);
                        } else {
                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              buildTop(_userData.profileImage, _userData.name),
                              SizedBox(height: 50.0,),
                              Column(
                                children: [
                                  _userProfileData(_userData.name, _userData.email,
                                      _userData.profileImage, _userData.bio),
                                  _userCollectedData(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.8),
                                      thickness: 1.25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 17.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.07),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.stream,
                                          color: Colors.grey.shade400,
                                          size: 25.0,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "My Activity",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Divider(
                                      color: Colors.grey.shade700,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.07),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.email,
                                          color: Colors.grey.shade400,
                                          size: 25.0,
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),
                                        Text(
                                          "Inbox",
                                          style: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      }
                  );
                }
            )
            ,

            /*CustomScrollView(
          slivers: [
            /*SliverAppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.grey.shade300.withOpacity(0.3),
                            BlendMode.dstIn),
                        image: AssetImage('assets/images/SF.jpg'),
                        fit: BoxFit.fill)),
              ),
              backgroundColor: Colors.transparent,
              expandedHeight: 90.0,
              leading: IconButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false),
                icon: Icon(
                  Icons.arrow_back,
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                _settingsIcon(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen(),
                    ),
                  );
                }),
              ],
            ),*/
            SliverList(
              delegate: SliverChildListDelegate(
                [

                ],
              ),
            ),
          ],
        ),*/
          )
          ,
        ));
  }

  Widget buildTop(String _image, String _name) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: overlayImage()),
        Positioned(
          top: 95,
          child: AppUserProfile(
            icon: Icons.person,
            hasImage: _image.isEmpty
                ? false
                : true,
            size: profileHeight,
            imageFile: _image,
            color:
            _name[0] == "P"
                ? Colors.orangeAccent
                : Colors.blueAccent,
            iconSize: 35.0,
            onPressed: _openImagePicker,
          ),
        ),
      ],
    );
  }

  Widget overlayImage() {
    return Container(
      width: double.infinity,
      height: coverHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.grey.shade300.withOpacity(0.3),
                  BlendMode.dstIn),
              image: AssetImage('assets/images/SF.jpg'),
              fit: BoxFit.fill)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()),
                        (route) => false),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
          ),
          _settingsIcon(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SettingsScreen(),
              ),
            );
          })
        ],
      ),
    );
  }


  Widget _buildProfileView() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return StreamBuilder<MyUserModel>(
          stream: StreamService.instance.getUserData(_auth.user.uid),
          builder: (_context, _snapshot) {
            var _userData = _snapshot.data;
            if (!_snapshot.hasData) {
              return Text(""); //OurLoadingWidget(context);
            } else {
              return Column(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.15,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.grey.shade300.withOpacity(0.3),
                                BlendMode.dstIn),
                            image: AssetImage('assets/images/SF.jpg'),
                            fit: BoxFit.fill)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () =>
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                      (route) => false),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white70,
                          ),
                        ),
                        _settingsIcon(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SettingsScreen(),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      _userProfileData(_userData.name, _userData.email,
                          _userData.profileImage, _userData.bio),
                      _userCollectedData(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          color: Colors.white.withOpacity(0.8),
                          thickness: 1.25,
                        ),
                      ),
                      SizedBox(
                        height: 17.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.stream,
                              color: Colors.grey.shade400,
                              size: 25.0,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "My Activity",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Divider(
                          color: Colors.grey.shade700,
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.grey.shade400,
                              size: 25.0,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "Inbox",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _userProfileData(String _name, String _email, String _image,
      String _bio) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "edit_profile"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AppUserProfile(
                icon: Icons.person,
                hasImage: _image.isEmpty ? false : true,
                size: 43.0,
                imageFile: _image,
                color:
                _name[0] == "P" ? Colors.orangeAccent : Colors.blueAccent,
                iconSize: 35.0,
                onPressed: _openImagePicker,
              ),
            ),
          ),*/
          _userNameAndEmail(name: _name, email: _email),
          _userBio(bio: _bio),
        ],
      ),
    );
  }

  Widget _userCollectedData() {
    return StreamBuilder<MyUserModel>(
      stream: StreamService.instance.getUserData(_auth.user.uid),
      builder: (_context, _snapshot) {
        var _userData = _snapshot.data;
        if (!_snapshot.hasData) {
          return Text(""); //OurLoadingWidget(context);

        }
        //DEBUGGING: print(_snapshot.data.length);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildCountColumn("bonfires", _userData.bonfires),
              //buildCountColumn("Teams", 0),
              buildCountColumn("interactions", _userData.interactions),
              //buildCountColumn("Rated", 0),
              //buildCountColumn("followers", 0),
            ],
          ),
        );
      },
    );
  }

  Widget _settingsIcon({Function onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          width: 45,
          child: Icon(
            MyFlutterApp.cog,
            size: 25.0,
            color: Theme
                .of(context)
                .primaryColor
                .withOpacity(0.9),
          ),
        ),
      ),
    );
  }

  _userNameAndEmail({String name, String email}) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5),
              ),
              SizedBox(
                height: 20.0,
              ),
              /*Text(
                email,
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 15.0,
                    letterSpacing: 0.25),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  _userBio({String bio}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*Text(
            "Bio",
            textAlign: TextAlign.left,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.grey.shade400,
                fontSize: 17.0,
                fontWeight: FontWeight.w600),
          ),*/
          bio.isEmpty
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "• ",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.white70,
                    letterSpacing: 0.6),
              ),
              Expanded(
                child: Text(
                  "Define yourself shortly",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.6),
                ),
              ),
            ],
          )
              : Text(
            bio,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade500,
                letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade300),
        ),
        Container(
          margin: EdgeInsets.only(top: 1.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
