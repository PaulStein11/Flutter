import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


Widget OurRecordBFButton(BuildContext context, bool isListening, void onPressed()) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 60.0),
    child: AvatarGlow(
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).backgroundColor,
            boxShadow: [BoxShadow(
                color: Colors.grey.shade700,
                blurRadius: 2,
                spreadRadius: 2
            )]
        ),
        width: 70,
        height: 70,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            child: Icon(
              Icons.mic_rounded,
              color: Colors.grey.shade400,
              size: 30.0,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
      endRadius: 90,
      glowColor: Theme.of(context).primaryColor,
      repeat: true,
      repeatPauseDuration: const Duration(seconds:
      1),
      duration: const Duration(seconds: 3),
      animate: isListening,
    ),
  );
}