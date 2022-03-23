import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

Widget OurFloatingButton({BuildContext context, Function onPressed}) {
  return Material(
    color: Colors.transparent,
    child: Container(
      height: 55.0,
      width: 55.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          //hoverColor: Theme.of(context).accentColor,
          elevation: 10.0,
          onPressed: onPressed,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 35,
                width: 35.0,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    image: AssetImage("assets/images/flame_sharp_white.png")
                  )
                ),
              )),
        ),
      ),
    ),
  );
}
