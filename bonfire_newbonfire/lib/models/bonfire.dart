

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bf_pagoda/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/auth.dart';
import '../services/stream_services.dart';
import '../widgets/AudienceWidget.dart';
import '../widgets/CircleAddButton.dart';
import '../widgets/audio_stream/MusicVisualizer.dart';
import '../widgets/buildSkeleton.dart';
bool isImage = false;
MyUserModel? currentUser;

class BF extends StatefulWidget {
  final int audience;
  final String bfId;
  final String duration;
  final String file;
  final dynamic likes;
  final String ownerId;
  final String ownerName;
  final String profileImage;
  final String title;
  final Timestamp timestamp;
  final DateTime timestampClosure;

  BF(
      {required this.bfId,
        required this.ownerId,
        required this.ownerName,
        required this.profileImage,
        required this.title,
        required this.audience,
        required this.timestamp,
        required this.timestampClosure,
        this.likes,
        required this.file,
        required this.duration});

  factory BF.fromDocument(DocumentSnapshot snapshot) {
    return BF(
      bfId: snapshot['bfId'],
      ownerId: snapshot['ownerId'],
      ownerName: snapshot['ownerName'],
      profileImage: snapshot['profileImage'],
      title: snapshot['title'],
      audience: snapshot['audience'],
      timestamp: snapshot['timestamp'],
      timestampClosure: snapshot['timestampClosure'],
      likes: snapshot['likes'],
      file: snapshot['file'],
      duration: snapshot['duration'],
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

  double getDislikeCount(dislikes) {
    //if no likes, return 0
    if (dislikes == null) {
      return 0;
    }
    double count = 0;
    //if the key is explicitly set to true, add a dislike
    dislikes.values.forEach((val) {
      if (val == true) {
        count += 1;
        likes == 0;
      }
    });
    return count;
  }

  double getUpgradesCount(upgrades) {
    //if no likes, return 0
    if (upgrades == null) {
      return 0;
    }
    double count = 0;
    //if the key is explicitly set to true, add a like
    upgrades.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _BFState createState() => _BFState(
      bfId: bfId,
      ownerId: ownerId,
      ownerName: ownerName,
      profileImage: profileImage,
      title: title,
      audience: audience,
      timestamp: timestamp,
      timestampClosure: this.timestampClosure,
      likes: likes,
      likeCount: getLikeCount(likes),
      file: file,
      duration: duration);
}

class _BFState extends State<BF> {
  late AuthProvider _auth;

  //final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  late Timer _timerLink;
  String currentUserId = currentUser!.uid;
  String? bfId, ownerId, ownerName, profileImage, title, file, duration;
  int? audience;
  final Timestamp timestamp;

  final DateTime timestampClosure;
  bool? isLiked, isDisliked, isUpgraded, _isPlaying = false, _isCreatingLink = false;
  double? likeCount;
  Map? likes;

  String? a_linkMessage;
  /*Audio Played*/
  late AudioPlayer audioPlayer;
  double _percent = 0.0;
  int? _currentTime, _totalTime;

  _BFState({required this.bfId,
    required this.ownerId,
    required this.ownerName,
    required this.profileImage,
    required this.title,
    required this.audience,
    required this.timestamp,
    required this.timestampClosure,
    required this.likes,
    required this.likeCount,
    required this.file,
    required this.duration});


  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    audioPlayer = AudioPlayer();
    //WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await audioPlayer.stop();
    //WidgetsBinding.instance!.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
  }

  /*@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
            () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }*/


  @override
  Widget build(BuildContext context) {
    isLiked = (likes![ownerId] == true);

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
    double? totalLikes = likeCount;
    int likesToInt = totalLikes!.toInt();

    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<List<BF>>(
          stream: StreamServices.instance.getBonfire(ownerId!),
          builder: (context, _snapshot) {
            var _data = _snapshot.data;
            print(_data!.length.toString() + "DATA LENGTH");
            if (!_snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  buildSkeleton(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildSkeleton(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildSkeleton(context),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildSkeleton(context)
                ],
              );
            }
            bool isPostOwner = currentUserId == ownerId;

            return StreamBuilder<MyUserModel>(
              stream: StreamServices.instance.getUserData(ownerId!),
              builder: (context, _snapshot) {
                var _userData = _snapshot.data;
                if (!_snapshot.hasData) {
                  return buildSkeleton(context);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.5, horizontal: 0.0),
                  child: GestureDetector(
                    onTap: () {},
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BonfirePage(
                                  bfId: bfId,
                                  ownerName: ownerName,
                                  ownerId: ownerId,
                                  profileImage: _userData.profileImage,
                                  bfTitle: title,
                                  file: file,
                                  audience: audience,
                                  duration: duration,
                                ),
                          ),
                        ),*/
                    child: Material(
                      elevation: 1.0,
                      //borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .cardColor,
                          //borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*ListTile(
                                leading: AppUserProfile(
                                    icon: ownerName == "Mr Anonymous"
                                        ? MyFlutterApp.user_secret
                                        : Icons.person,
                                    hasImage: ownerName == "Mr Anonymous"
                                        ? false
                                        : true,
                                    imageFile: _userData.profileImage,
                                    onPressed: ownerId != _auth.user.uid
                                        ? () =>
                                        showOtherProfile(context,
                                            profileId: ownerId)
                                        : ownerId == _auth.user.uid &&
                                        ownerName != "Mr Anonymous"
                                        ? () => showProfile(context)
                                        : () => print("Tapping anonymous"),
                                    iconSize: 29.0,
                                    color: ownerName[0] == "P"
                                        ? Colors.orangeAccent
                                        : ownerName == "Mr Anonymous"
                                        ? Theme
                                        .of(context)
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
                                                : _userData.name,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline2),
                                      ),
                                      Text("\u2022",
                                        style: TextStyle(color: Colors.grey),),
                                      //VerticalDivider(color: Colors.grey.shade600, thickness: 1.5, indent: 7, endIndent: 7,),
                                      SizedBox(width: 5.0,),
                                      RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            //new TextSpan(text: user.email, style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).accentColor)),
                                            new TextSpan(
                                                text: /*" - " + */ timeago
                                                    .format(
                                                  timestamp.toDate(),
                                                )
                                                    .replaceAll(
                                                    "a day ago", "1 d")
                                                    .replaceAll("days ago", "d")
                                                    .replaceAll(
                                                    "minutes ago", "min")
                                                    .replaceAll(
                                                    "hours ago", "h"),
                                                style: Theme
                                                    .of(context)
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
                                    child: Text(title, style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline1)),
                                /*subtitle: Transform.translate(
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
                                    ),*/
                              ),*/
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    AudienceWidget(context, audience!),
                                    Row(
                                      children: [
                                        _isPlaying == false
                                            ? InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _isPlaying = true;
                                            });
                                            audioPlayer.play(file!);
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
                                                _percent = _currentTime!
                                                    .toDouble() /
                                                    _totalTime!.toDouble();
                                              });
                                            });
                                            audioPlayer.onPlayerCompletion
                                                .listen((duration) {
                                              setState(() {
                                                _isPlaying = false;
                                                _percent = 0;
                                              });
                                            });
                                          },
                                          child: Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: BoxDecoration(
                                              color:
                                              Theme
                                                  .of(context)
                                                  .indicatorColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20.0),
                                              /*border: Border.all(
                                                    width: 2,
                                                    color:
                                                    Theme.of(context)
                                                        .cardColor)*/),
                                            child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.grey.shade400,
                                              size: 20.0,
                                            ),
                                          ),
                                        )
                                            : InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _isPlaying = false;
                                            });
                                            audioPlayer.pause();
                                          },
                                          splashColor: Theme
                                              .of(context)
                                              .accentColor,
                                          child: Container(
                                            height: 35.0,
                                            width: 35.0,
                                            decoration: BoxDecoration(
                                                color:
                                                Theme
                                                    .of(context)
                                                    .cardColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    20.0),
                                                border: Border.all(
                                                    width: 2,
                                                    color:
                                                    Theme
                                                        .of(context)
                                                        .cardColor)),
                                            child: MusicVisualizer(
                                              numBars: 4,
                                              barHeight: 15.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAddButton(
                                      context,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          barrierColor: Colors.grey.shade800
                                              .withOpacity(0.8),
                                          elevation: 10.0,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: new Icon(
                                                      Icons.chat_bubble,
                                                      //MyFlutterApp.chat_empty,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                    title: new Text('Reply',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () {
                                                      showDialog<String>(
                                                          barrierColor:
                                                          Colors.transparent,
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) {
                                                            return Text("");/*RecordTile(
                                                                onUploadComplete:
                                                                _onUploadComplete(),
                                                                ownerId:
                                                                ownerId,
                                                                ownerName:
                                                                ownerName,
                                                                ownerImage:
                                                                profileImage,
                                                                bfId: bfId,
                                                                bfTitle: title,
                                                                timestamp:
                                                                DateTime
                                                                    .now());*/
                                                          });
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: new Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                    ),
                                                    title: new Text('Share',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () async {
                                                      /*await showAlertDialog(
                                                          context,
                                                          title:
                                                          'Share Bonfire!',
                                                          content:
                                                          'Get link to share with others',
                                                          cancelActionText:
                                                          'Cancel',
                                                          defaultActionText:
                                                          'Get link',
                                                          getRequiredLink:
                                                          _dynamicLinkService
                                                              .createDynamicLink());*/
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
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
}
