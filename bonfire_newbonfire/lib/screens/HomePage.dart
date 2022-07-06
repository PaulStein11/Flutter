import 'package:bf_pagoda/models/bonfire.dart';
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
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

  Future<void> initOneSignal(BuildContext context) async {
    /// Set App Id.
    await OneSignal.shared.setAppId(oneSignalAppId);

    /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    print("Paul, the userId is $osUserID");
    // We will update this once he logged in and goes to dashboard.
    ////updateUserProfile(osUserID);
    // Store it into shared prefs, So that later we can use it.
    //Preferences.setOnesignalUserId(osUserID);

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    /// Calls when foreground notification arrives.
    /*OneSignal.shared.setNotificationWillShowInForegroundHandler(
      handleForegroundNotifications,
    );*/

    /// Calls when the notification opens the app.
    //OneSignal.shared.setNotificationOpenedHandler(handleBackgroundNotification);
  }

  @override
  void initState() {
    _audio = audio.AudioPlayer();
    super.initState();
    OneSignal.shared.getDeviceState().then((deviceState) {
      print("DeviceState: ${deviceState?.userId}");
    });
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
        print("User's tokenId: " + userData.tokenId);
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
                    ),
                  ),
                ),
                /*drawerListTile(
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
                ),*/
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
                        builder: (_) => new AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;

                                  return Container(
                                      height: height - 400,
                                      width: width - 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "First bonfire",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                                    color:
                                                        Colors.grey.shade600),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Before start your first bonfire check some examples for reference",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .copyWith(
                                                      color:
                                                          Colors.grey.shade800,
                                                      fontSize: 17.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.5),
                                            child: FlatButton(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(
                                                "see examples",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .backgroundColor),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BFExample(
                                                              uid: userData.uid,
                                                              username:
                                                                  userData.name,
                                                              profileImg: userData
                                                                  .profileImage,
                                                            )));
                                              },
                                            ),
                                          ),
                                          FlatButton(
                                              color: Theme.of(context)
                                                  .indicatorColor,
                                              child: Text(
                                                "continue",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateBFPage(
                                                      uid: userData.uid,
                                                      username: userData.name,
                                                      profileImg:
                                                          userData.profileImage,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ],
                                      ));
                                },
                              ),
                            ));
                  } else if (userData.bonfires > 0){
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
              List<DocumentSnapshot> listOfBonfires = snapshot.data!.docs;

              return RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(
                    Duration(seconds: 2),
                    () {
                      OurLoadingWidget(context);
                    },
                  );
                },
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: listOfBonfires.length,
                  itemBuilder: (BuildContext context, int index) {
                    OneSignal.shared.setNotificationOpenedHandler(
                        (OSNotificationOpenedResult result) {
                      print(
                          "Opened notification: ${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BonfirePage(
                            bfId: result.notification.smallIcon,
                            bfTitle: result.notification.title,
                            ownerId: result.notification.largeIcon,
                          ),
                        ),
                      );
                    });
                    return Bonfire(
                      bfId: listOfBonfires[index]["bfId"],
                      bfTitle: listOfBonfires[index]["title"],
                      audience: listOfBonfires[index]["audience"],
                      bfAudioFile: listOfBonfires[index]["file"],
                      bfOwner: listOfBonfires[index]["ownerName"],
                      ownerId: listOfBonfires[index]["ownerId"],
                      ownerImage: listOfBonfires[index]["ownerImage"],
                      file: listOfBonfires[index]["file"],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
