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
import 'package:laza/features/auth/domain/entities/verify_otp_request_entity.dart';
import 'package:laza/features/auth/domain/entities/reset_password_request_entity.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService api;
  AuthRepositoryImpl(this.api);

  @override
  Future<RegisterResponseEntity> register(RegisterRequestModel request) async {
    final response = await api.register(request);
    return RegisterResponseEntity(
      message:
          response.message ??
          'Registration successful, but no message provided.',
    );
  }

  // todo ______________

  @override
  Future<LoginResponseEntity> login(LoginRequestEntity request) async {
    final requestModel = LoginRequestModel.fromEntity(request);
    final response = await api.login(requestModel);
    return response.toEntity();
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequestEntity request) async {
    final requestModel = ForgotPasswordRequestModel.fromEntity(request);
    await api.forgotPassword(requestModel.toJson());
  }

  @override
  Future<void> verifyOtp(VerifyOtpRequestEntity request) async {
    final requestModel = VerifyOtpRequestModel.fromEntity(request);
    await api.verifyOtp(requestModel.toJson());
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestEntity request) async {
    final requestModel = ResetPasswordRequestModel.fromEntity(request);
    await api.resetPassword(requestModel.toJson());
  }
}