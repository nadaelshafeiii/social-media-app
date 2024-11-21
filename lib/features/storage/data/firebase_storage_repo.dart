import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  
  @override
  Future<String?> uploadProfileMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);

      final storageRef = storage.ref().child('$folder/$fileName');

      final UploadTask = await storageRef.putFile(file);

      final downloadUrl = await UploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }


  @override
  Future<String?> uploadPostMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");

  }

  

}
