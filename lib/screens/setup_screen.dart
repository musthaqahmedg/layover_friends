import 'package:flutter/material.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _layoverController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  // 🌍 Selected airport
  String? selectedAirport;

  // 🌍 Global-feeling airport list (sample for now)
  final List<String> airports = [
    'DXB – Dubai',
    'MCT – Muscat',
    'DOH – Doha',
    'DEL – Delhi',
    'BOM – Mumbai',
    'LHR – London Heathrow',
    'JFK – New York',
    'SIN – Singapore',
    'CDG – Paris',
    'FRA – Frankfurt',
  ];

  Future<void> _submit() async {
    final hours = int.tryParse(_layoverController.text.trim());

    setState(() {
      errorMessage = null;
    });

    if (selectedAirport == null) {
      setState(() {
        errorMessage = '❌ Please select an airport';
      });
      return;
    }

    if (hours == null || hours <= 0) {
      setState(() {
        errorMessage = '❌ Layover hours must be greater than 0';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          airportCode: selectedAirport!,
          layoverHours: hours,
          intent: 'Career / Opportunity',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _layoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layover Friends ✈️'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Find your opportunity during a layover',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Search your airport and see who is open to connect',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // 🌍 Airport Autocomplete
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return airports.where(
                  (airport) => airport.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              onSelected: (String selection) {
                setState(() {
                  selectedAirport = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, _) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.flight_takeoff),
                    labelText: 'Search Airport',
                    hintText: 'Type DXB, MCT, LHR...',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _layoverController,
              keyboardType: TextInputType.number,
              enabled: !isLoading,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.timer),
                labelText: 'Layover Hours',
                hintText: 'e.g. 3',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (errorMessage != null)
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Continue', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
