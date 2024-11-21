import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_states.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';
import 'package:social_media_app/features/profile/domain/repos/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

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

  //return user profile for loading many profiles for posts

  Future<ProfileUser?> getUserProfile(String uid) async {
    final user = await profileRepo.fetchUserProfile(uid);
    return user;
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
  }) async {
    emit(Profileloading());
    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError('Failed to fetch user'));
        return;
      }
      final updatedProfile =
          currentUser.copyWith(newBio: newBio ?? currentUser.bio);

      await profileRepo.updateProfile(updatedProfile);

      //refetch updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updatting profile$e'));
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
