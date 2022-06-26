import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget OurLoadingWidget(BuildContext context) {
  return Container(
    height: 30.0,
    width: 30.0,
    color: Theme.of(context).backgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: SpinKitFadingCircle(color: Theme.of(context).accentColor,)

      ),
    ),
  );
}