import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/posts/domain/repos/post_repo.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_states.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';
import 'package:social_media_app/features/storage/domain/storage_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo; // Add storage repo for uploading images
    final PostRepo postRepo;


  ProfileCubit({required this.profileRepo, required this.storageRepo,    required this.postRepo,
}) : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(Profileloading());
      final user = await profileRepo.fetchUserProfile(uid);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('Sorry , user not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
  Future<void> fetchUserPosts(String userId) async {
    
    try {
      emit(Profileloading());
      final posts = await postRepo.fetchPostsByUserId(userId);
      emit(ProfilePostsLoaded(posts));
    } catch (e) {
      emit(ProfileError('Failed to fetch posts: $e'));
    }
  }
  //return user profile for loading many profiles for posts

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? newProfileImagePath, // Add parameter for profile image path
  }) async {
    emit(Profileloading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError('Failed to fetch user'));
        return;
      }

      String? profileImageUrl;

      if (newProfileImagePath != null) {
        profileImageUrl = await storageRepo.uploadProfileMobile(newProfileImagePath, "$uid-profile");
        if (profileImageUrl == null) {
          emit(ProfileError('Failed to upload profile picture'));
          return;
        }
      }

      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
      );

      await profileRepo.updateProfile(updatedProfile);

      // Refetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
    }
  }

   Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      await profileRepo.toggleFollow(currentUserId, targetUserId);
    } catch (e) {
      emit(ProfileError('Error toggling follow :$e'));
    }
  }
}
