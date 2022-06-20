
import 'package:flutter/material.dart';
import '';


GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
/*class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  /*static NavigationService instance = NavigationService();

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }*/

  Future<dynamic> navigateToReplacement(String _routeName) {
    return navigatorKey.currentState.pushReplacementNamed(_routeName);
  }
  Future<dynamic> navigateToPage(String _routeName) {
    return navigatorKey.currentState.pushNamed(_routeName);
  }
  Future<dynamic> navigateToRoute(MaterialPageRoute _route) {
    return navigatorKey.currentState.push(_route);
  }

  void goBack() {
    navigatorKey.currentState.pop();
  }
}*/