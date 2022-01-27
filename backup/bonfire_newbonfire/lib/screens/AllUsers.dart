import 'package:bonfire_newbonfire/components/AppUserProfile.dart';
import 'package:bonfire_newbonfire/components/OurLoadingWidget.dart';
import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/providers/auth.dart';
import 'package:bonfire_newbonfire/service/stream_service.dart';
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
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: _userTitle(),
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(60.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70, width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(60.0),
                        ),
                      ),
                      fillColor: Colors.transparent,
                      hintText: "Search",
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 15.0),
                      filled: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Icon(
                          Icons.search,
                          size: 25.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (String query) {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  child: StreamBuilder<List<MyUserModel>>(
                    stream: StreamService.instance.getUsersInDB(),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9.0),
                                    child: Container(
                                      height: 500,
                                      child: GridView.builder(
                                        itemCount: _usersData.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var _userData = _usersData[index];
                                          return Expanded(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).indicatorColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15.0, bottom: 8.0),
                                                child: Column(
                                                  children: [
                                                    AppUserProfile(
                                                        icon: Icons.person,
                                                        hasImage: _userData.profileImage.isEmpty
                                                            ? false
                                                            : true,
                                                        imageFile: _userData.profileImage,
                                                        onPressed: () {},
                                                        color: _userData.name[0] == "P" ? Colors.orangeAccent: Colors.blueAccent,
                                                        size: 30.0,
                                                        iconSize: 32.0),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 15.0,
                                                              top: 8.0),
                                                      child: Text(
                                                        _userData.name,
                                                        style: TextStyle(
                                                            color:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    _followButton()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : OurLoadingWidget(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _userTitle() {
    return Text(
      "Users",
      style: TextStyle(
          color: Colors.grey, fontSize: 18.0, fontWeight: FontWeight.normal),
    );
  }

  _followButton() {
    return RaisedButton(
      onPressed: () {},
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      child:  Text(
        "salute",
        style: TextStyle(
            fontFamily: "Palanquin", fontSize: 15.0, color: Colors.white),
      ),
    );
  }
}
