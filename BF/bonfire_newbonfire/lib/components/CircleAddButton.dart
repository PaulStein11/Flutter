import 'package:flutter/material.dart';

Widget CircleAddButton(BuildContext context, {Function onPressed}) {
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
            height: 28.0,
            width: 28.0,
            decoration: BoxDecoration(
              color: Theme.of(context).indicatorColor,
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              size: 21.0,
            ),
          ),
        ),
      ),
    ),
  );
}
