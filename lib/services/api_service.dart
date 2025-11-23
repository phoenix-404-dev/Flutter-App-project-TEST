import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/device_config.dart';

class ApiService {
  final DeviceConfig config;
  static const Duration timeout = Duration(seconds: 5);

  ApiService(this.config);

  String get baseUrl => config.baseUrl;

  /// Get current device status
  Future<DeviceStatus> getStatus() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/status'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeviceStatus.fromJson(data);
      } else {
        throw Exception('Failed to get status: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Connection timeout');
    } on SocketException {
      throw Exception('Network error - device not reachable');
    } catch (e) {
      throw Exception('Error getting status: $e');
    }
  }

  /// Activate a theme by ID
  Future<bool> activateTheme(int themeId, {
    int? brightness,
    int? volume,
    int? speed,
  }) async {
    try {
      // Build query parameters
      final params = {'m': themeId.toString()};
      
      // Add optional parameters if provided
      if (brightness != null) params['brightness'] = brightness.toString();
      if (volume != null) params['volume'] = volume.toString();
      if (speed != null) params['speed'] = speed.toString();

      final uri = Uri.parse('$baseUrl/setMode').replace(queryParameters: params);
      
      final response = await http
          .get(uri)
          .timeout(timeout);

      return response.statusCode == 200;
    } on TimeoutException {
      throw Exception('Connection timeout');
    } on SocketException {
      throw Exception('Network error - device not reachable');
    } catch (e) {
      throw Exception('Error activating theme: $e');
    }
  }

  /// Return to main menu (stop current theme)
  Future<bool> backToMenu() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/backToMenu'))
          .timeout(timeout);

      return response.statusCode == 200;
    } on TimeoutException {
      throw Exception('Connection timeout');
    } on SocketException {
      throw Exception('Network error - device not reachable');
    } catch (e) {
      throw Exception('Error returning to menu: $e');
    }
  }

  /// Test connection to device
  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/status'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Validate response structure
        return data.containsKey('mode') && data.containsKey('active');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Ping device (simple connectivity check)
  Future<bool> ping() async {
    try {
      final response = await http
          .head(Uri.parse(baseUrl))
          .timeout(Duration(seconds: 2));
      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }
}
