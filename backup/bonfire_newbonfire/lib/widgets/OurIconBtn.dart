// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget OurIconBtn(
    {BuildContext context,
    String text,
    Function onPressed,
    Color btnColor,
    Color txtColor,
    IconData icon,
    bool hasIcon}) {
  return Material(
    elevation: 5.0,
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    color: Theme.of(context).cardColor,
    child: MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            hasIcon == true
                ? FaIcon(
                    icon,
                    color: txtColor,
                    size: 24.0,
                  )
                : Text(""),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: txtColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
