// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AuthService {
//   static const String _baseUrl = "http://localhost:2010/gatherly/api/v1/auth";
//   static final _storage = FlutterSecureStorage();

//   /// **🔹 Logout Function**
//   static Future<Map<String, dynamic>> logout() async {
//     try {
//       // Retrieve the access token
//       String? token = await _storage.read(key: 'auth_token');

//       if (token == null) {
//         return {"status": 401, "body": {"message": "No token found"}};
//       }

//       final response = await http.post(
//         Uri.parse("$_baseUrl/log-out"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         await _storage.deleteAll(); // Clear secure storage on logout
//       }

//       return {
//         "status": response.statusCode,
//         "body": response.body.isNotEmpty ? jsonDecode(response.body) : {}
//       };
//     } catch (e) {
//       return {
//         "status": 500,
//         "body": {"message": "Error connecting to server"}
//       };
//     }
//   }
// }
