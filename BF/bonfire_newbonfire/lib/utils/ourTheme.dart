import 'package:flutter/material.dart';

class OurTheme {
  Color _backgroundColor = Color(0xff1E1C1A);
  Color _boxColor = Colors.grey.shade800.withOpacity(0.70);//Color(0xff383838);
  Color _audioBtns = Color(0xff383838);
  Color _canvasColor = Color(0xff383838).withOpacity(0.85); //Drawer menu etc
  Color _primaryFont = Colors.grey.shade100; //BF titles, user names and timestamps
  Color _headingTitles = Color(0xffe2e2e2); // Heading titles on categories
  Color _secondaryFont = Color(0xffe2e2e2);
  Color _accentColor = Colors.amber.shade800; 

  ThemeData buildTheme() {
    return ThemeData(
      backgroundColor: _backgroundColor,
      canvasColor: _backgroundColor,
      primaryColor: _primaryFont,
      accentColor: _accentColor,
      indicatorColor: _canvasColor,
      unselectedWidgetColor: _accentColor,
      cardColor: _boxColor,
      secondaryHeaderColor: _secondaryFont,
      hintColor: _secondaryFont,
      fontFamily: "Poppins",
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: _primaryFont),
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
        disabledColor: _primaryFont.withOpacity(0.8),
        buttonColor: _accentColor,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        minWidth: 150,
        height: 40.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),

      ////////////START /////////////  Headlines
      textTheme: TextTheme(
        //MAIN TITLES OF BONFIRES
        headline1: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade200,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6),
        //USER NAMES ALONG THE APP
        headline2: TextStyle(
            color: Colors.grey.shade300,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            fontFamily: "PalanquinDark",
            letterSpacing: 0.5),
        //TIMESTAMPS ALONG THE APP
        headline3: TextStyle(
          fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            letterSpacing: 0.5),
        // HEADLINE TITLES EX: WHATS HAPPENING, THAT'S FIRE, CHOOSE CATEGORY ETC
        headline4: TextStyle(
            fontSize: 17,
            letterSpacing: 0.5,
            color: Colors.grey.shade50,
            fontWeight: FontWeight.w800
        ),
        // ICONS DATA NUMBER
        headline5: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 16,
            fontWeight: FontWeight.w600),
        headline6: TextStyle(
            fontSize: 16.5,
            letterSpacing: 0.5,
            color: Colors.grey.shade300,
            fontWeight: FontWeight.w800
        ),
      ),
    );
  }
}
