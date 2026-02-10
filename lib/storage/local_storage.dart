import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _recentSearchKey = 'recent_search';
  static const _favAirportsKey = 'favorite_airports';
  static const _travelClassKey = 'travel_class';
  static const _specialFareKey = 'special_fare';

  /* ---------------- RECENT SEARCH ---------------- */

  Future<void> saveRecentSearch(String data) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_recentSearchKey, data);
  }

  Future<String?> getRecentSearch() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_recentSearchKey);
  }

  /* ---------------- FAVORITE AIRPORTS ---------------- */

  Future<void> addFavoriteAirport(String code) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(_favAirportsKey) ?? [];
    if (!list.contains(code)) {
      list.add(code);
      pref.setStringList(_favAirportsKey, list);
    }
  }

  Future<List<String>> getFavoriteAirports() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getStringList(_favAirportsKey) ?? [];
  }

  Future<void> removeFavoriteAirport(String code) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList(_favAirportsKey) ?? [];
    list.remove(code);
    pref.setStringList(_favAirportsKey, list);
  }

  /* ---------------- USER PREFERENCES ---------------- */

  Future<void> saveTravelClass(String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_travelClassKey, value);
  }

  Future<String?> getTravelClass() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_travelClassKey);
  }

  Future<void> saveSpecialFare(String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(_specialFareKey, value);
  }

  Future<String?> getSpecialFare() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_specialFareKey);
  }
}
