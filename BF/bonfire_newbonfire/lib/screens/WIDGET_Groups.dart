import 'package:flutter/material.dart';

Widget GroupsWidget(Function onPressed, BuildContext context, bool isGroup, String category,
    String image_path) {
  return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 14, right: 25, top: 20, bottom: 5),
            //horizontal: 14.0, vertical: 20),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 2.0,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: isGroup == true ? Colors.grey.shade800.withOpacity(0.70): Colors.grey.shade600,
                  //.withOpacity(0.95),//.withAlpha(240),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: isGroup == true ? Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(image_path)),
                    ),
                  ) : Icon(Icons.add, color: Colors.grey.shade900, size: 30.0,),
                ),
              ),
            ),
          ),
          Center(
              child: Text(
            category,
            style: Theme.of(context).textTheme.headline2.copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.normal,
                fontFamily: "PalanquinRegular"),
            textAlign: TextAlign.left,
          ))
        ],
      ));
}
