import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Profile/ProfilePage.dart';

AuthProvider _auth;

class InteractionFeed extends StatefulWidget {
  final String bfId;
  final String bfTitle;
  final String interactionId;
  final String interactionTitle;
  final String userId;
  final String username;
  final String userImg;

  InteractionFeed(
      {this.bfId,
      this.bfTitle,
      this.interactionId,
      this.interactionTitle,
      this.userId,
      this.username,
      this.userImg});

  @override
  _InteractionFeedState createState() => _InteractionFeedState(
      bfId: this.bfId,
      bfTitle: this.bfTitle,
      interactionId: this.interactionId,
      interactionTitle: this.interactionTitle,
      userId: this.userId,
      username: this.username,
      userImg: this.userImg);
}

class _InteractionFeedState extends State<InteractionFeed> {
  final String bfId;
  final String bfTitle;
  final String interactionId;
  final String interactionTitle;
  final String userId;
  final String username;
  final String userImg;
  Map interactionLikes;
  dynamic likes;

  double getLikeCount(likes) {
    //if no likes, return 0
    if (likes == null) {
      return 0;
    }
    double count = 0;
    //if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  _InteractionFeedState(
      {this.bfId,
      this.bfTitle,
      this.interactionId,
      this.interactionTitle,
      this.userId,
      this.username,
      this.userImg});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext _context) {
          _auth = Provider.of<AuthProvider>(_context);
          return _InteractionFeed();
        },
      ),
    );
  }

  _InteractionFeed() {
    return StreamBuilder<MyUserModel>(
        stream: StreamService.instance.getUserData(_auth.user.uid),
        builder: (_context, _snapshot) {
          var _userData = _snapshot.data;
          if (!_snapshot.hasData) {
            return OurLoadingWidget(context);
          } else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0.0,
                title: SizedBox(
                  child: Row(
                    children: [
                      AppUserProfile(
                        icon: Icons.person,
                        hasImage: _userData.profileImage.isEmpty ? false : true,
                        imageFile: _userData.profileImage,
                        size: 19.5,
                        color: _userData.name[0] == "P"
                            ? Colors.orangeAccent
                            : Colors.blueAccent,
                        iconSize: 28.0,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 17.0,
                      ),
                      Text(_userData.name),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [Text(interactionTitle)],
              ),
            );
          }
        });
  }
}
