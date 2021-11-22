import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Join the Bonfire", style: Theme.of(context).textTheme.headline1,),
        SizedBox(
          height: 60.0,
        ),
        Container(
          child: OurLoadingWidget(context),
        ),
      ],
    );
  }
}
