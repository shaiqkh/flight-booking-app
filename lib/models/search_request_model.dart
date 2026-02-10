class SearchRequest {
  final String origin;
  final String destination;
  final String departureDate;
  final String? returnDate;

  final int travellers;
  final String travelClass; // Economy / Premium / Business
  final String tripType; // oneWay / roundTrip / multiCity

  final bool zeroCancellation;
  final bool studentFare;
  final bool seniorCitizenFare;
  final bool armedForcesFare;

  const SearchRequest({
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.returnDate,
    required this.travellers,
    required this.travelClass,
    required this.tripType,
    required this.zeroCancellation,
    required this.studentFare,
    required this.seniorCitizenFare,
    required this.armedForcesFare,
  });

  factory SearchRequest.initial() => const SearchRequest(
    origin: '',
    destination: '',
    departureDate: '',
    returnDate: null,
    travellers: 1,
    travelClass: 'Economy',
    tripType: 'oneWay',
    zeroCancellation: false,
    studentFare: false,
    seniorCitizenFare: false,
    armedForcesFare: false,
  );

  SearchRequest copyWith({
    String? origin,
    String? destination,
    String? departureDate,
    String? returnDate,
    int? travellers,
    String? travelClass,
    String? tripType,
    bool? zeroCancellation,
    bool? studentFare,
    bool? seniorCitizenFare,
    bool? armedForcesFare,
  }) {
    return SearchRequest(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      travellers: travellers ?? this.travellers,
      travelClass: travelClass ?? this.travelClass,
      tripType: tripType ?? this.tripType,
      zeroCancellation: zeroCancellation ?? this.zeroCancellation,
      studentFare: studentFare ?? this.studentFare,
      seniorCitizenFare: seniorCitizenFare ?? this.seniorCitizenFare,
      armedForcesFare: armedForcesFare ?? this.armedForcesFare,
    );
  }

  /// Convert to API request JSON (POST /flights/search)
  Map<String, dynamic> toJson() {
    return {
      "origin": origin,
      "destination": destination,
      "departureDate": departureDate,
      "returnDate": returnDate,
      "passengers": travellers,
      "class": travelClass,
      "tripType": tripType,
      "specialFares": {
        "student": studentFare,
        "seniorCitizen": seniorCitizenFare,
        "armedForces": armedForcesFare,
      },
      "zeroCancellation": zeroCancellation,
    };
  }
}
