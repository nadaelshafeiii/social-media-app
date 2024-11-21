import 'package:social_media_app/features/profile/domain/profie_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);
}
