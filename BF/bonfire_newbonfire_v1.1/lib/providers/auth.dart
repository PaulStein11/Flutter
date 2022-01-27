import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/screens/HomePage.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:bonfire_newbonfire/service/snackbar_service.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

//Creating a class to host all the AuthProvider functionality
class AuthProvider extends ChangeNotifier {
  User user;
  AuthStatus status;
  FirebaseAuth _auth; //Internal variable to call firebase auth
  static AuthProvider instance =
  AuthProvider(); //Create static member of our class to only allow one AuthProvider

  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _checkCurrentUserIsAuthenticated();
  }

  void _autoLogin() {
    if (user != null) {
      NavigationService.instance.navigateToReplacement("home");
    } else {
      NavigationService.instance.navigateToReplacement("welcome");
    }
  }

  void _checkCurrentUserIsAuthenticated() async {
    user = await _auth.currentUser;
    if (user != null) {
      notifyListeners();
      _autoLogin();
    }
  }

  //Functions of our class
  void loginUserWithEmailAndPassword(String _email, String _password,
      context) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance.showSnackBarSuccess("Welcome ${user.email}", context);
      //TODO: Update lastSeen
      //NavigationService.instance.navigateToReplacement("loading");
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } catch (error) {
      status = AuthStatus.Error;

      if (user == null) {
        SnackBarService.instance.showSnackBarError("Account doesn't exist", context);
      } else {
        SnackBarService.instance.showSnackBarError(
            "Check that your email and password are correct", context);
      }
    }
    notifyListeners();
  }




  void registerUserWithEmailAndPassword(BuildContext context, String _email, String _password,
      Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      UserCredential _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      SnackBarService.instance.showSnackBarSuccess("Signed in successfully", context);
      user.sendEmailVerification();
      NavigationService.instance.navigateToReplacement("email_verification");
      //NavigationService.instance.goBack();
      //NavigationService.instance.navigateToReplacement(LoadingScreen.id);

    } catch (error) {
      status = AuthStatus.Error;
      user = null;
      SnackBarService.instance
          .showSnackBarError("Error while registering user", context);
    }
    notifyListeners();
  }


  void logoutUser(Future<void> onSuccess(), BuildContext context) async {
    try {
      await _auth.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement("welcome");
      SnackBarService.instance.showSnackBarSuccess("Logged Out Successfully!", context);
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out", context);
    }
    notifyListeners();
  }
}
