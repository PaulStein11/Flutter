import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

Widget AudienceWidget(BuildContext context, int audience) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    textBaseline: TextBaseline.ideographic,
    children: [
      Icon(
        MyFlutterApp.users,
        size: 25.0,
        color: Colors.white70,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          audience.toString(),
          style: Theme.of(context).textTheme.headline5
        ),
      ),
    ],
  );
}