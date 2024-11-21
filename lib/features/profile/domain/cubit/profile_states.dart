import 'package:social_media_app/features/profile/domain/profie_user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class Profileloading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser; // Corrected Typo
  ProfileLoaded(this.profileUser);
}


class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
