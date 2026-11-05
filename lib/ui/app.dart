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
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 255, 42),
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

// Login screen or the app, depending on whether someone is logged in
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
