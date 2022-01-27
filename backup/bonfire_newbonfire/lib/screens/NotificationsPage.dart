import 'package:bonfire_newbonfire/components/AppSkeleton.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/notif_updated.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';

class NotificationPage extends StatefulWidget {
  final String userId;

  NotificationPage({this.userId});

  @override
  _NotificationPageState createState() => _NotificationPageState(
        userId: this.userId,
      );
}

class _NotificationPageState extends State<NotificationPage> {
  final String userId;

  _NotificationPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    print("this is the userId $userId");
    return WillPopScope(
      onWillPop: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Activity Feed"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: StreamBuilder<List<notif_updated>>(
          stream: StreamService.instance.getNotifications(userId),
          builder: (context, _snapshot) {
            var _data = _snapshot.data;
            print("Users notification is $userId");
            print("Data length is ${_data.length}");
            if (!_snapshot.hasData) {
              return OurLoadingWidget(context);
            }
            if (_snapshot.connectionState == ConnectionState.none) {
              return OurLoadingWidget(context);
            }
            if (_snapshot.connectionState == ConnectionState.waiting) {
              return OurLoadingWidget(context);
            }
            if (_data.length == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "No notifications",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                ],
              );
            }
            print(_data);
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Column(
                        children: _data.toList(),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
