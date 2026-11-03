import 'package:flutter/foundation.dart';

import '../../data/repositories/auth_repository.dart';
import '../../domain/exceptions.dart';
import '../../domain/models/app_user.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

final class AuthInProgress extends AuthState {
  const AuthInProgress();
}

final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn(this.user);

  final AppUser user;
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;
}

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  AuthState _state = const AuthLoggedOut();
  bool _disposed = false;

  AuthState get state => _state;

  Future<void> login(String username, String password) async {
    _setState(const AuthInProgress());
    try {
      final user = await _repository.login(username, password);
      _setState(AuthLoggedIn(user));
    } on InvalidCredentialsException {
      _setState(const AuthError('Wrong username or password.'));
    } catch (_) {
      _setState(const AuthError('Could not log in. Try again.'));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } catch (_) {
      // The local session ends even when the server cannot be reached.
    }
    _setState(const AuthLoggedOut());
  }

  void _setState(AuthState state) {
    _state = state;
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
