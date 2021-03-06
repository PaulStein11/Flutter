import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/screens/bonfire_event_screen.dart';
import 'package:flutter/material.dart';

class Trends extends StatelessWidget {
  String description, time;
  IconData icon;
  Color iconColor;
  bool isLive;

  Trends({this.description, this.time, this.icon, this.iconColor, this.isLive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => BonfireEvent(
                      isLive: this.isLive,
                      description: this.description,
                      time: this.time,
                      icon: this.icon,
                      iconColor: this.iconColor,
                    )));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              border: Border.all(color: Colors.grey.shade800
                  //color: Color(0XFF717171),
                  ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Open calendar");
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Icon(
                                    MyFlutterApp.calendar,
                                    size: 22.0,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                // Text("5:00 PM", style: TextStyle(fontSize: 20.0, color: Colors.white),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        width: 240.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              description,
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isLive == true
                            ? Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        "LIVE",
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(""),
                        isLive == true
                            ? SizedBox(
                                height: 10.0,
                              )
                            : SizedBox(),
                        isLive == false
                            ? Icon(
                                MyFlutterApp.share,
                                color: Colors.white70,
                                size: 22.0,
                              )
                            : Text(""),
                      ],
                    ),
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
