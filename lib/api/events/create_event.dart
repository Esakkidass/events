import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventApi {
  static const String _baseUrl = 'http://localhost:2010/gatherly/api/v1/event/create';
static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
 static Future<String?> getAccessToken() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    print("Retrieved Token from Storage: $token");
    return token;
  }

  /// Function to register a sponsor
  static Future<Map<String, dynamic>> registerEvent({
    required String eventName,
    required String eventStartDate,
    required String eventEndDate,
    required String eventStartTime,
    required String eventEndTime,
    required String eventLocation,
    required String latitude,
    required String longitude,
    required bool isFree,
    required String eventDescription,
    required List<String> eventCategoryIds, 


  }) async {
    try {
      // Retrieve stored access token
      String? accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return {
          "status": 401,
          "error": "Unauthorized: No access token found",
        };
      }

      // Set Authorization Header
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      };

      // Prepare request body
      final Map<String, dynamic> body = {
        "eventName": eventName,
        "eventStartDate": eventStartDate,
        "eventEndDate": eventEndDate,
        "eventStartTime": eventStartTime,
        "eventEndTime": eventEndTime,
        "eventLocation": eventLocation,
        "latitude": latitude,
        "longitude": longitude,
        "isFree": isFree,
        "eventDescription": eventDescription,
        "eventCategoryIds":eventCategoryIds,
      };

      // Send HTTP POST request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      // Debugging Response
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "status": response.statusCode,
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "status": response.statusCode,
          "error": response.body.isNotEmpty ? jsonDecode(response.body) : "Unknown error",
        };
      }
    } catch (error) {
      print("Error in registerOfficer: $error");
      return {
        "status": 500,
        "error": error.toString(),
      };
    }
  }
}
