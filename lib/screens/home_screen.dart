import 'package:flutter/material.dart';
import 'setup_screen.dart';

class LayoverSetupScreen extends StatelessWidget {
  const LayoverSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layover Friends')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SetupScreen()),
            );
          },
          child: const Text('Start'),
        ),
      ),
    );
  }
}
