import 'package:bf_pagoda/models/user.dart';
import 'package:bf_pagoda/providers/auth.dart';
import 'package:bf_pagoda/services/stream_services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../widgets/OurFilledButton.dart';
import '../../widgets/OurLeadingIcon.dart';
import '../../widgets/OurLoadingWidget.dart';
import 'CreateInteracAudioPage.dart';
import 'createBF/CreateBFAudio.dart';

class CreateInteractionPage extends StatefulWidget {
  String? bfTitle, bfId;

  CreateInteractionPage({required this.bfTitle, required this.bfId});

  @override
  State<CreateInteractionPage> createState() =>
      _CreateInteractionPageState(this.bfTitle, this.bfId);
}

class _CreateInteractionPageState extends State<CreateInteractionPage> {
  late AuthProvider _auth;
  String? bfTitle, bfId;
  late String _interactionTitle;

  //Interaction control
  TextEditingController interacController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  _CreateInteractionPageState(this.bfTitle, this.bfId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(builder: (context) {
        _auth = Provider.of<AuthProvider>(context);
        return StreamBuilder<MyUserModel>(
            stream: StreamServices.instance.getUserData(_auth.user!.uid),
            builder: (context, AsyncSnapshot<MyUserModel> snapshot) {
              if (snapshot.hasError) {
                Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('Stack trace: ${snapshot.stackTrace}'),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return OurLoadingWidget(context);
              }
              final MyUserModel userData = snapshot.data!;
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0.0,
                    leading: OurLeadingIcon(context),
                  ),
                  body: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(height: 40.0),
                            Center(
                              child: Text(
                                bfTitle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 25.0),
                              ),
                            ),
                            SizedBox(height: 50.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Divider(
                                  color: Theme.of(context).primaryColor,
                                )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "Your interaction",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.7)),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Theme.of(context).primaryColor,
                                )),
                              ]),
                            ),
                            Form(
                              key: _formKey,
                              onChanged: () {
                                _formKey.currentState!.save();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.07),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      autocorrect: true,
                                      enableSuggestions: false,
                                      validator: (input) {
                                        return input!.isEmpty
                                            ? "Title your bonfire"
                                            : null;
                                      },
                                      onSaved: (input) {
                                        _interactionTitle = input!;
                                      },
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 16.5),
                                      controller: interacController,
                                      cursorColor:
                                          Theme.of(context).accentColor,
                                      minLines: 2,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        fillColor: Theme.of(context).backgroundColor,
                                        filled: true,
                                        hintText:
                                            "Title your interaction here...",
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 12.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 15.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCheckCircle,
                                            size: 18.0,
                                            color:
                                                Colors.orange.shade900,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Expanded(
                                              child: Text(
                                                "Summarize your title",
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 0.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCheckCircle,
                                            size: 18.0,
                                            color:
                                            Colors.orange.shade900,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Expanded(
                                              child: Text(
                                                "Explain in your audio",
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80.0,
                            ),
                            Center(
                              child: OurFilledButton(
                                context: context,
                                text: "continue",
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RecordInteraction(
                                                  uid: userData.uid,
                                                  username: userData.name,
                                                  profileImg:
                                                      userData.profileImage,
                                                  interacTitle:
                                                      _interactionTitle,
                                                  bfId: widget.bfId,
                                                  bfTitle: widget.bfTitle),
                                        ));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
