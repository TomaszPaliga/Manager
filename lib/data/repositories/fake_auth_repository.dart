import 'dart:math';

import '../../domain/exceptions.dart';
import '../../domain/models/app_user.dart';
import 'auth_repository.dart';
import 'fake_network.dart';

// Only accepts the demo account
// TODO Lab 3: real login
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    Duration delay = const Duration(milliseconds: 800),
    double failureRate = 0.0,
    Random? random,
  }) : _network = FakeNetwork(
         delay: delay,
         failureRate: failureRate,
         random: random,
       );

  static const demoUsername = 'demo';
  static const demoPassword = 'demo123';

  final FakeNetwork _network;

  @override
  Future<AppUser> login(String username, String password) async {
    await _network.simulateRequest();
    if (username != demoUsername || password != demoPassword) {
      throw const InvalidCredentialsException();
    }
    return const AppUser(
      id: 'user-1',
      username: demoUsername,
      displayName: 'Demo User',
    );
  }

  @override
  Future<void> logout() => _network.simulateRequest();
}
