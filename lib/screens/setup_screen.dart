import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../data/airports.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  List<Airport> _airports = [];
  final TextEditingController _layoverController = TextEditingController();

  String? selectedAirport;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    final loaded = await loadAirports();
    setState(() {
      _airports = loaded;
    });
  }

  Future<void> _submit() async {
    final hours = int.tryParse(_layoverController.text.trim());

    if (selectedAirport == null) {
      setState(() => errorMessage = "Please select an airport");
      return;
    }

    if (hours == null || hours <= 0) {
      setState(() => errorMessage = "Enter valid layover hours");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          airportCode: selectedAirport!,
          layoverHours: hours,
          intent: "Career / Opportunity",
        ),
      ),
    );
  }

  String _flagFromCountryCode(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) =>
          String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_airports.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Layover Friends ✈️"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Autocomplete<Airport>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                final query = textEditingValue.text.toLowerCase();

                if (query.isEmpty) {
                  return _airports;
                }

                return _airports.where((airport) {
                  return airport.code.toLowerCase().contains(query) ||
                      airport.city.toLowerCase().contains(query) ||
                      airport.country.toLowerCase().contains(query) ||
                      airport.countryCode.toLowerCase().contains(query);
                });
              },
              displayStringForOption: (Airport option) =>
                  "${option.code} - ${option.city}",
              onSelected: (Airport selection) {
                selectedAirport = selection.code;
              },
              fieldViewBuilder:
                  (context, controller, focusNode, _) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: "Search Airport",
                    hintText: "Type city, country or code...",
                    border: OutlineInputBorder(),
                  ),
                );
              },
              optionsViewBuilder:
                  (context, onSelected, Iterable<Airport> options) {
                return Material(
                  elevation: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final airport = options.elementAt(index);
                      return ListTile(
                        leading: Text(
                          _flagFromCountryCode(airport.countryCode),
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(
                          "${airport.code} - ${airport.city}, ${airport.country}",
                        ),
                        onTap: () => onSelected(airport),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _layoverController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Layover Hours",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
