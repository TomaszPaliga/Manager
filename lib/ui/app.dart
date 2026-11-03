import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_view_model.dart';
import 'auth/login_screen.dart';
import 'home_shell.dart';

class ManagerApp extends StatelessWidget {
  const ManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 255, 42),
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

/// Shows the app to a logged-in user and the login screen to everyone else.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return switch (context.watch<AuthViewModel>().state) {
      AuthLoggedIn() => const HomeShell(),
      _ => const LoginScreen(),
    };
  }
}
