import 'dart:math';

class FakeNetworkException implements Exception {
  const FakeNetworkException();

  @override
  String toString() => 'FakeNetworkException: simulated failure';
}

// Pretends to be a slow, unreliable server, all the fake repositories use it
// failureRate: 0.0 never fails, 1.0 always fails
class FakeNetwork {
  FakeNetwork({
    this.delay = const Duration(milliseconds: 800),
    this.failureRate = 0.0,
    Random? random,
  }) : assert(failureRate >= 0.0 && failureRate <= 1.0),
       _random = random ?? Random();

  final Duration delay;
  final double failureRate;
  final Random _random;

  Future<void> simulateRequest() async {
    await Future<void>.delayed(delay);
    // nextDouble() gives 0.0 to 1.0, so 0.2 fails about 1 in 5 requests
    if (_random.nextDouble() < failureRate) {
      throw const FakeNetworkException();
    }
  }
}
