import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

import '../../services/future_services.dart';
import '../../widgets/OurFilledButton.dart';
import '../../widgets/audio_stream/MusicVisualizer.dart';

class UploadInterac extends StatefulWidget {
  String interacTitle, bfId, bfTitle;
  String? uid, username, profileImg, filePath, audioDuration;


  UploadInterac({required this.uid,
    required this.username,
    required this.profileImg,
    required this.interacTitle,
    required this.bfId,
    required this.bfTitle,
    required this.audioDuration,
    required this.filePath});

  @override
  State<UploadInterac> createState() =>
      _UploadInteracState(
          this.uid,
          this.username,
          this.profileImg,
          this.interacTitle,
          this.bfId,
          this.bfTitle,
          this.audioDuration,
          this.filePath);
}

class _UploadInteracState extends State<UploadInterac> {
  static const double _controlSize = 56;
  final _formKey = new GlobalKey<FormState>();
  late audio.AudioPlayer _audio;
  String interacTitle,
      interacId = Uuid().v4(),
      bfId,
      bfTitle;
  String? uid, username, profileImg, filePath, audioDuration;
  late Recording _current;
  var durationInterac;
  String? duration;
  bool isPlaying = false;
  double _percent = 0.0;
  var durationBf;
  int? _totalTime, _currentTime;
  TextEditingController interacTitleController = TextEditingController();
  String dropdownvalue = '1 day';
  final metadata = SettableMetadata(contentType: "audio/x-wav");

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;


  _UploadInteracState(this.uid, this.username, this.profileImg,
      this.interacTitle, this.bfId, this.bfTitle, this.audioDuration,
      this.filePath);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audio = audio.AudioPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create interaction",
            style: TextStyle(fontSize: 17.5, color: Colors.grey.shade200),
          ),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade200,
              size: 22.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              _formKey.currentState!.save();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Title",
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3),
                  ),
                ),
                TextFormField(
                  autofocus: false,
                  autocorrect: true,
                  validator: (input) {
                    return input!.isEmpty ? "Title your bonfire" : null;
                  },
                  onSaved: (input) {
                    widget.interacTitle = input!;
                  },
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 0.3),
                  controller: interacTitleController,
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .indicatorColor),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      filled: true,
                      fillColor:
                      Theme
                          .of(context)
                          .backgroundColor
                          .withOpacity(0.8),
                      hintText:
                      interacTitleController.text = widget.interacTitle),
                ),
                /*Text(
    widget.bfTitle,
    style: TextStyle(
        color: Colors.grey.shade300,
        fontSize: 19.0,
        fontWeight: FontWeight.w200,
        letterSpacing: 0.75),
  ),*/
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    "Audio",
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border:
                        Border.all(color: Colors.grey.shade800, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          isPlaying == false
                              ? InkWell(
                            onTap: () async {
                              setState(() {
                                isPlaying = true;
                              });
                              _audio.play(widget.filePath!);
                              _audio.onDurationChanged.listen((duration) {
                                setState(() {
                                  _totalTime = duration.inMicroseconds;
                                });
                              });
                              _audio.onAudioPositionChanged
                                  .listen((duration) {
                                setState(() {
                                  _currentTime = duration.inMicroseconds;
                                  _percent = _currentTime!.toDouble() /
                                      _totalTime!.toDouble();
                                });
                              });
                              _audio.onPlayerCompletion
                                  .listen((duration) {
                                setState(() {
                                  isPlaying = false;
                                  _percent = 0;
                                });
                              });
                            },
                            child: Material(
                              elevation: 4.0,
                              borderRadius: BorderRadius.circular(20.0),
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
                              _audio.pause();
                            },
                            splashColor: Theme
                                .of(context)
                                .accentColor,
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Icon(
                                Icons.pause,
                                color: Colors.white70,
                                size: 20.0,
                              ),
                            ),
                          ),
                          isPlaying == false
                              ? Container(
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                              : Container(
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.7,
                            child: MusicVisualizer(
                              numBars: 24,
                              barHeight: 12,
                            ),
                          ),

                          /*----------------------SLIDER INSTEAD OF DOTS
                                                      * /*SliderTheme(
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
                                                        ),*/
                                                      * */
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.audioDuration}",
                        //'${_current.duration!.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration!.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.grey.shade300),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                ),
                Center(
                  child: OurFilledButton(
                    context: context,
                    text: "done",
                    onPressed: () async {
                      /*String? audioUrl = await Storage()
                          .uploadBF(widget.uid!, widget.filePath.toString(),
                              widget.bfTitle);
                      Storage()
                          .listFiles(widget.uid!)
                          .then((value) => print('Done listing files'));*/
                      await storage
                          .ref().child(interacTitle)
                          .child("interaction_audios").putFile(File(widget
                          .filePath.toString()))
                          .then((taskSnapshot) {
                        print("task done");
                        if (taskSnapshot.state == TaskState.running) {
                          return Text("Loading...", style: Theme
                              .of(context)
                              .textTheme
                              .headline1,);
                        }
// download url when it is uploaded
                        else if (taskSnapshot.state == TaskState.success) {
                          storage.ref(
                              '${widget.interacTitle}/interaction_audios')
                              .getDownloadURL()
                              .then((url) {
                            FutureServices.instance.createInteraction(
                                widget.uid,
                                widget.username,
                                widget.profileImg,
                                interacId,
                                widget.interacTitle,
                                widget.bfId,
                                widget.bfTitle,
                                url,
                                audioDuration);
                            print("Here is the URL of Image $url");
                            return url;
                          }).catchError((onError) {
                            print("Got Error $onError");
                          });
                        }
                        Navigator.pushReplacementNamed(context, "home");
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildControl() {
    Icon icon;
    Color color;

    icon =
        Icon(Icons.play_arrow, color: Theme
            .of(context)
            .primaryColor, size: 26);
    color = Theme
        .of(context)
        .indicatorColor
        .withOpacity(0.9);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ClipOval(
        child: Material(
          color: color,
          child: InkWell(
            child: SizedBox(width: 38, height: 38, child: icon),
            onTap: () async {
              play();
            },
          ),
        ),
      ),
    );
  }

  Future<void> play() async {
    await _audio.play(widget.filePath!, isLocal: true);
    _audio.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => durationBf = d);
    });
  }

  Future<void> pause() {
    return _audio.pause();
  }

  Future<int> stop() async {
    await _audio.stop();
    return _audio.seek(const Duration(milliseconds: 0));
  }
}