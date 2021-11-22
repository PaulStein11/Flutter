import 'package:flutter/material.dart';

Widget OurLoadingWidget(BuildContext context) {
  return Container(
    color: Theme.of(context).cardColor,
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).accentColor,
        ),
      ),
    ),
  );
}