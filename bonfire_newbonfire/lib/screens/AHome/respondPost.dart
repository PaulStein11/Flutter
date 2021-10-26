import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'cloud_record_listview.dart';
import 'features_buttons.dart';


class RespondPostPage extends StatefulWidget {
  String title;
  String postId;

  RespondPostPage({this.title, this.postId});


  @override
  _RespondPostPageState createState() =>
      _RespondPostPageState(this.title, this.postId);
}

class _RespondPostPageState extends State<RespondPostPage> {
  String title;
  String postId;
  bool isUploadingPost = false;
  List<StorageReference> references = [];


  _RespondPostPageState(this.title, this.postId);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Text(
                      "Adding some data here",
                      style: TextStyle(
                          color: Color(0xffe2e2e2),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    _buildAudioButton(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Record audio",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: references.isEmpty
                          ? Center(
                        child: Text('No File uploaded yet'),
                      )
                          : CloudRecordListView(
                        references: references,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: FeatureButtonsView(
                        //onUploadComplete: _onUploadComplete,
                      ),
                    ),

                    /*Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: FloatingActionButton(
                        backgroundColor: Color(0xff383838),
                        onPressed: () async {
                        },
                        child: Icon(
                          Icons.play_arrow,
                          size: 32.0,
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Center(
                      child: isUploadingPost
                          ? CircularProgressIndicator(
                              color: Theme.of(context).accentColor,
                            )
                          : RaisedButton(
                              onPressed: isUploadingPost
                                  ? null
                                  : () async {
                                      setState(() {
                                        isUploadingPost = true;
                                      });
                                    },
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                child: Text(
                                  "Next",
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
          ],
        ),
      ),
    );
  }

  Widget _buildAudioButton() {
    final bool isRecording = false;
    final icon = isRecording ? Icons.stop : Icons.mic_rounded;

    return FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      onPressed: () {},
      child: Icon(
        icon,
        size: 30.0,
      ),
    );
  }

}
