import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FutureServices {
  static FutureServices instance = FutureServices();
  late FirebaseFirestore _firestore;

  FutureServices() {
    _firestore = FirebaseFirestore.instance;
  }

  // //COLLECTION NAMES
  String _users = "users";
  String _bonfires = "bonfires";
  String _interactions = "interactions";
  String _usersInteractions = "usersInteractions";
  String todayWeekday = DateFormat('EEEE').format(DateTime.now());

  Future<void> createUserInDB(String? _uid, String? _name, String? _email,
      String? profileImage, String? _bio, String _tokenId) async {
    try {
      return await _firestore.collection(_users).doc(_uid).set({
        "name": _name,
        "email": _email,
        "profileImage": profileImage,
        "tokenId": _tokenId,
        "bio": _bio,
        "bonfires": 0,
        "groups": false,
        "unseenCount": 0,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createBF(String? _uid,
      String? _username,
      String? _profileImg,
      String _bfId,
      String _title,
      String _bfDuration,
      String _audioDuration,
      DateTime _closure,

      String? _file,
      bool isAnonymous,) async {
    try {
      return await _firestore.collection(_bonfires).doc(_bfId).set({
        "ownerId": _uid,
        "ownerName": _username,
        "ownerImage": _profileImg,
        "isAnonymous": isAnonymous,
        "bfId": _bfId,
        "title": _title,
        "audience": 0,
        "duration": _bfDuration,
        "audioDuration": _audioDuration,
        "timestamp": DateTime.now(),
        "opening": DateTime.now(),
        "closure": _closure,
        "likes": {},
        "report": 0,
        "file": _file,
      }).then((value) =>
          _firestore.collection(_users).doc(_uid).update({
            //TODO: This could be set as a CLOUD FUNCTION
            "bonfires": FieldValue.increment(1),
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> createInteraction(String? _uid,
      String? _username,
      String? _profileImg,
      String _interacId,
      String _interacTitle,
      String _bfId,
      String _bfTitle,
      String? _file,
      String? _fileDuration) async {
    try {
      return await _firestore
          .collection(_interactions)
          .doc(_bfId)
          .collection(_usersInteractions)
          .doc(_interacId)
          .set({
        "ownerId": _uid,
        "ownerName": _username,
        "ownerImage": _profileImg,
        "bfId": _bfId,
        "bfTitle": _bfTitle,
        "interacId": _interacId,
        "interacTitle": _interacTitle,
        "audience": 0,
        "timestamp": DateTime.now(),
        "likes": {},
        "report": 0,
        "file": _file,
        "fileDuration": _fileDuration
      }).then((value) {
        _firestore.collection(_bonfires).doc(_bfId).update({
          "audience": FieldValue.increment(1),
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
