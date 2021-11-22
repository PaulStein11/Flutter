import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/CircleAddButton.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/components/RecordingTile.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/screens/ActivityPage.dart';
import 'package:bonfire_newbonfire/screens/BonfirePage.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:bonfire_newbonfire/screens/Profile/others_profile.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'comment.dart';

MyUserModel currentUser;
AuthProvider _auth;
bool isImage = false;

class Activity extends StatefulWidget {
  final String bfId;
  final String ownerId;
  final String ownerName;
  final String profileImage;
  final String title;
  final Timestamp timestamp;

  Activity({
    this.bfId,
    this.ownerId,
    this.ownerName,
    this.profileImage,
    this.title,
    this.timestamp,
  });

  factory Activity.fromFirestore(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;

    return Activity(
      bfId: _data['bfId'],
      ownerId: _data['ownerId'],
      ownerName: _data['ownerName'],
      profileImage: _data['profileImage'],
      title: _data['title'],
      timestamp: _data['timestamp'],
    );
  }

  @override
  _ActivityState createState() => _ActivityState(
        bfId: this.bfId,
        ownerId: this.ownerId,
        ownerName: this.ownerName,
        profileImage: this.profileImage,
        title: this.title,
        timestamp: this.timestamp,
      );
}

class _ActivityState extends State<Activity> {
  AuthProvider _auth;

  final String currentUserId = currentUser?.uid;

  final String bfId;
  final String ownerId;
  final String ownerName;
  final String profileImage;
  final String title;
  final Timestamp timestamp;

  _ActivityState({
    this.bfId,
    this.ownerId,
    this.ownerName,
    this.profileImage,
    this.title,
    this.timestamp,
  });

  List<firebase_storage.StorageReference> references = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        postHeader(),
        //buildPostFooter(),
        //  postInteraction(opinion, percentage, percent),
      ],
    );
  }

  postHeader() {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: _buildMainScreen(),
    );
  }

  Widget _buildMainScreen() {
    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<List<Activity>>(
          stream: StreamService.instance.getActivity(ownerId),
          builder: (context, _snapshot) {
            var _data = _snapshot.data;
            if (!_snapshot.hasData) {
              return OurLoadingWidget(context);
            }
            bool isPostOwner = currentUserId == ownerId;

            return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(ownerId),
              builder: (context, _snapshot) {
                var _userData = _snapshot.data;
                if (!_snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 13.0),
                  child: GestureDetector(
                    onTap: (){}, /*=> Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityPage(
                                  bfId: bfId,
                                ))),*/
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 12.0,
                              ),
                              /*ListTile(

                                leading: AppUserProfile(
                                    icon: ownerName == "Mr Anonymous"
                                        ? MyFlutterApp.user_secret
                                        : Icons.person,
                                    hasImage: ownerName == "Mr Anonymous"
                                        ? false
                                        : true,
                                    imageFile: _userData.profileImage,
                                    onPressed: () {

                                    },
                                    iconSize: 32.0,
                                    color: ownerName[0] == "P"
                                        ? Colors.orangeAccent
                                        : ownerName == "Mr Anonymous"
                                        ? Theme.of(context).primaryColor
                                        : Colors.blueAccent,
                                    size: 19.0),
                                title: Transform.translate(
                                  offset: const Offset(-5.0, 1.0),
                                  child: Text(
                                      ownerName == "Mr Anonymous"
                                          ? "Mr Anonymous"
                                          : ownerName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                ),
                                subtitle: Transform.translate(
                                  offset: const Offset(-5.0, -4.5),
                                  child: RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        //new TextSpan(text: user.email, style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).accentColor)),
                                        new TextSpan(
                                            text: /*" - " + */ timeago.format(
                                              timestamp.toDate(),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                              buildTitle(),
                              SizedBox(
                                height: 8.0,
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    textBaseline: TextBaseline.alphabetic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          DecoratedIcon(
                                            MyFlutterApp.users,
                                            size: 24.0,
                                            color: Colors.white54,
                                            shadows: [
                                              BoxShadow(
                                                blurRadius: 12.0,
                                                color: Colors.amber.shade900,
                                              ),
                                              BoxShadow(
                                                blurRadius: 12.0,
                                                color: Colors.amber.shade900,
                                                offset: Offset(0, 4.3),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text("+35",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    .copyWith(
                                                        color:
                                                            Colors.orangeAccent,
                                                        fontSize: 15)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          DecoratedIcon(
                                            Icons
                                                .local_fire_department_outlined,
                                            size: 30.0,
                                            color: Colors.white54,
                                            shadows: [
                                              BoxShadow(
                                                  blurRadius: 12.0,
                                                  color: Colors.amber
                                                      .shade900 //Theme.of(context)
                                                  //.accentColor,
                                                  ),
                                              BoxShadow(
                                                blurRadius: 12.0,
                                                color: Colors.amber.shade900,
                                                //Theme.of(context)
                                                //.accentColor,
                                                offset: Offset(0, 4.3),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: Text("+12",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    .copyWith(
                                                        color:
                                                            Colors.orangeAccent,
                                                        fontSize: 15)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
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

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = " $title - $ownerName";

    Share.share(text,
        subject: "This is someone sharing with you what Bonfire is about!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    var listResult = await firebaseStorage
        .ref()
        .child('upload-voice-firebase')
        .getDownloadURL();
    setState(() {
      references = listResult.items;
    });
  }

  buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(title,
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_goMsgPage(BuildContext context,
    {String postId, String ownerId, String image}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postOwnerId: ownerId,
      postMediaUrl: image,
    );
  }));
}

Widget _listTileTrailingWidgets(Timestamp _lastMessageTimestamp) {
  return Text(
    timeago.format(_lastMessageTimestamp.toDate()),
    style: TextStyle(fontSize: 13, color: Colors.white70),
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
