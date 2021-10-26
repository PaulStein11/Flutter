import 'package:flutter/material.dart';

class OurTheme {
  Color _backgroundColor = Color(0xff1a1a1a);
  Color _primaryFont = Color(0xffe2e2e2);
  Color _secondaryFont = Colors.grey;
  Color _canvasColor = Color(0xff383838).withOpacity(0.57);
  Color _mainOrange = Color(0xffe65100);
  Color _boxColor = Color(0xff2a2827);

  ThemeData buildTheme() {
    return ThemeData(
      backgroundColor: _backgroundColor,
      canvasColor: _canvasColor,
      primaryColor: _primaryFont,
      accentColor: _mainOrange,
      cardColor: _boxColor,
      secondaryHeaderColor: _secondaryFont,
      hintColor: _secondaryFont,
      fontFamily: "Poppins",
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: _backgroundColor// 1
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: _secondaryFont, fontSize: 14.0) ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: _mainOrange,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.w600,
          color: Color(0xffe2e2e2),
        ),
        headline2: TextStyle(
          fontSize: 16.5,
          letterSpacing: 1,
          color: Color(0xffe2e2e2),
        ),
        //Contains the status
        headline3: TextStyle(
            fontFamily: "Palanquin",
            fontSize: 15,
            letterSpacing: 0.5,
            color: Colors.green,
            fontWeight: FontWeight.w600
        ),
        headline4: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
