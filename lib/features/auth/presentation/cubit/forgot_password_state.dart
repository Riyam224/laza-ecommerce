import 'package:equatable/equatable.dart';

sealed class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Email submission states
class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String email;
  ForgotPasswordSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

// OTP verification states
class OtpVerificationLoading extends ForgotPasswordState {}

class OtpVerificationSuccess extends ForgotPasswordState {
  final String email;
  final String otp;
  OtpVerificationSuccess(this.email, this.otp);

  @override
  List<Object?> get props => [email, otp];
}

class OtpVerificationError extends ForgotPasswordState {
  final String message;
  OtpVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Password reset states
class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {}

class ResetPasswordError extends ForgotPasswordState {
  final String message;
  ResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
