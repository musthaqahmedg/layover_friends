import 'package:flutter/material.dart';
import 'matches_screen.dart';

class SummaryScreen extends StatelessWidget {
  final String airport;
  final String hours;

  const SummaryScreen({super.key, required this.airport, required this.hours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Layover Details ✅",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text("Airport: $airport", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Layover Hours: $hours", style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MatchesScreen(airport: airport, hours: hours),
                        ),
                      );
                    },
                    child: const Text("View Matches"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
