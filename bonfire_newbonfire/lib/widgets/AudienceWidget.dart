import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget AudienceWidget(BuildContext context, int audience) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,    children: [
    Icon(
      FontAwesomeIcons.users,//MyFlutterApp.users,
      size: 25.0,
      color: Colors.grey.shade500,
    ),
    Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Transform.translate(
        offset: const Offset(2.0, 4.0),
        child: Text(
            audience.toString(),
            style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.grey.shade500, fontSize: 15.0)
        ),
      ),
    ),
  ],
  );
}