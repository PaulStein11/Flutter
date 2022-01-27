import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Login/SplashPage.dart';
import 'package:bonfire_newbonfire/utils/ourTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        initialRoute: "welcome",
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => WelcomePage());
        },
        routes: {
          //"splash": (BuildContext _context) => SplashScreen(),
          "login": (BuildContext _context) => LoginPage(),
          "splash": (BuildContext context) => SplashPage(),
          "register": (BuildContext _context) => RegisterPage(),
          "welcome": (BuildContext _context) => WelcomePage(),
          "home": (BuildContext _context) => HomePage(),
          "email_verification": (BuildContext _context) =>
              EmailVerificationScreen(),
          "profile": (BuildContext _context) => ProfilePage(),
          "edit_profile": (BuildContext _context) => EditProfilePage(),
          "guide": (BuildContext _context) => OnboardingPage(),
        },
      ),
    );
  }
}
