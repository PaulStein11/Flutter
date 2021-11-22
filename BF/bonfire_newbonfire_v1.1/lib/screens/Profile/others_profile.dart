import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/screens/Profile/MessagePage.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bonfire_newbonfire/model/post.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class OthersProfile extends StatefulWidget {
  final String profileId;

  OthersProfile({this.profileId});

  @override
  _OthersProfileState createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  final String currentUserId = currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            expandedHeight: 40.0,
            title: Text(
              "",
            ),
            automaticallyImplyLeading: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ChangeNotifierProvider<AuthProvider>.value(
                  value: AuthProvider.instance,
                  child: _buildProfileView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Builder(
      builder: (BuildContext _context) {
        _auth = Provider.of<AuthProvider>(_context);
        return StreamBuilder<MyUserModel>(
          stream: StreamService.instance.getUserData(widget.profileId),
          builder: (_context, _snapshot) {
            var _userData = _snapshot.data;
            if (!_snapshot.hasData) {
              return OurLoadingWidget(context);
            } else {
              return Column(
                children: [
                  _userProfileData(_userData.name, _userData.email,
                      _userData.profileImage, _userData.bio, _userData.uid),
                  _userCollectedData(),
                  Divider(color: Colors.white70),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _userProfileData(
      String _name, String _email, String _image, String _bio, String _userId) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "edit_profile"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: AppUserProfile(
                icon: Icons.person,
                imageFile: _image,
                size: 43.0,
                color:
                    _name[0] == "P" ? Colors.orangeAccent : Colors.blueAccent,
                iconSize: 50.0,
                onPressed: () {},
              ),
            ),
          ),
          _userName(name: _name),
          _userBio(bio: _bio),
          _userInteraction(_name, _image, _userId)
        ],
      ),
    );
  }

  _userName({String name}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
      ],
    );
  }

  _userBio({String bio}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bio",
            textAlign: TextAlign.left,
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.grey.shade400,
                fontSize: 17.0,
                fontWeight: FontWeight.w400),
          ),
          bio.isEmpty
              ? Text(
                  "Writing down bio...",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.6),
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

  Widget _userInteraction(String username, String profileImage, String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 38.0,
            child: Material(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              elevation: 2.0,
              child: MaterialButton(
                onPressed: () {},
                minWidth: 110.0,
                height: 22.0,
                child: Text(
                  "follow",
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 35.0,
          ),
          SizedBox(
            height: 38.0,
            child: Material(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              elevation: 2.0,
              child: MaterialButton(
                onPressed: () {
                  FutureService.instance.createOrGetConversartion(
                      _auth.user.uid, widget.profileId,
                          (String _conversationID) {
                        Navigator.push(context, MaterialPageRoute(builder: (_context) {
                          return MessagePage(
                              _conversationID,
                              widget.profileId,
                              username,
                              profileImage);
                        }),);
                      });
                },
                minWidth: 110.0,
                height: 22.0,
                child: Text(
                  "message",
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCollectedData() {
    return StreamBuilder<MyUserModel>(
      stream: StreamService.instance.getUserData(widget.profileId),
      builder: (_context, _snapshot) {
        var _userData = _snapshot.data;
        if (!_snapshot.hasData) {
          return CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          );
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
          margin: EdgeInsets.only(top: 4.0),
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

/*GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(MyFlutterApp.history,
                              size: 20.0,
                              color: Colors.black54 //kBottomNavigationBar,
                              ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "My Summary",
                              style: TextStyle(fontSize: 16.5),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.black),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (notificationOff == false) {
                          notificationOff = true;
                        } else {
                          notificationOff = false;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                              notificationOff
                                  ? MyFlutterApp.lock
                                  : MyFlutterApp.lock,
                              size: 20.0,
                              color: Colors.black54 //kBottomNavigationBar,
                              ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Notifications",
                              style: TextStyle(fontSize: 16.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 100.0),
                            child: Text(
                              notificationOff ? "OFF" : "ON",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
