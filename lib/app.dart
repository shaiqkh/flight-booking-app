import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class FlightApp extends StatelessWidget {
  const FlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight Booking',
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.search,
    );
  }
}
