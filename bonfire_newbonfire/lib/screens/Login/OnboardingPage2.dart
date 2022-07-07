import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/navigation_service.dart';
import '../../widgets/OurFilledButton.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "How it works",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 22.0, color: Colors.white),
                  ),
                  Text(
                    "Create your bonfire with your topic of interest",
                    //"Get ready to contribute your idea around others and build something new together"
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 17.0,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(

                            child: Image(
                                image: AssetImage("assets/images/flame_sharp_white.png"),
                                height: 55),
                          ),
                      ),
                      Text(
                        "<=>",
                        style:
                        TextStyle(fontSize: 28.0, color: Colors.white),
                      ),
                      Icon(
                        MyFlutterApp.chat_empty,
                        size: 45.0,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                  Text(
                    "Listen and support peoples interactions",
                    //"Get ready to contribute your idea around others and build something new together"
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 17.0,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Icon(
                    FontAwesomeIcons.microphoneLines,
                    size: 45.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "See the outcome of your collaboration!",
                    //"Get ready to contribute your idea around others and build something new together"
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 17.0,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.0,),
                  OurFilledButton(
                    context: context,
                    text: "continue",
                    onPressed: () {
                      navigatorKey?.currentState
                          ?.pushReplacementNamed("home");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
