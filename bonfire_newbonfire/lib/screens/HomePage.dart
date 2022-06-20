import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Bonfire/createBF/BFExample.dart';
import 'package:bf_pagoda/screens/Bonfire/createBF/CreateBFPage.dart';
import 'package:bf_pagoda/screens/Groups/IntroGroups.dart';
import 'package:bf_pagoda/services/dynamic_services.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/services/stream_services.dart';
import 'package:bf_pagoda/widgets/CircleAddButton.dart';
import 'package:bf_pagoda/widgets/DrawerWidgets.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import '../main.dart';
import '../widgets/OurFloatingButton.dart';
import '../widgets/OurLoadingWidget.dart';
import 'Bonfire/BonfirePage.dart';
import 'Login/OnboardingPage.dart';
import 'SendFeedbackPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthProvider _auth;
  late ScrollController _chatScrollController;
  int loadMoreMsgs = 10; // at first it will load only 10
  int addXMore = 10;
  final Stream<QuerySnapshot> _bonfiresStream = FirebaseFirestore.instance
      .collection('bonfires')
      .orderBy("timestamp", descending: true)
      .snapshots();
  Uri? uri;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;

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
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return _homeUI();
        },
      ),
    );
  }

  Widget _homeUI() {
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
        print(userData.bonfires);
        return Scaffold(
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: DrawerHeader(
                      child: Row(
                    children: [
                      SizedBox(
                        width: 5.0,
                      ),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).indicatorColor,
                        radius: 26.0,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).indicatorColor,
                          radius: 20.0,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      appTitle(),
                    ],
                  )),
                ),
                Divider(color: Colors.grey.shade800),
                drawerListTile(
                  icon: FontAwesomeIcons.houseFire,
                  text: "Explore",
                  onPressed: () {
                    navigatorKey?.currentState?.pushNamed("main_groups");
                    /*if(userData.groups == false) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => IntroGroup()));
                    } else if(userData.groups == true) {
                      navigatorKey?.currentState?.pushNamed("main_groups");
                    }*/
                  },
                ),
                /*drawerListTile(
                  icon: FontAwesomeIcons.fireBurner,
                  text: "Divulge",
                  onPressed: () {
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupsPage(),
                      ),
                    );*/
                  },
                ),*/
                drawerListTile(
                  icon: Icons.feedback_rounded,
                  text: "Send feedback",
                  onPressed: () {
                    navigatorKey?.currentState
                        ?.pushReplacementNamed("onboarding");
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendFeedback(
                          id: userData.uid,
                          name: userData.name,
                          email: userData.email,
                        ),
                      ),
                    );*/
                  },
                ),
                drawerListTile(
                  icon: Icons.exit_to_app,
                  text: "Sign out",
                  onPressed: () async {
                    _auth.signOut();
                    _auth.signOutGoogle();
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: OurFloatingButton(
                context: context,
                onPressed: () {
                  if (userData.bonfires == 0) {
                    // Show example option
                    //TODO: Create a Widget out of this dialog
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        backgroundColor: Color(0xff2A2827),
                        title: Text(
                          "First bonfire",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        content: Text(
                          "Before start your first bonfire check some examples for reference",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        actions: [
                          FlatButton(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              "see examples",
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BFExample(
                                        uid: userData.uid,
                                        username: userData.name,
                                        profileImg: userData.profileImage,
                                      )));
                            },
                          ),
                          FlatButton(
                            color: Theme.of(context).indicatorColor,
                            child: Text(
                              "continue",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateBFPage(
                                    uid: userData.uid,
                                    username: userData.name,
                                    profileImg: userData.profileImage,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateBFPage(
                          uid: userData.uid,
                          username: userData.name,
                          profileImg: userData.profileImage,
                        ),
                      ),
                    );
                  }
                },
              )),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              elevation: 0.0,
              title: appTitle(),
              centerTitle: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bars,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                userData.profileImage.isEmpty
                    ? IconButton(
                        icon: Icon(
                          FontAwesomeIcons.solidCircleUser,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 28.0,
                        ),
                        onPressed: () {
                          navigatorKey?.currentState?.pushNamed("profile");
                        },
                      )
                    : GestureDetector(
                        onTap: () =>
                            navigatorKey?.currentState?.pushNamed("profile"),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade700,
                          radius: 19,
                          child: ClipOval(
                            child: Image.network(
                              userData.profileImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  width: 8.0,
                )
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _bonfiresStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Something went wrong',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Theme.of(context).accentColor),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: OurLoadingWidget(context));
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BonfirePage(
                              bfId: data["bfId"], bfTitle: data["title"]),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).cardColor.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Flexible(
                                    child: Text(
                                      data['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                            overflow: TextOverflow.clip,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Transform.translate(
                                            offset: const Offset(2.0, 4.0),
                                            child: Text(
                                                data['audience'].toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4!
                                                    .copyWith(
                                                        color: Colors
                                                            .grey.shade400)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    CircleAddButton(
                                      context,
                                      onPressed: () {
                                        showModalBottomSheet(
                                          barrierColor: Colors.grey.shade800
                                              .withOpacity(0.8),
                                          elevation: 10.0,
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 10.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: isPlayingBF == false
                                                        ? IconButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            isPlayingBF = true;
                                                          });
                                                          _audio.play(data["file"]);
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
                                                          FontAwesomeIcons
                                                              .pauseCircle,
                                                          color: Colors.white70,
                                                        )),
                                                    title: new Text('Play',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () async {
                                                      await _audio
                                                          .play(data["file"]);
                                                    },
                                                  ),
                                                  /*ListTile(
                                                    leading: new Icon(
                                                      FontAwesomeIcons.message,
                                                      color: Colors.white,
                                                    ),
                                                    title: new Text('Reply',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () {
                                                      showDialog<String>(
                                                          barrierColor: Colors
                                                              .transparent,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Text("");

                                                          });
                                                    },
                                                  ),*/
                                                  ListTile(
                                                    leading: new Icon(
                                                      Icons.share,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    title: new Text('Share',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4),
                                                    onTap: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          contentPadding:
                                                              EdgeInsets.all(
                                                                  15.0),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20.0))),
                                                          backgroundColor:
                                                              Color(0xff2A2827),
                                                          title: Text(
                                                            "Share bonfire",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline4,
                                                          ),
                                                          content: Text(
                                                            "Obtain link to start sharing this bonfire",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1,
                                                          ),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              child: Text(
                                                                "cancel",
                                                              ),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                            ),
                                                            FutureBuilder<Uri>(
                                                                future: DynamicLinkService()
                                                                    .createLongDynamicLink(
                                                                        data[
                                                                            "title"],
                                                                        "${userData.name} - open bonfire"),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    Uri? uri =
                                                                        snapshot
                                                                            .data;
                                                                    return FlatButton(
                                                                      onPressed: () => FlutterShare.share(
                                                                          title:
                                                                              "example",
                                                                          linkUrl:
                                                                              uri.toString()),
                                                                      color: Theme.of(
                                                                              context)
                                                                          .indicatorColor,
                                                                      child:
                                                                          Text(
                                                                        "continue",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return FlatButton(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .indicatorColor,
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        "share",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Theme.of(context).primaryColor),
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
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
