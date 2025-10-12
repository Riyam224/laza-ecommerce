import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/models/login/login_request_model.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/data/models/forgot_password/forgot_password_request_model.dart';
import 'package:laza/features/auth/data/models/forgot_password/verify_otp_request_model.dart';
import 'package:laza/features/auth/data/models/forgot_password/reset_password_request_model.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';
import 'package:laza/features/auth/domain/entities/login_request_entity.dart';
import 'package:laza/features/auth/domain/entities/login_response_entity.dart';
import 'package:laza/features/auth/domain/entities/forgot_password_request_entity.dart';
import 'package:laza/features/auth/domain/entities/user_entity.dart';
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService api;
  AuthRepositoryImpl(this.api);

  String _extractErrorMessage(DioException e, String defaultMessage) {
    if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
      return e.response!.data['message'] ?? defaultMessage;
    }
    return defaultMessage;
  }

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final response = await api.register(request);
      return Right(
        RegisterResponseEntity(
          message:
              response.message ??
              'Registration successful, but no message provided.',
        ),
      );
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: _extractErrorMessage(e, 'Registration failed')),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> login(
    LoginRequestEntity request,
  ) async {
    try {
      final requestModel = LoginRequestModel.fromEntity(request);
      final response = await api.login(requestModel);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: _extractErrorMessage(e, 'Login failed')),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(
    ForgotPasswordRequestEntity request,
  ) async {
    try {
      final requestModel = ForgotPasswordRequestModel.fromEntity(request);
      await api.forgotPassword(requestModel.toJson());
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _extractErrorMessage(e, 'Password reset failed'),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(
    VerifyOtpRequestEntity request,
  ) async {
    try {
      final requestModel = VerifyOtpRequestModel.fromEntity(request);
      await api.verifyOtp(requestModel.toJson());
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _extractErrorMessage(e, 'OTP verification failed'),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    ResetPasswordRequestEntity request,
  ) async {
    try {
      final requestModel = ResetPasswordRequestModel.fromEntity(request);
      await api.resetPassword(requestModel.toJson());
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _extractErrorMessage(e, 'Password reset failed'),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() async {
    try {
      final user = await api.getUserInfo();
      return Right(user.toEntity());
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: _extractErrorMessage(e, 'Failed to fetch user info'),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await api.logout();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: _extractErrorMessage(e, 'Logout failed')),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
