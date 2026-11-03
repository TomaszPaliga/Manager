import '../../domain/models/app_user.dart';

/// Logs the user in and out.
abstract interface class AuthRepository {
  /// Returns the logged-in user. Throws InvalidCredentialsException when the
  /// username or password is wrong.
  Future<AppUser> login(String username, String password);

  Future<void> logout();
}
