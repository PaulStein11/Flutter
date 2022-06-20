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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30.0,),
              Text(
                "How it works",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 22.0, color: Colors.white),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
height: MediaQuery.of(context).size.height * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                        Container(
                          height: 55.0,
                          width: 55.0,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: FittedBox(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 35,
                                  width: 35.0,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/flame_sharp_white.png"))),
                                )),
                          ),
                        ),
                        Text(
                          "<=>",
                          style: TextStyle(fontSize: 28.0, color: Colors.white),
                        ),
                        Icon(
                          MyFlutterApp.chat_empty,
                          size: 38.0,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesomeIcons.microphoneLines,
                          size: 38.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "<=>",
                          style: TextStyle(fontSize: 28.0, color: Colors.white),
                        ),
                        CircleAvatar(
                          radius: 27,
                          backgroundColor: Theme.of(context).accentColor,
                          child: IconButton(
                            iconSize: 25.0,
                            icon: Icon(MyFlutterApp.angle_circled_up,
                                color: Theme.of(context).secondaryHeaderColor),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Check what comes out once the time is over!",
                      //"Get ready to contribute your idea around others and build something new together"
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 17.0,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OurFilledButton(
                    context: context,
                    text: "continue",
                    onPressed: () {
                      navigatorKey?.currentState?.pushReplacementNamed("home");
                    },
                  ),
                ],
              ),
              SizedBox(height: 50.0,),

            ],
          ),
        ),
      ),
    );
  }
}
