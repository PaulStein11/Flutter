import 'package:flutter/material.dart';

class TermsOfPrivacyPage extends StatefulWidget {
  @override
  _TermsOfPrivacyPageState createState() => _TermsOfPrivacyPageState();
}

class _TermsOfPrivacyPageState extends State<TermsOfPrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.cancel, color: Colors.grey, size: 26.0,),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Privacy and Policy of Bonfire",
                        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20.0),
                      ),
                    )
                  ],
                ),
              ])
            ]))
          ],
        ));
  }
}
