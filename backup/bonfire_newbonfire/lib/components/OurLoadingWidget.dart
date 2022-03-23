import 'package:flutter/material.dart';

Widget OurLoadingWidget(BuildContext context) {
  return Container(
    height: 30.0,
    width: 30.0,
    color: Theme.of(context).backgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).indicatorColor,
        ),
      ),
    ),
  );
}