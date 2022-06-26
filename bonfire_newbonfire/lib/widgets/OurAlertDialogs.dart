import 'package:flutter/material.dart';

Widget OurAlertDialog() {
  return new AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(10.0))),
    content: Builder(
      builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height =
            MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
            height: height - 400,
            width: width - 50,
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  "First bonfire",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!.copyWith(color: Colors.grey.shade600),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Before start your first bonfire check some examples for reference",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!.copyWith(color: Colors.grey.shade800, fontSize: 17.0),
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.5),
                  child: FlatButton(
                    color:
                    Theme.of(context).primaryColor,
                    child: Text(
                      "see examples",
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  BFExample(
                                    uid: userData.uid,
                                    username:
                                    userData.name,
                                    profileImg: userData
                                        .profileImage,
                                  )));
                    },
                  ),
                ),
                FlatButton(
                    color: Theme.of(context)
                        .indicatorColor,
                    child: Text(
                      "continue",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryColor),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateBFPage(
                                uid: userData.uid,
                                username: userData.name,
                                profileImg:
                                userData.profileImage,
                              ),
                        ),
                      );
                    }),*/
              ],
            ));
      },
    ),
  );
}