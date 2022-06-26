import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Bonfire/CreateInteracPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/interaction.dart';
import '../../services/dynamic_services.dart';
import '../../services/stream_services.dart';
import '../../widgets/AudienceWidget.dart';
import '../../widgets/CircleAddButton.dart';
import '../../widgets/OurLoadingWidget.dart';
import '../../widgets/OurOutlinedButton.dart';

class BonfirePage extends StatefulWidget {
  String? bfId, bfTitle, ownerId;

  BonfirePage(
      {required this.bfId, required this.bfTitle, required this.ownerId});

  @override
  State<BonfirePage> createState() =>
      _BonfirePageState(this.bfId, this.bfTitle, this.ownerId);
}

class _BonfirePageState extends State<BonfirePage> {
  late AuthProvider _auth;

  String? bfId, bfTitle, ownerId;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;
  bool isPlayingInt = false;

  _BonfirePageState(this.bfId, this.bfTitle, this.ownerId);

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
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return _bonfirePageUI();
        },
      ),);
  }

  Widget _bonfirePageUI() {
    return StreamBuilder<MyUserModel>(
        stream: StreamServices.instance.getUserData(_auth.user!.uid),

        builder: (context, AsyncSnapshot<MyUserModel> snapshot) {
          if (snapshot.hasError) {
            Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return OurLoadingWidget(context);
          }
          final MyUserModel userData = snapshot.data!;
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
                            color: Theme
                                .of(context)
                                .backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 20.0),
                              child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('bonfires')
                                      .doc(bfId)
                                      .snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.hasError) {
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text('Error: ${snapshot.error}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Text('Stack trace: ${snapshot.stackTrace}'),
                                          ),
                                        ],
                                      );
                                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                                      return OurLoadingWidget(context);
                                    }
                                    final bfData = snapshot.data!.data();

                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              bfData!["isAnonymous"] == true
                                                  ? CircleAvatar(
                                                backgroundColor:
                                                Theme
                                                    .of(context)
                                                    .primaryColor
                                                    .withOpacity(0.8),
                                                radius: 22.0,
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundColor:
                                                  Theme
                                                      .of(context)
                                                      .cardColor,
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .userSecret,
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor
                                                        .withOpacity(0.85),
                                                    size: 20.0,
                                                  ),
                                                ),
                                              )
                                                  : CircleAvatar(
                                                backgroundColor:
                                                Colors.grey.shade700,
                                                radius: 18,
                                                backgroundImage: NetworkImage(
                                                    bfData["ownerImage"]),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              bfData!["isAnonymous"] == true
                                                  ? Transform.translate(
                                                offset:
                                                const Offset(2.5, 0.0),
                                                child: Text("Mr Anonymous",
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .headline3),
                                              )
                                                  : Text(bfData["ownerName"],
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline3)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  bfData['title'],
                                                  style: Theme
                                                      .of(context)
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
                                              vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              isPlayingBF == false
                                                  ? IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isPlayingBF = true;
                                                    });
                                                    _audio.play(
                                                        bfData["file"]);
                                                    _audio.onPlayerCompletion
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
                                                    color: Colors.white70,
                                                  )),
                                              Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width *
                                                    0.6,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: isPlayingBF == false
                                                      ? Colors.grey.shade300
                                                      : Colors.amber.shade600,
                                                  borderRadius:
                                                  BorderRadius.circular(5),
                                                ),
                                              ),
                                              Text(
                                                bfData["audioDuration"]
                                                    .toString()
                                                    .substring(1),
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .copyWith(
                                                    fontFamily: "Palanquin",
                                                    letterSpacing: -0.5,
                                                    fontWeight: FontWeight
                                                        .w600,
                                                    fontSize: 16.5,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            textBaseline: TextBaseline
                                                .ideographic,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    MyFlutterApp.users,
                                                    color: Colors.grey
                                                        .shade400,
                                                    size: 25.0,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 15.0),
                                                    child: Transform
                                                        .translate(
                                                      offset:
                                                      const Offset(2.0, 4.0),
                                                      child: Text(
                                                          bfData["audience"]
                                                              .toString(),
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headline4!
                                                              .copyWith(
                                                              color: Colors
                                                                  .grey
                                                                  .shade400)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              CircleAddButton(
                                                context,
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    barrierColor: Colors
                                                        .grey.shade800
                                                        .withOpacity(0.8),
                                                    elevation: 10.0,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12.0,
                                                            horizontal: 10.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: <Widget>[
                                                            ListTile(
                                                              leading: new Icon(
                                                                FontAwesomeIcons
                                                                    .message,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              title: new Text(
                                                                  'Interact',
                                                                  style: Theme
                                                                      .of(
                                                                      context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () {
                                                                Navigator
                                                                    .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (
                                                                            context) =>
                                                                            CreateInteractionPage(
                                                                                bfTitle:
                                                                                bfData[
                                                                                "title"],
                                                                                bfId: bfData[
                                                                                "bfId"])));
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
                                                                  style: Theme
                                                                      .of(
                                                                      context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () async {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (
                                                                      context) =>
                                                                      AlertDialog(
                                                                        contentPadding: EdgeInsets
                                                                            .all(
                                                                            15.0),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius
                                                                                .all(
                                                                                Radius
                                                                                    .circular(
                                                                                    20.0))),
                                                                        backgroundColor: Color(
                                                                            0xff2A2827),
                                                                        title: Text(
                                                                          "Share bonfire",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: Theme
                                                                              .of(
                                                                              context)
                                                                              .textTheme
                                                                              .headline4,
                                                                        ),
                                                                        content: Text(
                                                                          "Obtain link to start sharing this bonfire",
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: Theme
                                                                              .of(
                                                                              context)
                                                                              .textTheme
                                                                              .headline1,
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          FlatButton(
                                                                            color: Theme
                                                                                .of(
                                                                                context)
                                                                                .primaryColor,
                                                                            child: Text(
                                                                              "cancel",
                                                                            ),
                                                                            onPressed: () =>
                                                                                Navigator
                                                                                    .of(
                                                                                    context)
                                                                                    .pop(
                                                                                    false),
                                                                          ),
                                                                          FutureBuilder<
                                                                              Uri>(
                                                                              future: DynamicLinkService()
                                                                                  .createLongDynamicLink(
                                                                                  bfTitle!,
                                                                                  "${bfData["ownerName"]} - open bonfire"),
                                                                              builder: (
                                                                                  context,
                                                                                  snapshot) {
                                                                                if (snapshot
                                                                                    .hasData) {
                                                                                  Uri? uri = snapshot
                                                                                      .data;
                                                                                  return FlatButton(
                                                                                    onPressed: () =>
                                                                                        FlutterShare
                                                                                            .share(
                                                                                            title: "example",
                                                                                            linkUrl: uri
                                                                                                .toString()),
                                                                                    color: Theme
                                                                                        .of(
                                                                                        context)
                                                                                        .indicatorColor,
                                                                                    child: Text(
                                                                                      "continue",
                                                                                      style: TextStyle(
                                                                                          color: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .primaryColor),
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  return FlatButton(
                                                                                    color: Theme
                                                                                        .of(
                                                                                        context)
                                                                                        .indicatorColor,
                                                                                    onPressed: () {},
                                                                                    child: Text(
                                                                                      "share",
                                                                                      style: TextStyle(
                                                                                          color: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .primaryColor),
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              }),
                                                                        ],
                                                                      ),
                                                                );
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
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('sparks')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Something went wrong',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Theme
                                  .of(context)
                                  .accentColor),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: OurLoadingWidget(context));
                          } else if (snapshot.hasData) {
                            List<DocumentSnapshot> listOfSparks =
                                snapshot.data!.docs;
                            if (listOfSparks.isEmpty) {
                              return Column(
                                children: [
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50.0, horizontal: 20.0),
                                    child: OurOutlineButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateInteractionPage(
                                                          bfTitle: widget
                                                              .bfTitle,
                                                          bfId: widget.bfId)));
                                        },
                                        context: context,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        text: "start interacting",
                                        hasIcon: false),
                                  ),
                                ],
                              );
                            }
                            return Ink(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listOfSparks.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                listOfSparks[index]
                                                ["name1"],
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline1,
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                  Colors.grey.shade700,
                                                  radius: 17.5,
                                                  backgroundImage: NetworkImage(
                                                      listOfSparks[index]
                                                      ["name2"]),
                                                ),
                                                Container(
                                                  /*decoration: BoxDecoration(
                                           border: Border.all(color: Colors.grey),
                                           borderRadius: BorderRadius.circular(50.0)
                                         ),*/
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      isPlayingInt == false
                                                          ? IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              isPlayingInt =
                                                              true;
                                                            });
                                                            _audio.play(
                                                                listOfSparks[
                                                                index]
                                                                ["file"]);
                                                            _audio
                                                                .onPlayerCompletion
                                                                .listen(
                                                                    (duration) {
                                                                  setState(() {
                                                                    isPlayingInt =
                                                                    false;
                                                                  });
                                                                });
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .playCircle,
                                                            color: Colors
                                                                .white70,
                                                          ))
                                                          : IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              isPlayingInt =
                                                              false;
                                                            });
                                                            _audio.pause();
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .pauseCircle,
                                                            color: Colors
                                                                .white70,
                                                          )),
                                                      Container(
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.5,
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          color: isPlayingInt ==
                                                              false
                                                              ? Colors.grey
                                                              .shade300
                                                              : Colors.amber
                                                              .shade600,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 3.0),
                                                        child: Text(
                                                          listOfSparks[index]
                                                          ["audioDuration"]
                                                              .toString()
                                                              .substring(1),
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headline1!
                                                              .copyWith(
                                                              fontFamily:
                                                              "Palanquin",
                                                              letterSpacing: -0.5,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 16.5,
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('interactions')
                            .doc(bfId)
                            .collection("usersInteractions")
                            .orderBy("timestamp", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Something went wrong',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Theme
                                  .of(context)
                                  .accentColor),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: OurLoadingWidget(context));
                          } else if (snapshot.hasData) {
                            List<DocumentSnapshot> listOfInteractions =
                                snapshot.data!.docs;
                            if (listOfInteractions.isEmpty) {
                              return Column(
                                children: [
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50.0, horizontal: 20.0),
                                    child: OurOutlineButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateInteractionPage(
                                                          bfTitle: widget
                                                              .bfTitle,
                                                          bfId: widget.bfId)));
                                        },
                                        context: context,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        text: "start interacting",
                                        hasIcon: false),
                                  ),
                                ],
                              );
                            }
                            return Ink(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listOfInteractions.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                listOfInteractions[index]
                                                ["interacTitle"],
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headline1,
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                  Colors.grey.shade700,
                                                  radius: 17.5,
                                                  backgroundImage: NetworkImage(
                                                      listOfInteractions[index]
                                                      ["ownerImage"]),
                                                ),
                                                Container(
                                                  /*decoration: BoxDecoration(
                                           border: Border.all(color: Colors.grey),
                                           borderRadius: BorderRadius.circular(50.0)
                                         ),*/
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      isPlayingInt == false
                                                          ? IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              isPlayingInt =
                                                              true;
                                                            });
                                                            _audio.play(
                                                                listOfInteractions[
                                                                index]
                                                                ["file"]);
                                                            _audio
                                                                .onPlayerCompletion
                                                                .listen(
                                                                    (duration) {
                                                                  setState(() {
                                                                    isPlayingInt =
                                                                    false;
                                                                  });
                                                                });
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .playCircle,
                                                            color: Colors
                                                                .white70,
                                                          ))
                                                          : IconButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              isPlayingInt =
                                                              false;
                                                            });
                                                            _audio.pause();
                                                          },
                                                          icon: Icon(
                                                            FontAwesomeIcons
                                                                .pauseCircle,
                                                            color: Colors
                                                                .white70,
                                                          )),
                                                      Container(
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width *
                                                            0.5,
                                                        height: 4,
                                                        decoration: BoxDecoration(
                                                          color: isPlayingInt ==
                                                              false
                                                              ? Colors.grey
                                                              .shade300
                                                              : Colors.amber
                                                              .shade600,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 12.0,
                                                            right: 3.0),
                                                        child: Text(
                                                          listOfInteractions[index]
                                                          ["fileDuration"]
                                                              .toString()
                                                              .substring(1),
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headline1!
                                                              .copyWith(
                                                              fontFamily:
                                                              "Palanquin",
                                                              letterSpacing: -0.5,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 16.5,
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
        });
  }



/*@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return _bonfirePageUI();
        },
      ),
    );
  }

  Widget _bonfirePageUI() {
    return StreamBuilder<MyUserModel>(
        stream: StreamServices.instance.getUserData(_auth.user!.uid),
        builder: (context, AsyncSnapshot<MyUserModel> snapshot) {
          if (snapshot.hasError) {
            Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return OurLoadingWidget(context);
          }
          final MyUserModel userData = snapshot.data!;
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
                            color: Theme
                                .of(context)
                                .backgroundColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 20.0),
                              child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('bonfires')
                                      .doc(bfId)
                                      .snapshots(),
                                  builder: (BuildContext context, snapshot) {
                                    var bfData = snapshot.data!.data();
                                    if (snapshot.hasData) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                bfData!["isAnonymous"] == true
                                                    ? CircleAvatar(
                                                  backgroundColor:
                                                  Theme
                                                      .of(context)
                                                      .primaryColor
                                                      .withOpacity(0.8),
                                                  radius: 22.0,
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundColor:
                                                    Theme
                                                        .of(context)
                                                        .cardColor,
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .userSecret,
                                                      color: Theme
                                                          .of(context)
                                                          .primaryColor
                                                          .withOpacity(0.85),
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                )
                                                    : CircleAvatar(
                                                  backgroundColor:
                                                  Colors.grey.shade700,
                                                  radius: 18,
                                                  backgroundImage: NetworkImage(
                                                      bfData["ownerImage"]),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                bfData!["isAnonymous"] == true
                                                    ? Transform.translate(
                                                  offset:
                                                  const Offset(2.5, 0.0),
                                                  child: Text("Mr Anonymous",
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .headline3),
                                                )
                                                    : Text(bfData["ownerName"],
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .headline3)
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
                                                    bfData['title'],
                                                    style: Theme
                                                        .of(context)
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
                                                vertical: 12.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                    Theme
                                                        .of(context)
                                                        .cardColor,
                                                    width: 1.5),
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8.0, vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    isPlayingBF == false
                                                        ? GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          isPlayingBF = true;
                                                        });
                                                        _audio.play(
                                                            bfData["file"]);
                                                        _audio
                                                            .onPlayerCompletion
                                                            .listen((duration) {
                                                          setState(() {
                                                            isPlayingBF = false;
                                                          });
                                                        });
                                                      },
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .playCircle,
                                                        color: Colors.white70,
                                                        size: 26.5,
                                                      ),
                                                    )
                                                        : GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          isPlayingBF = true;
                                                        });
                                                        _audio.play(
                                                            bfData["file"]);
                                                        _audio
                                                            .onPlayerCompletion
                                                            .listen((duration) {
                                                          setState(() {
                                                            isPlayingBF = false;
                                                          });
                                                        });
                                                      },
                                                      child: Icon(
                                                        FontAwesomeIcons
                                                            .pauseCircle,
                                                        color: Colors.white70,
                                                        size: 26.5,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width *
                                                          0.6,
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        color: isPlayingBF == false
                                                            ? Colors.grey.shade300
                                                            : Colors.amber.shade600,
                                                        borderRadius:
                                                        BorderRadius.circular(5),
                                                      ),
                                                    ),
                                                    Text(
                                                      bfData["audioDuration"]
                                                          .toString()
                                                          .substring(1),
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .headline1!
                                                          .copyWith(
                                                          fontFamily: "Palanquin",
                                                          letterSpacing: -0.5,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 16.5,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
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
                                                            bfData["audience"]
                                                                .toString(),
                                                            style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .headline4!
                                                                .copyWith(
                                                                color: Colors.grey
                                                                    .shade400)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                CircleAddButton(
                                                  context,
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      barrierColor: Colors
                                                          .grey.shade800
                                                          .withOpacity(0.8),
                                                      elevation: 10.0,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              vertical: 12.0,
                                                              horizontal: 10.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            children: <Widget>[
                                                              ListTile(
                                                                leading: new Icon(
                                                                  FontAwesomeIcons
                                                                      .message,
                                                                  color: Colors.white,
                                                                ),
                                                                title: new Text(
                                                                    'Interact',
                                                                    style: Theme
                                                                        .of(
                                                                        context)
                                                                        .textTheme
                                                                        .headline4),
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              CreateInteractionPage(
                                                                                  bfTitle:
                                                                                  bfData[
                                                                                  "title"],
                                                                                  bfId: bfData[
                                                                                  "bfId"])));
                                                                },
                                                              ),
                                                              ListTile(
                                                                leading: new Icon(
                                                                  Icons.share,
                                                                  color: Colors.white,
                                                                ),
                                                                title: new Text(
                                                                    'Share',
                                                                    style: Theme
                                                                        .of(
                                                                        context)
                                                                        .textTheme
                                                                        .headline4),
                                                                onTap: () async {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder:
                                                                        (context) =>
                                                                        AlertDialog(
                                                                          contentPadding:
                                                                          EdgeInsets
                                                                              .all(
                                                                              15.0),
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .all(
                                                                                  Radius
                                                                                      .circular(
                                                                                      20.0))),
                                                                          backgroundColor:
                                                                          Color(
                                                                              0xff2A2827),
                                                                          title: Text(
                                                                            "Share bonfire",
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                            style: Theme
                                                                                .of(
                                                                                context)
                                                                                .textTheme
                                                                                .headline4,
                                                                          ),
                                                                          content: Text(
                                                                            "Obtain link to start sharing this bonfire",
                                                                            textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                            style: Theme
                                                                                .of(
                                                                                context)
                                                                                .textTheme
                                                                                .headline1,
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
                                                                            FlatButton(
                                                                              color: Theme
                                                                                  .of(
                                                                                  context)
                                                                                  .primaryColor,
                                                                              child: Text(
                                                                                "cancel",
                                                                              ),
                                                                              onPressed: () =>
                                                                                  Navigator
                                                                                      .of(
                                                                                      context)
                                                                                      .pop(
                                                                                      false),
                                                                            ),
                                                                            FutureBuilder<
                                                                                Uri>(
                                                                                future: DynamicLinkService()
                                                                                    .createLongDynamicLink(
                                                                                    bfTitle!,
                                                                                    "${bfData["ownerName"]} - open bonfire"),
                                                                                builder:
                                                                                    (
                                                                                    context,
                                                                                    snapshot) {
                                                                                  if (snapshot
                                                                                      .hasData) {
                                                                                    Uri?
                                                                                    uri =
                                                                                        snapshot
                                                                                            .data;
                                                                                    return FlatButton(
                                                                                      onPressed: () =>
                                                                                          FlutterShare
                                                                                              .share(
                                                                                              title: "example",
                                                                                              linkUrl: uri
                                                                                                  .toString()),
                                                                                      color:
                                                                                      Theme
                                                                                          .of(
                                                                                          context)
                                                                                          .indicatorColor,
                                                                                      child:
                                                                                      Text(
                                                                                        "continue",
                                                                                        style: TextStyle(
                                                                                            color: Theme
                                                                                                .of(
                                                                                                context)
                                                                                                .primaryColor),
                                                                                      ),
                                                                                    );
                                                                                  } else {
                                                                                    return FlatButton(
                                                                                      color:
                                                                                      Theme
                                                                                          .of(
                                                                                          context)
                                                                                          .indicatorColor,
                                                                                      onPressed:
                                                                                          () {},
                                                                                      child:
                                                                                      Text(
                                                                                        "share",
                                                                                        style: TextStyle(
                                                                                            color: Theme
                                                                                                .of(
                                                                                                context)
                                                                                                .primaryColor),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                }),
                                                                          ],
                                                                        ),
                                                                  );
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
                                          ),
                                        ],
                                      );
                                    } else {
                                      Text("");
                                    }
                                    return Center(child: CircularProgressIndicator());
                                  }),
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<MyUserModel>(
                          stream: StreamServices.instance.getUserData(widget.ownerId),
                          builder: (context, AsyncSnapshot<MyUserModel> snapshot) {
                            if(snapshot.hasData) {
                              MyUserModel userData = snapshot.data!;
                              return userData.tip == false ? Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (userData.tip == false) {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(userData.uid)
                                                .update({"tip": true});
                                          }
                                          showDialog(context: context, builder: (_) =>
                                              AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(10.0))),
                                                content: Builder(
                                                  builder: (context) {
// Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                    var height =
                                                        MediaQuery
                                                            .of(context)
                                                            .size
                                                            .height;
                                                    var width = MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width;

                                                    return Container(
                                                        height: height - 500,
                                                        width: width - 50,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "Support interaction",
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: Theme
                                                                  .of(context)
                                                                  .textTheme
                                                                  .headline4!
                                                                  .copyWith(
                                                                  color: Colors.grey
                                                                      .shade600),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child: Text(
                                                                "Press and hold the interaction until it turns blue",
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .headline1!
                                                                    .copyWith(
                                                                    color: Colors.grey
                                                                        .shade800,
                                                                    fontSize: 17.0),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 16.5),
                                                              child: FlatButton(
                                                                color:
                                                                Theme
                                                                    .of(context)
                                                                    .indicatorColor,
                                                                child: Text(
                                                                  "continue",
                                                                  style: TextStyle(
                                                                      color: Theme
                                                                          .of(context)
                                                                          .primaryColor),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ));
                                                  },
                                                ),
                                              ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.orange.shade900,
                                                  width: 1.5),
                                              borderRadius:
                                              BorderRadius.circular(15.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.solidCheckCircle,
                                                    size: 18.0,
                                                    color: Colors.orange.shade900,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Center(
                                                      child: Text(
                                                        "New Tip",
                                                        style: TextStyle(
                                                          color: Theme
                                                              .of(context)
                                                              .primaryColor
                                                              .withOpacity(0.85),
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ) : Text("", style: TextStyle(fontSize: 1.0),);
                            }
                            return Text("Error getting access to data", style: Theme.of(context).textTheme.headline1,);
                          }),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('interactions')
                            .doc(bfId)
                            .collection("usersInteractions")
                            .orderBy("timestamp", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Something went wrong',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(color: Theme
                                  .of(context)
                                  .accentColor),
                            );
                          } else if (snapshot.data == null) {
                            return Text("");
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: OurLoadingWidget(context));
                          } else if (snapshot.hasData) {
                            List<DocumentSnapshot> listOfInteractions =
                                snapshot.data!.docs;
                            if (listOfInteractions.isEmpty) {
                              return Column(
                                children: [
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 50.0, horizontal: 20.0),
                                    child: OurOutlineButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateInteractionPage(
                                                          bfTitle: widget.bfTitle,
                                                          bfId: widget.bfId)));
                                        },
                                        context: context,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        text: "start interacting",
                                        hasIcon: false),
                                  ),
                                ],
                              );
                            }
                            return ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listOfInteractions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Interaction(
                                      interacTitle: listOfInteractions[index]
                                      ["interacTitle"],
                                      ownerImage: listOfInteractions[index]
                                      ["ownerImage"],
                                      interacAudioFile: listOfInteractions[index]
                                      ["file"],
                                      interacAudioDuration: listOfInteractions[index]
                                      ["fileDuration"]);
                                });
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
        });
  }*/
}


