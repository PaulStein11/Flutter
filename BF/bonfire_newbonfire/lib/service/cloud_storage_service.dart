import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  //Variable declaration
  FirebaseStorage _storage;
  StorageReference _baseRef;
  String _profileImages = "profile_images";
  String _bfAudios = "bonfire_audios";
  String _interactionsAudio = "interaction_audios";


  CloudStorageService() {
    //Instantiate the services
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

  Future<StorageTaskSnapshot> uploadUserImage(String _uid, File _imageFile) {
    try {
      return _baseRef
          .child(_uid)
          .child(_profileImages)
          .putFile(_imageFile)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }

  Future<StorageTaskSnapshot> uploadBfAudio(String _bfTitle, File _bfAudio) {
    try {
      return _baseRef
          .child(_bfTitle)
          .child(_bfAudios)
          .putFile(_bfAudio)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }

  Future<StorageTaskSnapshot> uploadInteraction(
      String _interactionData, File _interAudio) {
    try {
      return _baseRef
          .child(_interactionData)
          .child(_interactionsAudio)
          .putFile(_interAudio)
          .onComplete;
    } catch (e) {
      print(e);
    }
  }
}
