// @dart=2.9

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget OurOutlineButton(
    {BuildContext context,
    String text,
    Function onPressed,
    Color color,
    IconData icon,
    bool hasIcon,
    bool isLoading}) {
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
        child: isLoading == true ? Center(child: LoadingAnimationWidget.threeArchedCircle(color: Theme.of(context).accentColor, size: 28.0,)) : Row(
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
