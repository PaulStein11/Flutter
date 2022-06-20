import 'package:flutter/material.dart';

Widget CircleAddButton(BuildContext context, {required Function() onPressed}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      height: 45.0,
      width: 45.0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
              color: Colors.orange.shade900,//Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
              size: 21.0,
            ),
          ),
        ),
      ),
    ),
  );
}
