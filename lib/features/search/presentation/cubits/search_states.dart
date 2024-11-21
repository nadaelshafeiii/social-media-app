import 'package:social_media_app/features/profile/domain/profie_user.dart';

abstract class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<ProfileUser?> users;
  SearchLoaded(this.users);
}

class SearchError extends SearchStates {
  final String message;
  SearchError(this.message);
}
