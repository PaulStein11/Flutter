import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/BonfirePage.dart';
import 'package:bonfire_newbonfire/screens/Interaction_feed.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_flutter_app_icons.dart';
import '../screens/Profile/Others_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

MyUserModel currentUser;

class notif_updated extends StatefulWidget {
  final String bfId;
  final String bfTitle;
  final String interactionId;
  final String interactionTitle;
  final String type;
  final String userId;
  final String username;
  final String userImg;

  final Timestamp timestamp;

  notif_updated(
      {this.bfId,
      this.bfTitle,
      this.interactionId,
      this.interactionTitle,
      this.type,
      this.userId,
      this.username,
      this.userImg,
      this.timestamp});

  factory notif_updated.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    return notif_updated(
      bfId: _data['bfId'],
      bfTitle: _data['bfTitle'],
      interactionId: _data['interactionId'],
      interactionTitle: _data['interactionTitle'],
      type: _data['type'],
      userId: _data['userId'],
      username: _data['username'],
      userImg: _data['userImg'],
      timestamp: _data['timestamp'],
    );
  }

  @override
  _notif_updatedState createState() => _notif_updatedState(
        bfId: this.bfId,
        bfTitle: this.bfTitle,
        interactionId: this.interactionId,
        interactionTitle: this.interactionTitle,
        type: this.type,
        userId: this.userId,
        username: this.username,
        userImg: this.userImg,
        timestamp: this.timestamp,
      );
}

class _notif_updatedState extends State<notif_updated> {
  AuthProvider _auth;
  final String currentUserId = currentUser?.uid;

  final String bfId;
  final String bfTitle;
  final String interactionId;
  final String interactionTitle;
  final String type;
  final String userId;
  final String username;
  final String userImg;

  final Timestamp timestamp;

  _notif_updatedState(
      {this.bfId,
      this.bfTitle,
      this.interactionId,
      this.interactionTitle,
      this.type,
      this.userId,
      this.username,
      this.userImg,
      this.timestamp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: _buildMainScreen(),
    );
  }

  Widget _buildMainScreen() {
    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<List<notif_updated>>(
          stream: StreamService.instance.getNotifications(_auth.user.uid),
          builder: (context, _snapshot) {
            var _activity = _snapshot.data;
            if (!_snapshot.hasData) {
              return OurLoadingWidget(context);
            }
            if (_activity.length == null) {
              return OurLoadingWidget(context);
            }
            bool isPostOwner = currentUserId == userId;

            return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (context, _snapshot) {
                var _userData = _snapshot.data;
                if (!_snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                if (_snapshot.data == null) {
                  return OurLoadingWidget(context);
                }
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InteractionFeed(interactionTitle: interactionTitle),
                      )),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border(
                          bottom: BorderSide(
                              width: 0.5, color: Colors.grey.shade800),
                        )),
                    child: ListTile(
                      leading: AppUserProfile(
                          icon: username == "Mr Anonymous"
                              ? MyFlutterApp.user_secret
                              : Icons.person,
                          hasImage: username == "Mr Anonymous" ? false : true,
                          imageFile: userImg,
                          onPressed: userId != _auth.user.uid
                              ? () =>
                                  showOtherProfile(context, profileId: userId)
                              : userId == _auth.user.uid &&
                                      username != "Mr Anonymous"
                                  ? () => showProfile(context)
                                  : () => print("Tapping anonymous"),
                          iconSize: 32.0,
                          color: username[0] == "P"
                              ? Colors.orangeAccent
                              : username == "Mr Anonymous"
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.82)
                                  : Colors.blueAccent,
                          size: 18.0),
                      title: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.headline3.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.5,
                              color: Colors.grey.shade200),
                          children: [
                            TextSpan(
                              text: username,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            TextSpan(
                              text: " liked your interaction",
                            ),
                          ],
                        ),
                      ),
                      subtitle: RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            //new TextSpan(text: user.email, style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).accentColor)),
                            new TextSpan(
                                text: /*" - " + */ timeago.format(
                                  timestamp.toDate(),
                                ),
                                style: Theme.of(context).textTheme.headline3),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OthersProfile(
          profileId: profileId,
        ),
      ),
    );
  }
}
