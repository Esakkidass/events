import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServiceRegister {
  static const String _baseUrl = "http://localhost:2010/gatherly/api/v1/auth";
  //http://localhost:2010/gatherly/api/v1/auth

  static Future<Map<String, dynamic>> register(String firstName, String lastName, String email, String password) async {
    try {
    // print("🔹 Attempting login...");
    //   print(" Username: $userName");
    //   print("Password: $password");
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"firstName": firstName, "lastName": lastName, "email":email, "password":password}),
      );

      return {
        "status": response.statusCode,
        "body": response.body.isNotEmpty ? jsonDecode(response.body) : {}
      };
    } catch (e) {
      return {
        "status": 500,
        "body": {"message": "Error connecting to server"}
      };
    }
  }
}
