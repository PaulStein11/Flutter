import 'dart:async';

import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/my_flutter_app_icons.dart';
import 'package:bonfire_newbonfire/screens/CreateBonfireAudio.dart';
import 'package:bonfire_newbonfire/service/future_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

import 'HomePage.dart';

class CreateNewBonfire extends StatefulWidget {
  String id;
  String name;
  String profileImage;

  CreateNewBonfire({this.id, this.name, this.profileImage});

  @override
  _CreateNewBonfireState createState() =>
      _CreateNewBonfireState(this.id, this.name, this.profileImage);
}

class _CreateNewBonfireState extends State<CreateNewBonfire> {
  bool isUploadingPost = false;
  String id, name, bfId = Uuid().v4(), profileImage;
  String dropdownValue = 'Default';
  String _title = "";
  String _anonymous = '👓';
  final _formKey = new GlobalKey<FormState>();
  bool isAnonymous = false;
  bool _light = false;
  TextEditingController titleController = TextEditingController();

  _CreateNewBonfireState(this.id, this.name, this.profileImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                        horizontal: MediaQuery.of(context).size.width * 0.07),
                    child: Form(
                      key: _formKey,
                      onChanged: () {
                        _formKey.currentState.save();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Text(
                            "Start a Bonfire",
                            style: TextStyle(
                                color: Color(0xffe2e2e2),
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Don't feel shy and make it anonymous or share your thoughts with others!",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                          ),

                          //NEEDS FORM Widget and add bad words
                          TextFormField(
                            validator: (input) {
                              return input.isEmpty
                                  ? "Need to title your Bonfire"
                                  : null;
                            },
                            onSaved: (input) {
                              _title = input;
                            },
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                            controller: titleController,
                            cursorColor: Theme.of(context).accentColor,
                            minLines: 2,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Start writing here...",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade400, width: 1.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Icon(
                                  MyFlutterApp.user_secret,
                                  size: 28.0,
                                  color: Colors.white70,
                                ),
                              ),
                              Expanded(
                                child: const Text(
                                  'Make it anonymous',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      letterSpacing: 0.5),
                                ),
                              ),
                              Switch(
                                value: isAnonymous,
                                onChanged: (bool value) {
                                  setState(() {
                                    _light = value;
                                    isAnonymous = !isAnonymous;
                                  });
                                },
                              ),
                            ],
                          ),
                          /*SwitchListTile(
                            inactiveTrackColor: Colors.grey,
                            title: const Text(
                              'Make it anonymous',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  letterSpacing: 0.5),
                            ),
                            value: isAnonymous,
                            onChanged: (bool value) {
                              setState(() {
                                _light = value;
                                isAnonymous = !isAnonymous;
                              });
                            },
                            secondary: Icon(
                              MyFlutterApp.user_secret,
                              size: 30.0,
                              color: Colors.white70,
                            ),
                          ),*/
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          Center(
                            child: isUploadingPost
                                ? CircularProgressIndicator(
                                    color: Theme.of(context).accentColor,
                                  )
                                : SizedBox(
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateBonfireAudio(
                                                      id: id,
                                                      name: name,
                                                      profileImage:
                                                          profileImage,
                                                      title: _title,
                                                      isAnonym: isAnonymous),
                                            ),
                                          );
                                        }
                                      },
                                      color: Theme.of(context).accentColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80)),
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontFamily: "Palanquin",
                                            fontSize: 17.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          /* Row(
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
                          )*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

/*SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
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
                height: MediaQuery.of(context).size.height * 0.02,
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
              ),*/
