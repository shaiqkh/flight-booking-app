class AppConstants {
  // App
  static const String appName = "Flight Booking App";

  // Trip Types
  static const String oneWay = "oneWay";
  static const String roundTrip = "roundTrip";
  static const String multiCity = "multiCity";

  // Travel Classes
  static const List<String> travelClasses = [
    "Economy",
    "Premium",
    "Business",
  ];

  // Date formats
  static const String apiDateFormat = "yyyy-MM-dd";
  static const String displayDateFormat = "dd MMM, EEE";

  // Errors
  static const String genericError =
      "Something went wrong. Please try again.";

  // Currency
  static const String currencySymbol = "₹";
}
