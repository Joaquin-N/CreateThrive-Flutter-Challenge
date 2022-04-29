import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  final folderRef = FirebaseStorage.instance.ref('items_imgs/');

  Future<String> uploadImage(String filePath, String docId) async {
    File file = File(filePath);
    String ext = path.extension(filePath);
    var ref = folderRef.child('$docId$ext');

    try {
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future deleteImage(String url) async {
    try {
      var ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (e) {}
  }
}
