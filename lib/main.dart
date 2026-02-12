import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';

void main() {
  runApp(const LayoverFriendsApp());
}

class LayoverFriendsApp extends StatelessWidget {
  const LayoverFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetupScreen(),
    );
  }
}
