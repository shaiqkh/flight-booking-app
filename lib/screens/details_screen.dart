import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flight_provider.dart';
import '../widgets/loading_widget.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final flightId = ModalRoute.of(context)?.settings.arguments as String?;

      print('📱 Details Screen - didChangeDependencies');
      print('   Flight ID from arguments: $flightId');

      if (flightId != null) {
        context.read<FlightProvider>().loadDetails(flightId);
      }

      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Flight Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, FlightProvider provider) {
    // ⭐ CRITICAL FIX - Use loadingDetails instead of loading
    if (provider.loadingDetails) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      );
    }

    // ⭐ Check detailsError instead of error
    if (provider.detailsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              provider.detailsError!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    final details = provider.details;
    if (details == null) {
      return const Center(
        child: Text("No flight details available"),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* ---------------- AIRLINE HEADER ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.flight,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            details.airline,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            details.flightNumber,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /* ---------------- ROUTE DETAILS ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, "Flight Route"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _cityInfo(
                        code: details.from,
                        label: "Departure",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.flight_takeoff,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            details.duration,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Icon(
                            Icons.flight_land,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _cityInfo(
                        code: details.to,
                        label: "Arrival",
                        isDestination: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /* ---------------- BAGGAGE ALLOWANCE ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, "Baggage Allowance"),
                const SizedBox(height: 12),
                _infoRow(
                  icon: Icons.work_outline,
                  label: "Cabin Baggage",
                  value: details.baggage.cabin,
                ),
                const SizedBox(height: 8),
                _infoRow(
                  icon: Icons.luggage,
                  label: "Check-in Baggage",
                  value: details.baggage.checkIn,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /* ---------------- FARE BREAKDOWN ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, "Fare Summary"),
                const SizedBox(height: 12),
                ...details.fareBreakup.entries.map(
                      (entry) => _row(entry.key, "₹ ${entry.value}"),
                ),
                const Divider(height: 24),
                _row(
                  "Total Fare",
                  "₹ ${details.totalFare}",
                  bold: true,
                  fontSize: 16,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /* ---------------- CANCELLATION POLICY ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, "Cancellation Policy"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          details.cancellationPolicy,
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          /* ---------------- AMENITIES ---------------- */
          if (details.amenities.isNotEmpty)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(context, "In-Flight Amenities"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: details.amenities.map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue.shade200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAmenityIcon(amenity),
                              size: 16,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              amenity,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          /* ---------------- BOOK NOW BUTTON ---------------- */
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "₹ ${details.totalFare}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Booking feature coming soon!"),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            },
                            child: const Text(
                              "BOOK NOW",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _row(String k, String v, {bool bold = false, double? fontSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            v,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: fontSize ?? 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityInfo({
    required String code,
    required String label,
    bool isDestination = false,
  }) {
    return Column(
      crossAxisAlignment:
      isDestination ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('meal')) return Icons.restaurant;
    if (lower.contains('usb') || lower.contains('charging')) {
      return Icons.battery_charging_full;
    }
    if (lower.contains('seat')) return Icons.airline_seat_recline_normal;
    if (lower.contains('boarding')) return Icons.flight_takeoff;
    return Icons.check_circle;
  }
}