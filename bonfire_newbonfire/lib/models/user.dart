// @dart=2.9


import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final int bonfires;
  final bool groups;
  final String profileImage;
  final String tokenId;
  final int unseenCount;
  final Timestamp lastSeen;

  MyUserModel({this.uid, this.name, this.email, this.profileImage, this.tokenId, this.bio, this.bonfires, this.groups, this.unseenCount, this.lastSeen});

  factory MyUserModel.fromDocument(DocumentSnapshot snapshot) {
    //Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
    return MyUserModel(
      uid: snapshot.id,
      name: snapshot["name"],
      email: snapshot["email"],
      profileImage: snapshot["profileImage"],
      tokenId: snapshot["tokenId"],
      bio: snapshot["bio"],
      bonfires: snapshot["bonfires"],
      groups: snapshot["groups"],
      unseenCount: snapshot["unseenCount"],
      lastSeen: snapshot["lastSeen"],
    );
  }
}
