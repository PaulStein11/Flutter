import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/CircleAddButton.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/components/RecordingTile.dart';
import 'package:bonfire_newbonfire/model/interaction.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/dynamic_link_service.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'Home/HomePage.dart';
import 'MusicVisualizer.dart';
import 'Profile/Others_profile.dart';

AuthProvider _auth;

class BonfirePage extends StatefulWidget {
  String bfId;
  String ownerId;
  String ownerName;
  String profileImage;
  String bfTitle;
  String file;
  int audience;
  String duration;

  BonfirePage(
      {this.bfId,
      this.ownerId,
      this.ownerName,
      this.profileImage,
      this.bfTitle,
      this.file,
      this.audience,
      this.duration});

  @override
  _BonfirePageState createState() => _BonfirePageState(
        bfId: this.bfId,
        ownerId: this.ownerId,
        ownerName: this.ownerName,
        profileImage: this.profileImage,
        bfTitle: this.bfTitle,
        file: this.file,
        audience: this.audience,
        duration: this.duration,
      );
}

class _BonfirePageState extends State<BonfirePage> with WidgetsBindingObserver {
  String bfId;
  String ownerId;
  String ownerName;
  String profileImage;
  String bfTitle;
  String file;
  int audience;
  Duration _position = new Duration();
  Duration _duration = new Duration();
  String duration;
  bool isPlaying = false;
  AudioPlayer audioPlayer;
  double _percent = 0.0;
  int _totalTime;
  int _currentTime;
  List<firebase_storage.StorageReference> references = [];
  Timestamp timestamp;
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  String url = "";

  _BonfirePageState(
      {this.bfId,
      this.ownerId,
      this.ownerName,
      this.profileImage,
      this.bfTitle,
      this.file,
      this.audience,
      this.duration});

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
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

  void changeDuration(int second) {
    Duration newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (context, snapshot) {
                var userData = snapshot.data;
                if (!snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  body: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SafeArea(
                              child: Material(
                                elevation: 0.0,
                                child: Container(
                                  color: Theme.of(context).backgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: [
                                              AppUserProfile(
                                                  icon: ownerName ==
                                                          "Mr Anonymous"
                                                      ? MyFlutterApp.user_secret
                                                      : Icons.person,
                                                  hasImage: ownerName ==
                                                          "Mr Anonymous"
                                                      ? false
                                                      : true,
                                                  imageFile: profileImage,
                                                  onPressed: () {
                                                    /*showProfile(context,
                                                        profileId: ownerId);*/
                                                  },
                                                  iconSize: 29.0,
                                                  color: ownerName[0] == "P"
                                                      ? Colors.orangeAccent
                                                      : ownerName ==
                                                              "Mr Anonymous"
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.blueAccent,
                                                  size: 18.0),
                                              SizedBox(
                                                width: 12.0,
                                              ),
                                              Text(ownerName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  bfTitle,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              border: Border.all(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  isPlaying == false
                                                      ? InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              isPlaying = true;
                                                            });
                                                            audioPlayer
                                                                .play(file);
                                                            audioPlayer
                                                                .onDurationChanged
                                                                .listen(
                                                                    (duration) {
                                                              setState(() {
                                                                _totalTime =
                                                                    duration
                                                                        .inMicroseconds;
                                                              });
                                                            });
                                                            audioPlayer
                                                                .onAudioPositionChanged
                                                                .listen(
                                                                    (duration) {
                                                              setState(() {
                                                                _currentTime =
                                                                    duration
                                                                        .inMicroseconds;
                                                                _percent = _currentTime
                                                                        .toDouble() /
                                                                    _totalTime
                                                                        .toDouble();
                                                              });
                                                            });
                                                            audioPlayer
                                                                .onPlayerCompletion
                                                                .listen(
                                                                    (duration) {
                                                              setState(() {
                                                                isPlaying =
                                                                    false;
                                                                _percent = 0;
                                                              });
                                                            });
                                                          },
                                                          child: Material(
                                                            elevation: 4.0,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            child: Container(
                                                              height: 30.0,
                                                              width: 30.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade800,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .play_arrow,
                                                                color: Colors
                                                                    .white70,
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
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          child: Container(
                                                            height: 30.0,
                                                            width: 30.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade800,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            child: Icon(
                                                              Icons.pause,
                                                              color: Colors
                                                                  .white70,
                                                              size: 20.0,
                                                            ),
                                                          ),
                                                        ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    height: 3,
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        activeTrackColor: Colors
                                                            .grey.shade200,
                                                        inactiveTrackColor:
                                                            Color(0xFF8D8E98),
                                                        overlayColor:
                                                            Color(0x29EB1555),
                                                        thumbColor: Colors.white
                                                            .withOpacity(0.85),
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                                enabledThumbRadius:
                                                                    7.0),
                                                        overlayShape:
                                                            RoundSliderOverlayShape(
                                                                overlayRadius:
                                                                    20.0),
                                                      ),
                                                      child: Slider(
                                                          min: 0.0,
                                                          max: _duration
                                                              .inSeconds
                                                              .toDouble(),
                                                          value: _position
                                                              .inSeconds
                                                              .toDouble(),
                                                          onChanged:
                                                              (double value) {
                                                            setState(() {
                                                              changeDuration(
                                                                  value
                                                                      .toInt());
                                                              value = value;
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                  isPlaying
                                                      ? Container(
                                                        child: ConstrainedBox(
                                                          constraints: BoxConstraints(
                                                            minWidth: 20,
                                                            maxWidth: 30.0,
                                                            minHeight: 0.0,
                                                            maxHeight: 50.0,
                                                          ),
                                                          child: Text(

                                                              '${_position.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                              style: TextStyle(
                                                                  fontSize: 13.0,
                                                                  color: Colors.grey
                                                                      .shade300,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                        ),
                                                      )
                                                      : Text(
                                                          duration.toString(),
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              color: Colors.grey
                                                                  .shade300,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            textBaseline:
                                                TextBaseline.ideographic,
                                            children: [
                                              AudienceWidget(context, audience),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return RecordTile(
                                                          onUploadComplete:
                                                              _onUploadComplete(),
                                                          ownerId: ownerId,
                                                          ownerName: ownerName,
                                                          ownerImage:
                                                              profileImage,
                                                          bfId: bfId,
                                                          bfTitle: bfTitle,
                                                          timestamp:
                                                              DateTime.now(),
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.chat_empty,
                                                  color: Colors.white70,
                                                  size: 28,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await showAlertDialog(context,
                                                      title: 'Share Bonfire!',
                                                      content:
                                                          'Get link to share with others',
                                                      cancelActionText:
                                                          'Cancel',
                                                      defaultActionText:
                                                          'Get link',
                                                      getRequiredLink:
                                                          _dynamicLinkService
                                                              .createDynamicLink());
                                                },
                                                icon: Icon(
                                                  Icons.share,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  await showAlertDialog(
                                                    context,
                                                    title: 'Report content',
                                                    content:
                                                        'You want to report this Bonfire to alert the team about its content. Continue proceeding?',
                                                    cancelActionText: 'Cancel',
                                                    defaultActionText:
                                                        'Yes report',
                                                    onPressed: () {
                                                      Firestore.instance
                                                          .collection("Bonfire")
                                                          .document(bfId)
                                                          .updateData(
                                                        {
                                                          "report": FieldValue
                                                              .increment(1)
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          content: Text(
                                                              'Reporting Bonfire'),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  MyFlutterApp.attention,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              /*CircleAddButton(
                                                context,
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    barrierColor: Colors
                                                        .grey.shade800
                                                        .withOpacity(0.8),
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            ListTile(
                                                              leading: new Icon(
                                                                MyFlutterApp
                                                                    .chat_empty,
                                                                color: Colors
                                                                    .white,
                                                                size: 28,
                                                              ),
                                                              title: new Text(
                                                                  'Reply',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () {
                                                                showDialog<
                                                                        String>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
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
                                                                        bfId:
                                                                            bfId,
                                                                        bfTitle:
                                                                            bfTitle,
                                                                        timestamp:
                                                                            DateTime.now(),
                                                                      );
                                                                    });
                                                              },
                                                            ),
                                                            ListTile(
                                                              leading: new Icon(
                                                                Icons.share,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              title: new Text(
                                                                  'Share',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () async {
                                                                await showAlertDialog(
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
                                                                            .createDynamicLink());
                                                              },
                                                            ),
                                                            ListTile(
                                                              leading: new Icon(
                                                                MyFlutterApp
                                                                    .attention,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                              ),
                                                              title: new Text(
                                                                  'Report',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () async {
                                                                await showAlertDialog(
                                                                  context,
                                                                  title:
                                                                      'Report content',
                                                                  content:
                                                                      'You want to report this Bonfire to alert the team about its content. Continue proceeding?',
                                                                  cancelActionText:
                                                                      'Cancel',
                                                                  defaultActionText:
                                                                      'Report',
                                                                  onPressed:
                                                                      () {
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "Bonfire")
                                                                        .document(
                                                                            bfId)
                                                                        .updateData(
                                                                      {
                                                                        "report":
                                                                            FieldValue.increment(1)
                                                                      },
                                                                    );
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor:
                                                                            Theme.of(context).accentColor,
                                                                        content:
                                                                            Text('Reporting Bonfire'),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            /*ListTile(
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
                                                              ),*/
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),*/
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            StreamBuilder<List<Interaction>>(
                              stream:
                                  StreamService.instance.getInteractions(bfId),
                              builder: (_context, _snapshot) {
                                var _interactionData = _snapshot.data;
                                if (_snapshot.data == null) {
                                  return OurLoadingWidget(context);
                                }
                                if (_snapshot.data.isEmpty) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog<String>(
                                          barrierColor:
                                              Colors.grey.withOpacity(0.2),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return RecordTile(
                                                onUploadComplete:
                                                    _onUploadComplete(),
                                                bfId: bfId,
                                                bfTitle: bfTitle);
                                          });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                        ),
                                        Container(
                                          height: 70,
                                          width: 80,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                              image: new AssetImage(
                                                  "assets/images/Logo.png"),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Text(
                                            "Be the first one to contribute!",
                                            style: TextStyle(
                                                fontSize: 21,
                                                letterSpacing: 1,
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return _snapshot.hasData
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 8),
                                              child: Text(
                                                "Responses",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1
                                                    .copyWith(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Theme.of(context)
                                                          .accentColor
                                                          .withOpacity(0.8),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(height: 8.0),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children:
                                                      _interactionData.toList(),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : OurLoadingWidget(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = " $bfTitle - $ownerName";

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
  // ----------------------------------
  // MAKE THE USER SEE THE USER WHILE TAPPING ON USERS AVATAR
  /*showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OthersProfile(
          profileId: profileId,
        ),
      ),
    );
  }*/
}

/*Container(
                                    height: 38.0,
                                    width: 38.0,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        elevation: 5.0,
                                        onPressed: () {
                                          showModalBottomSheet(
                                            barrierColor:
                                                Theme.of(context).cardColor,
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
                                                        color: Colors.white,
                                                      ),
                                                      title: new Text('Reply',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline4),
                                                      onTap: () {
                                                        Navigator.pop(context);
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
                                        child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(Icons.add)),
                                      ),
                                    ),
                                  ),*/
