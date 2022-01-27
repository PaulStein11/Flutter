import 'dart:convert';
import 'package:http/http.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/HomePage.dart';
import 'package:bonfire_newbonfire/screens/MusicVisualizer.dart';
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

  handleLikePost() {
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
        Firestore.instance
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

  Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>
      {
        "app_id": appId,//kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color":"FFFFBF00",

        "small_icon":"ic_launcher",

        "large_icon":"https://firebasestorage.googleapis.com/v0/b/bonfire-e573e.appspot.com/o/flame_yellow_small.png?alt=media&token=24d3ae14-dd43-4f5e-b47b-6f3d567d171a",

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
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
                var userData = snapshot.data;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ownerName,
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                                /*" - " + */
                                timeago.format(
                                  timestamp.toDate(),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 10)),
                          ],
                        ),
                        isPostOwner == true
                            ? IconButton(
                                onPressed: () async {
                                  FutureService.instance.deleteInteractionInDB(
                                      bfId, interactionId);
                                  await showAlertDialog(context,
                                      title: 'Delete',
                                      content:
                                          'Are you sure that you want delete your interaction',
                                      cancelActionText: 'Cancel',
                                      getRequiredLinkbool: false,
                                      defaultActionText: 'Delete',
                                      onPressed: () async {
                                    await Firestore.instance
                                        .collection("Bonfire")
                                        .document(bfId)
                                        .updateData({
                                      "audience": FieldValue.increment(-1)
                                    });
                                    Navigator.pop(context);
                                    /*Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (Route<dynamic> route) => false);*/
                                  });
                                },
                                icon: Icon(
                                  FontAwesomeIcons.ellipsisH,
                                  color: Colors.grey.shade400,
                                ),
                                iconSize: 20.0,
                              )
                            : Text("")
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(interactionTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.normal)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppUserProfile(
                                  icon: ownerName == "Mr Anonymous"
                                      ? MyFlutterApp.user_secret
                                      : Icons.person,
                                  hasImage: ownerName == "Mr Anonymous"
                                      ? false
                                      : true,
                                  imageFile: ownerImage,
                                  onPressed: () => showOtherProfile(context,
                                      profileId: ownerId),
                                  iconSize: 26.0,
                                  color: Colors.grey.shade400,
                                  size: 18.0),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                isPlaying == false
                                    ? InkWell(
                                        onTap: () async {
                                          setState(() {
                                            isPlaying = true;
                                          });
                                          audioPlayer.play(file);
                                          audioPlayer.onDurationChanged
                                              .listen((duration) {
                                            setState(() {
                                              _totalTime =
                                                  duration.inMicroseconds;
                                            });
                                          });
                                          audioPlayer.onAudioPositionChanged
                                              .listen((duration) {
                                            setState(() {
                                              _currentTime =
                                                  duration.inMicroseconds;
                                              _percent =
                                                  _currentTime.toDouble() /
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
                                                  BorderRadius.circular(20.0),
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
                                                BorderRadius.circular(20.0),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      )
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        child: MusicVisualizer(
                                          numBars: 24,
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
                                  width: 10.0,
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          iconSize: 28.0,
                          icon: Icon(Icons.reply, color: Colors.white70),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            IconButton(
                              onPressed: () async {
                                bool _isLiked = likes[userData.uid] == true;
                                if (_isLiked) {
                                  Firestore.instance
                                      .collection("Interactions")
                                      .document(bfId)
                                      .collection('usersInteraction')
                                      .document(interactionId)
                                      .updateData(
                                          {'likes.${userData.uid}': false});
                                  //removeLikeFromActivityFeed();
                                  setState(() {
                                    isLiked = false;
                                    likeCount -= 1;
                                    likes[userData.uid] = false;
                                  });
                                  //Delete feed while unliking
                                  //Delete feed only when OTHER user dislikes our interaction
                                  bool isNotPostOwner = userData.uid != ownerId;

                                  if (isNotPostOwner) {
                                    await FutureService.instance.deleteFeed(ownerId, bfId);
                                  }
                                  print(
                                      "interaction disliked by user ${userData.uid}");
                                } else if (!_isLiked) {
                                  Firestore.instance
                                      .collection("Interactions")
                                      .document(bfId)
                                      .collection('usersInteraction')
                                      .document(interactionId)
                                      .updateData(
                                          {'likes.${userData.uid}': true});
                                  setState(() {
                                    isLiked = true;
                                    likeCount += 1;
                                    likes[userData.uid] = true;
                                  });
                                  //Create Feed while liking
                                  //Add notification only if OTHER user is liking our interaction
                                  bool isNotPostOwner = userData.uid != ownerId;
                                  if (isNotPostOwner == true) {
                                    print("Paul ${userData.uid}");

                                    await FutureService.instance.createFeed(
                                        ownerId,
                                        userData.uid,
                                        userData.name,
                                        userData.profileImage,
                                        bfId,
                                        bfTitle,
                                        interactionTitle,
                                        interactionId);

                                    await FutureService.instance.feedCount(ownerId);
                                    await sendNotification([userData.tokenId], "${userData.name} liked your interaction", "$interactionTitle");
                                  }
                                }
                                print(
                                    "interaction liked by user ${userData.uid}");
                              },
                              iconSize: 27.0,
                              icon: Icon(
                                Icons.local_fire_department_outlined,
                                color: isLiked
                                    ? Theme.of(context).accentColor
                                    : Colors.white70,
                              ),
                            ),
                            Text("${likeCount.toInt()}",
                                style: Theme.of(context).textTheme.headline5),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade800,
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
