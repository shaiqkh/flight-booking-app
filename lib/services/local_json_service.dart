import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class LocalJsonService {
  Future<Map<String, dynamic>> load(String path) async {
    try {
      // Load the JSON file from assets
      final data = await rootBundle.loadString(path);

      // Parse and return
      return jsonDecode(data) as Map<String, dynamic>;
    } on TimeoutException {
      throw Exception('Local JSON load timeout for: $path');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON format in $path: $e');
    } catch (e) {
      throw Exception('Failed to load local JSON from $path: $e');
    }
  }
}