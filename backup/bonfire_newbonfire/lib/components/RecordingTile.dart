import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Home/HomePage.dart';
import 'package:bonfire_newbonfire/widgets/MusicVisualizer.dart';
import 'package:bonfire_newbonfire/service/cloud_storage_service.dart';
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

AuthProvider _auth;

class RecordTile extends StatefulWidget {
  final Future<void> onUploadComplete;
  final String bfId, bfTitle, ownerId, ownerName, ownerImage;
  final DateTime timestamp;

  const RecordTile(
      {Key key,
      @required this.onUploadComplete,
      @required this.ownerId,
      @required this.ownerName,
      @required this.ownerImage,
      @required this.bfId,
      @required this.bfTitle,
      @required this.timestamp})
      : super(key: key);

  @override
  _RecordTileState createState() => _RecordTileState(this.bfId, this.bfTitle,
      this.ownerId, this.ownerName, this.ownerImage, this.timestamp); //
}

class _RecordTileState extends State<RecordTile> {
  bool _isPlaying;
  bool _isUploading;
  bool _isRecorded;
  bool _isRecording;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool stop = false;
  Recording _current;
  String bfId, bfTitle, ownerId, ownerName, ownerImage;
  String interactionId = Uuid().v4();
  DateTime timestamp;

  _RecordTileState(
    this.bfId,
    this.bfTitle,
    this.ownerId,
    this.ownerName,
    this.ownerImage,
    this.timestamp,
  );

  String title = "";
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
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext _context) {
          _auth = Provider.of<AuthProvider>(_context);
          return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (_context, _snapshot) {
                var _userData = _snapshot.data;

                return Dialog(
                    backgroundColor: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.48,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: _isRecorded
                              ? _isUploading
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: LinearProgressIndicator()),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    "Summarize",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        letterSpacing: 0.5,
                                                        color: Colors
                                                            .grey.shade200,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Text(
                                                  "Add 3 keywords to tag your answer",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade400,
                                                      letterSpacing: 0.5),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextFormField(
                                                  validator: (input) {
                                                    return input.isEmpty
                                                        ? "Title your comment"
                                                        : null;
                                                  },
                                                  onSaved: (input) {
                                                    title = input;
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                  controller: titleController,
                                                  cursorColor: Theme.of(context)
                                                      .accentColor,
                                                  minLines: 2,
                                                  maxLines: 2,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ex: Exciting, Creative, Collaboration",
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13.0),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10.0,
                                                            horizontal: 20.0),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  25.0)),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey,
                                                          width: 1.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.white,
                                                          width: 2.0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                      border: Border.all(
                                                        color: Colors
                                                            .grey.shade700,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 5.0),
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            _isPlaying == false
                                                                ? InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      _onPlayButtonPressed();
                                                                    },
                                                                    child:
                                                                        Material(
                                                                      elevation:
                                                                          4.0,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30.0,
                                                                        width:
                                                                            30.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade800,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          color:
                                                                              Colors.white70,
                                                                          //Theme.of(context).primaryColor,
                                                                          size:
                                                                              20.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        _isPlaying =
                                                                            false;
                                                                      });
                                                                      _audioPlayer
                                                                          .pause();
                                                                    },
                                                                    splashColor:
                                                                        Theme.of(context)
                                                                            .accentColor,
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30.0,
                                                                      width:
                                                                          30.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Theme.of(context)
                                                                            .indicatorColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Theme.of(context).primaryColor,
                                                                            blurRadius:
                                                                                3.0,
                                                                            spreadRadius:
                                                                                0.0,
                                                                            offset:
                                                                                Offset(
                                                                              0.0,
                                                                              0.0,
                                                                            ), // shadow direction: bottom right
                                                                          )
                                                                        ],
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .pause,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            _isPlaying == false
                                                                ? Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.45,
                                                                    height: 3,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade300,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.45,
                                                                    child:
                                                                        MusicVisualizer(
                                                                      numBars:
                                                                          25,
                                                                      barHeight:
                                                                          25,
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: 2.0,
                                                            ),
                                                            Text(
                                                              '${_current.duration.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 47.0,
                                                  width: 47.0,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .indicatorColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0)),
                                                  child: IconButton(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    icon: Icon(Icons.replay),
                                                    onPressed:
                                                        _onRecordAgainButtonPressed,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30.0,
                                                ),
                                                Container(
                                                  height: 47.0,
                                                  width: 47.0,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0)),
                                                  child: IconButton(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    icon: Icon(Icons.done),
                                                    onPressed: () async {
                                                      if (_formKey.currentState
                                                          .validate()) {
                                                        var _audioFile =
                                                            await CloudStorageService
                                                                .instance
                                                                .uploadInteraction(
                                                                    title,
                                                                    File(
                                                                        _filePath));
                                                        var _audioURL =
                                                            await _audioFile.ref
                                                                .getDownloadURL();
                                                        await _onFileUploadButtonPressed(
                                                            _audioURL,
                                                            title,
                                                            _userData
                                                                .profileImage,
                                                            _userData.uid,
                                                            _userData.name);
                                                      }
                                                    },
                                                  ),
                                                ),
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
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        bfTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        textAlign: TextAlign.center,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    width: 4.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 65,
                                                width: 65.0,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0)),
                                                child: IconButton(
                                                  iconSize: 28,
                                                  color: Colors.white70,
                                                  icon: _isRecording
                                                      ? Icon(
                                                          Icons.pause,
                                                          color: Theme.of(
                                                                  context)
                                                              .backgroundColor,
                                                        )
                                                      : Icon(
                                                          MyFlutterApp.mic,
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
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Text(
                                                    (_current == null)
                                                        ? "-00:00"
                                                        : '${_current.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}' ??
                                                            "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4
                                                        .copyWith(
                                                            color: Colors
                                                                .grey.shade300
                                                                .withOpacity(
                                                                    0.9)),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Record your answer",
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Tips:",
                                              style:
                                                  TextStyle(color: Colors.grey),
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                    ));
              });
        },
      ),
    );
  }

  Future<void> _onFileUploadButtonPressed(var _audioURL, String _title,
      String profileImage, String uid, String name) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await FutureService.instance.createInteraction(
          '${_current.duration.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
          uid,
          name,
          profileImage,
          bfId,
          bfTitle,
          interactionId,
          title,
          _audioURL.toString());
      await Firestore.instance.collection("Bonfire").document(bfId).updateData({
        "audience": FieldValue.increment(1),
      });
      await Firestore.instance.collection("Users").document(uid).updateData({
        "interactions": FieldValue.increment(1),
      });
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
      _audioRecorder.stop();
      _isRecording = false;
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
}
