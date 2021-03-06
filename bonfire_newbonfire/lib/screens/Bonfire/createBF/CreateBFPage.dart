import 'package:bf_pagoda/my_flutter_app_icons.dart';
import 'package:bf_pagoda/screens/Bonfire/createBF/CreateBFAudio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../widgets/OurFilledButton.dart';
import '../../../widgets/OurLeadingIcon.dart';
import 'BFExample.dart';

class CreateBFPage extends StatefulWidget {
  String? uid, username, profileImg; // User data to be passed onto nex screen

  CreateBFPage({this.uid, this.username, this.profileImg});

  @override
  State<CreateBFPage> createState() =>
      _CreateBFPageState(this.uid, this.username, this.profileImg);
}

class _CreateBFPageState extends State<CreateBFPage> {
  String? uid, username, profileImg; // User data to be passed onto nex screen
  String _bfTitle = "", dropdownvalue = '1 day';
  bool isAnonymous = false, isUploadingPost = false;
  TextEditingController bfTitleController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  // List of items in our dropdown menu
  var items = [
    '1 day',
    '2 day',
    '3 day',
    '4 day',
    '5 day',
  ];

  _CreateBFPageState(String? uid, String? username, String? profileImg);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create bonfire",
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
          elevation: 0.0,
          leading: OurLeadingIcon(context),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    content: Builder(
                      builder: (context) {
                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;

                        return Container(
                          height: height - 500,
                          width: width - 30,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TIPS",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                        color:
                                            Theme.of(context).backgroundColor,
                                        fontSize: 22.0),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "See how people uses bonfires to gather people to create new content",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          color: Colors.grey.shade800,
                                          fontSize: 17.0),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.5),
                                child: FlatButton(
                                  color: Theme.of(context).backgroundColor,
                                  child: Text(
                                    "see examples",
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => BFExample(
                                                  uid: widget.uid,
                                                  username: widget.username,
                                                  profileImg: widget.profileImg,
                                                )));
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                MyFlutterApp.attention,
                size: 17.0,
              ),
              color: Colors.white70,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.00,
                horizontal: MediaQuery.of(context).size.width * 0.07),
            child: Form(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    "Add your title",
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.75),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  //NEEDS FORM Widget and add bad words
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    validator: (input) {
                      return input!.isEmpty ? "Title your bonfire" : null;
                    },
                    onSaved: (input) {
                      _bfTitle = input!;
                    },
                    style:
                        TextStyle(color: Colors.grey.shade300, fontSize: 16.5),
                    controller: bfTitleController,
                    cursorColor: Theme.of(context).accentColor,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).backgroundColor,
                      filled: true,
                      hintText: "Ex: The day DOGE will reach 1 dollar",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Duration",
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).indicatorColor,
                            ),
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: dropdownvalue,
                              // Initial Value
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white70,
                              ),
                              // Down Arrow Icon
                              items: items.map((String items) {
                                // Array list of items
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14.5),
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidCheckCircle,
                              size: 18.0,
                              color: Colors.orange.shade900,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "This bonfire will finish on ${DateFormat('EEEE').format(DateTime.now().add(Duration(days: int.parse(dropdownvalue.substring(0, dropdownvalue.indexOf("day"))))))}",
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Center(
                      child: isUploadingPost
                          ? CircularProgressIndicator(
                              color: Theme.of(context).accentColor,
                            )
                          : OurFilledButton(
                              context: context,
                              text: "continue",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (isAnonymous == true) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateBFAudio(
                                          uid: widget.uid,
                                          username: widget.username,
                                          profileImg: widget.profileImg,
                                          bfTitle: _bfTitle,
                                          anonymous: isAnonymous,
                                          bfDuration: dropdownvalue,
                                        ),
                                      ),
                                      ModalRoute.withName('home'),
                                    );
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateBFAudio(
                                          uid: widget.uid,
                                          username: widget.username,
                                          profileImg: widget.profileImg,
                                          bfTitle: _bfTitle,
                                          anonymous: isAnonymous,
                                          bfDuration: dropdownvalue,
                                        ),
                                      ),
                                      ModalRoute.withName('home'),
                                    );
                                  }
                                }
                              },
                            )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
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
