import 'dart:async';
import 'dart:io';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/OurFilledButton.dart';
import '../../widgets/OurRecordBFButton.dart';
import '../../widgets/audio_stream/MusicVisualizer.dart';

String? path;
String? durationBf;
var newQuestion;

class FirstQuestionsPage extends StatefulWidget {
  const FirstQuestionsPage({Key? key}) : super(key: key);

  @override
  State<FirstQuestionsPage> createState() => _FirstQuestionsPageState();
}

class _FirstQuestionsPageState extends State<FirstQuestionsPage> {
  String? uid, minutes, seconds;
  int? _totalTime, _currentTime;
  bool _isRecording = false,
      _isPaused = false,
      _isRecorded = false,
      isPlaying = false;
  late AuthProvider _auth;

  //Audio Player states
  late audio.AudioPlayer _audio;
  int recordDuration = 0;
  Timer? _timer;
  List<String> questions = [
    "What are the 3 challenges from our generation?",
    "What is your song for COVID 19?",
    "Your best meme or joke for this 2022"
  ];

  //Amplitude? _amplitude;
  //ap.AudioPlayer? _audioPlayer;
  late FlutterAudioRecorder2 _audioRecorder;

  void shuffleList() {
    setState(() {
      questions.shuffle();
    });
  }

  @override
  void initState() {
    _isRecording = false;
    _audio = audio.AudioPlayer();
    questions.shuffle();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audio.dispose();
    _audioRecorder;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return Scaffold(
            appBar: AppBar(
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
              actions: [
                _isRecording == false && _isRecorded == false
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          color: Colors.orange.shade800,
                          child: IconButton(
                              onPressed: () => shuffleList(),
                              icon: Icon(
                                FontAwesomeIcons.shuffle,
                                color: Colors.grey.shade200,
                              )),
                        ),
                      )
                    : _isRecorded == true
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              color: Colors.orange.shade800,
                              child: IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(_auth.user!.uid)
                                        .update({
                                      "groups": true,
                                    });
                                    navigatorKey?.currentState?.pushNamed("main_groups");
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.check,
                                    color: Colors.grey.shade200,
                                  )),
                            ),
                          )
                        : Text("")
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        questions.first,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.75),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _recordBtn(),
                      _buildText(),
                    ],
                  ),
                  _audioListenerControl(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRecordStopControl(),
                      _buildPauseResumeControl(),
                      _uploadAudio(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _audioListenerControl() {
    if (_isRecorded == true) {
      return Column(
        children: [
          /*Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              "Audio",
              style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: Colors.grey.shade800, width: 2)),
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
                              _audio.play(path!);
                              _audio.onDurationChanged.listen((duration) {
                                setState(() {
                                  _totalTime = duration.inMicroseconds;
                                });
                              });
                              _audio.onAudioPositionChanged.listen((duration) {
                                setState(() {
                                  _currentTime = duration.inMicroseconds;
                                });
                              });
                              _audio.onPlayerCompletion.listen((duration) {
                                setState(() {
                                  isPlaying = false;
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
                                  borderRadius: BorderRadius.circular(20.0),
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
                            splashColor: Theme.of(context).accentColor,
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.7,
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
                  "$minutes : $seconds",
                  //'${_current.duration!.inMinutes.remainder(60).toString().padLeft(1, '0')}:${_current.duration!.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 15.0, color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Text("");
  }

  Widget _recordBtn() {
    return OurRecordBFButton(context, _isRecording, () {
      setState(() {
        _isRecorded = false;
      });
      if (_isRecording == false || _isPaused == true) {
        _start();
      }
    });
  }

  Widget _buildRecordStopControl() {
    if (_isRecording || _isPaused) {
      return ClipOval(
        child: Material(
          color: Theme.of(context).accentColor.withOpacity(0.95),
          child: InkWell(
            child: SizedBox(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.stop,
                  size: 30.0,
                  color: Theme.of(context).indicatorColor,
                )),
            onTap: () {
              _isRecording ? _stop() : _start();
            },
          ),
        ),
      );
    }
    return Text("");
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;

    if (!_isPaused) {
      icon = Icon(
        Icons.pause,
        size: 30.0,
        color: Theme.of(context).primaryColor.withOpacity(0.9),
      );
    } else {
      final theme = Theme.of(context);
      icon = Icon(
        Icons.play_arrow,
        size: 30.0,
        color: Theme.of(context).primaryColor.withOpacity(0.9),
      );
    }

    return ClipOval(
      child: Material(
        color: Theme.of(context).indicatorColor,
        child: InkWell(
          child: SizedBox(width: 60, height: 60, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _uploadAudio() {
    if (_isRecording || _isPaused) {
      return ClipOval(
        child: Material(
          color: Colors.teal.withOpacity(0.85),
          child: InkWell(
            onTap: () async {
              _audioRecorder.stop();
              setState(() {
                _isRecording = false;
                _isPaused = false;
                _isRecorded = true;
              });
              _audio.onDurationChanged.listen((Duration d) {
                print('Max duration: $d');
                durationBf = d.toString();
              });
              print(path);
              print(recordDuration.toString());
              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => UploadInterac(
                      uid: widget.uid,
                      username: widget.username,
                      profileImg: widget.profileImg,
                      interacTitle: widget.interacTitle,
                      audioDuration: "$minutes : $seconds",
                      filePath: path,
                      bfId: widget.bfId,
                      bfTitle: widget.bfTitle,
                    ) /*UploadBF(
                          bfTitle: widget.bfTitle,
                          bfDuration: widget.bfDuration,
                          anonymous: widget.anonymous,
                          filePath: path,
                        ),*/
                ),
              );*/
            },
            child: SizedBox(
              width: 60.0,
              height: 60.0,
              child: Icon(
                FontAwesomeIcons.check,
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
        ),
      );
    }
    return Text("");
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    } else if (_isRecorded == true) {
      return Text("");
    }

    return Text(
      "Waiting to record",
      style: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.75),
    );
  }

  Widget _buildTimer() {
    minutes = _formatNumber(recordDuration ~/ 60);
    seconds = _formatNumber(recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 22.0,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.75),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  Future<void> _start() async {
    await Permission.microphone.request();

    final bool? hasRecordingPermission = await FlutterAudioRecorder2
        .hasPermissions
        .timeout(Duration(seconds: 2), onTimeout: () async {
      print('microphone permissions not available, need to request');
      await Permission.microphone.request();
    });
    try {
      if (hasRecordingPermission ?? false) {
        Directory directory = await getApplicationDocumentsDirectory();
        path = directory.path +
            '/' +
            DateTime.now().millisecondsSinceEpoch.toString() +
            '.aac';
        _audioRecorder =
            FlutterAudioRecorder2(path!, audioFormat: AudioFormat.AAC);
        await _audioRecorder.initialized;
        _audioRecorder.start();
        var recording = await _audioRecorder.current(channel: 0);
        var current = await recording!.status.toString();
        //bool isRecording = await _audioRecorder.recording

        setState(() {
          _isRecording = true;
          recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      _isPaused = false;
    });
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
    int time = await _audioRecorder.recording!.duration!.inSeconds;
    setState(() {
      _isPaused = true;
      print(time);
    });
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => recordDuration++);
    });
  }
}
