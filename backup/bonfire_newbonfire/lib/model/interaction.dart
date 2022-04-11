import 'dart:convert';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:http/http.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Home/HomePage.dart';
import 'package:bonfire_newbonfire/widgets/MusicVisualizer.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

MyUserModel currentUser;
AuthProvider _auth;
String appId = "a97b81df-e138-4954-87e8-5ebe6a5ca49b";

class Interaction extends StatefulWidget {
  final String bfId;
  final String bfTitle;
  final String file;
  final String interactionId;
  final String interactionTitle;
  final String ownerId;
  final String ownerImage;
  final String ownerName;
  final Timestamp timestamp;
  final String duration;
  final dynamic likes;

  Interaction(
      {this.bfId,
      this.bfTitle,
      this.file,
      this.interactionId,
      this.interactionTitle,
      this.ownerId,
      this.ownerImage,
      this.ownerName,
      this.timestamp,
      this.duration,
      this.likes});

  factory Interaction.fromDocument(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    return Interaction(
      bfId: _data['bfId'],
      bfTitle: _data['bfTitle'],
      file: _data['file'],
      interactionId: _data['interactionId'],
      interactionTitle: _data['interactionTitle'],
      ownerId: _data['ownerId'],
      ownerImage: _data['ownerImage'],
      ownerName: _data['ownerName'],
      timestamp: _data['timestamp'],
      duration: _data['duration'],
      likes: _data['likes'],
    );
  }

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

  @override
  _InteractionState createState() => _InteractionState(
        bfId: this.bfId,
        bfTitle: this.bfTitle,
        file: this.file,
        interactionId: this.interactionId,
        interactionTitle: this.interactionTitle,
        ownerId: this.ownerId,
        ownerImage: this.ownerImage,
        ownerName: this.ownerName,
        timestamp: this.timestamp,
        duration: this.duration,
        likes: this.likes,
        likeCount: getLikeCount(this.likes),
      );
}

class _InteractionState extends State<Interaction> {
  final String currentUserId = currentUser?.uid;
  final String bfId;
  final String bfTitle;
  final String file;
  final String interactionId;
  final String interactionTitle;
  final String ownerId;
  final String ownerImage;
  final String ownerName;
  final Timestamp timestamp;
  final String duration;
  bool isLiked;
  double likeCount;
  Map likes;
  String _likedInteraction = Uuid().v4();
  bool isPlaying = false;
  AudioPlayer audioPlayer;
  double _percent = 0.0;
  int _totalTime;
  int _currentTime;

  _InteractionState({
    this.bfId,
    this.bfTitle,
    this.file,
    this.interactionId,
    this.interactionTitle,
    this.ownerId,
    this.ownerImage,
    this.ownerName,
    this.timestamp,
    this.duration,
    this.likes,
    this.likeCount,
  });

  handleLikePost() async {
    bool _isLiked = likes[currentUserId] == true;
    if (_isLiked) {
      Firestore.instance
          .collection("Interactions")
          .document(bfId)
          .collection('usersInteraction')
          .document(interactionId)
          .updateData({'likes.$currentUserId': false});
      //Delete feed while unliking
      //Delete feed only when OTHER user dislikes our interaction
      bool isNotPostOwner = currentUserId != ownerId;
      if (isNotPostOwner) {
        Firestore.instance
            .collection("Feed")
            .document(ownerId)
            .collection("FeedItems")
            .document()
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
      }
      setState(() {
        likeCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      Firestore.instance
          .collection("Interactions")
          .document(bfId)
          .collection('usersInteraction')
          .document(interactionId)
          .updateData({'likes.$currentUserId': true});
      setState(() {
        likeCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
      });
      //Create Feed while liking
      //Add notification only if OTHER user is liking our interaction
      bool isNotPostOwner = currentUserId != ownerId;
      if (isNotPostOwner) {
        await Firestore.instance
            .collection("Feed")
            .document(currentUserId)
            .collection("FeedItems")
            .document(bfId).collection("likedInteraction").document()
            .setData({
          "username": currentUser.name,
          "userId": currentUser.uid,
          "userImg": currentUser.profileImage,
        });
        await Firestore.instance
            .collection("Feed")
            .document(currentUserId)
            .collection("FeedItems")
            .document(bfId)
            .setData({
          "type": "like",
          "username": currentUser.name,
          "userId": currentUser.uid,
          "userImg": currentUser.profileImage,
          "bfId": bfId,
          "bfTitle": bfTitle,
          "interactionId": interactionId,
          "interactionTitle": interactionTitle,
          "timestamp": timestamp
        });
      }
    }
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": appId,
        //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,
        //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FFFFBF00",

        "small_icon": "ic_launcher",

        "large_icon":
            "https://firebasestorage.googleapis.com/v0/b/bonfire-e573e.appspot.com/o/icon_amber_1.png?alt=media&token=88afb73e-bfbb-44a5-bb93-643ace490925",
        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        audioPlayer.stop();
        Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, "home");
      },
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(
          builder: (BuildContext context) {
            _auth = Provider.of<AuthProvider>(context);
            bool isPostOwner = _auth.user.uid == ownerId;
            isLiked = (likes[_auth.user.uid] == true);
            print("the owner of the post is" + ownerId);
            return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (context, snapshot) {
                var _userData = snapshot.data;
                if (!snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.5, horizontal: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: AppUserProfile(
                                icon: ownerName == "Mr Anonymous"
                                    ? MyFlutterApp.user_secret
                                    : Icons.person,
                                hasImage:
                                    ownerName == "Mr Anonymous" ? false : true,
                                imageFile: ownerImage,
                                onPressed: ownerId != _auth.user.uid
                                    ? () => showOtherProfile(context,
                                        profileId: ownerId)
                                    : ownerId == _auth.user.uid &&
                                            ownerName != "Mr Anonymous"
                                        ? () => showProfile(context)
                                        : () => print("Tapping anonymous"),
                                iconSize: 32.0,
                                color: ownerName[0] == "P"
                                    ? Colors.orangeAccent
                                    : ownerName == "Mr Anonymous"
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.82)
                                        : Colors.blueAccent,
                                size: 18.0),
                            title: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Transform.translate(
                                    offset: const Offset(-7.0, 0.0),
                                    child: Text(
                                        ownerName == "Mr Anonymous"
                                            ? "Mr Anonymous"
                                            : ownerName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                  ),
                                  Text(
                                    "\u2022",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  //VerticalDivider(color: Colors.grey.shade600, thickness: 1.5, indent: 7, endIndent: 7,),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        //new TextSpan(text: user.email, style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).accentColor)),
                                        new TextSpan(
                                            text: /*" - " + */ timeago
                                                .format(
                                                  timestamp.toDate(),
                                                )
                                                .replaceAll("a day ago", "1 d")
                                                .replaceAll("days ago", "d")
                                                .replaceAll(
                                                    "minutes ago", "min")
                                                .replaceAll("hours ago", "h"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Transform.translate(
                                offset: const Offset(-7.0, 0.0),
                                child: Text(interactionTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .copyWith(fontSize: 13.5))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Transform.translate(
                                  offset: const Offset(-7.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      isPlaying == false
                                          ? InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  isPlaying = true;
                                                });
                                                if (audioPlayer.play(file) ==
                                                    audioPlayer.play(file)) {
                                                  audioPlayer.play(file);
                                                  audioPlayer.onDurationChanged
                                                      .listen((duration) {
                                                    setState(() {
                                                      _totalTime = duration
                                                          .inMicroseconds;
                                                    });
                                                  });
                                                  audioPlayer
                                                      .onAudioPositionChanged
                                                      .listen((duration) {
                                                    setState(() {
                                                      _currentTime = duration
                                                          .inMicroseconds;
                                                      _percent = _currentTime
                                                              .toDouble() /
                                                          _totalTime.toDouble();
                                                    });
                                                  });
                                                  audioPlayer.onPlayerCompletion
                                                      .listen((duration) {
                                                    setState(() {
                                                      isPlaying = false;
                                                      _percent = 0;
                                                    });
                                                  });
                                                } else {
                                                  audioPlayer.stop();
                                                  audioPlayer.play(file);
                                                  audioPlayer.onDurationChanged
                                                      .listen((duration) {
                                                    setState(() {
                                                      _totalTime = duration
                                                          .inMicroseconds;
                                                    });
                                                  });
                                                  audioPlayer
                                                      .onAudioPositionChanged
                                                      .listen((duration) {
                                                    setState(() {
                                                      _currentTime = duration
                                                          .inMicroseconds;
                                                      _percent = _currentTime
                                                              .toDouble() /
                                                          _totalTime.toDouble();
                                                    });
                                                  });
                                                  audioPlayer.onPlayerCompletion
                                                      .listen((duration) {
                                                    setState(() {
                                                      isPlaying = false;
                                                      _percent = 0;
                                                    });
                                                  });
                                                }
                                              },
                                              child: Material(
                                                elevation: 4.0,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Container(
                                                  height: 30.0,
                                                  width: 30.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade800,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white70,
                                                    //Theme.of(context).primaryColor,
                                                    size: 20.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  audioPlayer.stop();
                                                  isPlaying = false;
                                                });
                                                audioPlayer.pause();
                                              },
                                              splashColor:
                                                  Theme.of(context).accentColor,
                                              child: Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .indicatorColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Icon(
                                                  Icons.pause,
                                                  color: Colors.white70,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 15.0,
                                      ),
                                      isPlaying == false
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: MusicVisualizer(
                                                numBars: 20,
                                                barHeight: 12,
                                              ) /*LinearProgressIndicator(
                                                                    minHeight: 5,
                                                                    backgroundColor: Colors.grey,
                                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                                        Theme.of(context).accentColor),
                                                                    value: _percent,
                                                                  ),*/
                                              ),
                                      SizedBox(
                                        width: 12.5,
                                      ),
                                      Text(
                                        duration.toString(),
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.grey.shade300,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    textBaseline: TextBaseline.ideographic,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          bool _isLiked =
                                              likes[_userData.uid] == true;
                                          if (_isLiked) {
                                            Firestore.instance
                                                .collection("Interactions")
                                                .document(bfId)
                                                .collection('usersInteraction')
                                                .document(interactionId)
                                                .updateData({
                                              'likes.${_userData.uid}': false
                                            });
                                            //removeLikeFromActivityFeed();
                                            setState(() {
                                              isLiked = false;
                                              likeCount -= 1;
                                              likes[_userData.uid] = false;
                                            });
                                            //Delete feed while unliking
                                            //Delete feed only when OTHER user dislikes our interaction
                                            bool isNotPostOwner =
                                                _userData.uid != ownerId;

                                            if (isNotPostOwner) {
                                              await FutureService.instance
                                                  .deleteFeed(ownerId, bfId);
                                            }
                                            print(
                                                "interaction disliked by user ${_userData.uid}");
                                          } else if (!_isLiked) {
                                            Firestore.instance
                                                .collection("Interactions")
                                                .document(bfId)
                                                .collection('usersInteraction')
                                                .document(interactionId)
                                                .updateData({
                                              'likes.${_userData.uid}': true
                                            });
                                            setState(() {
                                              isLiked = true;
                                              likeCount += 1;
                                              likes[_userData.uid] = true;
                                            });
                                            //Create Feed while liking
                                            //Add notification only if OTHER user is liking our interaction
                                            bool isNotPostOwner =
                                                _userData.uid != ownerId;
                                            if (isNotPostOwner == true) {
                                              print("Paul ${_userData.uid}");

                                              await FutureService.instance
                                                  .createFeed(
                                                ownerId,
                                                _userData.uid,
                                                _userData.name,
                                                _userData.profileImage,
                                                bfId,
                                                bfTitle,
                                                interactionId,
                                                interactionTitle,
                                              );

                                              await FutureService.instance
                                                  .feedCount(ownerId);
                                              await sendNotification([
                                                _userData.tokenId
                                              ], "${_userData.name} liked your interaction",
                                                  "$interactionTitle");
                                            }
                                          }
                                          print(
                                              "interaction liked by user ${_userData.uid}");
                                        },
                                        iconSize: 25.0,
                                        icon: Icon(
                                          MyFlutterApp.thumbs_up,
                                          color: isLiked
                                              ? Theme.of(context).accentColor
                                              : Colors.white70,
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: const Offset(-5.0, 3.0),
                                        child: Text(
                                          "${likeCount.toInt()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                  color: Colors.grey.shade400,
                                                  fontSize: 15.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
