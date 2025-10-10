import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:laza/features/auth/domain/entities/user_entity.dart';
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponseEntity>> register(RegisterRequestModel request);
  Future<Either<Failure, LoginResponseEntity>> login(LoginRequestEntity request);
  Future<Either<Failure, void>> forgotPassword(ForgotPasswordRequestEntity request);
  Future<Either<Failure, void>> verifyOtp(VerifyOtpRequestEntity request);
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequestEntity request);
  Future<Either<Failure, UserEntity>> getUserInfo();
}
