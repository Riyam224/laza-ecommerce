import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/error/auth_error_msg.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/domain/use_cases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> registerUser({
    required String email,
    required String username,
    required String password,
  }) async {
    emit(RegisterLoading());

    try {
      // Split username into first & last name (safe fallback)
      final parts = username
          .trim()
          .split(' ')
          .where((e) => e.isNotEmpty)
          .toList();
      final firstName = parts.isNotEmpty ? parts.first : 'User';
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : 'Name';

      // Build request model
      final request = RegisterRequestModel(
        email: email.trim(),
        password: password.trim(),
        firstName: firstName,
        lastName: lastName,
      );

      // Call the use case
      final result = await registerUseCase(request);

      // Success state
      emit(RegisterSuccess(result));
    } on DioException catch (e) {
      // 🧩 Centralized Dio error handling
      final errorMessage = _handleDioError(e);
      emit(RegisterError(errorMessage));
    } catch (e) {
      // 🔒 Fallback for unexpected errors
      emit(RegisterError(ErrorMessages.getErrorMessage(e)));
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

        // Handle server messages precisely
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

        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode == 409) {
          return ErrorMessages.emailAlreadyExists;
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return ErrorMessages.registrationFailed;

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
