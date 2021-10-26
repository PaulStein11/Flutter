import 'dart:async';

import 'package:bonfire_newbonfire/service/db/future.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class AskBonfirePage extends StatefulWidget {
  String name;
  String id;

  AskBonfirePage({this.name, this.id});

  @override
  _AskBonfirePageState createState() =>
      _AskBonfirePageState(this.id, this.name);
}

class _AskBonfirePageState extends State<AskBonfirePage> {
  bool isUploadingPost = false;
  String id,
      name,
      postId = Uuid().v4();
  String dropdownValue = 'Default';
  String title = "";
  final _formKey = new GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  _AskBonfirePageState(this.id, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        centerTitle: true,
        /* title: Text(
          "Create bonfire",
          style: TextStyle(
              fontFamily: "Palanquin",
              color: Colors.grey.shade500,
              fontSize: 18.0),
        ),*/
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery
                .of(context)
                .size
                .height * 0.03,
            horizontal: MediaQuery
                .of(context)
                .size
                .width * 0.1),
        child: Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState.save();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Say something and see what people want to add",
                style: TextStyle(
                    color: Color(0xffe2e2e2),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
              ),

              //NEEDS FORM Widget and add bad words
              TextFormField(
                validator: (input) {
                  return input.isEmpty ? "Need to title your Post" : null;
                },
                onSaved: (input) {
                  title = input;
                },
                style: TextStyle(color: Colors.white, fontSize: 15.0),
                controller: titleController,
                cursorColor: Theme
                    .of(context)
                    .accentColor,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Ex: Let's talk about crypto currency",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04,
              ),

              Text(
                "Duration of bonfire",
                style: TextStyle(
                    color: Color(0xffe2e2e2),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
              ),

              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.white, fontSize: 15.0),
                underline: Container(
                  height: 2,
                  color: Colors.deepOrange,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Default', '1 day', '2 day', '3 day', '4 day']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
              ),
              Center(
                child: isUploadingPost
                    ? CircularProgressIndicator(
                  color: Theme
                      .of(context)
                      .accentColor,
                )
                    : RaisedButton(
                  onPressed: isUploadingPost ? null : () async {
                    setState(() {
                      isUploadingPost = true;
                    });
                    await DBFuture.instance
                        .postInBF(this.id, this.postId, this.title);
                    /*await Firestore.instance
                        .collection("Users")
                        .document(this.id)
                        .updateData({"posts": FieldValue.increment(1)});*/
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()), (
                            route) => false);
                  },
                  color: Theme
                      .of(context)
                      .accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.0),
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontFamily: "Palanquin",
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tips:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See example",
                      style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.deepOrange,
                        fontSize: 14.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
