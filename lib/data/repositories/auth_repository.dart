import '../../domain/models/app_user.dart';

abstract interface class AuthRepository {
  // Throws InvalidCredentialsException if the login or password is wrong
  Future<AppUser> login(String username, String password);

  Future<void> logout();
}
