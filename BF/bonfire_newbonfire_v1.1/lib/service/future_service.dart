import 'package:bonfire_newbonfire/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FutureService {
  static FutureService instance = FutureService();
  FirebaseFirestore _db;

  FutureService() {
    _db = FirebaseFirestore.instance;
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
      return await _db.collection(_bfCollection).doc(_bfId).set({
        "ownerId": _uid,
        "ownerName": _ownerName,
        "ownerImage": _ownerImage,
        "bfId": _bfId,
        "title": _title,
        "audience": 0,
        "timestamp": Timestamp.now(),
        "likes": {},
        "dislikes": {},
        "upgrades": {},
        "file": _file,
        "duration": _duration
      });
    } catch (e) {
      print(e);
    }

    await FirebaseFirestore.instance.collection("Users").doc(_uid).update(
      {
        "posts": FieldValue.increment(1),
      },
    );
  }

  Future<void> deleteBFInDB(String _bfId, _postId) async {
    try {
      return await _db.collection(_bfCollection).doc(_bfId).get().then(
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
          .doc(_bfId)
          .collection("usersInteraction")
          .doc(_interactionId)
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
      String _bio, String _profileImage) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).set({
        "name": _name,
        "email": _email,
        "profileImage": _profileImage,
        "bio": _bio,
        "bonfires": 0,
        "interactions": 0,
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
          .doc(_bfId)
          .collection("usersInteraction")
          .doc(_interactionId)
          .set(
        {
          "ownerId": _ownerId,
          "ownerName": _ownerName,
          "ownerImage": _ownerImage,
          "bfId": _bfId,
          "bfTitle": _bfTitle,
          "interactionId": _interactionId,
          "interactionTitle": '#$_interactionTitle',
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

  Future<void> addComment(String _uid, String _comntId, String _postId,
      String _name, String _comment, String postMediaUrl) async {
    try {
      return await _db
          .collection(_commentsCollection)
          .doc(_postId)
          .collection("postMsg")
          .doc(_comntId)
          .set({
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
          .doc(_uid)
          .collection("usersActivity")
          .doc(_bfId)
          .set({
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

    await FirebaseFirestore.instance.collection("Users").doc(_uid).update(
      {
        "posts": FieldValue.increment(1),
      },
    );
  }

  /*Future<void> createOrGetConversartion(String _currentID, String _recepientID,
      Future<void> _onSuccess(String _conversationID)) async {
    var _ref = _db.collection(_conversationsCollection);
    var _userConversationRef = _db
        .collection(_userCollection)
        .doc(_currentID)
        .collection(_conversationsCollection);
    try {
      var conversation =
          await _userConversationRef.doc(_recepientID).get();
      if (conversation.data != null) {
        return _onSuccess(conversation.data["conversationID"]);
      } else {
        var _conversationRef = _ref.doc();
        await _conversationRef.set(
          {
            "members": [_currentID, _recepientID],
            "ownerID": _currentID,
            'messages': [],
          },
        );
        return _onSuccess(_conversationRef.id);
      }
    } catch (e) {
      print(e);
    }
  }*/

  Future<void> sendMessage(String _conversationID, Message _message) {
    var _ref =
        _db.collection(_conversationsCollection).doc(_conversationID);
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
    return _ref.update(
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
