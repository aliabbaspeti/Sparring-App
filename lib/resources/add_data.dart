import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class Storedata {
  Future<String> uploadImageToStorage(String childname, Uint8List file) async {
    Reference ref = _storage.ref().child(childname);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required Uint8List file,
  }) async {
    String resp = "Some Error Occurred";
    try {
      String imageUrl = await uploadImageToStorage('ProfileImage', file);
      resp = imageUrl;
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
