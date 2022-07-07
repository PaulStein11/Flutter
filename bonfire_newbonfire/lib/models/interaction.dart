import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/services/stream_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/OurLoadingWidget.dart';

late MyUserModel currentUser;
late AuthProvider _auth;

class Interaction extends StatefulWidget {
  late String bfId,
      interacTitle,
      ownerImage,
      ownerId,
      interacAudioFile,
      interacAudioDuration,
      interactionId;
  final dynamic likes;

  Interaction(
      {required this.bfId,
      required this.interacTitle,
      required this.ownerImage,
      required this.ownerId,
      required this.interacAudioFile,
      required this.interacAudioDuration,
      required this.likes,
      required this.interactionId});

  @override
  State<Interaction> createState() => _InteractionState(
      this.bfId,
      this.interacTitle,
      this.ownerImage,
      this.ownerId,
      this.interacAudioFile,
      this.interacAudioDuration,
      this.interactionId,
      this.likes);
}

class _InteractionState extends State<Interaction> {
  late String bfId,
      interacTitle,
      ownerImage,
      ownerId,
      interacAudioFile,
      interacAudioDuration,
      interactionId;
  Map likes;
  late bool isLiked;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlaying = false;
  bool isTapped = false;

  _InteractionState(
      this.bfId,
      this.interacTitle,
      this.ownerImage,
      this.ownerId,
      this.interacAudioFile,
      this.interacAudioDuration,
      this.interactionId,
      this.likes);

  @override
  void initState() {
    _audio = audio.AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          bool isPostOwner = _auth.user!.uid == ownerId;
          isLiked = (likes[_auth.user!.uid] == true);
          print("the owner of the post is" + ownerId);
          return StreamBuilder<MyUserModel>(
            stream: StreamServices.instance.getUserData(_auth.user!.uid),
            builder: (context, snapshot) {
              var _userData = snapshot.data;
              if (!snapshot.hasData) {
                return OurLoadingWidget(context);
              }
              return GestureDetector(
                onLongPress: () async {
                  bool _isLiked = likes[_userData!.uid] == true;
                  if (_isLiked) {
                    FirebaseFirestore.instance
                        .collection("interactions")
                        .doc(bfId)
                        .collection('usersInteractions')
                        .doc(interactionId)
                        .update({'likes.${_userData.uid}': false});
                    //removeLikeFromActivityFeed();
                    setState(() {
                      isLiked = false;
                      //likeCount -= 1;
                      likes[_userData.uid] = false;
                    });
                    //Delete feed while unliking
                    //Delete feed only when OTHER user dislikes our interaction
                    bool isNotPostOwner = _userData.uid != ownerId;

                    /*if (isNotPostOwner) {
                      await FutureService.instance
                          .deleteFeed(ownerId, bfId);
                    }
                    print(
                        "interaction disliked by user ${_userData.uid}");*/
                  } else if (!_isLiked) {
                    FirebaseFirestore.instance
                        .collection("interactions")
                        .doc(bfId)
                        .collection('usersInteractions')
                        .doc(interactionId)
                        .update({'likes.${_userData.uid}': true});
                    setState(() {
                      isLiked = true;
                      //likeCount += 1;
                      likes[_userData.uid] = true;
                    });
                    //Create Feed while liking
                    //Add notification only if OTHER user is liking our interaction
                    bool isNotPostOwner = _userData.uid != ownerId;
                    if (isNotPostOwner == true) {
                      print("Paul ${_userData.uid}");

                      /*await FutureService.instance
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
                          "$interactionTitle");*/
                    }
                  }
                  print("interaction liked by user ${_userData!.uid}");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      bottom: BorderSide(
                          width: 1.2,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.05)),
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.interacTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        fontSize: 16.4,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.clip,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isLiked ? Theme.of(context).accentColor.withOpacity(0.05) : Colors.transparent,
                                borderRadius: BorderRadius.circular(40.0),
                                border: isLiked
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.55),
                                        width: 1.8)
                                    : Border.all(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.05),
                                        width: 1.8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  widget.ownerImage.isEmpty ? Icon(
                              FontAwesomeIcons.solidCircleUser,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 30.0,
                              ) : CircleAvatar(
                                    backgroundColor: Colors.grey.shade700,
                                    radius: 17.5,
                                    backgroundImage:
                                        NetworkImage(widget.ownerImage),
                                  ),
                                  Container(
                                    /*decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey),
                                                            borderRadius: BorderRadius.circular(50.0)
                                                          ),*/
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        isPlaying == false
                                            ? IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isPlaying = true;
                                                  });
                                                  _audio.play(
                                                      widget.interacAudioFile);
                                                  _audio.onPlayerCompletion
                                                      .listen((duration) {
                                                    setState(() {
                                                      isPlaying = false;
                                                    });
                                                  });
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.playCircle,
                                                  size: 25.0,
                                                  color: isLiked
                                                      ? Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(0.85)
                                                      : Colors.white70,
                                                ))
                                            : IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    isPlaying = false;
                                                  });
                                                  await _audio.pause();
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.pauseCircle,
                                                  size: 25.0,
                                                  color: isLiked ? Theme.of(context).accentColor.withOpacity(0.85) : Colors.white70,
                                                )),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.52,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: isPlaying == false
                                                  ? Colors.grey.shade300
                                                  : Colors.orange.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 3.0),
                                          child: Text(
                                            widget.interacAudioDuration
                                                .toString()
                                                .substring(1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                  fontFamily: "Palanquin",
                                                  letterSpacing: -0.5,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.2,
                                                  color: Colors.grey.shade400,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        /*Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: IconButton(onPressed: (){}, icon: Icon(MyFlutterApp.angle_circled_up, size: 32.0, color: Theme.of(context).primaryColor,)),
                                          )*/
                        SizedBox(
                          height: 15.0,
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
    );
  }

/*
  * GestureDetector(
      onLongPress: () {
        setState(() {
          isTapped = !isTapped;
        });
        print("double tapped");
      },
      child: Container(
        decoration: BoxDecoration(
          color: isTapped == true
              ? Colors.blue.withOpacity(0.35)
              : Theme.of(context).cardColor.withOpacity(0.8),
          border: Border(
            bottom: BorderSide(width: 1.2, color: Theme.of(context).primaryColor.withOpacity(0.05)),
          ),        ),
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.interacTitle,
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontWeight: FontWeight.normal,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: isTapped == true
                          ? Colors.blue.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(40.0),
                      border:
                          Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05), width: 1.8)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade700,
                          radius: 17.5,
                          backgroundImage: NetworkImage(widget.ownerImage),
                        ),
                        Container(
                          /*decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(50.0)
                                                        ),*/
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              isPlaying == false
                                  ? GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isPlaying = true;
                                        });
                                        _audio.play(widget.interacAudioFile);
                                        _audio.onPlayerCompletion
                                            .listen((duration) {
                                          setState(() {
                                            isPlaying = false;
                                          });
                                        });
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.playCircle,
                                        color: Colors.white70,
                                        size: 26.5,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isPlaying = true;
                                        });
                                        _audio.play(widget.interacAudioFile);
                                        _audio.onPlayerCompletion
                                            .listen((duration) {
                                          setState(() {
                                            isPlaying = false;
                                          });
                                        });
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.pauseCircle,
                                        color: Colors.white70,
                                        size: 26.5,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isPlaying == false
                                        ? Colors.grey.shade300
                                        : Colors.orange.shade800,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 3.0),
                                child: Text(
                                  widget.interacAudioDuration
                                      .toString()
                                      .substring(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontFamily: "Palanquin",
                                          letterSpacing: -0.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.2,
                                          color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: IconButton(onPressed: (){}, icon: Icon(MyFlutterApp.angle_circled_up, size: 32.0, color: Theme.of(context).primaryColor,)),
                                        )*/
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );*/
}
