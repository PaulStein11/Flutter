import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  MyThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }




}