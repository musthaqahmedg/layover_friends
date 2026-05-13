import 'dart:convert';
import 'package:flutter/services.dart';

class Airport {
  final String code;
  final String city;
  final String country;
  final String countryCode;

  Airport({
    required this.code,
    required this.city,
    required this.country,
    required this.countryCode,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      code: json['code'],
      city: json['city'],
      country: json['country'],
      countryCode: json['countryCode'],
    );
  }
}

Future<List<Airport>> loadAirports() async {
  final String response = await rootBundle.loadString('assets/airports.json');

  final List<dynamic> data = json.decode(response);

  return data.map((json) => Airport.fromJson(json)).toList();
}
