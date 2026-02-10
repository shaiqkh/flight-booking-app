import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/api_service.dart';
import 'services/local_json_service.dart';
import 'services/repository.dart';
import 'providers/airport_provider.dart';
import 'providers/search_provider.dart';
import 'providers/flight_provider.dart';
import 'providers/app_state_provider.dart';

void main() {
  final localJsonService = LocalJsonService();
  final apiService = ApiService(localJsonService);
  final repository = FlightRepository(apiService);

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AppStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AirportProvider(repository),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FlightProvider(repository),
        ),
      ],
      child: const FlightApp(),
    ),
  );
}
