import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

class Interaction extends StatefulWidget {
  late String interacTitle, ownerImage, interacAudioFile, interacAudioDuration;

  Interaction(
      {required this.interacTitle,
      required this.ownerImage,
      required this.interacAudioFile,
      required this.interacAudioDuration});

  @override
  State<Interaction> createState() => _InteractionState(this.interacTitle,
      this.ownerImage, this.interacAudioFile, this.interacAudioDuration);
}

class _InteractionState extends State<Interaction> {
  late String interacTitle, ownerImage, interacAudioFile, interacAudioDuration;

  _InteractionState(this.interacTitle, this.ownerImage, this.interacAudioFile,
      this.interacAudioDuration);

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlaying = false;
  bool isTapped = false;

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
    return GestureDetector(
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
    );
  }
}
