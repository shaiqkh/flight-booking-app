import 'package:flutter/material.dart';
import '../models/airport_model.dart';
import '../services/repository.dart';
import '../storage/local_storage.dart';

class AirportProvider extends ChangeNotifier {
  final FlightRepository repo;
  final LocalStorage storage = LocalStorage();

  AirportProvider(this.repo);

  bool loading = false;
  String? error;

  List<AirportModel> airports = [];

  /// Load all airports
  Future<void> loadAirports() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      airports = await repo.fetchAirports();
    } catch (e) {
      error = 'Failed to load airports';
    }

    loading = false;
    notifyListeners();
  }

  /// Search airports for autocomplete
  List<AirportModel> searchAirport(String query) {
    if (query.isEmpty) return airports;

    final q = query.toLowerCase();
    return airports.where((a) {
      return a.city.toLowerCase().contains(q) ||
          a.code.toLowerCase().contains(q) ||
          a.name.toLowerCase().contains(q);
    }).toList();
  }

  /* ---------------- FAVORITES ---------------- */

  Future<void> addToFavorite(String code) async {
    await storage.addFavoriteAirport(code);
  }

  Future<List<String>> getFavorites() async {
    return storage.getFavoriteAirports();
  }
}
