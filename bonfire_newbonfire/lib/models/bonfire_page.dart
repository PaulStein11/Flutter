import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import '../my_flutter_app_icons.dart';
import '../screens/Bonfire/createInterac/CreateInteracPage.dart';
import '../services/dynamic_services.dart';
import '../widgets/CircleAddButton.dart';

class BonfirePageModel extends StatefulWidget {
  late String bfId, bfTitle, audioDuration, bfOwner, ownerId, ownerImage, file;
  late int audience;

  BonfirePageModel(
      {required this.bfId,
      required this.bfTitle,
      required this.audience,
      required this.audioDuration,
      required this.bfOwner,
      required this.ownerId,
      required this.ownerImage,
      required this.file});

  @override
  State<BonfirePageModel> createState() => _BonfirePageModelState(
      this.bfId,
      this.bfTitle,
      this.audience,
      this.audioDuration,
      this.bfOwner,
      this.ownerId,
      this.ownerImage,
      this.file);
}

class _BonfirePageModelState extends State<BonfirePageModel> {
  late String bfId, bfTitle, bfAudioFile, bfOwner, ownerId, ownerImage, file;
  late int audience;

  //AUDIO PLAYER
  late audio.AudioPlayer _audio;
  bool isPlayingBF = false;

  _BonfirePageModelState(this.bfId, this.bfTitle, this.audience,
      this.bfAudioFile, this.bfOwner, this.ownerId, this.ownerImage, this.file);

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              ownerImage.isEmpty ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  FontAwesomeIcons.solidCircleUser,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: 28.0,
                ),
              ) : CircleAvatar(
                backgroundColor: Colors.grey.shade700,
                radius: 18,
                backgroundImage: NetworkImage(ownerImage),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(widget.bfOwner, style: Theme.of(context).textTheme.headline3)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  widget.bfTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).indicatorColor,
                ),
                borderRadius: BorderRadius.circular(50.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isPlayingBF == false
                    ? IconButton(
                        onPressed: () async {
                          setState(() {
                            isPlayingBF = true;
                          });
                          _audio.play(widget.file);
                          _audio.onPlayerCompletion.listen((duration) {
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
                          FontAwesomeIcons.pauseCircle,
                          color: Colors.white70,
                        )),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isPlayingBF == false
                        ? Colors.grey.shade300
                        : Colors.orange.shade800,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Text(
                  widget.audioDuration.toString().substring(1),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontFamily: "Palanquin",
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.5,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textBaseline: TextBaseline.ideographic,
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
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Transform.translate(
                      offset: const Offset(2.0, 4.0),
                      child: Text(widget.audience.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.grey.shade400)),
                    ),
                  ),
                ],
              ),
              CircleAddButton(
                context,
                onPressed: () {
                  showModalBottomSheet(
                    barrierColor: Colors.grey.shade800.withOpacity(0.8),
                    elevation: 10.0,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(
                                FontAwesomeIcons.message,
                                color: Colors.white,
                              ),
                              title: new Text('Interact',
                                  style: Theme.of(context).textTheme.headline4),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateInteractionPage(
                                        bfTitle: widget.bfTitle,
                                        bfId: widget.bfId),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: new Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              title: new Text('Share',
                                  style: Theme.of(context).textTheme.headline4),
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    contentPadding: EdgeInsets.all(15.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    backgroundColor: Color(0xff2A2827),
                                    title: Text(
                                      "Share bonfire",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    content: Text(
                                      "Obtain link to start sharing this bonfire",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          "cancel",
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                      FutureBuilder<Uri>(
                                          future: DynamicLinkService()
                                              .createLongDynamicLink(bfTitle!,
                                                  "${widget.bfOwner} - open bonfire"),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Uri? uri = snapshot.data;
                                              return FlatButton(
                                                onPressed: () =>
                                                    FlutterShare.share(
                                                        title: "example",
                                                        linkUrl:
                                                            uri.toString()),
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                child: Text(
                                                  "continue",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              );
                                            } else {
                                              return FlatButton(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                                onPressed: () {},
                                                child: Text(
                                                  "share",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
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
                            ListTile(
                              leading: new Icon(
                                FontAwesomeIcons.solidCheckCircle,
                                color: Colors.white,
                              ),
                              title: new Text('Tip',
                                  style: Theme.of(context).textTheme.headline4),
                              onTap: () {
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
                                              height: height - 450,
                                              width: width - 50,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Support interaction",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4!
                                                        .copyWith(
                                                        color:
                                                        Theme.of(context).backgroundColor, fontSize: 21.0, fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 20.0,),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Hold the interaction area for ~1 second and let it light blue",
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
                                                        vertical: 18.5),
                                                    child: FlatButton(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      child: Text(
                                                        "got it",
                                                        style: TextStyle(
                                                            color: Theme.of(context)
                                                                .primaryColor),
                                                      ),
                                                      onPressed: () {
                                                       Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        },
                                      ),
                                    ));
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
  }
}
