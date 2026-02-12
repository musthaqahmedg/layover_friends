import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String airportCode;
  final int layoverHours;
  final String intent;

  const HomeScreen({
    super.key,
    required this.airportCode,
    required this.layoverHours,
    required this.intent,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> sentRequests = {};

  List<Map<String, String>> getDummyPeople() {
    return [
      {
        'name': 'Ahmed',
        'role': 'Product Manager',
        'message': 'Happy to share my journey into tech.',
      },
      {
        'name': 'Sarah',
        'role': 'Startup Founder',
        'message': 'Love talking about ideas & business.',
      },
      {
        'name': 'Daniel',
        'role': 'Software Engineer',
        'message': 'Open to mentoring or career chats.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final people = getDummyPeople();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Layover Friends ✈️'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context
            Text(
              'You’re at ${widget.airportCode} · ${widget.layoverHours}h layover',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 6),

            // Presence count
            Text(
              '${people.length} people open to ${widget.intent.toLowerCase()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Intro text
            const Text(
              'These people are open to a friendly career chat. '
              'No pressure — say hi only if it feels right.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "I'm done for now",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // People list
            Expanded(
              child: ListView.builder(
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final person = people[index];
                  final name = person['name']!;
                  final alreadySent = sentRequests.contains(name);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        '$name — ${person['role']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(person['message']!),
                      trailing: alreadySent
                          ? const Text(
                              'Request sent',
                              style: TextStyle(color: Colors.grey),
                            )
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  sentRequests.add(name);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Request sent to $name'),
                                  ),
                                );
                              },
                              child: const Text('Say Hi 👋'),
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
