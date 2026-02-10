import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import '../models/flight_detail_model.dart';
import '../models/search_request_model.dart';
import '../services/repository.dart';

class FlightProvider extends ChangeNotifier {
  final FlightRepository repo;

  FlightProvider(this.repo);

  // ⭐ CRITICAL FIX - Separate loading states
  bool loading = false;  // For search/results screen
  bool loadingDetails = false;  // For details screen

  String? error;
  String? detailsError;

  List<FlightModel> flights = [];
  List<FlightModel> _allFlights = [];
  FlightDetailModel? details;

  List<String> availableClasses = [];
  String? selectedClass;

  /* ---------------- INTERNAL ---------------- */

  void _extractAvailableClasses() {
    final classesSet = <String>{};
    for (var flight in _allFlights) {
      classesSet.add(flight.flightClass);
    }
    availableClasses = classesSet.toList()..sort();
  }

  /* ---------------- FILTERS ---------------- */

  void filterByClass(String? travelClass) {
    selectedClass = travelClass;

    if (travelClass == null || travelClass.isEmpty) {
      flights = List.from(_allFlights);
    } else {
      flights = _allFlights
          .where((f) =>
      f.flightClass.toLowerCase() ==
          travelClass.toLowerCase())
          .toList();
    }
    notifyListeners();
  }

  void filterByStops(int stops) {
    flights = flights.where((f) => f.stops == stops).toList();
    notifyListeners();
  }

  void filterByAirline(String airline) {
    flights = _allFlights
        .where((f) =>
    f.airline.name.toLowerCase() ==
        airline.toLowerCase())
        .toList();
    notifyListeners();
  }

  void clearFilters() {
    flights = List.from(_allFlights);
    selectedClass = null;
    notifyListeners();
  }

  /* ---------------- SORT ---------------- */

  void sortByPrice(bool ascending) {
    flights.sort((a, b) {
      final p1 = a.price.total;
      final p2 = b.price.total;
      return ascending ? p1.compareTo(p2) : p2.compareTo(p1);
    });
    notifyListeners();
  }

  /* ---------------- SEARCH ---------------- */

  Future<void> search(SearchRequest request) async {
    loading = true;  // Only affects results screen
    error = null;
    flights = [];
    _allFlights = [];
    availableClasses = [];
    selectedClass = null;
    notifyListeners();

    try {
      final results = await repo.searchFlights(request);
      _allFlights = results;
      flights = List.from(_allFlights);
      _extractAvailableClasses();
      error = null;
    } catch (e) {
      error = 'Failed to search flights';
    }

    loading = false;
    notifyListeners();
  }

  /* ---------------- DETAILS ---------------- */

  Future<void> loadDetails(String flightId) async {
    print('════════════════════════════════════════');
    print('Loading details for flight: $flightId');

    loadingDetails = true;
    detailsError = null;
    details = null;
    notifyListeners();

    try {
      print(' Fetching from repository...');
      details = await repo.fetchDetails(flightId);
      print(' Details loaded successfully');
      print('   Airline: ${details?.airline}');
      detailsError = null;
    } catch (e) {
      print(' Error: $e');
      detailsError = 'Failed to load flight details';
      details = null;
    }

    loadingDetails = false;
    notifyListeners();
    print('════════════════════════════════════════');
  }

  // Helper method to clear details when navigating away
  void clearDetails() {
    details = null;
    detailsError = null;
    loadingDetails = false;
    notifyListeners();
  }
}