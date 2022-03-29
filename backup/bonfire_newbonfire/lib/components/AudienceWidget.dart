import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

Widget AudienceWidget(BuildContext context, int audience) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,    children: [
      Icon(
        MyFlutterApp.users,
        size: 25.0,
        color: Colors.grey.shade500,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Transform.translate(
          offset: const Offset(2.0, 4.0),
          child: Text(
            audience.toString(),
            style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.grey.shade500, fontSize: 15.0)
          ),
        ),
      ),
    ],
  );
}