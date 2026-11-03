import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
const LoginScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
body: Padding(
padding: const EdgeInsets.all(30.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const SizedBox(height: 40), // 1. HEIGHT: Pushes the text further down the screen

const Center( // 2. CENTERING: Forces the text to the horizontal middle
child: Padding(
// 3. PADDING: Adds breathing room directly around the text
padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
child: Text(
'Welcome To Manager!',
// 4. TEXT ALIGN: Keeps text centered if it's too long and wraps to a second line
textAlign: TextAlign.center,
// 5. STYLING: Controls font size, weight, and color
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Color.fromARGB(255, 207, 0, 155),
),
),
),
),

const SizedBox(height: 50), // 1. HEIGHT: Adds space between the text and your text boxes
const TextField(
decoration: InputDecoration(hintText: 'Username'),
),
const SizedBox(height: 50),
const TextField(
obscureText: true, // Hides the password
decoration: InputDecoration(hintText: 'Password'),
),
const SizedBox(height: 50),
ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => const HomeScreen()),
);
},
child: const Text('Login'),
),
],
),
),
);
}
}