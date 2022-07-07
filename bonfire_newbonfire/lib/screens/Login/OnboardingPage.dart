import 'package:bf_pagoda/services/navigation_service.dart';
import 'package:bf_pagoda/widgets/OurFilledButton.dart';
import 'package:bf_pagoda/widgets/OurOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingPage extends StatefulWidget {
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
      print(controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        preferredSize: Size.fromHeight(30.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.headphonesAlt,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 60.0,),
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.userAstronaut,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.microphoneLines,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 45.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 37,
                        backgroundColor: Theme.of(context).indicatorColor,
                        child: IconButton(
                          iconSize: 35.0,
                          icon: Icon(
                            FontAwesomeIcons.fire,
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.7)
                                .withOpacity(controller.value),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(width: 45.0,),
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.userGraduate,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.userSecret,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 60.0,),
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Theme.of(context).indicatorColor.withOpacity(0.7),
                      child: IconButton(
                        iconSize: 25.0,
                        icon: Icon(
                          FontAwesomeIcons.userDoctor,
                          color: Theme.of(context)
                              .secondaryHeaderColor
                              .withOpacity(0.7)
                              .withOpacity(controller.value),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(                  height: MediaQuery.of(context).size.height * 0.095,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      child: Text(
                        "Welcome to bonfire",
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontSize: 22.0,
                            color: Colors.white.withOpacity(controller.value)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      "Contribute your ideas around others and build something new together",
                      //"Get ready to contribute your idea around others and build something new together"
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontSize: 17.0,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  /*Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Icon(
                          FontAwesomeIcons.fireBurner, color: Theme.of(context).primaryColor.withOpacity(0.7).withOpacity(controller.value), size: 40.0,
                        ),
                      ),
                    ),*/
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:    OurFilledButton(context: context, text: "continue", onPressed: (){
                  navigatorKey?.currentState?.pushReplacementNamed("onboarding2");
                },),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
