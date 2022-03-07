import 'package:bonfire_newbonfire/screens/Login/widgets/OurOutlinedButton.dart';
import 'package:flutter/material.dart';

import '../../my_flutter_app_icons.dart';
import '../HomePage.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Text(
                "continue",
                style: TextStyle(color: Colors.grey.shade200, fontWeight: FontWeight.bold),
              ),
              onPressed: reachEnd
                  ? () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false)
                  : null
            ),
          ),
        ],
      ),
      body: ListWheelScrollView(
        itemExtent: 630,
        diameterRatio: 5,
        offAxisFraction: -2,
        controller: mainController,
        //useMagnifier: true,
        //magnification: 1.08,
        children: [

          Container(
            //color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, bottom: 5, left: 15, right: 15.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).accentColor,
                      blurRadius: 4.0,
                      spreadRadius: 2,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                      // shadow direction: bottom right
                    ),
                  ],
                ),
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: new DecorationImage(
                          image:
                              AssetImage("assets/images/caveman_scene.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              "Onboarding 1",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        "Make it fun",
                        style: TextStyle(
                            fontSize: 20.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade300,
                            letterSpacing: 0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "#Easy way to make people laugh: King of GIF's, Master of Memes, Emperor of stand ups and more!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 0.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Icon(
                              MyFlutterApp.users,
                              size: 25.0,
                              color: Colors.white70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "110",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),*/
              ),
            ),
          ),
          Container(
            //color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 30, right: 30.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).accentColor,
                      blurRadius: 4.0,
                      spreadRadius: 2,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                      // shadow direction: bottom right
                    ),
                  ],
                ),
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: new DecorationImage(
                          image:
                          AssetImage("assets/images/caveman_scene.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              "Onboarding 1",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        "Make it fun",
                        style: TextStyle(
                            fontSize: 20.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade300,
                            letterSpacing: 0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "#Easy way to make people laugh: King of GIF's, Master of Memes, Emperor of stand ups and more!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 0.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Icon(
                              MyFlutterApp.users,
                              size: 25.0,
                              color: Colors.white70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "110",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),*/
              ),
            ),
          ),
          Container(
            //color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 30, right: 30.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).accentColor,
                      blurRadius: 4.0,
                      spreadRadius: 2,
                      offset: Offset(
                        1.0,
                        1.0,
                      ),
                      // shadow direction: bottom right
                    ),
                  ],
                ),
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: new DecorationImage(
                          image:
                          AssetImage("assets/images/caveman_scene.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                            ),
                            Text(
                              "Onboarding 1",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                /*child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        "Make it fun",
                        style: TextStyle(
                            fontSize: 20.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade300,
                            letterSpacing: 0.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "#Easy way to make people laugh: King of GIF's, Master of Memes, Emperor of stand ups and more!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            letterSpacing: 0.2),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Icon(
                              MyFlutterApp.users,
                              size: 25.0,
                              color: Colors.white70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "110",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),*/
              ),
            ),
          ),
        ],
        clipBehavior: Clip.hardEdge,
      ),
    );
  }
} /*Scaffold(
      body: SafeArea(
        child: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/caveman_scene.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    Text(
                      "Onboarding 1",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 21.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: OurOutlineButton(
                        context: context,
                        text: "Continue",
                        hasIcon: false,
                        color: Colors.amber.shade700,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => OnboardPage2(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/