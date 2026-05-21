import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  List<Map<String, dynamic>> people = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('airport_code', widget.airportCode)
          .eq('is_active', true);

      setState(() {
        people = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layover Friends ✈️'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You\'re at ${widget.airportCode} · ${widget.layoverHours}h layover',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '${people.length} people open to ${widget.intent.toLowerCase()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : people.isEmpty
                ? const Center(child: Text('No one here yet. Be the first! 🚀'))
                : Expanded(
                    child: ListView.builder(
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        final person = people[index];
                        final name = person['full_name'] ?? 'Traveler';
                        final role = person['role'] ?? 'Explorer';
                        final bio = person['bio'] ?? 'Open to connecting!';
                        final alreadySent = sentRequests.contains(name);

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      child: Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '$name — $role',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(bio, style: const TextStyle(fontSize: 13)),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: alreadySent
                                      ? const Text(
                                          'Request sent',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            setState(() {
                                              sentRequests.add(name);
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Request sent to $name',
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Say Hi 👋'),
                                        ),
                                ),
                              ],
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
