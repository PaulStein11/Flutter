// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget OurOutlineButton(
    {BuildContext context,
    String text,
    Function onPressed,
    Color color,
    IconData icon,
    bool hasIcon}) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).secondaryHeaderColor, width: 1.5),
          borderRadius: BorderRadius.circular(40)),
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
                    color: color,
                    size: 22.0,
                  )
                : Text(""),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
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
