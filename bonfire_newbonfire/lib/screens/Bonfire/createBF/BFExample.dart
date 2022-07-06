import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/screens/Bonfire/CreateInteracPage.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

import '../../../widgets/CircleAddButton.dart';
import '../../../widgets/OurLoadingWidget.dart';
import 'CreateBFPage.dart';

class BFExample extends StatefulWidget {
  BFExample({this.uid, this.username, this.profileImg});

  String? uid, username, profileImg; // User data to be passed onto nex screen

  @override
  State<BFExample> createState() =>
      _BFExampleState(this.uid, this.username, this.profileImg);
}

class _BFExampleState extends State<BFExample> {
  //AUDIO PLAYER
  String? uid, username, profileImg; // User data to be passed onto nex screen
  _BFExampleState(String? uid, String? username, String? profileImg);

  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;
  bool isPlayingInt = false;
  List<String> titles = ["title 1, title2, title 3"];
  List<String> userNames = ["Robin", "Patricia", "Kyle"];
  List<String> profileImages = [
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/examples%2FprofileImages%2FSF.jpg?alt=media&token=fa571ab2-f83c-4690-85d8-ad3f99c7afad",
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/examples%2FprofileImages%2Fgreen.png?alt=media&token=e743eb03-907d-4b8f-9d7a-37c1b7c96e85",
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/examples%2FprofileImages%2Fyellow.png?alt=media&token=ed8aa451-5fa0-41f9-af38-6e5ef6b1f81a"
  ];
  List<String> fileAudios = [
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/Robin%2Fbonfire_audios?alt=media&token=23a73814-d847-4e39-84c6-90f486c2e1ac",
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/Robin%2Fbonfire_audios?alt=media&token=23a73814-d847-4e39-84c6-90f486c2e1ac",
    "https://firebasestorage.googleapis.com/v0/b/pagoda-7fac2.appspot.com/o/Robin%2Fbonfire_audios?alt=media&token=23a73814-d847-4e39-84c6-90f486c2e1ac",
  ];

  @override
  void initState() {
    // TODO: implement initState
    _audio = audio.AudioPlayer();
    bool isPlaying = false;
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
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).accentColor,),
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Robin likes to participate in new tech conversations and this can be one of them",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w500,
                  fontSize: 17.0),
                ),
              ),
            ),
          ),
        ),
        Material(
          elevation: 0.0,
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade700,
                          radius: 22,
                          backgroundImage: NetworkImage(profileImages[0]),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(userNames[0],
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(fontSize: 17.0))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            "",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border:
                            Border.all(color: Theme.of(context).cardColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isPlayingBF == false
                            ? IconButton(
                            onPressed: () async {
                              setState(() {
                                isPlayingBF = true;
                              });
                              _audio.play(fileAudios[0]);
                              _audio.onPlayerCompletion
                                  .listen((duration) {
                                setState(() {
                                  isPlayingBF = false;
                                });
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.playCircle,
                              color: Colors.white70,
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
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isPlayingBF == false
                                ? Colors.grey.shade300
                                : Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        /*Text(
                                      bfData["audioDuration"]
                                          .toString()
                                          .substring(1),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(
                                          fontFamily: "Palanquin",
                                          letterSpacing: -0.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.5,
                                          color: Colors.grey),
                                    ),*/
                      ],
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textBaseline: TextBaseline.ideographic,
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
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Transform.translate(
                                offset: const Offset(2.0, 4.0),
                                child: Text(10.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.grey.shade400)),
                              ),
                            ),
                          ],
                        ),
                        CircleAddButton(
                          context,
                          onPressed: () {
                            showModalBottomSheet(
                              barrierColor:
                                  Colors.grey.shade800.withOpacity(0.8),
                              elevation: 10.0,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: new Icon(
                                          FontAwesomeIcons.message,
                                          color: Colors.white,
                                        ),
                                        title: new Text('Interact',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                        onTap: () {
                                          /*Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => CreateInteractionPage(
                                                                bfTitle:
                                                                bfData[
                                                                "title"],
                                                                bfId: bfData[
                                                                "bfId"])));*/
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
                                          /*await showAlertDialog(
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
                                                              .createDynamicLink());*/
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
                  ),*/
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /*Material(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 2.0,
                    child: MaterialButton(
                      onPressed: (){},
                      minWidth: 150.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "see more",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),*/
                  OurFilledButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateBFPage(
                              uid: widget.uid,
                              username: widget.username,
                              profileImg: widget.profileImg,
                            ),
                          ),
                          ModalRoute.withName('home'),
                        );
                      },
                      context: context,
                      text: "continue"),
                  SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
