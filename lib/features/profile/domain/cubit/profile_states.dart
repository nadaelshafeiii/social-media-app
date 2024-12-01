import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class Profileloading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser; // Corrected Typo
  ProfileLoaded(this.profileUser);
}

class ProfilePostsLoaded extends ProfileState {
  final List<Post> posts;

  ProfilePostsLoaded(this.posts);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
