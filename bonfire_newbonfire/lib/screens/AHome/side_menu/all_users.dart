import 'package:bonfire_newbonfire/model/post.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/db_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

AuthProvider _auth;

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  TextEditingController searchTextEditingController =
  new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: AuthProvider.instance,
      child: Builder(
        builder: (BuildContext context) {
          _auth = Provider.of<AuthProvider>(context);
          return DefaultTabController(
            length: 1,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  "Users",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 25.0),
                    child: TextFormField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade50,
                        hintText: "Search for a user...",
                        filled: true,
                        prefixIcon: Icon(
                          Icons.account_box,
                          size: 25.0,
                        ),
                      ),
                      onFieldSubmitted: (String query) {
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    child: StreamBuilder<List<User>>(
                      stream: DBService.instance.getUsersInDB(),
                      builder: (_context, _snapshot) {
                        var _usersData = _snapshot.data;

                        /*if (_usersData != null) {
                          _usersData.removeWhere((_contact) =>
                          _contact.uid == _auth.user.uid);
                        }*/
                        return _snapshot.hasData
                            ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 9.0),
                                child: Container(
                                  height: 500,
                                  child: GridView.builder(
                                      itemCount: _usersData.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),

                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        var _userData = _usersData[index];
                                        return Container(
                                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            decoration: BoxDecoration(
                                              color:
                                              Theme
                                                  .of(context)
                                                  .cardColor,
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0, bottom: 12.0),
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                      NetworkImage(_userData.profileImage),
                                                      radius: 30.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0,
                                                          top: 8.0),
                                                      child: Text(
                                                        _userData.name,
                                                        style: TextStyle(
                                                            color: Theme
                                                                .of(
                                                                context)
                                                                .primaryColor,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    RaisedButton(
                                                      onPressed: () {},
                                                      color: Theme
                                                          .of(context)
                                                          .accentColor,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              80)),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0),
                                                        child: Text(
                                                          "follow",
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "Palanquin",
                                                              fontSize: 15.0,
                                                              color:
                                                              Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            )
                                        );
                                      }
                                  ),
                                ),
                              ),
                            ],),)
                            : Center(
                          child: CircularProgressIndicator(
                            color: Theme
                                .of(context)
                                .accentColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

