import 'dart:convert';

import 'package:bonfire_newbonfire/components/RecordingTile.dart';
import 'package:bonfire_newbonfire/screens/MusicVisualizer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/HomePage.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart';

AuthProvider _auth;
String appId = "a97b81df-e138-4954-87e8-5ebe6a5ca49b";

class CreateBonfireAudio extends StatefulWidget {
  String id, name, profileImage, title;
  bool isAnonym;

  CreateBonfireAudio(
      {this.id, this.name, this.profileImage, this.title, this.isAnonym});

  @override
  _CreateBonfireAudioState createState() => _CreateBonfireAudioState(
      this.id, this.name, this.profileImage, this.title, this.isAnonym);
}

class _CreateBonfireAudioState extends State<CreateBonfireAudio> {
  String id, name, profileImage, title, bfId = Uuid().v4();
  bool isAnonym;
  List<firebase_storage.StorageReference> references = [];

  _CreateBonfireAudioState(
      this.title, this.profileImage, this.name, this.id, this.isAnonym);

  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording _current;
  String interactionId = Uuid().v4();

  final _formKey = new GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  double _percent = 0.0;
  AudioPlayer _audioPlayer;
  String _filePath;

  FlutterAudioRecorder2 _audioRecorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    print("Hello title $this.title");
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext _context) {
          _auth = Provider.of<AuthProvider>(_context);
          return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (_context, _snapshot) {
                var _userData = _snapshot.data;

                return Scaffold(
                    appBar: AppBar(
                      elevation: 0.0,
                    ),
                    body: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.16,
                          ),
                          Center(
                            child: Container(
                                color: Theme.of(context).backgroundColor,
                                child: _isRecorded
                                    ? _isUploading
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child:
                                                      LinearProgressIndicator(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  )),
                                              Text(
                                                'Sharing content',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xffe2e2e2),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Form(
                                            key: _formKey,
                                            onChanged: () =>
                                                _formKey.currentState.save(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Your Bonfire",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4
                                                            .copyWith(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 8.0,
                                                                left: 8.0,
                                                                right: 8.0),
                                                        child: Text(
                                                          widget.title,
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              letterSpacing:
                                                                  0.5,
                                                              color: Colors.grey
                                                                  .shade200,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                      ),

                                                      /*Text(
                                                        "Add 3 keywords to tag your answer",
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .grey.shade400,
                                                            letterSpacing: 0.5),
                                                        textAlign: TextAlign.center,
                                                      ),*/
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        5.0),
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  _isPlaying ==
                                                                          false
                                                                      ? InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            _onPlayButtonPressed();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40.0,
                                                                            width:
                                                                                40.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).indicatorColor,
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.play_arrow,
                                                                              color: Colors.white70,
                                                                              //Theme.of(context).primaryColor,
                                                                              size: 25.0,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            setState(() {
                                                                              _isPlaying = false;
                                                                            });
                                                                            _audioPlayer.pause();
                                                                          },
                                                                          splashColor:
                                                                              Theme.of(context).accentColor,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                40.0,
                                                                            width:
                                                                                40.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).indicatorColor,
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.pause,
                                                                              color: Theme.of(context).primaryColor,
                                                                              size: 25.0,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  _isPlaying ==
                                                                          true
                                                                      ? Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.50,
                                                                          child:
                                                                              MusicVisualizer(
                                                                            numBars:
                                                                                28,
                                                                            barHeight:
                                                                                25.0,
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.50,
                                                                          height:
                                                                              3,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.grey.shade300,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                        ),
                                                                  Text(
                                                                    '${_current.duration.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        height: 50,
                                                        child: OutlineButton(
                                                          splashColor: Colors.deepOrange,
                                                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80)),
                                                          onPressed:
                                                              _onRecordAgainButtonPressed,
                                                          child: Center(
                                                            child: Text(
                                                              "Try again",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Palanquin",
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors.grey.shade300),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 32.0,
                                                      ),
                                                      /*Container(
                                          height: 40.0,
                                          width: 40.0,
                                          decoration: BoxDecoration(
                                              color:
                                              Theme.of(context).accentColor,
                                              borderRadius:
                                              BorderRadius.circular(50.0)),
                                          child: IconButton(
                                            color: Theme.of(context).cardColor,
                                            icon: Icon(_isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow),
                                            onPressed: _onPlayButtonPressed,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.0,
                                        ),*/
                                                      SizedBox(
                                                        height: 50.0,
                                                        child: RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80)),
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          onPressed: () {
                                                            _onFileUploadButtonPressed(
                                                                widget.title,
                                                                _userData
                                                                    .profileImage,
                                                                _userData.uid,
                                                                _userData.name,
                                                                _userData
                                                                    .tokenId);
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              "Done",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Palanquin",
                                                                  fontSize:
                                                                      15.5,
                                                                  color: Colors
                                                                      .white, letterSpacing: 0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            /*Text(
                                              widget.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              textAlign: TextAlign.center,
                                            ),*/
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.0),
                                                      border: Border.all(
                                                          color: _isRecording
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Colors.grey,
                                                          width: 7.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Container(
                                                      height: 85.0,
                                                      width: 85.0,
                                                      decoration: BoxDecoration(
                                                        color: _isRecording
                                                            ? Theme.of(context)
                                                                .accentColor
                                                            : Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.0),
                                                      ),
                                                      child: IconButton(
                                                        iconSize: 33,
                                                        color: Colors.white70,
                                                        icon: _isRecording
                                                            ? Icon(
                                                                Icons.pause,
                                                                color: Theme.of(
                                                                        context)
                                                                    .backgroundColor,
                                                              )
                                                            : Icon(
                                                                MyFlutterApp
                                                                    .mic,
                                                                color: Theme.of(
                                                                        context)
                                                                    .backgroundColor,
                                                              ),
                                                        onPressed:
                                                            _onRecordButtonPressed,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _isRecording
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 25.0),
                                                        child: Text(
                                                          (_current == null)
                                                              ? "-00:00"
                                                              : '${_current.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}' ??
                                                                  "",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4
                                                                  .copyWith(
                                                                      fontSize:
                                                                          25.0),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 25.0),
                                                        child: Text(
                                                          "Tap to start recording",
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            /*Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Tips:",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "See example",
                                                      style: TextStyle(
                                                        letterSpacing: 0.5,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        fontSize: 14.0,
                                                        decoration: TextDecoration
                                                            .underline,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )*/
                                          ],
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    ));
              });
        },
      ),
    );
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
        "android_accent_color": "FF9976D2",

        //"small_icon":"res/drawable-ic_launcher",

        "large_icon":
            "https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  Future<void> _onFileUploadButtonPressed(String _title, String profileImage,
      String uid, String name, String tokenId) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await FutureService.instance.createBF(
        widget.id,
        !widget.isAnonym ? name : "Mr Anonymous",
        !widget.isAnonym ? profileImage : "",
        bfId,
        _title,
        _filePath,
        '${_current.duration.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
      );
      await sendNotification([tokenId], "$name created Bonfire", "");
      await Firestore.instance
          .collection("Users")
          .document(widget.id)
          .updateData(
        {"bonfires": FieldValue.increment(1)},
      );
      /*await DBFuture.instance
                              .postInBF(this.id, this.postId,  this.profileImage, this.name, this.title);*/
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    await Permission.microphone.request();

    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool hasRecordingPermission =
        await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      var recording = await _audioRecorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _audioRecorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade200,
          content: Center(
            child: Text(
              'Please enable recording permission',
              style: TextStyle(color: Theme.of(context).cardColor),
            ),
          ),
        ),
      );
    }
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
}

/*isUploadingPost
                                          ? null
                                          : () async {
                                              setState(() {
                                                isUploadingPost = true;
                                              });

                                              await FutureService.instance.createBF(
                                                  this.id,
                                                  !isAnonymous
                                                      ? this.name
                                                      : "Mr Anonymous",
                                                  !isAnonymous
                                                      ? this.profileImage
                                                      : "",
                                                  bfId,
                                                  title);
                                              await Firestore.instance
                                                  .collection("Users")
                                                  .document(this.id)
                                                  .updateData(
                                                {
                                                  "bonfires":
                                                      FieldValue.increment(1)
                                                },
                                              );
                                              /*await DBFuture.instance
                              .postInBF(this.id, this.postId,  this.profileImage, this.name, this.title);*/
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          HomePage()));
                                            },*/
