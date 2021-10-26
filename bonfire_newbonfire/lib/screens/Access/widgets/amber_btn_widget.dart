import 'package:flutter/material.dart';

Widget Amber_Btn_Widget(
    {BuildContext context, String text, Function onPressed}) {
  return Material(
    color: Theme.of(context).accentColor,//Theme.of(context).accentColor,
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    elevation: 2.0,
    child: MaterialButton(
      onPressed: onPressed,
      minWidth: 100.0,
      child: Text(
          text,
          style: TextStyle(
              letterSpacing: 0.5,
              fontSize: 18,
              color: Theme.of(context).primaryColor),
        ),
    ),
  );
}
