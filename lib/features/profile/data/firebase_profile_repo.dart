import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo implements ProfileRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    // Corrected Typo
    try {
      //get user's data from firestore
      final userDoc =
          await firebaseFirestore.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          final followers = List<String>.from(userData['followers'] ?? []);
          final following = List<String>.from(userData['following'] ?? []);

          return ProfileUser(
            // Corrected Typo
            uid: uid,
            email: userData['email'],
            name: userData['name'],
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageUrl'].toString(),
            followers: followers,
            following: following,
          );
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    // Corrected Typo
    try {
      await firebaseFirestore
          .collection('Users')
          .doc(updatedProfile.uid)
          .update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleFollow(String currentUid, String targetUid) async {
    try {
      final currentUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();
      final targetUserDoc =
          await firebaseFirestore.collection('users').doc(currentUid).get();

      if (currentUserDoc.exists && currentUserDoc.exists) {
        final currentUserData = currentUserDoc.data();
        final targetUserData = targetUserDoc.data();

        if (currentUserData != null && targetUserData != null) {
          final List<String> currentFollowing =
              List<String>.from(currentUserData['following'] ?? []);

          if (currentFollowing.contains(targetUid)) {
            await firebaseFirestore.collection('users').doc(currentUid).update({'following':FieldValue.arrayRemove([targetUid])});
            await firebaseFirestore.collection('users').doc(currentUid).update({'followers':FieldValue.arrayRemove([currentUid])});

          }else{
            await firebaseFirestore.collection('users').doc(currentUid).update({'following':FieldValue.arrayRemove([targetUid])});
            await firebaseFirestore.collection('users').doc(currentUid).update({'followers':FieldValue.arrayRemove([currentUid])});


          }
        }
      }
    } catch (e) {}
  }
}
