// @dart=2.9

import 'package:flutter/material.dart';

Widget OurFloatingButton({BuildContext context, Function onPressed}) {
  return Material(
    color: Colors.transparent,
    child: Container(
      height: 68.0,
      width: 68.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Colors.orange.shade800,
          //Theme.of(context).secondaryHeaderColor.withOpacity(0.9),
          //hoverColor: Theme.of(context).accentColor,
          elevation: 10.0,
          onPressed: onPressed,
          child: /*IconButton(
            onPressed: onPressed,
            icon: Icon(FontAwesomeIcons.fire, color: Theme.of(context).backgroundColor.withOpacity(0.8),
            ),
          ), */ Padding(
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
