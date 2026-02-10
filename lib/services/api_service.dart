import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/airport_model.dart';
import '../models/flight_model.dart';
import '../models/flight_detail_model.dart';
import '../models/search_request_model.dart';
import 'local_json_service.dart';

class ApiService {
  final LocalJsonService local;
  final http.Client client;

  ApiService(this.local, {http.Client? client})
      : client = client ?? http.Client();

  /* ---------------- GET /airports ---------------- */

  Future<List<AirportModel>> getAirports() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final json = await local.load('assets/json/airports.json');

      return (json['airports'] as List)
          .map((e) => AirportModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load airports: $e');
    }
  }

  /* ---------------- POST /flights/search ---------------- */

  // Future<List<FlightModel>> searchFlights(SearchRequest request) async {
  //   try {
  //     // Simulate network delay
  //     await Future.delayed(const Duration(seconds: 1));
  //
  //     final json = await local.load('assets/json/flights.json');
  //
  //     List<FlightModel> flights = (json['flights'] as List)
  //         .map((e) => FlightModel.fromJson(e))
  //         .toList();
  //
  //     // Filter flights based on search criteria
  //     flights = flights.where((f) {
  //       bool matchesOrigin = f.origin.code.toUpperCase() == request.origin.toUpperCase();
  //       bool matchesDestination = f.destination.code.toUpperCase() == request.destination.toUpperCase();
  //
  //       return matchesOrigin && matchesDestination;
  //     }).toList();
  //
  //     return flights;
  //   } catch (e) {
  //     throw Exception('Flight search failed: $e');
  //   }
  // }
  Future<List<FlightModel>> searchFlights(SearchRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    final json = await local.load('assets/json/flights.json');

    return (json['flights'] as List)
        .map((e) => FlightModel.fromJson(e))
        .toList();
  }

  /* ---------------- GET /flights/:id ---------------- */

  Future<FlightDetailModel> getFlightDetails(String id) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final json = await local.load('assets/json/flight_details.json');

      return FlightDetailModel.fromJson(json['flightDetails']);
    } catch (e) {
      throw Exception('Failed to load flight details: $e');
    }
  }
}