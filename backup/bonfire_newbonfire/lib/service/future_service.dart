import 'package:bonfire_newbonfire/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FutureService {
  static FutureService instance = FutureService();
  Firestore _db;

  FutureService() {
    _db = Firestore.instance;
  }

  String _userCollection = "Users";
  String _bfCollection = "Bonfire";
  String _interactionCollection = "Interactions";
  String _commentsCollection = "Message";
  String _conversationsCollection = "Conversations";

  Future<void> createBF(
    String _uid,
    String _ownerName,
    String _ownerImage,
    String _bfId,
    String _title,
    String _file,
    String _duration,
  ) async {
    try {
      return await _db.collection(_bfCollection).document(_bfId).setData({
        "ownerId": _uid,
        "ownerName": _ownerName,
        "ownerImage": _ownerImage,
        "bfId": _bfId,
        "title": _title,
        "audience": 0,
        "timestamp": DateTime.now(),
        "likes": {},
        "dislikes": {},
        "upgrades": {},
        "report": 0,
        "file": _file,
        "duration": _duration
      });
    } catch (e) {
      print(e);
    }

    await Firestore.instance.collection("Users").document(_uid).updateData(
      {
        "posts": FieldValue.increment(1),
      },
    );
  }

  Future<void> deleteBFInDB(String _bfId, _postId) async {
    try {
      return await _db.collection(_bfCollection).document(_bfId).get().then(
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

  Future<void> deleteInteractionInDB(String _bfId, _interactionId) async {
    try {
      return await _db
          .collection(_interactionCollection)
          .document(_bfId)
          .collection("usersInteraction")
          .document(_interactionId)
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

  Future<void> createUserInDB(String _uid, String _name, String _email,
      String _bio, String _profileImage, _tokenId) async {
    try {
      return await _db.collection(_userCollection).document(_uid).setData({
        "name": _name,
        "email": _email,
        "profileImage": _profileImage,
        "tokenId": _tokenId,
        "bio": _bio,
        "bonfires": 0,
        "interactions": 0,
        "unseenCount": 0,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createInteraction(
      String _duration,
      String _ownerId,
      String _ownerName,
      String _ownerImage,
      String _bfId,
      String _bfTitle,
      String _interactionId,
      String _interactionTitle,
      String _file) async {
    try {
      return await _db
          .collection(_interactionCollection)
          .document(_bfId)
          .collection("usersInteraction")
          .document(_interactionId)
          .setData(
        {
          "ownerId": _ownerId,
          "ownerName": _ownerName,
          "ownerImage": _ownerImage,
          "bfId": _bfId,
          "bfTitle": _bfTitle,
          "interactionId": _interactionId,
          "interactionTitle": _interactionTitle,
          "file": _file,
          "timestamp": Timestamp.now(),
          "duration": _duration,
          "likes": {},
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> createFeed(
    String mainUser,
    String _ownerId,
    String _ownerName,
    String _ownerImage,
    String _bfId,
    String _bfTitle,
    String _interactionId,
    String _interactionTitle,
  ) async {
    try {
      return await _db
        ..collection("Feed")
            .document(mainUser)
            .collection("FeedItems")
            .document(_bfId)
            .setData({
          "type": "like",
          "username": _ownerName,
          "userId": _ownerId,
          "userImg": _ownerImage,
          "bfId": _bfId,
          "bfTitle": _bfTitle,
          "interactionId": _interactionId,
          "interactionTitle": _interactionTitle,
          "timestamp": Timestamp.now(),
        });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFeed(String mainUser, String _bfId) async {
    try {
      return await _db
        ..collection("Feed")
            .document(mainUser)
            .collection("FeedItems")
            .document(_bfId)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        });
    } catch (e) {
      print(e);
    }
  }

  Future<void> feedCount(String _userId) async {
    try {
      return await _db.collection("Users").document(_userId).updateData({
        "unseenCount": FieldValue.increment(1),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> feedSeeCount(String _userId) async {
    try {
      return await _db.collection("Users").document(_userId).updateData({
        "unseenCount": 0,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addComment(String _uid, String _comntId, String _postId,
      String _name, String _comment, String postMediaUrl) async {
    try {
      return await _db
          .collection(_commentsCollection)
          .document(_postId)
          .collection("postMsg")
          .document(_comntId)
          .setData({
        "postId": _postId,
        "ownerId": _uid,
        "name": _name,
        "mediaUrl": postMediaUrl,
        "comment": _comment,
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createActivity(
    String _uid,
    String _ownerName,
    String _ownerImage,
    String _bfId,
    String _title,
  ) async {
    try {
      return await _db
          .collection("Activity")
          .document(_uid)
          .collection("usersActivity")
          .document(_bfId)
          .setData({
        "ownerId": _uid,
        "ownerName": _ownerName,
        "ownerImage": _ownerImage,
        "bfId": _bfId,
        "title": _title,
        "audience": 0,
        "timestamp": Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }

    await Firestore.instance.collection("Users").document(_uid).updateData(
      {
        "posts": FieldValue.increment(1),
      },
    );
  }

  Future<void> createOrGetConversartion(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID)) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .document(_currentID)
        .collection(_conversationsCollection);
    try {
      var conversation =
          await _userConversationRef.document(_recepientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data["conversationID"]);
      } else {
        var _conversationRef = _ref.document();
        await _conversationRef.setData(
          {
            "members": [_currentID, _recepientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.documentID);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref =
        _db.collection(_conversationsCollection).document(_conversationID);
    var _messageType = "";
    switch (_message.type) {
      case MessageType.Text:
        _messageType = "text";
        break;
      case MessageType.Image:
        _messageType = "image";
        break;
      default:
    }
    return _ref.updateData(
      {
        "messages": FieldValue.arrayUnion(
          [
            {
              "message": _message.content,
              "senderID": _message.senderID,
              "timestamp": _message.timestamp,
              "type": _messageType,
            },
          ],
        ),
      },
    );
  }
}
