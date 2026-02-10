import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  /// Global loading indicator
  bool isLoading = false;

  /// Global error message
  String? errorMessage;

  /// App theme (bonus)
  bool isDarkMode = false;

  /* ---------------- LOADING ---------------- */

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /* ---------------- ERROR ---------------- */

  void setError(String message) {
    errorMessage = message;
    isLoading = false;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  /* ---------------- THEME ---------------- */

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
