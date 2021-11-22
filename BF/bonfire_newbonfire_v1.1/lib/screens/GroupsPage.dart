import 'dart:async';

import 'package:bonfire_newbonfire/screens/FunPage.dart';
import 'package:flutter/material.dart';

import '../my_flutter_app_icons.dart';
import 'HomePage.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topLeft,
              colors: [Theme
                  .of(context)
                  .backgroundColor, Theme
                  .of(context)
                  .indicatorColor,
                Theme
                    .of(context)
                    .indicatorColor,
                Colors.orange.withOpacity(0.4),
              ])),
      child: Scaffold(
        //backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              "Groups",
              style: TextStyle(color: Colors.grey.shade300),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false),
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          //StreamBuilder of groups created by the user or company or whatever
          //Itemcount is the length of the collection
          //Builder is the ListTile with all the information store in the document of FB
          body: Column(
            children: [
              SizedBox(height: 20.0,),
              Card(
                color: Colors.grey.shade800,
                child: ListTile(
                  /*leading: Container(
                    height: 30,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/green.png"),
                      ),
                    ),
                  ),*/
                  title: Text("# Main BF", style: Theme.of(context).textTheme.headline1,),

                ),
              ),
              Card(
                color: Colors.grey.shade800,
                child: ListTile(
                  /*leading: Container(
                    height: 30,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/lol.png"),
                      ),
                    ),
                  ),*/
                  title: Text("# Memeland", style: Theme.of(context).textTheme.headline1,),

                ),
              )
            ],
          )

          /*ListView.builder(
            itemCount: collection.length,
            itemBuilder: (context, index) {
              return ListTileWidget(
                data.icon,
                data.title,
              );
          return ListTile();
        })*/
          ),
    );
  }
}
