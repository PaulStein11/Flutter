import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/CircleAddButton.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/components/RecordingTile.dart';
import 'package:bonfire_newbonfire/model/activity.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/screens/BonfirePage.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:bonfire_newbonfire/screens/MusicVisualizer.dart';
import 'package:bonfire_newbonfire/screens/Profile/ProfilePage.dart';
import 'package:bonfire_newbonfire/screens/Profile/others_profile.dart';
import 'package:bonfire_newbonfire/service/dynamic_link_service.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'comment.dart';
import 'package:url_launcher/url_launcher.dart';

MyUserModel currentUser;
AuthProvider _auth;
bool isImage = false;

class BF extends StatefulWidget {
  final String bfId;
  final String ownerId;
  final String ownerName;
  final String profileImage;
  final String title;
  final String file;
  final String duration;
  final int audience;
  final Timestamp timestamp;
  final dynamic likes;

  BF(
      {this.bfId,
      this.ownerId,
      this.ownerName,
      this.profileImage,
      this.title,
      this.audience,
      this.timestamp,
      this.likes,
      this.file,
      this.duration});

  factory BF.fromFirestore(DocumentSnapshot _snapshot) {
    Map<String, dynamic> _data = _snapshot.data as Map<String, dynamic>;

    return BF(
      bfId: _data['bfId'],
      ownerId: _data['ownerId'],
      ownerName: _data['ownerName'],
      profileImage: _data['profileImage'],
      title: _data['title'],
      audience: _data['audience'],
      timestamp: _data['timestamp'],
      likes: _data['likes'],
      file: _data['file'],
      duration: _data['duration'],
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
      bfId: this.bfId,
      ownerId: this.ownerId,
      ownerName: this.ownerName,
      profileImage: this.profileImage,
      title: this.title,
      audience: this.audience,
      timestamp: this.timestamp,
      likes: this.likes,
      likeCount: getLikeCount(this.likes),
      file: this.file,
      duration: this.duration);
}

class _BFState extends State<BF> with WidgetsBindingObserver {
  AuthProvider _auth;
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;
  final String currentUserId = currentUser?.uid;

  final String bfId;
  final String ownerId;
  final String ownerName;
  final String profileImage;
  final String title;
  final String file;
  final String duration;
  final int audience;
  final Timestamp timestamp;
  bool isLiked;
  bool isDisliked;
  bool isUpgraded;
  double likeCount;
  Map likes;

  String _linkMessage;
  bool _isCreatingLink = false;

  /*Audio Played*/
  bool isPlaying = false;
  AudioPlayer audioPlayer;
  double _percent = 0.0;
  int _totalTime;
  int _currentTime;

  _BFState(
      {this.bfId,
      this.ownerId,
      this.ownerName,
      this.profileImage,
      this.title,
      this.audience,
      this.timestamp,
      this.likes,
      this.likeCount,
      this.file,
      this.duration});

  List<firebase_storage.Reference> references = [];

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer = AudioPlayer();
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[ownerId] == true);

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
    double totalLikes = likeCount;

    double votePercentage = (likeCount / 100) * 1.0;
    double votePercentageText = votePercentage * 100;
    int votePercentageTextInt = votePercentageText.toInt();

    int likesToInt = totalLikes.toInt();

    return Builder(
      builder: (BuildContext context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<List<BF>>(
          stream: StreamService.instance.getMyPosts(ownerId),
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BonfirePage(
                                  bfId: bfId,
                                  ownerName: ownerName,
                                  ownerId: ownerId,
                                  profileImage: _userData.profileImage,
                                  bfTitle: title,
                                  file: file,
                                  duration: duration,
                                ))),
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
                              ListTile(
                                leading: AppUserProfile(
                                    icon: ownerName == "Mr Anonymous"
                                        ? MyFlutterApp.user_secret
                                        : Icons.person,
                                    hasImage: ownerName == "Mr Anonymous"
                                        ? false
                                        : true,
                                    imageFile: _userData.profileImage,
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
                                title: Transform.translate(
                                  offset: const Offset(-5.0, 1.0),
                                  child: Text(
                                      ownerName == "Mr Anonymous"
                                          ? "Mr Anonymous"
                                          : _userData.name,
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
                              ),
                              buildTitle(),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Row(
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
                                                },
                                                child: Container(
                                                  height: 35.0,
                                                  width: 35.0,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade400,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)
                                                      /*boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .accentColor,
                                              blurRadius: 5.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(
                                                1.0,
                                                1.0,
                                              ), // shadow direction: bottom right
                                            )
                                          ],*/
                                                      ),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Theme.of(context)
                                                        .indicatorColor,

                                                    //Theme.of(context).primaryColor,
                                                    size: 20.0,
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
                                                splashColor: Theme.of(context)
                                                    .accentColor,
                                                child: Container(
                                                  height: 35.0,
                                                  width: 35.0,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade600,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)
                                                      /*boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context)
                                                  .accentColor,
                                              blurRadius: 5.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(1.0,
                                                  1.0), // shadow direction: bottom right
                                            )
                                          ],*/
                                                      ),
                                                  child: MusicVisualizer(
                                                    numBars: 4,
                                                    barHeight: 10.0,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                    AudienceWidget(context, audience),
                                    CircleAddButton(
                                      context,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          barrierColor:
                                              Colors.grey.withOpacity(0.9),
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
                                                      MyFlutterApp.chat_empty,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                    title: new Text('Reply',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () {
                                                      showDialog<String>(
                                                          barrierColor:
                                                              Theme.of(context)
                                                                  .cardColor
                                                                  .withOpacity(
                                                                      0.8),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return RecordTile(
                                                                onUploadComplete:
                                                                    _onUploadComplete(),
                                                                ownerId:
                                                                    ownerId,
                                                                ownerName:
                                                                    ownerName,
                                                                ownerImage:
                                                                    profileImage,
                                                                bfId: bfId,
                                                                bfTitle: title);
                                                          });
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: new Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                    ),
                                                    title: new Text('Share',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () async {
                                                      await showAlertDialog(
                                                        context,
                                                        title: 'Share Bonfire!',
                                                        content:
                                                            'Get link to share with others',
                                                        cancelActionText:
                                                            'Cancel',
                                                        defaultActionText:
                                                            'Get link',
                                                        getRequiredLink: _dynamicLinkService.createDynamicLink()
                                                      );
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: new Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                    ),
                                                    title: new Text('Cancel',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () {
                                                      Navigator.pop(context);
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

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = " $title - $ownerName";

    Share.share(text,
        subject: "This is someone sharing with you what Bonfire is about!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    firebase_storage.ListResult listResult = (await firebaseStorage
        .ref()
        .child('upload-voice-firebase')
        .getDownloadURL()) as firebase_storage.ListResult;
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

void showOtherProfile(BuildContext context, {String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OthersProfile(
        profileId: profileId,
      ),
    ),
  );
}

void showProfile(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(),
    ),
  );
}

//BUILD INTERACTIVE CONTENT
/*Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("Tapped");
                                    handleUpgradePost();
                                  },
                                  child: Column(
                                    children: [
                                      /*IconButton(
                                        icon: */
                                      Icon(
                                        MyFlutterApp.campfire,
                                        size: 28.0,
                                        color: isUpgraded
                                            ? Colors.orange
                                            : Colors.grey,
                                      ),
                                      /*onPressed: () {
                                          print("Tapped");
                                          handleUpgradePost();
                                        },
                                      ),*/
                                      SizedBox(height: 5.0),
                                      Text("$upgradesToInt",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: isUpgraded
                                                ? Colors.orange
                                                : Colors.grey.shade200,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 35.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _goMsgPage(context,
                                        postId: postId,
                                        ownerId: ownerId,
                                       );
                                  },
                                  child: Column(
                                    children: [
                                      /*IconButton(
                                        icon: */
                                      Icon(
                                        MyFlutterApp.lnr_bubble,
                                        size: 28.0,
                                        color: Colors.grey,
                                      ),
                                      /*onPressed: () {
                                          _goMsgPage(context,
                                              postId: postId,
                                              ownerId: ownerId,
                                              image: image);
                                        },
                                      ),*/
                                      SizedBox(height: 5.0),
                                      StreamBuilder<List<Comment>>(
                                        stream: DBService.instance
                                            .getComments(postId),
                                        builder: (context, _snapshot) {
                                          var _data = _snapshot.data;
                                          if (!_snapshot.hasData) {
                                            return CircularProgressIndicator(
                                              color: Colors.lightBlueAccent,
                                            );
                                          }
                                          return Text(
                                            _data.length.toString(),
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey.shade200),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                                  child: new LinearPercentIndicator(
                                    width: 200,
                                    animation: true,
                                    lineHeight: 30.0,
                                    animationDuration: 1000,
                                    percent: 0.9,
                                    center: Text("90.0%", style: TextStyle(fontWeight: FontWeight.w600),),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: isUpgraded ? Colors.orange : Colors.white70,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),*/

/*IconButton(
          onPressed: () {
            showModalBottomSheet(
                barrierColor: Theme.of(context).cardColor,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: new Icon(
                            Icons.chat_bubble,
                            color: Colors.white,
                          ),
                          title: new Text('Reply',
                              style: Theme.of(context).textTheme.headline4),
                          onTap: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AlertDialog(
                                  backgroundColor: Theme.of(context).cardColor,
                                  title: const Text('AlertDialog Title'),
                                  /*content:
                                      FeatureButtonsView(
                                        onUploadComplete:
                                        _onUploadComplete,
                                        owner:
                                        document["owner"],
                                        profileImage:
                                        document["profileImage"],
                                      ),
*/
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            /*showModalBottomSheet(
                                                                        barrierColor: Theme.of(context).backgroundColor,
                                                                        context: context,
                                                                        builder: (context) {
                                                                          return Padding(
                                                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                                            child: Flexible(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(12.0),
                                                                                    child: FeatureButtonsView(
                                                                                      onUploadComplete: _onUploadComplete,
                                                                                      owner: document["owner"],
                                                                                      profileImage: document["profileImage"],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );*/
                          },
                        ),
                        ListTile(
                          leading: new Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          title: new Text('Share',
                              style: Theme.of(context).textTheme.headline4),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: new Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                          title: new Text('Cancel',
                              style: Theme.of(context).textTheme.headline4),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
            );
          },
          icon: Icon(
            CupertinoIcons.hand_raised_fill,
            size: 28.0,
            color: Colors.grey[400],
          ),
        ),*/
