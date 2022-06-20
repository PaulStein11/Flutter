import 'package:bf_pagoda/screens/Login/TermsPrivacyPage.dart';
import 'package:bf_pagoda/services/navigation_service.dart';
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
        TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 15.0,),
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
                navigatorKey?.currentState?.pushNamed("terms&conditions");
              },
          ),
          TextSpan(
              text: ' and ',
              style: TextStyle(
                  fontSize: 15, color: Theme.of(context).secondaryHeaderColor),
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
        ],
      ),
      maxLines: 4,
    ),
  );
}