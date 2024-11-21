
abstract class StorageRepo {
  Future<String?> uploadProfileMobile(String path, String fileName);

  // Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

    Future<String?> uploadPostMobile(String path, String fileName);

  // Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
