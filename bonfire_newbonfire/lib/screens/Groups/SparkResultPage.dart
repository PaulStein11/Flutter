import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/screens/Bonfire/CreateInteracPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import '../../widgets/AudienceWidget.dart';
import '../../widgets/CircleAddButton.dart';
import '../../widgets/OurLoadingWidget.dart';

class SparkResultPage extends StatefulWidget {
  String sparkId;

  SparkResultPage({required this.sparkId});

  @override
  State<SparkResultPage> createState() => _SparkResultPageState(this.sparkId);
}

class _SparkResultPageState extends State<SparkResultPage> {
  String sparkId;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;
  bool isPlayingInt = false;

  _SparkResultPageState(this.sparkId);

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
                            horizontal: 15.0, vertical: 20.0),
                        child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('sparks')
                                .doc(sparkId)
                                .snapshots(),
                            builder: (BuildContext context, snapshot) {
                              var sparkData = snapshot.data!.data();
                              if (snapshot.hasData) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade700,
                                            radius: 18,
                                            backgroundImage: NetworkImage(
                                                sparkData!["profileImage"]),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(sparkData["owner"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3)
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              sparkData['title'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyFlutterApp.users,
                                                color: Colors.grey.shade400,
                                                size: 25.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Transform.translate(
                                                  offset:
                                                      const Offset(2.0, 4.0),
                                                  child: Text(
                                                      sparkData["audience"]
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .copyWith(
                                                              color: Colors.grey
                                                                  .shade400)),
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
                                              isPlayingBF == false
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          isPlayingBF = true;
                                                        });
                                                        _audio.play(
                                                            sparkData["file"]);
                                                        _audio
                                                            .onPlayerCompletion
                                                            .listen((duration) {
                                                          setState(() {
                                                            isPlayingBF = false;
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .playCircle,
                                                        color: Colors.white70,
                                                        size: 29.0,
                                                      ))
                                                  : IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          isPlayingBF = false;
                                                        });
                                                        await _audio.pause();
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .pauseCircle,
                                                        size: 29.0,
                                                        color: Colors.white70,
                                                      )),
                                              Text(
                                                sparkData["audioDuration"]
                                                    .toString()
                                                    .substring(1),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .copyWith(
                                                        fontFamily: "Palanquin",
                                                        letterSpacing: -0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 17.5,
                                                        color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey.shade400,
                                                size: 25.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Transform.translate(
                                                  offset:
                                                      const Offset(2.0, 4.0),
                                                  child: Text(
                                                      sparkData["audience"]
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4!
                                                          .copyWith(
                                                              color: Colors.grey
                                                                  .shade400)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            }),
                      ),
                    ),
                  ),
                ),
                /*Container(
                    color: Theme.of(context).cardColor.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        "That's fire",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.orange.shade900),
                      ),
                    )),*/
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('results')
                      .doc(sparkId)
                      .collection("sparks_results")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Something went wrong',
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: Theme.of(context).accentColor),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: OurLoadingWidget(context));
                    } else if (snapshot.hasData) {
                      List<DocumentSnapshot> resultsWinners =
                          snapshot.data!.docs;
                      if (resultsWinners.isEmpty) {
                        return Container(
                          decoration:
                              BoxDecoration(color: Theme.of(context).cardColor),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: Text(
                                  "Error! No results found :(",
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Ink(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).cardColor.withOpacity(0.7),
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: resultsWinners.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 5.0),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              resultsWinners[index]["name2"][4],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey.shade700,
                                                radius: 21,
                                                backgroundImage: NetworkImage(
                                                  resultsWinners[index]["name2"]
                                                      [1],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                  resultsWinners[index]["name2"]
                                                      [0],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline3),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              isPlayingBF == false
                                                  ? IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          isPlayingBF = true;
                                                        });
                                                        _audio.play(
                                                          resultsWinners[index]
                                                              ["name2"][2],
                                                        );
                                                        _audio
                                                            .onPlayerCompletion
                                                            .listen((duration) {
                                                          setState(() {
                                                            isPlayingBF = false;
                                                          });
                                                        });
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .playCircle,
                                                        color: Colors.white70,
                                                        size: 32.0,
                                                      ))
                                                  : IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          isPlayingBF = false;
                                                        });
                                                        await _audio.pause();
                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons
                                                            .pauseCircle,
                                                        size: 32.0,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                MyFlutterApp.chevron_up_circle,
                                                color: Colors.orange.shade700,
                                                size: 25.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                    resultsWinners[index]
                                                    ["name2"][3]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                        color: Colors.grey
                                                            .shade400)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey.shade400,
                                                size: 25.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                    resultsWinners[index]
                                                    ["name2"][3]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                        color: Colors.grey
                                                            .shade400)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )

                                    /*Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: IconButton(onPressed: (){}, icon: Icon(MyFlutterApp.angle_circled_up, size: 32.0, color: Theme.of(context).primaryColor,)),
                                    )*/
                                  ],
                                ),
                              );
                            }),
                      );
                    }
                    return OurLoadingWidget(context);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
