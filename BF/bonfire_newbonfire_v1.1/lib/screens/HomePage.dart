import 'dart:math';

import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/OurFloatingButton.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/activity.dart';
import 'package:bonfire_newbonfire/model/post.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/AllUsers.dart';
import 'package:bonfire_newbonfire/screens/CreateBonfire.dart';
import 'package:bonfire_newbonfire/screens/FunPage.dart';
import 'package:bonfire_newbonfire/screens/GroupsPage.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import 'InboxPage.dart';
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
                    colors: [Theme
                        .of(context)
                        .backgroundColor, Theme
                        .of(context)
                        .indicatorColor
                    ])),
            child: Scaffold(
                //backgroundColor: Colors.transparent,
                drawerScrimColor: Colors.grey.withOpacity(0.3),
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
                            builder: (context) =>
                                CreateNewBonfire(
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
                          child: Icon(MyFlutterApp.bell_1, color: Colors.grey.shade400, size: 28.0,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.12,
                        child: DrawerHeader(
                          child: ListTile(
                            leading: Image.asset("assets/images/logo.png",
                                fit: BoxFit.cover, height: 40.0, width: 40.0),
                            title: _appTitle(),
                          ),
                        ),
                      ),
                      Divider(color: Colors.white),
                      /*SizedBox(
                        height: 15.0,
                      ),
                      _drawerListTile(
                        icon: MyFlutterApp.group_work,
                        text: "Groups",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupsPage(),
                            ),
                          );
                        },
                      ),*/
                      /*SizedBox(
                        height: 5.0,
                      ),
                      _drawerListTile(
                        icon: Icons.email,
                        text: "Inbox",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InboxPage(MediaQuery
                                      .of(context)
                                      .size
                                      .height, MediaQuery
                                      .of(context)
                                      .size
                                      .width),
                            ),
                          );
                        },
                      ),*/
                      /*SizedBox(
                        height: 5.0,
                      ),
                      _drawerListTile(
                        icon: MyFlutterApp.group_work,
                        text: "Groups",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnboardingPage(),
                            ),
                          );
                        },
                      ),*/
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
                              builder: (context) =>
                                  SendFeedback(
                                    id: _userData.uid,
                                    name: _userData.name,
                                    email: _userData.email,
                                  ),
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
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate([
                          StreamBuilder<List<BF>>(
                            stream: StreamService.instance.getBonfires(documentLimit),
                            builder: (context, _snapshot) {
                              var _data = _snapshot.data;
                              if (!_snapshot.hasData) {
                                return Column(
                                  children: [
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
                                  /*Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 14.0),
                                        child: Text(
                                          "Groups",
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline4,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*StreamBuilder<List<Activity>>(
                                      stream: DBService.instance
                                          .getActivity(_auth.user.uid),
                                      builder: (context, _snapshot) {
                                        var _data = _snapshot.data;
                                        if (!_snapshot.hasData) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 4.0,
                                              ),
                                              buildSkeleton(context),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          );
                                        }
                                        if(_snapshot.data.isEmpty) {
                                          return SizedBox(height: 0.1,);
                                        }
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 14.0),
                                                    child: Text(
                                                      "Your activity",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline4,
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: _data.toList(),
                                            ),
                                          ],
                                        );
                                      }),
                                  SizedBox(
                                    height: 20.0,
                                  ),*/

                                  Container(
                                    height: 160,
                                    child: NotificationListener<OverscrollIndicatorNotification>(
                                      onNotification: (overScroll) {
                                        overScroll.disallowGlow();
                                      },
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          //Bonfire is trying to collect thre most importtant things that will be addressed whenever the admin or owner wants to pull it up
                                          GroupsWidget(
                                                  () =>
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FunPage())),
                                              context,
                                              true,
                                              "Bonfire", "assets/images/yellow.png"),
                                          //Memeland is a place where people post and also minimal tools to create those moments are added AR stuff, record option, GIF
                                          GroupsWidget(
                                                  () =>
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FunPage())),
                                              context,
                                              true,
                                              "Memeland", "assets/images/lol.png"),
                                          //Create option to start creating groups
                                          GroupsWidget(
                                                  () =>
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              FunPage())),
                                              context,
                                              false,
                                              "", ""),
                                        ],
                                      ),
                                    ),
                                  ),*/
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 13.0),
                                          child: Text(
                                            "What's happening",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline4.copyWith(fontSize: 18.0),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: _data.toList(),
                                  ),

                                  /*Container(
                                    height: 250,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        GroupsWidget(() => Navigator.push(context, MaterialPageRoute(builder: (context) => FunPage())), context, "Make it fun"),
                                        GroupsWidget(() => Navigator.push(context, MaterialPageRoute(builder: (context) => FunPage())), context, "Talking about the present"),
                                        GroupsWidget(() => Navigator.push(context, MaterialPageRoute(builder: (context) => FunPage())), context, "Talking about the future"),
                                      ],
                                    ),
                                  )*/
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
