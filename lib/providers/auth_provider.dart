import 'package:events/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:events/login/auth_service.dart';
import 'package:events/utils/token_storage.dart';
import 'package:events/router.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = true;
  bool isLoggedIn = false;
  String userType = '';

  Future<void> checkLoginStatus() async {
    final userData = await SecureStorage.getUserData();
// print("userData ====================>>>>> $userData");

if (userData != null && 
    userData.containsKey("data") && 
    userData["data"].containsKey("userDetails") && 
    userData["data"]["userDetails"].containsKey("userType")) {
  
  userType = userData["data"]["userDetails"]["userType"];
  isLoggedIn = true;
}

print("Extracted userType: $userType");
    isLoading = false;
    notifyListeners();
  }

  Future<void> login(String userName, String password, BuildContext context) async {
    final response = await AuthService.login(userName, password);
    if (response["status"] == 200 && response["body"] != null) {
      await SecureStorage.saveUserData(response["body"]);
      await SecureStorage.saveUserDataa(response["body"]);
      await checkLoginStatus();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AppRouter.redirectHome(userType)));


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["body"]?["message"] ?? "Invalid email or password")),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    await SecureStorage.clearUserData();
    isLoggedIn = false;
    userType = '';
    notifyListeners();
    Navigator.pushReplacementNamed(context, '/');
  }
}
