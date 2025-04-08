import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditEventApi {
  static const String _baseUrl = 'http://localhost:2010/gatherly/api/v1/event/update';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Retrieve access token from secure storage
  static Future<String?> getAccessToken() async {
    String? token = await _secureStorage.read(key: 'accessToken');
    print("Retrieved Token from Storage: $token");
    return token;
  }

  // Function to edit an existing event
  static Future<Map<String, dynamic>> editEvent({
    required String eventId, // Unique Event ID
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
    // required List<String> eventCategoryIds,
  }) async {
    try {
      // Retrieve stored access token
      String? accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
      print("Error: No access token found!");
        return {
          "status": 401,
          "error": "Unauthorized: No access token found",
        };
      }

      // Construct the API endpoint dynamically with eventId
      String url = '$_baseUrl/$eventId';


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
        // "eventCategoryIds": eventCategoryIds,
        
      };
      
// if (eventCategoryIds.isNotEmpty) {
//   body["eventCategoryIds"] = eventCategoryIds; // Add only if allowed
// }


      // Send HTTP PUT request
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      // Debugging Response
      print('Edit Event Response Code: ${response.statusCode}');
      print('Edit Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
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
      print("Error in editEvent: $error");
      return {
        "status": 500,
        "error": error.toString(),
      };
    }
  }
}
