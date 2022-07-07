import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  String _profileImages = "profile_images";
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String _bfAudios = "bonfire_audios";
  final metadata = SettableMetadata(contentType: "audio/x-wav");

  Future<String?> uploadBF(String _uid, String _path, String _bfTitle) async {
    File file = File(_path);
    String? url;

    final uploadTask = storage.ref().child(_bfTitle)
        .child(_bfAudios).putFile(file, metadata);
    uploadTask.whenComplete(() async {

      url = await storage
          .ref('$_bfTitle/bonfire_audios')
          .getDownloadURL();
    });
    return url;
  }
  /*Future<firebase_storage.TaskSnapshot> uploadUserImage(String _uid, File _imageFile) {
    try {
      return storage.ref()
          .child(_uid)
          .child(_profileImages)
          .putFile(_imageFile);
    } catch (e) {
      print(e);
    }

  }*/
  Future<firebase_storage.ListResult> listFiles(String _uid) async {
    firebase_storage.ListResult results = await storage.ref('$_uid/$_bfAudios').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
      log('Found file: $ref');

    });
    return results;
  }

  /*Future<String> downloadURL(String _uid) async {
    String downloadURL = await storage.ref().child(_uid).child(_bfAudios).getDownloadURL();
    log('URL => $downloadURL');
    return downloadURL;
  }*/
}
