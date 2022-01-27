import 'dart:math';

import 'package:badges/badges.dart';
import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/OurFloatingButton.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/activity.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/AllUsers.dart';
import 'package:bonfire_newbonfire/screens/CreateBonfire.dart';
import 'package:bonfire_newbonfire/screens/FunPage.dart';
import 'package:bonfire_newbonfire/screens/GroupsPage.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../model/notif_updated.dart';
import 'InboxPage.dart';
import 'NotificationsPage.dart';
import 'SendFeedback.dart';
import 'WIDGET_Groups.dart';
import 'screens.dart';

AuthProvider _auth;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int documentLimit = 20;
  bool _hasMoreItems = true;
  bool _isFetchingBFs = false;
  ScrollController _chatScrollController;
  int loadMoreMsgs = 10; // at first it will load only 25
  int a = 10;

  @override
  void initState() {
    _chatScrollController = ScrollController()
      ..addListener(() {
        if (_chatScrollController.position.atEdge) {
          if (_chatScrollController.position.pixels == 0)
            print('ListView scrolled to top');
          else {
            setState(() {
              loadMoreMsgs =  loadMoreMsgs + a;
            });
            print('ListView scrolled to bottom');
          }
        }
      });
    super.initState();
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
                //backgroundColor: Colors.transparent,
                drawerScrimColor: Colors.grey.shade800.withOpacity(0.8),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
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
                  // here the desired height
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: AppBar(
                      //iconTheme: IconThemeData(color: Colors.white),
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
                                FutureService.instance.feedSeeCount(_userData.uid);
                              },
                              child: _userData.unseenCount == 0 ? Icon(
                                MyFlutterApp.bell,
                                color: Colors.grey.shade400,
                                size: 28.0,
                              ) :  Badge(
                                badgeColor: Theme.of(context).accentColor,
                                position: BadgePosition(top: -1, end: -1),
                                badgeContent: Text(""),
                                child: Icon(
                                  MyFlutterApp.bell,
                                                                                            color: Colors.grey.shade400,
                                  size: 28.0,
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
                            size: 22.5,
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
                      //title: _appTitle(),
                    ),
                  ),
                ),
                drawer: Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: DrawerHeader(
                          child: ListTile(
                            leading: Image.asset("assets/images/logo.png",
                                fit: BoxFit.cover, height: 40.0, width: 40.0),
                            title: _appTitle(),
                          ),
                        ),
                      ),
                      Divider(color: Colors.white),
                      SizedBox(
                        height: 5.0,
                      ),
                      _drawerListTile(
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
                      _drawerListTile(
                        icon: Icons.feedback_rounded,
                        text: "Onboarding",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingPage(),
                            ),
                          );
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
                        delegate: SliverChildListDelegate([
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
                                            padding:
                                            const EdgeInsets.only(left: 13.0),
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
                                    buildSkeleton(context)
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
                                          padding:
                                              const EdgeInsets.only(left: 13.0),
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
                                  SizedBox(height: 80,)
                                ],
                              );
                            },
                          ),
                        ]),
                      )
                    ],
                  ),
                )),
          );
        }
      },
    );
  }

  _appTitle() {
    return Text(
      "Bonfire",
      style: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w500,
        fontSize: 18.0,
        letterSpacing: 2.0,
      ),
    );
  }

  _drawerListTile({IconData icon, String text, Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: ListTile(
          leading: Icon(
            icon,
            color: Colors.grey.shade400,
            size: 28.0,
          ),
          title: Text(
            text,
            style: TextStyle(
                fontSize: 15.5,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6),
          ),
          onTap: onPressed),
    );
  }
}
