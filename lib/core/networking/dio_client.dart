// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_constants.dart';

// class DioClient {
//   static Dio createDio() {
//     final dio = Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         headers: {'Accept': 'application/json'},
//       ),
//     );

//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           final prefs = await SharedPreferences.getInstance();
//           final token = prefs.getString('access_token');
//           if (token != null && token.isNotEmpty) {
//             options.headers['Authorization'] = 'Bearer $token';
//           }
//           return handler.next(options);
//         },
//       ),
//     );

//     // 🧾 Add interceptors
//     dio.interceptors.add(
//       LogInterceptor(
//         request: true,
//         requestHeader: true,
//         requestBody: true,
//         responseHeader: false,
//         responseBody: true,
//         error: true,
//       ),
//     );

//     return dio;
//   }
// }

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    // ✅ Token Interceptor (adds Authorization header automatically)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('access_token');

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            print('⚠️ Failed to read token from SharedPreferences: $e');
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          // Optional: handle global errors (e.g. unauthorized)
          if (error.response?.statusCode == 401) {
            print(
              '🚫 Unauthorized request. Token might be invalid or expired.',
            );
          }
          return handler.next(error);
        },
      ),
    );

    // 🧾 Debug Logging Interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🔹 $obj'),
      ),
    );

    return dio;
  }
}
