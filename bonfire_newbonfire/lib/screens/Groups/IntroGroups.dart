import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroGroup extends StatefulWidget {
  @override
  State<IntroGroup> createState() => _IntroGroupState();
}

class _IntroGroupState extends State<IntroGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.9,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/shirley.png"),
                          fit: BoxFit.cover)),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(right: 25.0, top: 15.0),
                  child: Container(
                    height: 47.0,
                    alignment: Alignment.topRight,
                    child: Material(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () {
                          //TODO: NOTIFY USER DIDN'T PARTICIPATE
                          navigatorKey?.currentState
                              ?.pushReplacementNamed("onboarding_3");
                        },
                        minWidth: 70.0,
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                              letterSpacing: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Starts with a spark",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(
                                  fontSize: 22.0,
                                  color: Colors.white.withOpacity(0.9)),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Text(
                            "Make your first interaction in Bonfire and see what people is up to!",
                            //"Get ready to contribute your idea around others and build something new together"
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      fontSize: 17.0,
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w200,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    OurFilledButton(
                      context: context,
                      text: "start",
                      onPressed: () {
                        navigatorKey?.currentState
                            ?.pushNamed("first_groups");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
