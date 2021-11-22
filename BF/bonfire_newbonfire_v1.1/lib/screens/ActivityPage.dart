import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/AudienceWidget.dart';
import 'package:bonfire_newbonfire/components/CircleAddButton.dart';
import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/components/RecordingTile.dart';
import 'package:bonfire_newbonfire/model/interaction.dart';
import 'package:bonfire_newbonfire/model/post.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../my_flutter_app_icons.dart';
import 'Profile/others_profile.dart';

AuthProvider _auth;

class ActivityPage extends StatefulWidget {
  String bfId;

  ActivityPage({this.bfId});

  @override
  _ActivityPageState createState() => _ActivityPageState(this.bfId);
}

class _ActivityPageState extends State<ActivityPage> {
  List<firebase_storage.StorageReference> references = [];

  String bfId;

  _ActivityPageState(this.bfId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (context, snapshot) {
                var userData = snapshot.data;
                if (!snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return Scaffold(
                  backgroundColor: Theme.of(context).cardColor,
                  body: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            StreamBuilder<BF>(
                                stream: StreamService.instance.getBonfire(bfId),
                                builder: (context, snapshot) {
                                  var bfData = snapshot.data;

                                  return SafeArea(
                                    child: Material(
                                      elevation: 0.0,
                                      child: Container(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0, vertical: 10.0),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  AppUserProfile(
                                                      icon: bfData.ownerName ==
                                                              "Mr Anonymous"
                                                          ? MyFlutterApp
                                                              .user_secret
                                                          : Icons.person,
                                                      hasImage:
                                                          bfData.ownerName ==
                                                                  "Mr Anonymous"
                                                              ? false
                                                              : true,
                                                      imageFile:
                                                          bfData.profileImage,
                                                      onPressed: () {},
                                                      iconSize: 29.0,
                                                      color: bfData.ownerName[
                                                                  0] ==
                                                              "P"
                                                          ? Colors.orangeAccent
                                                          : bfData.ownerName ==
                                                                  "Mr Anonymous"
                                                              ? Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                              : Colors
                                                                  .blueAccent,
                                                      size: 18.0),
                                                  SizedBox(
                                                    width: 12.0,
                                                  ),
                                                  Text(bfData.ownerName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2)
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      bfData.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline1,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              StreamBuilder<BF>(
                                                  stream: StreamService.instance
                                                      .getBFAudience(bfId),
                                                  builder: (context, snapshot) {
                                                    var _audienceData =
                                                        snapshot.data;
                                                    if (!snapshot.hasData) {
                                                      return Text("Error");
                                                    }
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        textBaseline:
                                                            TextBaseline
                                                                .ideographic,
                                                        children: [
                                                          AudienceWidget(
                                                              context,
                                                              _audienceData
                                                                  .audience),
                                                          CircleAddButton(
                                                            context,
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                barrierColor: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.9),
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        ListTile(
                                                                          leading:
                                                                              new Icon(
                                                                            MyFlutterApp.chat_empty,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                28,
                                                                          ),
                                                                          title: new Text(
                                                                              'Reply',
                                                                              style: Theme.of(context).textTheme.headline4),
                                                                          onTap:
                                                                              () {
                                                                            showDialog<String>(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return RecordTile(onUploadComplete: _onUploadComplete(), ownerId: bfData.bfId, ownerName: bfData.ownerName, ownerImage: bfData.profileImage, bfId: bfId, bfTitle: bfData.title);
                                                                                });
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          leading:
                                                                              new Icon(
                                                                            Icons.share,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          title: new Text(
                                                                              'Share',
                                                                              style: Theme.of(context).textTheme.headline4),
                                                                          onTap:
                                                                              () async {
                                                                            await showAlertDialog(
                                                                              context,
                                                                              title: 'Working area!',
                                                                              content: 'Finishing some upgrades to share Bonfires with everyone. In the meantime obtain the invitation link',
                                                                              cancelActionText: 'Cancel',
                                                                              defaultActionText: 'Get link',
                                                                              onPressed: () => share(context),
                                                                            );
                                                                          },
                                                                        ),
                                                                        ListTile(
                                                                          leading:
                                                                              new Icon(
                                                                            MyFlutterApp.attention,
                                                                            color:
                                                                                Theme.of(context).accentColor,
                                                                          ),
                                                                          title: new Text(
                                                                              'Report',
                                                                              style: Theme.of(context).textTheme.headline4),
                                                                          onTap:
                                                                              () async {
                                                                            await showAlertDialog(
                                                                              context,
                                                                              title: 'Report content',
                                                                              content: 'You want to report this Bonfire to alert the team about its content. Continue proceeding?',
                                                                              cancelActionText: 'Cancel',
                                                                              defaultActionText: 'Report',
                                                                              onPressed: () {
                                                                                Firestore.instance.collection("Bonfire").document(bfId).updateData(
                                                                                  {
                                                                                    "report": FieldValue.increment(1)
                                                                                  },
                                                                                );
                                                                                Navigator.pop(context);
                                                                                Navigator.pop(context);
                                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                                  SnackBar(
                                                                                    backgroundColor: Theme.of(context).accentColor,
                                                                                    content: Text('Reporting Bonfire'),
                                                                                  ),
                                                                                );
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                        /*ListTile(
                                                              leading: new Icon(
                                                                Icons.cancel,
                                                                color: Colors.white,
                                                              ),
                                                              title: new Text('Cancel',
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .headline4),
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),*/
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            StreamBuilder<List<Interaction>>(
                              stream: StreamService.instance.getInteractions(bfId),
                              builder: (_context, _snapshot) {
                                var _interactionData = _snapshot.data;
                                if (_snapshot.data == null) {
                                  return OurLoadingWidget(context);
                                }
                                if (_snapshot.data.isEmpty) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog<String>(
                                          barrierColor:
                                              Colors.grey.withOpacity(0.2),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return RecordTile(
                                                onUploadComplete:
                                                    _onUploadComplete(),
                                                bfId: bfId,
                                                bfTitle: "");
                                          });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                        ),
                                        Container(
                                          height: 100,
                                          width: 110,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                              image: new AssetImage(
                                                  "assets/images/Logo.png"),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Be the first one to contribute!",
                                          style: TextStyle(
                                              fontSize: 25,
                                              letterSpacing: 1,
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return _snapshot.hasData
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /*Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 8),
                                              child: Text(
                                                "Most recent:",
                                                style:Theme.of(context).textTheme.headline4
                                              ),
                                            ),*/
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children:
                                                      _interactionData.toList(),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : OurLoadingWidget(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = "  - ";

    Share.share(text,
        subject: "This is someone sharing with you what Bonfire is about!",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    var listResult = await firebaseStorage
        .ref()
        .child('upload-voice-firebase')
        .getDownloadURL();
    setState(() {
      references = listResult.items;
    });
  }

  showProfile(BuildContext context, {String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OthersProfile(
          profileId: profileId,
        ),
      ),
    );
  }
}
