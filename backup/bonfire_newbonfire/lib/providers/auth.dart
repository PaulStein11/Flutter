import 'package:bonfire_newbonfire/screens/Home/HomePage.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bonfire_newbonfire/service/navigation_service.dart';
import 'package:bonfire_newbonfire/service/snackbar_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  UserNotFound,
  Error,
}

//Creating a class to host all the AuthProvider functionality
class AuthProvider extends ChangeNotifier {
  FirebaseUser user;
  AuthStatus status;
  FirebaseAuth _auth; //Internal variable to call firebase auth
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    user = await _auth.currentUser();
    if (user != null) {
      notifyListeners();
      _autoLogin();
    }
  }

  //Functions of our class

  //Google Sign In
  Future<String> googleSignIn() async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      AuthResult _result = await _auth.signInWithCredential(credential);
      user = _result.user;
      if (_result.additionalUserInfo.isNewUser) {
        var tokenId =
            await OneSignal.shared.getDeviceState().then((deviceState) {
          var userTokenId = deviceState.userId;
          print("$userTokenId");
          return userTokenId;
        });
        await FutureService.instance.createUserInDB(
            user.uid, user.displayName, user.email, "", user.photoUrl, tokenId);
        status = AuthStatus.Authenticated;
        NavigationService.instance.navigateToReplacement("onboarding");
      } else {
        NavigationService.instance.navigateToReplacement("home");
      }
    } on AuthException catch (e) {
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
  }

  //Email Log In
  void loginUserWithEmailAndPassword(
      String _email, String _password, context) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      SnackBarService.instance
          .showSnackBarSuccess("Welcome ${user.email}", context);
      //TODO: Update lastSeen
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } catch (error) {
      status = AuthStatus.Error;
      status = AuthStatus.NotAuthenticated;
      notifyListeners();
      if (user == null) {
        SnackBarService.instance
            .showSnackBarError("Account doesn't exist", context);
      } else {
        SnackBarService.instance.showSnackBarError(
            "Check that your email and password are correct", context);
      }
    }
    notifyListeners();
  }

  void registerUserWithEmailAndPassword(BuildContext context, String _email,
      String _password, Future<void> onSuccess(String _uid)) async {
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      AuthResult _result = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      user = _result.user;
      status = AuthStatus.Authenticated;
      await onSuccess(user.uid);
      user.sendEmailVerification();
      NavigationService.instance.navigateToReplacement("email_verification");
    } catch (error) {
      status = AuthStatus.Error;
      notifyListeners();
      print(error.code.toString());
      if (error.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        SnackBarService.instance.showSnackBarError(
            "Email already exist", context);
        }
      }
      notifyListeners();
  }

  void logoutUser(Future<void> onSuccess(), BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      user = null;
      status = AuthStatus.NotAuthenticated;
      await onSuccess();
      await NavigationService.instance.navigateToReplacement("welcome");
    } catch (e) {
      SnackBarService.instance.showSnackBarError("Error Logging Out", context);
    }
    notifyListeners();
  }

  void changePassword(String _email, BuildContext context) async{
    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: _email);
      status = AuthStatus.Authenticated;
      SnackBarService.instance
          .showSnackBarSuccess("An email was sent to reset your password", context);
      Navigator.pop(context);
    } catch(e) {
      status = AuthStatus.Error;
      status = AuthStatus.NotAuthenticated;
      notifyListeners();
      if (user == null) {
        SnackBarService.instance
            .showSnackBarError("Account doesn't exist", context);
      }
    }
    notifyListeners();
  }
}
