import 'package:bonfire_newbonfire/screens/Privacy/TermsPrivacyPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final String privacyPolicyTxt = "Privacy Policy";
final String termsAndConditionsTxt = 'Terms & Conditions';

Widget TermsOfPrivacyForUsers(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "By tapping 'Continue with Google or Email' you accept Bonfire ",
        style:
        TextStyle(color: Colors.white70, fontSize: 15.0,),
        children: <TextSpan>[
          TextSpan(
            text: privacyPolicyTxt,
            style: TextStyle(
              color: Theme
                  .of(context)
                  .accentColor,
              fontSize: 15.0,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermsPrivacyPolicy()));
              },
          ),
          TextSpan(
              text: ' and ',
              style: TextStyle(
                  fontSize: 15, color: Colors.white70),
              children: <TextSpan>[
                TextSpan(
                    text: termsAndConditionsTxt,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // code to open / launch privacy policy link here
                      })
              ]),
          /*TextSpan(
                            text: '. Check ',
                            style: TextStyle(
                                fontSize: 15, color: Colors.white70),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'easy peasy',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // code to open / launch privacy policy link here
                                    })
                            ]),
                        TextSpan(
                          text: ' version on how we manage your data in our platform and with respect of third party',
                          style: TextStyle(
                              fontSize: 15, color: Colors.white70),
                        ),*/
        ],
      ),
      maxLines: 4,
    ),
  );
}