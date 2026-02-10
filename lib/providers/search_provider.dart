import 'package:flutter/material.dart';
import '../models/search_request_model.dart';
import '../utils/validators.dart';
import '../storage/local_storage.dart';

/* ---------------- TRIP TYPE ---------------- */

enum TripType { oneWay, roundTrip, multiCity }

/* ---------------- MULTICITY LEG MODEL ---------------- */

class MultiCityLeg {
  String? from;
  String? to;
  DateTime? date;

  MultiCityLeg({this.from, this.to, this.date});
}

/* ---------------- SEARCH PROVIDER ---------------- */

class SearchProvider extends ChangeNotifier {
  final LocalStorage storage = LocalStorage();

  bool loading = false;

  /// Search request (for one-way & round-trip)
  SearchRequest request = SearchRequest.initial();

  /// UI states
  TripType tripType = TripType.oneWay;
  bool zeroCancellation = false;

  bool studentFare = false;
  bool seniorCitizenFare = false;
  bool armedForcesFare = false;

  int travellers = 1;
  String travelClass = "Economy";

  /// ⭐ MULTICITY LEGS
  List<MultiCityLeg> multiCityLegs = [
    MultiCityLeg(),
  ];

  /* ---------------- TRIP TYPE ---------------- */

  void setTripType(TripType type) {
    tripType = type;

    request = request.copyWith(
      tripType: type.name,
    );

    // Ensure at least one leg for multicity
    if (type == TripType.multiCity && multiCityLegs.isEmpty) {
      multiCityLegs.add(MultiCityLeg());
    }

    notifyListeners();
  }

  /* ---------------- ONE / ROUND TRIP ---------------- */

  void setOrigin(String code) {
    request = request.copyWith(origin: code);
    notifyListeners();
  }

  void setDestination(String code) {
    request = request.copyWith(destination: code);
    notifyListeners();
  }

  void setDepartureDate(String date) {
    request = request.copyWith(departureDate: date);
    notifyListeners();
  }

  void setReturnDate(String? date) {
    request = request.copyWith(returnDate: date);
    notifyListeners();
  }

  /* ---------------- MULTICITY ---------------- */

  void addCity() {
    multiCityLegs.add(MultiCityLeg());
    notifyListeners();
  }

  void updateLegFrom(int index, String value) {
    multiCityLegs[index].from = value;
    notifyListeners();
  }

  void updateLegTo(int index, String value) {
    multiCityLegs[index].to = value;
    notifyListeners();
  }

  void updateLegDate(int index, DateTime date) {
    multiCityLegs[index].date = date;
    notifyListeners();
  }

  /* ---------------- PASSENGERS & CLASS ---------------- */

  void setTravellers(int count) {
    travellers = count;
    request = request.copyWith(travellers: count);
    notifyListeners();
  }

  void setClass(String value) {
    travelClass = value;
    request = request.copyWith(travelClass: value);
    storage.saveTravelClass(value);
    notifyListeners();
  }

  void selectSpecialFare(String? fare) {
    studentFare = fare == "Student";
    seniorCitizenFare = fare == "Senior";
    armedForcesFare = fare == "Armed";
    notifyListeners();
  }

  /* ---------------- EXTRAS ---------------- */

  void toggleZeroCancellation(bool value) {
    zeroCancellation = value;
    notifyListeners();
  }

  void toggleStudentFare() {
    studentFare = !studentFare;
    notifyListeners();
  }

  void toggleSeniorCitizenFare() {
    seniorCitizenFare = !seniorCitizenFare;
    notifyListeners();
  }

  void toggleArmedForcesFare() {
    armedForcesFare = !armedForcesFare;
    notifyListeners();
  }

  /* ---------------- VALIDATION ---------------- */

  String? validate() {
    if (tripType == TripType.multiCity) {
      for (int i = 0; i < multiCityLegs.length; i++) {
        final leg = multiCityLegs[i];
        if (leg.from == null || leg.to == null || leg.date == null) {
          return "Please complete details for city ${i + 1}";
        }
        if (leg.from == leg.to) {
          return "From & To cannot be same (city ${i + 1})";
        }
      }
      return null;
    }

    // Existing validation (one-way & round-trip)
    return Validators.validateOrigin(request.origin) ??
        Validators.validateDestination(request.destination) ??
        Validators.validateOriginDestination(
          request.origin,
          request.destination,
        ) ??
        Validators.validateDepartureDate(request.departureDate) ??
        Validators.validateReturnDate(
          request.tripType,
          request.returnDate,
        );
  }

  /* ---------------- PERSISTENCE ---------------- */

  Future<void> saveRecentSearch() async {
    final data =
        "${request.origin}-${request.destination}-${request.departureDate}";
    await storage.saveRecentSearch(data);
  }

  Future<void> loadSavedPreferences() async {
    final savedClass = await storage.getTravelClass();
    if (savedClass != null) {
      travelClass = savedClass;
      request = request.copyWith(travelClass: savedClass);
      notifyListeners();
    }
  }

  /* ---------------- RESET ---------------- */

  void reset() {
    request = SearchRequest.initial();
    tripType = TripType.oneWay;

    multiCityLegs = [MultiCityLeg()];

    zeroCancellation = false;
    studentFare = false;
    seniorCitizenFare = false;
    armedForcesFare = false;

    travellers = 1;
    travelClass = "Economy";

    notifyListeners();
  }

  String? validateMultiCity() {
    if (multiCityLegs.length < 2) {
      return "Please add at least 2 cities";
    }

    for (int i = 0; i < multiCityLegs.length; i++) {
      final leg = multiCityLegs[i];
      if (leg.from == null || leg.to == null) {
        return "Select FROM and TO for city ${i + 1}";
      }
      if (leg.date == null) {
        return "Select date for city ${i + 1}";
      }
    }
    return null;
  }
}
