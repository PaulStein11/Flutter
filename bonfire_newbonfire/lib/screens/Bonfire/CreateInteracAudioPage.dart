import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:bf_pagoda/screens/Bonfire/UploadInterac.dart';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../widgets/OurRecordBFButton.dart';

String? path;
String? durationBf;

class RecordInteraction extends StatefulWidget {
  String interacTitle, bfId, bfTitle;
  String? uid, username, profileImg;

  RecordInteraction(
      {required this.uid,
      required this.username,
      required this.profileImg,
      required this.interacTitle,
      required this.bfId,
      required this.bfTitle});

  @override
  _RecordInteractionState createState() => _RecordInteractionState(
      this.uid,
      this.username,
      this.profileImg,
      this.interacTitle,
      this.bfId,
      this.bfTitle);
}

class _RecordInteractionState extends State<RecordInteraction> {
  String interacTitle, bfId, bfTitle;
  String? uid, username, profileImg, minutes, seconds;

  bool _isRecording = false, _isPaused = false;

  //Audio Player states
  late audio.AudioPlayer _audio;
  int recordDuration = 0;
  Timer? _timer;

  //Amplitude? _amplitude;
  //ap.AudioPlayer? _audioPlayer;
  late FlutterAudioRecorder2 _audioRecorder;

  _RecordInteractionState(this.uid, this.username, this.profileImg,
      this.interacTitle, this.bfId, this.bfTitle);

  @override
  void initState() {
    _isRecording = false;
    _audio = audio.AudioPlayer();
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
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              _recordBtn(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRecordStopControl(),
                  _buildPauseResumeControl(),
                  _uploadAudio(),
                ],
              )
            ],
          ),
        ),
      ),

      /*Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              _buildRecordStopControl(),
              _buildPauseResumeControl(),

            ],
          ),
          if (_amplitude != null) ...[
            const SizedBox(height: 40),
            Text('Current: ${_amplitude?.current ?? 0.0}'),
            Text('Max: ${_amplitude?.max ?? 0.0}'),
          ],
        ],
      ),*/
    );
  }

  Widget _recordBtn() {
    return OurRecordBFButton(context, _isRecording, () {
      if (_isRecording == false || _isPaused == true) {
        _start();
      }
    });
  }

  Widget _buildRecordStopControl() {
    if (_isRecording || _isPaused) {
      return ClipOval(
        child: Material(
          color: Theme.of(context).accentColor.withOpacity(0.85),
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
              });
              _audio.onDurationChanged.listen((Duration d) {
                print('Max duration: $d');
                durationBf = d.toString();
              });
              print(path);
              print(recordDuration.toString());
              Navigator.push(
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
              );
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
    }

    return Text(
      "Waiting to record",
      style: TextStyle(
          color: Colors.grey,
          fontSize: 19.0,
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
        log("AUDIO FILE PATH: $path");
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
