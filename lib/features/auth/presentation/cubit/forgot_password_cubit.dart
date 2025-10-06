import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/core/utils/error_messages.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:laza/features/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:laza/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit(
    this.forgotPasswordUseCase,
    this.verifyOtpUseCase,
    this.resetPasswordUseCase,
  ) : super(ForgotPasswordInitial());

  // Step 1: Send OTP to email
  Future<void> sendOtp(String email) async {
    emit(ForgotPasswordLoading());

    try {
      final request = ForgotPasswordRequestEntity(email: email.trim());
      await forgotPasswordUseCase(request);
      emit(ForgotPasswordSuccess(email.trim()));
    } on DioException catch (e) {
      emit(ForgotPasswordError(_handleDioError(e)));
    } catch (e) {
      emit(ForgotPasswordError(ErrorMessages.getErrorMessage(e)));
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    emit(OtpVerificationLoading());

    try {
      final request = VerifyOtpRequestEntity(
        email: email.trim(),
        otp: otp.trim(),
      );
      await verifyOtpUseCase(request);
      emit(OtpVerificationSuccess(email.trim(), otp.trim()));
    } on DioException catch (e) {
      emit(OtpVerificationError(_handleDioError(e)));
    } catch (e) {
      emit(OtpVerificationError(ErrorMessages.getErrorMessage(e)));
    }
  }

  // Step 3: Reset password
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    emit(ResetPasswordLoading());

    try {
      final request = ResetPasswordRequestEntity(
        email: email.trim(),
        otp: otp.trim(),
        newPassword: newPassword.trim(),
      );
      await resetPasswordUseCase(request);
      emit(ResetPasswordSuccess());
    } on DioException catch (e) {
      emit(ResetPasswordError(_handleDioError(e)));
    } catch (e) {
      emit(ResetPasswordError(ErrorMessages.getErrorMessage(e)));
    }
  }

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

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return data['message'];
        }

        if (response?.statusCode == 400) {
          return ErrorMessages.badRequest;
        }
        if (response?.statusCode == 404) {
          return 'Email not found';
        }
        if (response?.statusCode != null && response!.statusCode! >= 500) {
          return ErrorMessages.serverError;
        }
        return 'Operation failed. Please try again.';

      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
