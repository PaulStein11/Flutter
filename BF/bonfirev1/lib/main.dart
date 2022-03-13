import 'package:bonfirev1/palletes/ourDarkTheme.dart';
import 'package:bonfirev1/providers/auth.dart';
import 'package:bonfirev1/screens/Login/SplashPage.dart';
import 'package:bonfirev1/screens/Login/WelcomPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (BuildContext context) => AuthProvider())
    ], child: MaterialApp(
      theme: OurDarkTheme().buildTheme(),
      initialRoute: "splash",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage());
      },
      routes: {
        //"login": (BuildContext _context) => LoginPage(),
        "splash": (BuildContext context) => SplashScreen(
          goToPage: WelcomePage(),
          duration: 3,
        ),
        /*"register": (BuildContext _context) => RegisterPage(),
        "welcome": (BuildContext _context) => WelcomePage(),
        "home": (BuildContext _context) => HomePage(),
        "email_verification": (BuildContext _context) =>
            EmailVerificationScreen(),
        "profile": (BuildContext _context) => ProfilePage(),
        "edit_profile": (BuildContext _context) => EditProfilePage(),
        "onboarding": (BuildContext _context) => OnboardingPage(),*/
      },    ),);
  }
}

