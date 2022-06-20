import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/screens/Profile/EditProfile.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/services/stream_services.dart';
import 'package:bf_pagoda/widgets/OurLeadingIcon.dart';
import 'package:bf_pagoda/widgets/OurLoadingWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider _auth;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return _profileUI();
        },
      ),
    );
  }

  Widget _profileUI() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: true,
        leading: OurLeadingIcon(context),
        actions: [
          PopupMenuButton(
              color: Theme.of(context).indicatorColor,
              // add icon, by default "3 dot" icon
              icon: Icon(FontAwesomeIcons.ellipsisH, color: Colors.grey.shade200,),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "Edit profile",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),

                  /*PopupMenuItem<int>(
                    value: 1,
                    child: Text("My account", style: Theme.of(context).textTheme.headline1,),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Settings", style: Theme.of(context).textTheme.headline1,),
                  ),*/
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                } else if (value == 1) {
                  print("Settings menu is selected.");
                } else if (value == 2) {
                  print("Logout menu is selected.");
                }
              }),
        ],
      ),
      body: StreamBuilder<MyUserModel>(
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
            final accountTimestamp = userData.lastSeen;
            String formatter =
                DateFormat('yMd').format(accountTimestamp.toDate());

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userData.profileImage.isEmpty ||
                          snapshot.connectionState ==
                              ConnectionState.active
                          ? GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.solidCircleUser,
                            color: Theme.of(context)
                                .secondaryHeaderColor,
                            size: 80.0,
                          ),
                          onTap: () {
                            //TODO: Change profile Image
                          })
                          : CircleAvatar(
                        backgroundColor:
                        Theme.of(context).cardColor,
                        radius: 45.0,
                        child: CircleAvatar(
                          radius: 39.0,
                          backgroundImage:
                          NetworkImage(userData.profileImage),
                        ),
                      ),
                      SizedBox(width: 30.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.name,
                            style: TextStyle(
                                color: Colors.grey.shade100,
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Theme.of(context).indicatorColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 13.0),
                                child: Text(
                                  "Joined $formatter",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey.shade500,
                  thickness: 2.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: buildCountColumn("bonfires", userData.bonfires),
                ),

              ],
            );
          }),
    );
  }

  Row buildCountColumn(String label, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 1.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 15.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade300),
        ),
      ],
    );
  }
}
