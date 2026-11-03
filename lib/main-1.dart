import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const Manager());
}

class Manager extends StatelessWidget {
  const Manager({super.key});

  // This widget is the root of your application.
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
      home: const LoginScreen(),
    );
  }
}
