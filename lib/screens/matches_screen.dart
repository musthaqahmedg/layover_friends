import 'request_success.dart';
import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  final String airport;
  final String hours;

  const MatchesScreen({super.key, required this.airport, required this.hours});

  @override
  Widget build(BuildContext context) {
    final matches = [
      {
        "name": "Arjun",
        "country": "India",
        "layover": "3 hours",
        "interest": "Coffee + Chat",
      },
      {
        "name": "Sarah",
        "country": "UK",
        "layover": "4 hours",
        "interest": "Explore Airport",
      },
      {
        "name": "Ahmed",
        "country": "UAE",
        "layover": "2 hours",
        "interest": "Food + Relax",
      },
      {
        "name": "Maria",
        "country": "Spain",
        "layover": "5 hours",
        "interest": "Shopping",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Your Matches")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Airport: $airport",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Your layover: $hours hours",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text(
              "Matching people near you ✅",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final m = matches[index];

                  return Card(
                    child: ListTile(
                      title: Text("${m["name"]} • ${m["country"]}"),
                      subtitle: Text(
                        "Layover: ${m["layover"]}\nInterest: ${m["interest"]}",
                      ),
                      isThreeLine: true,
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestSuccessScreen(
                                name: (m["name"] ?? "User").toString(),
                              ),
                            ),
                          );
                        },

                        child: const Text("Connect"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
