import 'package:cloud_firestore/cloud_firestore.dart';

class DBFuture {
  static DBFuture instance = DBFuture();
  Firestore _db;

  DBFuture() {
    _db = Firestore.instance;
  }

  String _userCollection = "Users";
  String _postsCollection = "Posts";
  String _commentsCollection = "Message";

  Future<void> postInBF(
      String _uid,
      String _postId,
      String _title,
      ) async {
    try {
      return await _db
          .collection(_postsCollection)
          .document(_uid)
          .collection("userPosts")
          .document(_postId)
          .setData({
        "postId": _postId,
        "ownerId": _uid,
        "title": _title,
        "audience": 0,
        "timestamp": DateTime.now(),
        "likes": {},
        "dislikes": {},
        "upgrades": {},
      });
    } catch (e) {
      print(e);
    }

  }

  Future<void> deletePostInDB(String _uid, _postId) async {
    try {
      return await _db
          .collection(_postsCollection)
          .document(_uid)
          .getCollection("userPosts")
          .document(_postId)
          .get()
          .then(
            (doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUserInDB(
      String _uid, String _name, String _email, String _bio, String _profileImage) async {
    try {
      return await _db.collection(_userCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
        "profileImage": "",
        "bio": _bio,
        "bonfires": 0,
        "posts": 0,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> addComment(String _uid, String _comntId, String _postId,
      String _name, String _comment, String postMediaUrl) async {
    try {
      return await _db
          .collection(_commentsCollection)
          .document(_postId)
          .getCollection("postMsg")
          .document(_comntId)
          .setData({
        "postId": _postId,
        "ownerId": _uid,
        "name": _name,
        "mediaUrl": postMediaUrl,
        "comment": _comment,
        "timestamp": DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

}