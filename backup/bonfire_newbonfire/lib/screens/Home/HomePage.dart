import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/DrawerComponents.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/screens/Home/widgets/OurFloatingButton.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Home/CreateBonfire.dart';
import 'package:bonfire_newbonfire/screens/GroupsPage.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../NotificationsPage.dart';
import '../SendFeedback.dart';
import '../screens.dart';

AuthProvider _auth;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -------------------------------------
  // Controllers to load BFs and variables used for it, create method for AudioPlayer class
  // -------------------------------------
  ScrollController _chatScrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int loadMoreMsgs = 10; // at first it will load only 10
  int addXMore = 10;
  AudioPlayer _audioPlayer;

  // -------------------------
  // FOR USER TEST ONLY
  // -------------------------
  final _formKey = GlobalKey<FormState>();
  String _feedback = "";

  List<String> usersNotificationToken = [];


  @override
  void initState() {
    _chatScrollController = ScrollController()
      ..addListener(() {
        if (_chatScrollController.position.atEdge) {
          if (_chatScrollController.position.pixels == 0)
            print('ListView scrolled to top');
          else {
            setState(() {
              loadMoreMsgs = loadMoreMsgs + addXMore;
            });
            print('ListView scrolled to bottom');
          }
        }
      });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _audioPlayer = AudioPlayer();
    await _audioPlayer.stop();
  }

  void uploadUserTokens() async {
    List<String> userTokensList = [];
    QuerySnapshot snapshot = await Firestore.instance.collection("Users").getDocuments();
    snapshot.documents.forEach((DocumentSnapshot documentSnap) {
      Map<String, dynamic> data = documentSnap.data;
      userTokensList.add(data["tokenId"]);
    });
    setState(() {
      usersNotificationToken = userTokensList;
      print(" printing list of tokens $usersNotificationToken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext _context) {
          _auth = Provider.of<AuthProvider>(_context);
          return _homeUI();
        },
      ),
    );
  }

  _homeUI() {
    return StreamBuilder<MyUserModel>(
      stream: StreamService.instance.getUserData(_auth.user.uid),
      builder: (_context, _snapshot) {
        var _userData = _snapshot.data;
        uploadUserTokens();
        if (!_snapshot.hasData) {
          return OurLoadingWidget(context);
        } else {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.topLeft,
                    colors: [
                  Theme.of(context).backgroundColor,
                  Theme.of(context).indicatorColor
                ])),
            child: Scaffold(
              key: _scaffoldKey,
              drawerScrimColor: Colors.grey.shade800.withOpacity(0.8),
              /*floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,*/
              floatingActionButton: Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: OurFloatingButton(
                    context: context,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewBonfire(
                            id: _userData.uid,
                            name: _userData.name,
                            profileImage: _userData.profileImage,
                          ),
                        ),
                      );
                    },
                  )),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    // -----------------------------------------------
                    // Adding double tap to send feedback from users
                    // ------------------------------------------------
                    onDoubleTap: () {
                      print("Hello world");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Theme.of(context).backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "Sharing feedback",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30.0),
                                      child: Form(
                                        key: _formKey,
                                        onChanged: () =>
                                            _formKey.currentState.save(),
                                        child: TextFormField(
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.grey.shade200,
                                              fontSize: 15.0),
                                          validator: (input) {
                                            return input.isEmpty
                                                ? "Need to add something"
                                                : null;
                                          },
                                          onSaved: (input) {
                                            _feedback = input;
                                          },
                                        ),
                                      ),
                                    ),
                                    OurFilledButton(
                                        context: context,
                                        text: "Submit",
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            final Email email = Email(
                                              body: _feedback,
                                              subject: "Feedback - HomeScreen",
                                              recipients: [
                                                "pablerillas.11.pb@gmail.com"
                                              ],
                                            );

                                            String platformResponse;

                                            try {
                                              await FlutterEmailSender.send(
                                                  email);
                                              platformResponse = 'success';
                                            } catch (error) {
                                              platformResponse =
                                                  error.toString();
                                            }

                                            /*if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                    Theme.of(context).accentColor,
                                                    content: Text(
                                                        'Thanks for your feedback!'),
                                                  ),
                                                );    */
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: AppBar(
                      elevation: 0.0,
                      centerTitle: true,
                      backgroundColor: Colors.transparent.withOpacity(0.0),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(
                                      userId: _userData.uid,
                                    ),
                                  ),
                                );
                                FutureService.instance
                                    .feedSeeCount(_userData.uid);
                              },
                              child: _userData.unseenCount == 0
                                  ? Icon(
                                      MyFlutterApp.inbox,
                                      color: Colors.grey.shade400,
                                      size: 27.0,
                                    )
                                  : Badge(
                                      badgeColor: Colors.blueAccent,
                                      position: BadgePosition(top: -1, end: -1),
                                      badgeContent: Text(""),
                                      child: Icon(
                                        MyFlutterApp.inbox,
                                        color: Colors.grey.shade400,
                                        size: 27.0,
                                      ),
                                    )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 5.0),
                          child: AppUserProfile(
                            icon: Icons.person,
                            hasImage:
                                _userData.profileImage.isEmpty ? false : true,
                            imageFile: _userData.profileImage,
                            size: 19,
                            color: _userData.name[0] == "P"
                                ? Colors.orangeAccent
                                : Colors.blueAccent,
                            iconSize: 28.0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: DrawerHeader(
                          child: ListTile(
                            leading: Image.asset("assets/images/logo.png",
                                fit: BoxFit.cover, height: 40.0, width: 40.0),
                            title: appTitle(),
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade800),
                    SizedBox(
                      height: 5.0,
                    ),
                    drawerListTile(
                      icon: Icons.house_outlined,
                      text: "Home",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                    ),
                    drawerListTile(
                      icon: Icons.dashboard_outlined,
                      text: "Groups",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupsPage(),
                          ),
                        );
                      },
                    ),
                    Divider(color: Colors.grey.shade800),
                    drawerListTile(
                      icon: Icons.door_back_door_outlined,
                      text: "Onboarding page",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingPage(),
                          ),
                        );
                      },
                    ),
                    drawerListTile(
                      icon: Icons.feedback_rounded,
                      text: "Send feedback",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendFeedback(
                              id: _userData.uid,
                              name: _userData.name,
                              email: _userData.email,
                            ),
                          ),
                        );
                      },
                    ),
                    drawerListTile(
                      icon: Icons.exit_to_app,
                      text: "Sign out",
                      onPressed: () async {
                        await showAlertDialog(context,
                            title: 'Logout',
                            content: 'Are you sure that you want to logout?',
                            cancelActionText: 'Cancel',
                            getRequiredLinkbool: false,
                            defaultActionText: 'Logout', onPressed: () {
                          return _auth.logoutUser(() {}, context);
                        });
                      },
                    ),
                  ],
                ),
              ),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overScroll) {
                  overScroll.disallowGlow();
                },
                child: CustomScrollView(
                  controller: _chatScrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          StreamBuilder<List<BF>>(
                            stream: StreamService.instance
                                .getBonfires(loadMoreMsgs),
                            builder: (context, _snapshot) {
                              var _data = _snapshot.data;
                              if (!_snapshot.hasData) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              "What's happening",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(fontSize: 18.0),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    buildSkeleton(context),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    buildSkeleton(context),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    buildSkeleton(context),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    buildSkeleton(context),
                                  ],
                                );
                              }
                              print(_data);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 10),
                                          child: Text(
                                            "What's happening",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4
                                                .copyWith(fontSize: 18.0),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: _data.toList(),
                                  ),
                                  SizedBox(
                                    height: 80,
                                  )
                                ],
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
          );
        }
      },
    );
  }
}
