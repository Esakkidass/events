// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeleteEventApi {
  static const String _baseUrl =
      'http://localhost:2010/gatherly/api/v1/event/delete';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    print("Retrieved Token from Storage: $token");
    return token;
  }

  static Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    try {
      String? accessToken = await getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        print("Error: No access token found!");
        return {"status": 401, "error": "Unauthorized: No access token found"};
      }

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      };

      final body = jsonEncode({"id": eventId});

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return {
          "status": response.statusCode,
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "status": response.statusCode,
          "error": jsonDecode(response.body),
        };
      }
    } catch (error) {
      print("Error in deleteEvent: $error");
      return {"status": 500, "error": error.toString()};
    }
  }
}
