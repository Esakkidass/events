// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String _baseUrl = "http://localhost:2010/gatherly/api/v1/auth";
//   //http://localhost:2010/gatherly/api/v1/auth

//   static Future<Map<String, dynamic>> login(String userName, String password) async {
//     try {
//     // print("🔹 Attempting login...");
//     //   print(" Username: $userName");
//     //   print("Password: $password");
//       final response = await http.post(
//         Uri.parse("$_baseUrl/login"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"userName": userName, "password": password}),
//       );

//          final responseBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      
//       if (response.statusCode == 200 && responseBody.containsKey("data")) {
//         final session = responseBody["data"]["session"];
//         final userDetails = responseBody["data"]["userDetails"];

//         // Store token and user details
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('accessToken', session["accessToken"]);
//         await prefs.setString('refreshToken', session["refreshToken"]);
//         await prefs.setString('userDetails', jsonEncode(userDetails));

//         // return {
//         //   "status": response.statusCode,
//         //   "data": responseBody,
//         // };
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



import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:2010/gatherly/api/v1/auth/login'),
      body: jsonEncode({"userName": userName, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return {"status": 200, "body": jsonDecode(response.body)};
    } else {
      return {"status": response.statusCode, "body": jsonDecode(response.body)};
    }
  }
}
