import 'package:flutter/material.dart';

void main() {
  runApp(const LayoverFriendsApp());
}

class LayoverFriendsApp extends StatelessWidget {
  const LayoverFriendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layover Friends',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const SetupScreen(),
    );
  }
}

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airport Layover Friends')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your layover details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Airport Code (e.g. DXB)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Layover Duration (hours)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finding layover friends...')),
                );
              },
              child: const Text('Find Layover Friends'),
            ),
          ],
        ),
      ),
    );
  }
}
