import 'package:dio/dio.dart';
import 'package:laza/core/networking/api_constants.dart';
import 'package:laza/features/auth/data/models/register/register_request_model.dart';
import 'package:laza/features/auth/data/models/register/register_response_model.dart';
import 'package:laza/features/auth/data/models/login/login_request_model.dart';
import 'package:laza/features/auth/data/models/login/login_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("auth/register")
  Future<RegisterResponseModel> register(@Body() RegisterRequestModel body);

  @POST("auth/login")
  Future<LoginResponseModel> login(@Body() LoginRequestModel body);

  @POST("auth/forgot-password")
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);

  @POST("auth/validate-otp")
  Future<void> verifyOtp(@Body() Map<String, dynamic> body);

  @POST("auth/reset-password")
  Future<void> resetPassword(@Body() Map<String, dynamic> body);
}
