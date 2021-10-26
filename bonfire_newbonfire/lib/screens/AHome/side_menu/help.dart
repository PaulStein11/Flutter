import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpPage extends StatefulWidget {
  String user;
  String email;

  HelpPage({this.user, this.email});

  @override
  _HelpPageState createState() => _HelpPageState(this.user, this.email);
}

class _HelpPageState extends State<HelpPage> {
  bool isUploadingFeed = false;
  String help = "";
  String user;
  String email;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController feedbackController = TextEditingController();

  _HelpPageState(this.email, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Help",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 18.0,
                fontWeight: FontWeight.normal),
          ),
        ),
        body: Form(
          key: _formKey,
          onChanged: () {
            _formKey.currentState.save();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Let us know what's happening and we will contact you ASAP",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  validator: (input) {
                    return input.isEmpty ? "Need to title your Post" : null;
                  },
                  onSaved: (input) {
                    help = input;
                  },
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                  controller: feedbackController,
                  cursorColor: Theme
                      .of(context)
                      .accentColor,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Start writing here",
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
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.3),
              RaisedButton(
                onPressed: isUploadingFeed
                    ? null
                    : () async {
                  setState(() {
                    isUploadingFeed = true;
                    _launchURL(widget.email, "pablerillas.11.pb@gmail.com", help);
                  });
                },
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  child: Text(
                    "Send",
                    style: TextStyle(
                        fontFamily: "Palanquin",
                        fontSize: 17.0,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  void _launchURL(String sender, String toMyMail, String usersFeedback) async {

    var url = 'mailto:$toMyMail?sender=$sender&body=$usersFeedback';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch url $url";
    }
  }
}

