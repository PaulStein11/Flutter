import 'package:bonfire_newbonfire/model/activity.dart';
import 'package:bonfire_newbonfire/model/conversation.dart';
import 'package:bonfire_newbonfire/model/interaction.dart';
import 'package:bonfire_newbonfire/model/comment.dart';
import 'package:bonfire_newbonfire/model/message.dart';
import 'package:bonfire_newbonfire/model/notifications.dart';
import 'package:bonfire_newbonfire/model/user.dart';
import 'package:bonfire_newbonfire/model/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../notifications.dart';
import 'navigation_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class StreamService {
  static StreamService instance = StreamService();
  Firestore _db;

  StreamService() {
    _db = Firestore.instance;
  }

  String _userCollection = "Users";
  String _bfCollection = "Bonfire";
  String _conversationsCollection = "Conversations";
  String _commentsCollection = "Message";
  String _feedItemsCollection = "FeedItems";

  Stream<List<MyUserModel>> getUsersInDB() {
    var _ref = _db.collection("Users");
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return MyUserModel.fromDocument(_doc);
      }).toList();
    });
  }

  Stream<List<Interaction>> getInteractions(String _bfId) {
    var _ref = _db
        .collection("Interactions")
        .document(_bfId)
        .collection("usersInteraction")
        .orderBy("likes", descending: true);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Interaction.fromDocument(_doc);
      }).toList();
    });
  }

  Stream<BF> getBonfire(String _bfId) {
    var _ref = _db.collection("Bonfire").document(_bfId);
    return _ref.get().asStream().map((_snapshot) {
      return BF.fromFirestore(_snapshot);
    });
  }

  Stream<List<BF>> getBonfires(int limit) {
    var _ref = _db.collection("Bonfire").orderBy("timestamp", descending: true).limit(limit);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return BF.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<BF>> getActivities() {
    var _ref =
        _db.collection("Activity").orderBy("timestamp", descending: true);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return BF.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<Activity>> getActivity(String _userId) {
    var _ref = _db
        .collection("Activity")
        .document(_userId)
        .collection("usersActivity")
        .orderBy("timestamp", descending: true);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Activity.fromFirestore(_doc);
      }).toList();
    });
  }

  /* Stream<List<BF>> getInteraction(String _interactionId) {
    var _ref = _db.collection("FollowingTech").document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return UserModel.fromDocument(_snapshot);
    });
  }*/

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

  Stream<MyUserModel> isUserInTech(String _userID) {
    var _ref = _db.collection("FollowingTech").document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return MyUserModel.fromDocument(_snapshot);
    });
  }

  Stream<List<BF>> getMyPosts(String _userID) {
    var _ref = _db
        .collection(_bfCollection)
        .document(_userID)
        .collection("userPosts")
        .orderBy("timestamp", descending: true);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return BF.fromFirestore(_doc);
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

  Stream<MyUserModel> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return MyUserModel.fromDocument(_snapshot);
    });
  }

  Stream<BF> getBFAudience(String _userID) {
    var _ref = _db.collection(_bfCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return BF.fromFirestore(_snapshot);
    });
  }

  Stream<BF> getMyActivity(String _userID) {
    var _ref = _db.collection(_bfCollection).document(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return BF.fromFirestore(_snapshot);
    });
  }

  Stream<List<Comment>> getComments(String _postID) {
    var _ref = _db
        .collection(_commentsCollection)
        .document(_postID)
        .collection("postMsg")
        .orderBy("timestamp", descending: false);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return Comment.fromFirestore(_doc);
      }).toList();
    });
  }

  //Get BONFIRE Categories Timelines
  //1) TECH
  Stream<List<BF>> getTechTimeline() {
    var _ref = _db
        .collection("TimelineTech")
        .document("time_tech")
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .limit(10);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return BF.fromFirestore(_doc);
      }).toList();
    });
  }

  //2) NATURE
  Stream<List<BF>> getNatureTimeline() {
    var _ref = _db
        .collection("TimelineNat")
        .document("time_nature")
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .limit(10);
    return _ref.getDocuments().asStream().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return BF.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<List<ConversationSnippet>> getUserConversations(String _userID) {
    var _ref = _db
        .collection(_userCollection)
        .document(_userID)
        .collection(_conversationsCollection);
    return _ref.snapshots().map((_snapshot) {
      return _snapshot.documents.map((_doc) {
        return ConversationSnippet.fromFirestore(_doc);
      }).toList();
    });
  }

  Stream<Conversation> getConversation(String _conversationID) {
    var _ref =
        _db.collection(_conversationsCollection).document(_conversationID);
    return _ref.snapshots().map(
      (_doc) {
        return Conversation.fromFirestore(_doc);
      },
    );
  }

  //3) HEALTH
  Stream<List<BF>> getHealthTimeline() {
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
            return BF.fromFirestore(_doc);
          },
        ).toList();
      },
    );
  }
}
