// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import '../login/auth_service.dart';
// import '../model/login_response.dart';
// import '../utils/token_storage.dart';
// import '../services/auth_service.dart';  // Ensure this handles API calls

// class LoginViewModel extends ChangeNotifier {
//   String _email = '';
//   String _password = '';
//   bool _isPasswordInvisible = true;
//   bool _isLoading = false;
//   String _message = '';

//   String get email => _email;
//   String get password => _password;
//   bool get isPasswordInvisible => _isPasswordInvisible;
//   bool get isLoading => _isLoading;
//   String get message => _message;

//   void setEmail(String email) {
//     _email = email;
//     notifyListeners();
//   }

//   void setPassword(String password) {
//     _password = password;
//     notifyListeners();
//   }

//   void togglePasswordVisibility() {
//     _isPasswordInvisible = !_isPasswordInvisible;
//     notifyListeners();
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _setMessage(String msg) {
//     _message = msg;
//     notifyListeners();
//   }

//   Future<bool> login(BuildContext context) async {
//     if (_email.isEmpty || _password.isEmpty) {
//       _setMessage("Please enter both email and password.");
//       return false;
//     }

//     _setLoading(true);

//     try {
//       final response = await AuthService.login(_email, _password);

//       if (response["status"] == 200) {
//         final loginResponse = LoginResponse.fromJson(response["body"]);

//         await SecureStorage.storeToken(response["headers"]["token"] ?? '');
//         await SecureStorage.storeUsername(_email);
//         await SecureStorage.storeUserId(loginResponse.data.userData.id);
//         await SecureStorage.storeRoleCode(loginResponse.data.userData.role.roleCode);

//         _setLoading(false);
//         return true;
//       } else {
//         _setMessage(response["body"]["message"] ?? "Login failed.");
//       }
//     } on DioException catch (e) {
//       _setMessage(e.response?.data["message"] ?? "Login failed due to network error.");
//     } catch (e) {
//       _setMessage("An unexpected error occurred. Please try again.");
//     }

//     _setLoading(false);
//     return false;
//   }
// }
