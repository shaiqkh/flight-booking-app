import 'package:intl/intl.dart';
import 'constants.dart';

class Helpers {
  /// Format DateTime → API format
  static String formatDateForApi(DateTime date) {
    return DateFormat(AppConstants.apiDateFormat).format(date);
  }

  /// Format DateTime → UI display format
  static String formatDateForDisplay(DateTime date) {
    return DateFormat(AppConstants.displayDateFormat).format(date);
  }

  /// Format price with currency
  static String formatPrice(int amount) {
    return "${AppConstants.currencySymbol}$amount";
  }

  /// Capitalize first letter
  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// Duration helper (e.g. "2h 15m")
  static String formatDuration(String duration) {
    return duration;
  }
}
