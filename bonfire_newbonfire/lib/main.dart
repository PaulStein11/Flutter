// @dart=2.9

import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.allApps();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.instance.navigatorKey,
        theme: OurTheme().buildTheme(),
        initialRoute: "splash",
        routes: {
          "splash": (BuildContext _context) => SplashScreen(),
          "login": (BuildContext _context) => LoginScreen(),
          "register": (BuildContext _context) => Register2Screen(),
          "welcome": (BuildContext _context) => WelcomeScreen(),
          "home": (BuildContext _context) => HomeScreen(),
          "email_verification": (BuildContext _context) =>
              EmailVerificationScreen(),
          "profile": (BuildContext _context) => ProfileScreen(),
          "edit_profile": (BuildContext _context) => EditProfile(),
          "guide": (BuildContext _context) => Onboard1(),
        },
      ),
    );
  }
}
