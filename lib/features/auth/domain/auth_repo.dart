// the operations of the app
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password);

  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<AppUser> fetchUserById(String userId);

}
