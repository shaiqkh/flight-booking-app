class FlightModel {
  final String id;
  final Airline airline;
  final Location origin;
  final Location destination;
  final Departure departure;
  final Arrival arrival;
  final String duration;
  final int stops;
  final List<StopDetail> stopDetails;
  final String flightClass;
  final Price price;
  final Seats seats;
  final Baggage baggage;
  final Cancellation cancellation;
  final List<String> amenities;
  final double rating;

  FlightModel({
    required this.id,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.stops,
    required this.stopDetails,
    required this.flightClass,
    required this.price,
    required this.seats,
    required this.baggage,
    required this.cancellation,
    required this.amenities,
    required this.rating,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] ?? '',
      airline: Airline.fromJson(json['airline'] ?? {}),
      origin: Location.fromJson(json['origin'] ?? {}),
      destination: Location.fromJson(json['destination'] ?? {}),
      departure: Departure.fromJson(json['departure'] ?? {}),
      arrival: Arrival.fromJson(json['arrival'] ?? {}),
      duration: json['duration'] ?? '',
      stops: json['stops'] ?? 0,
      stopDetails: (json['stopDetails'] as List?)
          ?.map((e) => StopDetail.fromJson(e))
          .toList() ?? [],
      flightClass: json['class'] ?? 'Economy',
      price: Price.fromJson(json['price'] ?? {}),
      seats: Seats.fromJson(json['seats'] ?? {}),
      baggage: Baggage.fromJson(json['baggage'] ?? {}),
      cancellation: Cancellation.fromJson(json['cancellation'] ?? {}),
      amenities: (json['amenities'] as List?)?.cast<String>() ?? [],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline.toJson(),
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'departure': departure.toJson(),
      'arrival': arrival.toJson(),
      'duration': duration,
      'stops': stops,
      'stopDetails': stopDetails.map((e) => e.toJson()).toList(),
      'class': flightClass,
      'price': price.toJson(),
      'seats': seats.toJson(),
      'baggage': baggage.toJson(),
      'cancellation': cancellation.toJson(),
      'amenities': amenities,
      'rating': rating,
    };
  }
}

class Airline {
  final String code;
  final String name;
  final String logo;

  Airline({
    required this.code,
    required this.name,
    required this.logo,
  });

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'logo': logo,
    };
  }
}

class Location {
  final String code;
  final String city;
  final String airport;
  final String terminal;

  Location({
    required this.code,
    required this.city,
    required this.airport,
    required this.terminal,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      code: json['code'] ?? '',
      city: json['city'] ?? '',
      airport: json['airport'] ?? '',
      terminal: json['terminal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'city': city,
      'airport': airport,
      'terminal': terminal,
    };
  }
}

class Departure {
  final String time;
  final String date;

  Departure({
    required this.time,
    required this.date,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      time: json['time'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'date': date,
    };
  }
}

class Arrival {
  final String time;
  final String date;

  Arrival({
    required this.time,
    required this.date,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      time: json['time'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'date': date,
    };
  }
}

class StopDetail {
  final String airport;
  final String code;
  final String duration;

  StopDetail({
    required this.airport,
    required this.code,
    required this.duration,
  });

  factory StopDetail.fromJson(Map<String, dynamic> json) {
    return StopDetail(
      airport: json['airport'] ?? '',
      code: json['code'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airport': airport,
      'code': code,
      'duration': duration,
    };
  }
}

class Price {
  final int base;
  final int taxes;
  final int total;
  final String currency;

  Price({
    required this.base,
    required this.taxes,
    required this.total,
    required this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      base: json['base'] ?? 0,
      taxes: json['taxes'] ?? 0,
      total: json['total'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'taxes': taxes,
      'total': total,
      'currency': currency,
    };
  }
}

class Seats {
  final int available;
  final int total;

  Seats({
    required this.available,
    required this.total,
  });

  factory Seats.fromJson(Map<String, dynamic> json) {
    return Seats(
      available: json['available'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'total': total,
    };
  }
}

class Baggage {
  final String cabin;
  final String checkin;

  Baggage({
    required this.cabin,
    required this.checkin,
  });

  factory Baggage.fromJson(Map<String, dynamic> json) {
    return Baggage(
      cabin: json['cabin'] ?? '',
      checkin: json['checkin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cabin': cabin,
      'checkin': checkin,
    };
  }
}

class Cancellation {
  final bool allowed;
  final int fee;
  final String beforeDeparture;

  Cancellation({
    required this.allowed,
    required this.fee,
    required this.beforeDeparture,
  });

  factory Cancellation.fromJson(Map<String, dynamic> json) {
    return Cancellation(
      allowed: json['allowed'] ?? false,
      fee: json['fee'] ?? 0,
      beforeDeparture: json['beforeDeparture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowed': allowed,
      'fee': fee,
      'beforeDeparture': beforeDeparture,
    };
  }
}