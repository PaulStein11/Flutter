import 'package:bonfire_newbonfire/components/OurAlertDialog.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AuthProvider _auth;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Settings", style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: Builder(
          builder: (BuildContext context) {
            var _auth = Provider.of<AuthProvider>(context);
            return StreamBuilder<MyUserModel>(
              stream: StreamService.instance.getUserData(_auth.user.uid),
              builder: (context, snapshot) {
                var _userData = snapshot.data;
                if (!snapshot.hasData) {
                  return OurLoadingWidget(context);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    /*GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.palette_outlined,
                                size: 28.0,
                              color: Colors.grey.shade400,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                  "Change App Theme",
                                  style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15.0)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () async {
                        await showAlertDialog(
                            context,
                            title: 'Logout',
                            content: 'Are you sure that you want to logout?',
                            cancelActionText: 'Cancel',
                            defaultActionText: 'Logout',
                            onPressed: () {
                              return _auth.logoutUser(() {}, context);
                            }
                        );

                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app,
                              size: 28.0,
                              color: Theme.of(context).accentColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                  "LOG OUT",
                                  style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15.0)
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
