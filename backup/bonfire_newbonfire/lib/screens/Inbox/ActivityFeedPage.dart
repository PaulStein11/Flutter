import 'package:bonfire_newbonfire/components/AppSkeleton.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/UserFeed.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/material.dart';

import '../Home/HomePage.dart';

class ActivityFeedPage extends StatefulWidget {
  final String userId;

  ActivityFeedPage({this.userId});

  @override
  _ActivityFeedPageState createState() => _ActivityFeedPageState(
        userId: this.userId,
      );
}

class _ActivityFeedPageState extends State<ActivityFeedPage> {
  final String userId;

  _ActivityFeedPageState({this.userId});

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
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade200, size: 22.0,),
          ),
        ),
        body: StreamBuilder<List<UserFeed>>(
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
                      SizedBox(height: 20.0,),
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
