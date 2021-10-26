import 'package:bonfire_newbonfire/model/bonfire.dart';
import 'package:bonfire_newbonfire/model/comment.dart';
import 'package:bonfire_newbonfire/model/notifications.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class DBService {
  static DBService instance = DBService();
  Firestore _db;

  DBService() {
    _db = Firestore.instance;
  }

  String _userCollection = "Users";
  String _postsCollection = "Posts";
  String _commentsCollection = "Message";
  String _feedItemsCollection = "FeedItems";







  Future<void> createBonfire(
      String bonfire, String bf_Id, String _subCollection, String uid) async {
    return await _db
        .collection(bonfire)
        .document(bf_Id)
        .collection(_subCollection)
        .document(uid)
        .setData({});
  }

  Stream<List<User>> getUsersInDB() {
    var _ref = _db.collection("Users");
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return User.fromDocument(_doc);
      }).toList();
    });
  }

  Stream<List<Post>> getPostsInDB(String _uid) {
    var _ref = _db.collection("Posts").document(_uid).collection("userPosts");
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Post.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<NotificationItem>> getNotificationsItem(String _userID) {
    var _ref = _db
        .collection(_feedItemsCollection)
        .document(_userID)
        .collection("feedItems")
        .orderBy("timestamp", descending: true);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return NotificationItem.fromDocument(_doc);
      }).toList();
    });
  }

  Stream<User> isUserInTech(String _userID) {
    var _ref = _db.collection("FollowingTech").document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return User.fromDocument(_snapshot);
    });
  }

  Stream<List<Post>> getMyPosts(String _userID) {
    var _ref = _db
        .collection(_postsCollection)
        .document(_userID)
        .collection("userPosts")
        .orderBy("timestamp", descending: true);
    return _ref.snapshots.map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Post.fromFirestore(_doc);
      }).toList();
    });
  }



  /*Future<void> createQuestion(String _uid, String _name, String _image,
      String _question, String _questionId) async {
    try {
      return await _db
          .collection(_questionCollection)
          .document(_uid)
          .collection("userQuestion")
          .document(_questionId)
          .setData({
        "ownerId": _uid,
        "questionId": _questionId,
        "name": _name,
        "image": _image,
        "question": _question,
        "timestamp": Timestamp.now(),
        "upgrade": {},
      });
    } catch (e) {
      print(e);
    }
  }*/

  Stream<User> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return User.fromDocument(_snapshot);
    });
  }

  Stream<List<Comment>> getComments(String _postID) {
    var _ref = _db
        .collection(_commentsCollection)
        .document(_postID)
        .collection("postMsg")
        .orderBy("timestamp", descending: false);
    return _ref.snapshots.map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Comment.fromFirestore(_doc);
      }).toList();
    });
  }

  //Get BONFIRE Categories Timelines
  //1) TECH
  Stream<List<Post>> getTechTimeline() {
    var _ref = _db
        .collection("TimelineTech")
        .document("time_tech")
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .limit(10);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Post.fromFirestore(_doc);
      }).toList();
    });
  }

  //2) NATURE
  Stream<List<Post>> getNatureTimeline() {
    var _ref = _db
        .collection("TimelineNat")
        .document("time_nature")
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .limit(10);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Post.fromFirestore(_doc);
      }).toList();
    });
  }

  //3) HEALTH
  Stream<List<Post>> getHealthTimeline() {
    var _ref = _db
        .collection("TimelineHealth")
        .document("time_health")
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .limit(10);
    return _ref.getDocuments().asStream().map(
      (_snapshot) {
        return _snapshot.documents.map(
          (_doc) {
            return Post.fromFirestore(_doc);
          },
        ).toList();
      },
    );
  }
}
