import 'package:flutter/material.dart';
import '../screens/search_screen.dart';
import '../screens/results_screen.dart';
import '../screens/details_screen.dart';

class AppRoutes {
  static const search = '/';
  static const results = '/results';
  static const details = '/details';

  static Map<String, WidgetBuilder> routes = {
    search: (_) => const SearchScreen(),
    results: (_) => const ResultsScreen(),
    details: (_) => const DetailsScreen(),
  };
}
