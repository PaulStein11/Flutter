import 'package:bonfire_newbonfire/screens/Login/widgets/OurFilledButton.dart';
import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:bonfire_newbonfire/widgets/GlassCard.dart';
import 'package:bonfire_newbonfire/widgets/OurIconBtn.dart';
import 'package:flutter/material.dart';

import '../../my_flutter_app_icons.dart';
import '../Home/HomePage.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final mainController = FixedExtentScrollController();
  var reachEnd = false;

  _listener() {
    final maxScroll = mainController.position.maxScrollExtent;
    final minScroll = mainController.position.minScrollExtent;
    if (mainController.offset >= maxScroll) {
      setState(() {
        reachEnd = true;
      });
    }

    if (mainController.offset <= minScroll) {
      setState(() {
        reachEnd = false;
      });
    }
  }

  @override
  void initState() {
    mainController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    mainController.removeListener(_listener);
    mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.cancel, color: Colors.grey, size: 26.0,),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    child: Text(
                      "Welcome to bonfire!",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 22.0, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Text(
                    "Contribute your ideas around others and build something new together",
                    //"Get ready to contribute your idea around others and build something new together"
                    style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 18.0,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w200,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: GlassMorphism(
                  start: 0.0,
                  end: 1.0,
                  child: Column(
                    children: [
                      Text("sssssssssssssssssssssssss", style: Theme.of(context).textTheme.headline6,),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
