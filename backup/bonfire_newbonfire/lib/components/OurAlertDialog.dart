import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

Future<bool> showAlertDialog(BuildContext context,
    {@required String title,
    @required String content,
    String cancelActionText,
    bool getRequiredLinkbool,
    @required Future<void> getRequiredLink,
    @required String defaultActionText,
    @required onPressed}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xff383838),
        title: Text(title,
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16.5)),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: Color(0xffe2e2e2),
          ),
        ),
        actions: <Widget>[
          if (cancelActionText != null)
            FlatButton(
              child: Text(
                cancelActionText,
                style: Theme.of(context).textTheme.headline1,
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          getRequiredLinkbool == false
              ? FlatButton(
            color: Theme.of(context).accentColor,
            child: Text(
                    defaultActionText,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  onPressed: onPressed,
                )
              : FutureBuilder<Uri>(
                  future: getRequiredLink,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Uri uri = snapshot.data;
                      return FlatButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () => Share.share(uri.toString()),
                        child: Text(
                          defaultActionText,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      );
                    } else {
                      return FlatButton(
                        color: Theme.of(context).backgroundColor,
                        child: Text(
                          defaultActionText,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      );
                    }
                  }),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
