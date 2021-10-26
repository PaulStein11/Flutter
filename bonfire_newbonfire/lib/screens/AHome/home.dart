import 'package:bonfire_newbonfire/model/post.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/AHome/side_menu/feedback.dart';
import 'package:bonfire_newbonfire/screens/AHome/side_menu/help.dart';
import 'package:bonfire_newbonfire/service/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../screens.dart';
import 'side_menu/all_users.dart';
import 'createPost.dart';

AuthProvider _auth;

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext _context) {
          _auth = Provider.of<AuthProvider>(_context);
          return StreamBuilder<User>(
            stream: DBService.instance.getUserData(_auth.user.uid),
            builder: (_context, _snapshot) {
              var _userData = _snapshot.data;
              if (!_snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  drawerScrimColor: Theme.of(context).backgroundColor,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Container(
                      height: 70.0,
                      width: 70.0,
                      child: FittedBox(
                        child: FloatingActionButton(
                          elevation: 5.0,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AskBonfirePage(
                                          id: _userData.uid,
                                          name: _userData.name,
                                        )));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.local_fire_department_outlined,
                                color: Theme.of(context).primaryColor,
                                size: 30.0,
                              )),
                        ),
                      ),
                    ),
                  ),
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(70.0), // here the desired height
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: AppBar(
                        //iconTheme: IconThemeData(color: Colors.white),
                        elevation: 0.0,
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen())),
                              child: CircleAvatar(
                                radius: 21.0,
                                backgroundImage:
                                AssetImage("assets/images/user.png"),
                              ),
                            ),
                          ),
                        ],
                        title: Text(
                          "Bonfire",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                  drawer: Drawer(
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: DrawerHeader(
                            child: ListTile(
                              leading: Image.asset("assets/images/logo.png",
                                  fit: BoxFit.cover, height: 50.0, width: 50.0),
                              title: const Text(
                                'Bonfire',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2.0),
                              ),
                            ),
                          ),
                        ),
                        Divider(color: Colors.white),
                        ListTile(
                          leading: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          title: const Text(
                            'Users',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsers()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.feedback_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          title: const Text(
                            'Send feedback',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SendFeedbackPage(user: _userData.name, email: _userData.email)));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.help,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          title: const Text(
                            'Help',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage(user: _userData.name, email: _userData.email)));
                          },
                        ),
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      StreamBuilder<List<Post>>(
                        stream: DBService.instance.getPostsInDB(_userData.uid),
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
                            children: _data.toList(),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
