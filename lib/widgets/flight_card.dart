import 'package:flutter/material.dart';
import '../models/flight_model.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback onTap;

  const FlightCard({
    super.key,
    required this.flight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Airline & Class
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Airline logo placeholder (you can replace with Image.network)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.flight,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.airline.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            flight.flightClass,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Rating
                  if (flight.rating > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            flight.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              /// Route & Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TimeBlock(
                    code: flight.origin.code,
                    time: flight.departure.time,
                    city: flight.origin.city,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          flight.duration,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            if (flight.stops > 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          flight.stops == 0
                              ? "Non-stop"
                              : "${flight.stops} Stop${flight.stops > 1 ? 's' : ''}",
                          style: TextStyle(
                            fontSize: 11,
                            color: flight.stops == 0 ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _TimeBlock(
                    code: flight.destination.code,
                    time: flight.arrival.time,
                    city: flight.destination.city,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Bottom section with amenities and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Amenities
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        if (flight.amenities.contains("WiFi"))
                          _AmenityChip(Icons.wifi, "WiFi"),
                        if (flight.amenities.contains("Inflight Meal") ||
                            flight.amenities.contains("Premium Meal"))
                          _AmenityChip(Icons.restaurant, "Meal"),
                        if (flight.amenities.contains("USB Charging"))
                          _AmenityChip(Icons.power, "USB"),
                        if (flight.baggage.cabin.isNotEmpty)
                          _AmenityChip(Icons.work_outline, flight.baggage.cabin),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${flight.price.total}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (flight.seats.available < 10 && flight.seats.available > 0)
                        Text(
                          "${flight.seats.available} seats left",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable time widget
class _TimeBlock extends StatelessWidget {
  final String code;
  final String time;
  final String city;

  const _TimeBlock({
    required this.code,
    required this.time,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          city,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

/// Amenity chip widget
class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}