import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/bonfire.dart';
import '../models/user.dart';

class StreamServices {
  static StreamServices instance = StreamServices();
  FirebaseFirestore? _db;

  StreamServices() {
    _db = FirebaseFirestore.instance;
  }

  String _userCollection = "users";
  String _bfCollection = "bonfires";



  Stream<MyUserModel> getUserData(String? _userID) {
    var _ref = _db?.collection(_userCollection).doc(_userID);
    return _ref!.get().asStream().map((_snapshot) {
      return MyUserModel.fromDocument(_snapshot);
    });
  }

  /*Stream<List<BF>> getBonfires(int limit) {
    var _ref = _db!.collection("bonfires").orderBy("timestamp", descending: true).limit(limit);
    return _ref.get().asStream().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return BF.fromDocument(_doc);
      }).toList();
    });
  }

  Stream<List<BF>> getBonfire(String _userID) {
    var _ref = _db!
        .collection(_bfCollection)
        /*.doc(_userID)
        .collection("userPosts")*/
        .orderBy("timestamp", descending: true);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.docs.map((_doc) {
        return BF.fromDocument(_doc);
      }).toList();
    });
  }*/

}