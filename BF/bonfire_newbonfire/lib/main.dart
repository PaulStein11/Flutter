import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/screens/Login/SplashPage.dart';
import 'package:bonfire_newbonfire/utils/ourTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

String appId = "a97b81df-e138-4954-87e8-5ebe6a5ca49b";

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87,

  ));
  WidgetsFlutterBinding.ensureInitialized();
  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(appId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  //await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => AuthProvider(),

      ),
    ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.instance.navigatorKey,
      theme: OurTheme().buildTheme(),
      initialRoute: "splash",
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => WelcomePage());
      },
      routes: {
        "login": (BuildContext _context) => LoginPage(),
        "splash": (BuildContext context) => SplashScreen(
          goToPage: WelcomePage(),
          duration: 3,
        ),
        "register": (BuildContext _context) => RegisterPage(),
        "welcome": (BuildContext _context) => WelcomePage(),
        "home": (BuildContext _context) => HomePage(),
        "email_verification": (BuildContext _context) =>
            EmailVerificationScreen(),
        "profile": (BuildContext _context) => ProfilePage(),
        "edit_profile": (BuildContext _context) => EditProfilePage(),
        "onboarding": (BuildContext _context) => OnboardingPage(),
      },
    ),);
  }
}
