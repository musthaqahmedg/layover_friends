import 'package:flutter/material.dart';
import 'summary_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController airportController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  @override
  void dispose() {
    airportController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup your layover')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Layover details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: airportController,
              decoration: const InputDecoration(
                labelText: 'Airport (e.g. DXB)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Layover duration (hours)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                final airport = airportController.text.trim();
                final hoursText = hoursController.text.trim();

                // ✅ Validation 1: Airport empty
                if (airport.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter Airport (ex: DXB)"),
                    ),
                  );
                  return;
                }

                // ✅ Validation 2: Hours empty
                if (hoursText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter Layover Hours")),
                  );
                  return;
                }

                // ✅ Validation 3: Hours must be number
                final hoursNumber = int.tryParse(hoursText);
                if (hoursNumber == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Layover Hours must be a number (ex: 5)"),
                    ),
                  );
                  return;
                }

                // ✅ Validation 4: Hours must be > 0
                if (hoursNumber <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Layover Hours must be greater than 0"),
                    ),
                  );
                  return;
                }

                // ✅ Navigate to Summary Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SummaryScreen(airport: airport, hours: hoursText),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
