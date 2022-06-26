// @dart=2.9

import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/screens/Bonfire/createBF/CreateBFPage.dart';
import 'package:bf_pagoda/screens/Groups/FirstQuestions.dart';
import 'package:bf_pagoda/screens/Groups/SparksPage.dart';
import 'package:bf_pagoda/screens/Login/EmailVerificationPage.dart';
import 'package:bf_pagoda/screens/Login/ForgotPasswordPage.dart';
import 'package:bf_pagoda/screens/HomePage.dart';
import 'package:bf_pagoda/screens/Login/LoginPage.dart';
import 'package:bf_pagoda/screens/Login/OnboardingPage.dart';
import 'package:bf_pagoda/screens/Groups/IntroGroups.dart';
import 'package:bf_pagoda/screens/Login/OnboardingPage2.dart';
import 'package:bf_pagoda/screens/Login/SplashPage.dart';
import 'package:bf_pagoda/screens/Login/TermsPrivacyPage.dart';
import 'package:bf_pagoda/screens/Login/UnknownPage.dart';
import 'package:bf_pagoda/screens/Profile/EditProfile.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/utils/OurDarkTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/Login/RegisterPage.dart';
import 'screens/Profile/ProfilePage.dart';

final String  oneSignalAppId = "397cc3b7-7d47-44cf-b0eb-eb8ce39f8456";

/// --- MAIN FUNCTION --- ///
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xff1E1C1A),
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalAppId);

  runApp(MyApp());
}

/// MyApp main class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BF Pagoda',
        theme: OurDarkTheme().buildTheme(),
        initialRoute: "splash",
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => UnknownPage());
        },
        navigatorKey: navigatorKey,
        routes: {
          // LOGIN SCREENS
          "splash": (BuildContext context) => SplashPage(),
          "home": (BuildContext context) => HomePage(),
          "unknown": (BuildContext context) => UnknownPage(),
          "terms&conditions": (BuildContext context) => TermsOfPrivacyPage(),
          "login": (BuildContext context) => LoginPage(),
          "register": (BuildContext context) => RegisterPage(),
          "password": (BuildContext context) => ForgotPassPage(),
          "onboarding": (BuildContext context) => OnboardingPage(),
          "onboarding2": (BuildContext context) => OnboardingPage2(),
          "email_verification": (BuildContext context) =>
              EmailVerificationPage(),
          // PROFILE SCREENS
          "profile": (BuildContext context) => ProfilePage(),
          "edit_profile": (BuildContext context) => EditProfile(),
          // BF SCREENS
          "createBF": (BuildContext context) => CreateBFPage(),
          // GROUPS SCREENS
          "intro_groups": (BuildContext context) => IntroGroup(),
          "first_groups": (BuildContext context) => FirstQuestionsPage(),
          "main_groups": (BuildContext context) => SparksPage()
        },
        //home:  MyHomePage(),
      ),
    );
  }
}


