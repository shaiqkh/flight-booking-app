class Validators {
  static String? validateOrigin(String value) {
    if (value.isEmpty) {
      return "Please select origin airport";
    }
    return null;
  }

  static String? validateDestination(String value) {
    if (value.isEmpty) {
      return "Please select destination airport";
    }
    return null;
  }

  static String? validateOriginDestination(
      String origin, String destination) {
    if (origin.isNotEmpty &&
        destination.isNotEmpty &&
        origin == destination) {
      return "Origin and destination cannot be same";
    }
    return null;
  }

  static String? validateDepartureDate(String value) {
    if (value.isEmpty) {
      return "Please select departure date";
    }
    return null;
  }

  static String? validateReturnDate(
      String tripType, String? returnDate) {
    if (tripType == "roundTrip" &&
        (returnDate == null || returnDate.isEmpty)) {
      return "Please select return date";
    }
    return null;
  }
}
