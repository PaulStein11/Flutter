import 'package:flutter/material.dart';

Widget OurLoadingWidget(BuildContext context) {
  return Container(
    color: Theme.of(context).backgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    ),
  );
}