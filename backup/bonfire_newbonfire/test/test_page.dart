import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 13.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BonfirePage(
                    bfId: bfId,
                    ownerName: ownerName,
                    ownerId: ownerId,
                    profileImage: profileImage,
                    bfTitle: title,
                    audience: audience))),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<MyUserModel>(
                    stream: DBService.instance.getUserData(ownerId),
                    builder: (context, _snapshot) {
                      var _userData = _snapshot.data;
                      print(_snapshot.data);
                      if (!_snapshot.hasData) {
                        return OurLoadingWidget(context);
                      }
                      bool isPostOwner = _auth.user.uid == ownerId;
                      print("looks like the ID of this user is: " + _auth.user.uid);

                      return ListTile(
                        leading: AppUserProfile(
                            icon: ownerName == "Mr Anonymous"
                                ? MyFlutterApp.user_secret
                                : Icons.person,
                            hasImage: ownerName == "Mr Anonymous"
                                ? false
                                : true,
                            imageFile: _userData.profileImage,
                            onPressed: () {},
                            iconSize: 32.0,
                            color: ownerName[0] == "P"
                                ? Colors.orangeAccent
                                : ownerName == "Mr Anonymous"
                                ? Theme.of(context).primaryColor
                                : Colors.blueAccent,
                            size: 19.0),
                        title: Text(
                            ownerName == "Mr Anonymous"
                                ? "Mr Anonymous"
                                : _userData.name,
                            style:
                            Theme.of(context).textTheme.headline2),
                        subtitle: RichText(
                          text: new TextSpan(
                            children: <TextSpan>[
                              //new TextSpan(text: user.email, style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).accentColor)),
                              new TextSpan(
                                  text: /*" - " + */ timeago.format(
                                    timestamp.toDate(),
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  buildTitle(),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        AudienceWidget(context, audience),
                        CircleAddButton(
                          context,
                          onPressed: () {
                            showModalBottomSheet(
                              barrierColor:
                              Colors.grey.withOpacity(0.9),
                              elevation: 10.0,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: new Icon(
                                          MyFlutterApp.chat_empty,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        title: new Text('Reply',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                        onTap: () {
                                          showDialog<String>(
                                              barrierColor: Theme.of(context).cardColor.withOpacity(0.8),
                                              context: context,
                                              builder: (BuildContext
                                              context) {
                                                return RecordTile(
                                                    onUploadComplete:
                                                    _onUploadComplete(),
                                                    ownerId: ownerId,
                                                    ownerName:
                                                    ownerName,
                                                    ownerImage:
                                                    profileImage,
                                                    bfId: bfId,
                                                    bfTitle: title);
                                              });
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        title: new Text('Share',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4),
                                        onTap: () async {
                                          await showAlertDialog(
                                            context,
                                            title: 'Working area!',
                                            content:
                                            'Finishing some upgrades to share Bonfires with everyone. In the meantime obtain the invitation link',
                                            cancelActionText: 'Cancel',
                                            defaultActionText:
                                            'Get link',
                                            onPressed: () =>
                                                share(context),
                                          );
                                        },
                                      ),
                                      ListTile(
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
