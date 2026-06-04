import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
  final String _apiKey = '33153162b8002a959ce1f527b3a64f13';

  String _selectedAirport = 'DXB';
  String _selectedType = 'departure';
  List<dynamic> _flights = [];
  bool _isLoading = false;
  String? _error;

  final List<Map<String, String>> _popularAirports = [
    {'code': 'DXB', 'name': 'Dubai'},
    {'code': 'LHR', 'name': 'London'},
    {'code': 'JFK', 'name': 'New York'},
    {'code': 'SIN', 'name': 'Singapore'},
    {'code': 'BOM', 'name': 'Mumbai'},
    {'code': 'DEL', 'name': 'Delhi'},
    {'code': 'KUL', 'name': 'Kuala Lumpur'},
    {'code': 'DOH', 'name': 'Doha'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _flights = [];
    });

    try {
      final param = _selectedType == 'departure'
          ? 'dep_iata=$_selectedAirport'
          : 'arr_iata=$_selectedAirport';

      final url =
          'http://api.aviationstack.com/v1/flights?access_key=$_apiKey&$param&limit=20';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['data'] != null) {
        setState(() {
          _flights = data['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'No flights found.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching flights. Check your connection.';
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'landed':
        return const Color(0xFF00BFA5);
      case 'delayed':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Flights ✈️'),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Airport',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _popularAirports.map((airport) {
                      final isSelected = _selectedAirport == airport['code'];
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAirport = airport['code']!);
                          _fetchFlights();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF00BFA5)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                airport['code']!,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                airport['name']!,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black87
                                      : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedType = 'departure');
                          _fetchFlights();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedType == 'departure'
                                ? const Color(0xFF00BFA5)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flight_takeoff,
                                color: _selectedType == 'departure'
                                    ? Colors.black
                                    : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Departures',
                                style: TextStyle(
                                  color: _selectedType == 'departure'
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedType = 'arrival');
                          _fetchFlights();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedType == 'arrival'
                                ? const Color(0xFF00BFA5)
                                : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.flight_land,
                                color: _selectedType == 'arrival'
                                    ? Colors.black
                                    : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Arrivals',
                                style: TextStyle(
                                  color: _selectedType == 'arrival'
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00BFA5)),
                  )
                : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _flights.length,
                    itemBuilder: (context, index) {
                      final flight = _flights[index];
                      final status = flight['flight_status'] ?? 'unknown';
                      final flightNum = flight['flight']?['iata'] ?? 'N/A';
                      final airline = flight['airline']?['name'] ?? 'Unknown';
                      final depTime =
                          flight['departure']?['scheduled']
                              ?.toString()
                              .substring(11, 16) ??
                          'N/A';
                      final arrTime =
                          flight['arrival']?['scheduled']?.toString().substring(
                            11,
                            16,
                          ) ??
                          'N/A';
                      final depAirport = flight['departure']?['iata'] ?? 'N/A';
                      final arrAirport = flight['arrival']?['iata'] ?? 'N/A';
                      final delay = flight['departure']?['delay'] ?? 0;

                      return Card(
                        color: const Color(0xFF1E1E1E),
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    flightNum,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        status,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(
                                        color: _getStatusColor(status),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  airline,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          depAirport,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          depTime,
                                          style: const TextStyle(
                                            color: Color(0xFF00BFA5),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    '✈️',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          arrAirport,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          arrTime,
                                          style: const TextStyle(
                                            color: Color(0xFF00BFA5),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (delay != null && delay > 0) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '⚠️ Delayed by $delay minutes',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
