import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  //Variable declaration
  FirebaseStorage _storage;
  StorageReference _baseRef;
  String _profileImages = "profile_images";
  String _usersAudio = "users_audio";


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

    } catch(e) {
      print(e);
    }
  }

  Future<StorageTaskSnapshot> uploadAudio(String _uid, File _audioFile) {
    try {
      return _baseRef
          .child(_uid)
          .child(_usersAudio)
          .putFile(_audioFile)
          .onComplete;

    } catch(e) {
      print(e);
    }
  }
}
