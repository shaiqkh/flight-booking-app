class FlightDetailModel {
  final String airline;
  final String flightNumber;
  final String from;
  final String to;
  final String duration;

  final Baggage baggage;
  final Map<String, int> fareBreakup;
  final int totalFare;
  final String cancellationPolicy;
  final List<String> amenities;

  FlightDetailModel({
    required this.airline,
    required this.flightNumber,
    required this.from,
    required this.to,
    required this.duration,
    required this.baggage,
    required this.fareBreakup,
    required this.totalFare,
    required this.cancellationPolicy,
    required this.amenities,
  });

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) {
    final segment = json['itinerary']['segments'][0];

    return FlightDetailModel(
      airline: json['airline']['name'],
      flightNumber: segment['flightNumber'],
      from: segment['origin']['code'],
      to: segment['destination']['code'],
      duration: segment['duration'],

      baggage: Baggage.fromJson(json['baggage']),

      fareBreakup: {
        "Base Fare": json['fare']['breakdown']['baseFare'],
        "Fuel Surcharge": json['fare']['breakdown']['fuelSurcharge'],
        "Airport Tax": json['fare']['breakdown']['airportTax'],
        "GST": json['fare']['breakdown']['gst'],
      },

      totalFare: json['fare']['breakdown']['total'],

      cancellationPolicy:
      json['cancellation']['policy']['refundable'] == true
          ? "Refundable with cancellation charges"
          : "Non-refundable",

      amenities: (json['amenities']['inflight'] as List)
          .map((e) => e['name'].toString())
          .toList(),
    );
  }
}

class Baggage {
  final String cabin;
  final String checkIn;

  Baggage({
    required this.cabin,
    required this.checkIn,
  });

  factory Baggage.fromJson(Map<String, dynamic> json) {
    return Baggage(
      cabin: json['cabin']['allowance'],
      checkIn: json['checkin']['allowance'],
    );
  }
}
