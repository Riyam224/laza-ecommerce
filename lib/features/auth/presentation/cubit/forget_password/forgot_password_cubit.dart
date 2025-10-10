import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> sendOtp(String email) async {
    emit(ForgotPasswordLoading());

    final request = ForgotPasswordRequestEntity(email: email.trim());
    final result = await forgotPasswordUseCase(request);

    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (_) => emit(ForgotPasswordSuccess(email.trim())),
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(OtpVerificationLoading());

    final request = VerifyOtpRequestEntity(
      email: email.trim(),
      otp: otp.trim(),
    );
    final result = await verifyOtpUseCase(request);

    result.fold(
      (failure) => emit(OtpVerificationError(failure.message)),
      (_) => emit(OtpVerificationSuccess(email.trim(), otp.trim())),
    );
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    emit(ResetPasswordLoading());

    final request = ResetPasswordRequestEntity(
      email: email.trim(),
      otp: otp.trim(),
      newPassword: newPassword.trim(),
    );
    final result = await resetPasswordUseCase(request);

    result.fold(
      (failure) => emit(ResetPasswordError(failure.message)),
      (_) => emit(ResetPasswordSuccess()),
    );
  }
}
