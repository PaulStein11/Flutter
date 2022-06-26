import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/services/snackbar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../services/future_services.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticated,
  Authenticating,
  Error,
  VerifyingEmail,
  Emailverified
}

class AuthProvider extends ChangeNotifier {
  late FirebaseAuth _auth;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthStatus? status;
  User? user;
  late bool newUser = false;
  UserCredential? _credential;
  static AuthProvider instance = AuthProvider();
  late final String? osUserID;
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    checkCurrentUserIsAuth();
  }

  // //AUTH STATE ==> AUTOLOGIN OR LOGOUT
  void checkCurrentUserIsAuth() async {
    user = await _auth.currentUser;
    notifyListeners();
    _auth.userChanges().listen(
      (_user) {
        if (_user == null) {
          print('User is currently signed out');
          status = AuthStatus.NotAuthenticated;
          notifyListeners();
          navigatorKey?.currentState?.pushReplacementNamed("unknown");
        } else if (!_user.emailVerified) {
          navigatorKey?.currentState
              ?.pushReplacementNamed("email_verification");
        } else if (_user.emailVerified == true && newUser == true) {
          navigatorKey?.currentState?.pushReplacementNamed("onboarding");
        } else {
          print('User is signed in');
          status = AuthStatus.Authenticated;
          notifyListeners();
          navigatorKey?.currentState?.pushReplacementNamed("home");
        }
      },
    );
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      status = AuthStatus.NotAuthenticated;
      notifyListeners();
      navigatorKey?.currentState?.pushReplacementNamed("unknown");
    } catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      print(err);
    }
    notifyListeners();
  }

  // --------

  // //AUTHENTICATING BASE ACCOUNTS

  void registerUserWithEmailAndPassword(BuildContext context, String _email,
      String _password, Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _credential?.user;
      await onSuccess(user!.uid);
      if (_credential!.additionalUserInfo!.isNewUser) {
        newUser = true;
      }
      user?.sendEmailVerification();
      navigatorKey?.currentState?.pushReplacementNamed("email_verification");
    } on FirebaseAuthException catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      if (err.code == 'weak-password') {
        SnackBarService.instance
            .showSnackBarError("The password provided is too weak", context);
        print('The password provided is too weak.');
      } else if (err.code == 'email-already-in-use') {
        SnackBarService.instance
            .showSnackBarError("The account already exists", context);
        print('The account already exists for that email.');
      }
    } catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      print("APP ERROR / NOT FROM FIREBASE AUTH ==> $err");
    }
    notifyListeners();
  }

  void loginUserWithEmailAndPassword(
      String _email, String _password, BuildContext context) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      _credential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _credential?.user;
      status = AuthStatus.Authenticated;
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      if (err.code == 'user-not-found') {
        SnackBarService.instance
            .showSnackBarError("No user found for that email", context);
        print('No user found for that email.');
      } else if (err.code == 'wrong-password') {
        SnackBarService.instance
            .showSnackBarError("Wrong password provided", context);
        print('Wrong password provided');
      }
    } catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      print("APP ERROR / NOT FROM FIREBASE AUTH ==> $err");
    }
    notifyListeners();
  }

// ------------

  Future<String> signInWithGoogle() async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential authResult = await _auth.signInWithCredential(credential);
      user = authResult.user;
      /*String? tokenId = await messaging.getToken().then((deviceToken) {
        print("Device Token: $deviceToken");
        return deviceToken;
      });*/
      if (authResult.additionalUserInfo!.isNewUser) {
        /*var tokenId =
            await OneSignal.shared.getDeviceState().then((deviceState) {
          var userTokenId = deviceState!.userId;
          print("$userTokenId");
          return userTokenId;
        });*/
        final oneSigState = await OneSignal.shared.getDeviceState().then((deviceState) {
          osUserID = deviceState!.userId;
        });

        print("Paul, the userId is $osUserID");

        await FutureServices.instance.createUserInDB(
            user!.uid,
            user!.displayName,
            user!.email,
            user!.photoURL,
            "",
            osUserID); //tokenId!);
        status = AuthStatus.Authenticated;
        navigatorKey?.currentState?.pushReplacementNamed("onboarding");
      } else {
        navigatorKey?.currentState?.pushReplacementNamed("home");
      }
    } on FirebaseAuthException catch (err) {
      status = AuthStatus.Error;
      notifyListeners();
      print(err.message);
      await googleSignIn.disconnect();
      throw err;
    } catch (e) {
      status = AuthStatus.NotAuthenticated;
      notifyListeners();
      print("DISCONNECTING GOOGLE SIGN IN");
      print(e);
      googleSignIn.disconnect();
    }
    notifyListeners();
    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }
// // SOCIAL AUTHENTICATION
/*Future<String> googleSignIn() async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential _result = await _auth.signInWithCredential(credential);
      user = _result.user;
      if (_result.additionalUserInfo!.isNewUser) {
        await FutureServices.instance.createUserInDB(
            user!.uid, user!.displayName, user!.email, "");
        status = AuthStatus.Authenticated;
        navigatorKey?.currentState?.pushReplacementNamed("onboarding");
      } else {
        navigatorKey?.currentState?.pushReplacementNamed("home");
      }
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      print(e.message);
      await _googleSignIn.disconnect();
      throw e;
    } catch (e) {
      status = AuthStatus.NotAuthenticated;
      notifyListeners();
      print("DISCONNECTING GOOGLE SIGN IN");
      _googleSignIn.disconnect();
    }
    notifyListeners();
  }*/

}
