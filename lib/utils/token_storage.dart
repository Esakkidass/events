import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


class SecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveUserDataa(Map<String, dynamic> userData) async {
    if (userData.containsKey("data") && userData["data"].containsKey("session")) {
      final session = userData["data"]["session"];
      final accessToken = session["accessToken"];

      if (accessToken != null) {
        await _storage.write(key: 'accessToken', value: accessToken);
        print("Access Token Saved: $accessToken");
      } else {
        print("Error: accessToken is null!");
      }

      
    } else {
      print("Error: Invalid userData format!");
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }
  static Future<Map<String, dynamic>?> getUserData() async {
    String? userDataJson = await _storage.read(key: 'user_data');
    return userDataJson != null ? jsonDecode(userDataJson) : null;
  }

    static Future<void> clearUserData() async {
    await _storage.delete(key: 'user_data');
  }
}
