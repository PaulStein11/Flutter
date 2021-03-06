import 'package:flutter/material.dart';

Widget OurTextForm (String text) {
  return Text(
    text,
    textAlign: TextAlign.left,
    style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.normal,
        color: Colors.grey.shade200),
  );
}


const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(25.0)),
  ),
);