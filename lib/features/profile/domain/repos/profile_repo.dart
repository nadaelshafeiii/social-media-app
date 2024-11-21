import 'package:social_media_app/features/profile/domain/profie_user.dart';

abstract class ProfileRepo {
  Future<ProfileUser?> fetchUserProfile(String uid);

  Future<void> updateProfile(ProfileUser updatedProfile);

  Future<void> toggleFollow(String currentUid , String targetUid);
  
}
