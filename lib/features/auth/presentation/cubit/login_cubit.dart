// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:laza/core/utils/error_messages.dart';
// import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
// import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
// import 'login_state.dart';

// class LoginCubit extends Cubit<LoginState> {
//   final LoginUseCase loginUseCase;

//   LoginCubit(this.loginUseCase) : super(LoginInitial());

//   Future<void> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     emit(LoginLoading());

//     try {
//       // ✅ Build request entity
//       final request = LoginRequestEntity(
//         email: email.trim(),
//         password: password.trim(),
//       );

//       // ✅ Call the use case
//       final result = await loginUseCase(request);

//       // ✅ Success state
//       emit(LoginSuccess(result));
//     } on DioException catch (e) {
//       // 🧩 Centralized Dio error handling
//       final errorMessage = _handleDioError(e);
//       emit(LoginError(errorMessage));
//     } catch (e) {
//       // 🔒 Fallback for unexpected errors
//       emit(LoginError(ErrorMessages.getErrorMessage(e)));
//     }
//   }

//   /// Handles Dio-specific exceptions clearly
//   String _handleDioError(DioException e) {
//     switch (e.type) {
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.sendTimeout:
//       case DioExceptionType.receiveTimeout:
//         return ErrorMessages.timeout;

//       case DioExceptionType.connectionError:
//         return ErrorMessages.noInternet;

//       case DioExceptionType.cancel:
//         return 'Request cancelled by user';

//       case DioExceptionType.badResponse:
//         final response = e.response;
//         final data = response?.data;

//         // ✅ Handle server messages precisely
//         if (data is Map<String, dynamic>) {
//           if (data.containsKey('message')) return data['message'];

//           if (data['errors'] is Map && data['errors'].containsKey('email')) {
//             final emailErrors = data['errors']['email'];
//             if (emailErrors is List && emailErrors.isNotEmpty) {
//               return emailErrors.first;
//             }
//           }

//           if (data['errors'] is Map &&
//               data['errors'].containsKey('generalErrors')) {
//             final general = data['errors']['generalErrors'];
//             if (general is List && general.isNotEmpty) {
//               return general.first;
//             }
//           }
//         }

//         if (response?.statusCode == 401) {
//           return 'Invalid email or password';
//         }
//         if (response?.statusCode == 400) {
//           return ErrorMessages.badRequest;
//         }
//         if (response?.statusCode != null && response!.statusCode! >= 500) {
//           return ErrorMessages.serverError;
//         }
//         return 'Login failed. Please try again.';

//       default:
//         return ErrorMessages.unexpectedError;
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/utils/error_messages.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/use_cases/login_usecase.dart';
import 'package:laza/core/shared_prefs.dart'; // ✅ ADD THIS IMPORT

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      // ✅ Build request entity
      final request = LoginRequestEntity(
        email: email.trim(),
        password: password.trim(),
      );

      // ✅ Call the use case
      final result = await loginUseCase(request);

      // ✅ Save token after successful login
      // Depending on your usecase, adjust:
      // If result is an entity -> result.accessToken
      // If result is Map -> result['accessToken']
      await saveToken(result.accessToken);

      // ✅ Emit success
      emit(LoginSuccess(result));
    } on DioException catch (e) {
      // 🧩 Centralized Dio error handling
      final errorMessage = _handleDioError(e);
      emit(LoginError(errorMessage));
    } catch (e) {
      // 🔒 Fallback for unexpected errors
      emit(LoginError(ErrorMessages.getErrorMessage(e)));
    }
  }

  /// Handles Dio-specific exceptions clearly
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorMessages.timeout;

      case DioExceptionType.connectionError:
        return ErrorMessages.noInternet;

      case DioExceptionType.cancel:
        return 'Request cancelled by user';

      case DioExceptionType.badResponse:
        final response = e.response;
        final data = response?.data;

        if (data is Map<String, dynamic>) {
          if (data.containsKey('message')) return data['message'];

          if (data['errors'] is Map && data['errors'].containsKey('email')) {
            final emailErrors = data['errors']['email'];
            if (emailErrors is List && emailErrors.isNotEmpty) {
              return emailErrors.first;
            }
          }

          if (data['errors'] is Map &&
              data['errors'].containsKey('generalErrors')) {
            final general = data['errors']['generalErrors'];
            if (general is List && general.isNotEmpty) {
              return general.first;
            }
          }
        }

        if (response?.statusCode == 401) {
          return 'Invalid email or password';
        }
        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Login failed. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
