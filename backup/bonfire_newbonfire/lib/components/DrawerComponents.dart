import 'package:flutter/material.dart';

appTitle() {
  return Text(
    "Bonfire",
    style: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
      fontSize: 18.0,
      letterSpacing: 2.0,
    ),
  );
}

drawerListTile({IconData icon, String text, Function onPressed}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15.0),
    child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey.shade600,
          size: 28.0,
        ),
        title: Text(
          text,
          style: TextStyle(
              fontSize: 15.5,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6),
        ),
        onTap: onPressed),
  );
}