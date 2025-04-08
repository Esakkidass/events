class LoginResponse {
  final String code;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }
}

class LoginData {
  final UserData userData;
  final String expiresIn;

  LoginData({
    required this.userData,
    required this.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      userData: UserData.fromJson(json['userData'] ?? {}),
      expiresIn: json['expiresIn'] ?? '',
    );
  }
}

class UserData {
  final String id;
  final String phone;
  final String email;
  final String fullName;
  final String lastLogin;
  final bool isNewLogin;
  final RoleData role;

  UserData({
    required this.id,
    required this.phone,
    required this.email,
    required this.fullName,
    required this.lastLogin,
    this.isNewLogin = false,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      lastLogin: json['lastLogin'] ?? '',
      isNewLogin: json['isNewLogin'] ?? false,
      role: RoleData.fromJson(json['role'] ?? {}),
    );
  }
}

class RoleData {
  final String roleCode;
  final String role;

  RoleData({
    required this.roleCode,
    required this.role,
  });

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      roleCode: json['roleCode']?.toString() ?? '',
      role: json['role'] ?? '',
    );
  }
}
