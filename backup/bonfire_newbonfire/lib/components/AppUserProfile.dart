import 'dart:io';

import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget AppUserProfile(
    {Function onPressed,
    double size,
    double iconSize,
    Color color,
    bool hasImage,
    IconData icon,
    String imageFile}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        //color: Colors.grey.shade400, //Color(0xff1a1a1a).withOpacity(0.7),
      ),
      child: hasImage == false
          ? Icon(
        icon,
        size: iconSize,
        color: color,
      )
          : CircleAvatar(
        backgroundColor: Colors.grey.shade700,
       radius: size,
        backgroundImage: NetworkImage(imageFile)
       
      ), /* add child content here */
    ),
  );
}
