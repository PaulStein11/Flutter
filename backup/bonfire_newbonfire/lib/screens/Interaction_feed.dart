import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/interaction.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../my_flutter_app_icons.dart';
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
      this.userImg,});

  @override
  _InteractionFeedState createState() => _InteractionFeedState(
      bfId: this.bfId,
      bfTitle: this.bfTitle,
      interactionId: this.interactionId,
      interactionTitle: this.interactionTitle,
    userId: this.userId,
      username: this.username,
      userImg: this.userImg,
  );
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
  bool isPlaying = false;

  AudioPlayer audioPlayer;
  double _percent = 0.0;
  int _totalTime;
  int _currentTime;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
  }
  @override
  Future<void> dispose() async {
    super.dispose();
    await audioPlayer.stop();
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

  _InteractionFeedState(
      {this.bfId,
      this.bfTitle,
      this.interactionId,
      this.interactionTitle,
      this.userId,
      this.username,
      this.userImg,
      });

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
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey.shade200,
                    size: 22.0,
                  ),
                ),
                elevation: 0.0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Your interaction",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 16.0, letterSpacing: 0.75),
                        ),

                        /*isPlaying == false
                            ? InkWell(
                          onTap: () async {
                            setState(() {
                              isPlaying = true;
                            });
                            if (audioPlayer.play(
                                file) ==
                                audioPlayer.play(
                                    file)) {
                              audioPlayer
                                  .play(file);
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
                            } else {
                              audioPlayer.stop();
                              audioPlayer
                                  .play(file);
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
                              BorderRadius.circular(20.0),
                            ),
                            child: Icon(
                              Icons.pause,
                              color: Colors.white70,
                              size: 20.0,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).indicatorColor,
                    ),
                    Row(
                      children: [
                        StreamBuilder<Interaction>(
                            stream: StreamService.instance.getInteraction(bfId, interactionId),builder: (_context, _snapshot) {
                          var _interactionData = _snapshot.data;
                          print("Path for file ${_interactionData.file} and the interactionId is $interactionId");

                          if(!_snapshot.hasData) {
                            return OurLoadingWidget(context);
                          }
                          else {
                            return isPlaying == false
                                ? InkWell(
                              onTap: () async {
                                setState(() {
                                  isPlaying = true;
                                });
                                if (audioPlayer.play(
                                    _interactionData.file) ==
                                    audioPlayer.play(
                                        _interactionData.file)) {
                                  audioPlayer
                                      .play(_interactionData.file);
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
                                } else {
                                  audioPlayer.stop();
                                  audioPlayer
                                      .play(_interactionData.file);
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
                                    color: Theme.of(context).indicatorColor,
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Theme.of(context).primaryColor,
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
                                  color: Theme.of(context).indicatorColor,
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                ),
                                child: Icon(
                                  Icons.pause,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.0,
                                ),
                              ),
                            );
                          }
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                          child: Text(
                            interactionTitle,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Reactions",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(fontSize: 16.0, letterSpacing: 0.75),
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).indicatorColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppUserProfile(
                              icon: username == "Mr Anonymous"
                                  ? MyFlutterApp.user_secret
                                  : Icons.person,
                              hasImage:
                                  username == "Mr Anonymous" ? false : true,
                              imageFile: userImg,
                              onPressed: () {},
                              iconSize: 32.0,
                              color: username[0] == "P"
                                  ? Colors.orangeAccent
                                  : username == "Mr Anonymous"
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.82)
                                      : Colors.blueAccent,
                              size: 24.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
