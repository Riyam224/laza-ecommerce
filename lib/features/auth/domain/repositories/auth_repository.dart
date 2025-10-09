import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';

abstract class AuthRepository {
  Future<RegisterResponseEntity> register(RegisterRequestModel request);
  Future<LoginResponseEntity> login(LoginRequestEntity request);
  Future<void> forgotPassword(ForgotPasswordRequestEntity request);
  Future<void> verifyOtp(VerifyOtpRequestEntity request);
  Future<void> resetPassword(ResetPasswordRequestEntity request);
}
