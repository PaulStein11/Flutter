// @dart=2.9

import 'package:flutter/material.dart';

Widget OurFilledButton(
    {BuildContext context, String text, Function onPressed}) {
  return Material(
    color: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    elevation: 2.0,
    child: MaterialButton(
      onPressed: onPressed,
      minWidth: 150.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
            text,
            style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).backgroundColor),
          ),
      ),
    ),
  );
}
