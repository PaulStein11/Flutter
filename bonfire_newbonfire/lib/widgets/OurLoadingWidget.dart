import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget OurLoadingWidget(BuildContext context) {
  return Container(
    height: 60.0,
    width: 60.0,
    color: Theme.of(context).backgroundColor,
    child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Center(
        child: LoadingAnimationWidget.discreteCircle(
          color: Colors.amber.shade700,
          secondRingColor: Colors.blueAccent,
          thirdRingColor: Colors.teal,
          size: 33.0,
        ),

      ),
    ),
  );
}