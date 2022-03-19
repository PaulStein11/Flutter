import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

Future<bool> showAlertDialog(BuildContext context,
    {@required String title,
    @required String content,
    String cancelActionText,
    bool getRequiredLinkbool,
    Future<void> getRequiredLink,
    @required String defaultActionText,
    @required onPressed}) {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        backgroundColor: Theme.of(context).cardColor,
        title: Text(title,
            style: TextStyle(
                color: Color(0xffe2e2e2),
                fontWeight: FontWeight.w600,
                fontSize: 16.5)),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w400,
            color: Color(0xffe2e2e2).withOpacity(0.85),
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
                  child: Text(
                    defaultActionText,
                    style: Theme.of(context).textTheme.headline1.copyWith(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w700),
                  ),
                  onPressed: onPressed,
                )
              : FutureBuilder<Uri>(
                  future: getRequiredLink,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Uri uri = snapshot.data;
                      return FlatButton(
                        onPressed: () => Share.share(uri.toString()),
                        child: Text(
                          defaultActionText,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w700),
                        ),
                      );
                    } else {
                      return FlatButton(
                        color: Colors.transparent,
                        onPressed: onPressed,
                        child: Text(
                          defaultActionText,
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w700),
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
