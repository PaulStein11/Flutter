import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Bonfire/createBF/CreateBFPage.dart';
import 'package:bf_pagoda/screens/Groups/IntroGroups.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/services/stream_services.dart';
import 'package:bf_pagoda/widgets/CircleAddButton.dart';
import 'package:bf_pagoda/widgets/DrawerWidgets.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

import '../../widgets/OurLoadingWidget.dart';
import 'SparkResultPage.dart';

class SparksPage extends StatefulWidget {
  @override
  State<SparksPage> createState() => _SparksPageState();
}

class _SparksPageState extends State<SparksPage> {
  late AuthProvider _auth;

  /*final Stream<QuerySnapshot> _bonfiresStream = FirebaseFirestore.instance
      .collection('bonfires')
      .orderBy("timestamp", descending: true)
      .snapshots();*/
  final Stream<QuerySnapshot> _interaction = FirebaseFirestore.instance
      .collection('sparks')
      .doc("WXk7nJQm6XBs7ABXPf7j")
      .collection("interactions")
      .snapshots();
  final Stream<QuerySnapshot> _sparksStream =
      FirebaseFirestore.instance.collection('sparks').snapshots();

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
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              elevation: 0.0,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                    color: Colors.orange.shade900,
                    child: IconButton(
                      icon: Icon(FontAwesomeIcons.house),
                      onPressed: () => navigatorKey?.currentState
                          ?.pushNamedAndRemoveUntil("home", (route) => false),
                    )),
              ),
              title: Text(
                "Explore",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _sparksStream,
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
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SparkResultPage(sparkId: data["sparkId"],))),
                    child: Container(
                      decoration: BoxDecoration(
                          //color: Theme.of(context).cardColor.withOpacity(0.75),
                          border: Border(
                              bottom: BorderSide(
                            color: Colors
                                .orange.shade900.withOpacity(0.6), //Theme.of(context).accentColor,
                          ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      data['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      data['name1'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(color: Colors.grey.shade400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      data['name2'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(color: Colors.grey.shade400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      data['name3'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1!
                                          .copyWith(color: Colors.grey.shade400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Transform.translate(
                                          offset: const Offset(2.0, 4.0),
                                          child: Text(data['audience'].toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4!
                                                  .copyWith(
                                                      color:
                                                          Colors.grey.shade400)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.clock,
                                        color: Colors.grey.shade400,
                                        size: 22.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text("5 days",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3!
                                                .copyWith(
                                                    color: Colors.grey.shade400)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.0,
                            )
                          ],
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
