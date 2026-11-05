// Wrong login or password, as opposed to a network problem
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();

  @override
  String toString() => 'InvalidCredentialsException';
}
