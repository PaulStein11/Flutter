import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final int bonfires;
  final int interactions;
  final String profileImage;

  final Timestamp lastSeen;

  MyUserModel({this.uid, this.name, this.email, this.profileImage, this.bio, this.bonfires, this.interactions, this.lastSeen});

  factory MyUserModel.fromDocument(DocumentSnapshot _snapshot) {
    var _data = _snapshot.data;
    return MyUserModel(
      uid: _snapshot.documentID,
      name: _data["name"],
      email: _data["email"],
      profileImage: _data["profileImage"],
      bio: _data["bio"],
      bonfires: _data["bonfires"],
      interactions: _data["interactions"],
      lastSeen: _data["lastSeen"],
    );
  }
}
