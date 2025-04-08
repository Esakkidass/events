// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:events/utils/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CategoryApi {
  static const String _baseUrl =
      'http://localhost:2010/gatherly/api/v1/event-category/get';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    print("Retrieved Token from Storage: $token");
    return token;
  }

  static Future<Map<String, dynamic>> getCategory() async {
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

      final response = await http.get(Uri.parse(_baseUrl), headers: headers);

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
      print("Error in getCategory: $error"); // Debugging
      return {"status": 500, "error": error.toString()};
    }
  }
}
