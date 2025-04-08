// import 'package:dio/dio.dart';

// class AuthService {
//   static final Dio _dio = Dio(BaseOptions(
//     baseUrl: "http://your-api-url.com/api/v1",
//     headers: {"Content-Type": "application/json"},
//   ));

//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final response = await _dio.post(
//         "/auth/login",
//         data: {"username": email, "password": password},
//       );

//       return {
//         "status": response.statusCode,
//         "body": response.data,
//         "headers": response.headers.map,
//       };
//     } on DioException catch (e) {
//       return {
//         "status": e.response?.statusCode ?? 500,
//         "body": e.response?.data ?? {"message": "Login failed"},
//       };
//     }
//   }
// }
