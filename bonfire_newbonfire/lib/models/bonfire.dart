import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import '../my_flutter_app_icons.dart';
import '../screens/Bonfire/BonfirePage.dart';

class Bonfire extends StatefulWidget {
  late String bfId, bfTitle, bfAudioFile, bfOwner, ownerId, ownerImage, file;
  late int audience;
  Bonfire(
      {required this.bfId,
      required this.bfTitle,
      required this.audience,
      required this.bfAudioFile,
      required this.bfOwner,
      required this.ownerId,
      required this.ownerImage,
      required this.file});

  @override
  State<Bonfire> createState() => _BonfireState(
      this.bfId, this.bfTitle, this.audience, this.bfAudioFile, this.bfOwner, this.ownerId, this.ownerImage, this.file);
}

class _BonfireState extends State<Bonfire> {
  late String bfId, bfTitle, bfAudioFile, bfOwner, ownerId, ownerImage, file;
  late int audience;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;

  _BonfireState(
      this.bfId, this.bfTitle, this.audience, this.bfAudioFile, this.bfOwner, this.ownerId, this.ownerImage, this.file);

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BonfirePage(bfId: widget.bfId, bfTitle: widget.bfTitle, ownerId: widget.ownerId),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.75),
              borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Flexible(
                      child: Text(
                        widget.bfTitle,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.clip,
                            ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MyFlutterApp.users,
                            color: Colors.grey.shade400,
                            size: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Transform.translate(
                              offset: const Offset(2.0, 4.0),
                              child: Text(widget.audience.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.grey.shade400)),
                            ),
                          ),
                        ],
                      ),
                      isPlayingBF == false
                          ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  isPlayingBF = true;
                                });
                                _audio.play(widget.bfAudioFile);
                                _audio.onPlayerCompletion.listen((duration) {
                                  setState(() {
                                    isPlayingBF = false;
                                  });
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.playCircle,
                                color: Colors.white70,
                                size: 28.0,

                              ))
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  isPlayingBF = false;
                                });
                                await _audio.pause();
                              },
                              icon: Icon(
                                FontAwesomeIcons.pauseCircle,
                                color: Colors.white70,
                                size: 28.0,
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
