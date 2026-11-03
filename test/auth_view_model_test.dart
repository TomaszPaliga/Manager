import 'package:flutter_test/flutter_test.dart';
import 'package:manager/ui/auth/auth_view_model.dart';

import 'support/stub_repositories.dart';

void main() {
  test('starts logged out', () {
    final vm = AuthViewModel(StubAuthRepository());

    expect(vm.state, isA<AuthLoggedOut>());
  });

  test('login() with correct credentials logs the user in', () async {
    final vm = AuthViewModel(StubAuthRepository());

    await vm.login('demo', 'correct');

    final state = vm.state;
    expect(state, isA<AuthLoggedIn>());
    expect((state as AuthLoggedIn).user, StubAuthRepository.user);
  });

  test('login() with a wrong password reports wrong credentials', () async {
    final vm = AuthViewModel(StubAuthRepository());

    await vm.login('demo', 'wrong');

    final state = vm.state;
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Wrong username or password.');
  });

  test('login() reports a network failure separately', () async {
    final vm = AuthViewModel(StubAuthRepository(failNetwork: true));

    await vm.login('demo', 'correct');

    final state = vm.state;
    expect(state, isA<AuthError>());
    expect((state as AuthError).message, 'Could not log in. Try again.');
  });

  test('logout() returns to the logged-out state', () async {
    final repository = StubAuthRepository();
    final vm = AuthViewModel(repository);
    await vm.login('demo', 'correct');

    await vm.logout();

    expect(vm.state, isA<AuthLoggedOut>());
    expect(repository.logoutCalls, 1);
  });
}
