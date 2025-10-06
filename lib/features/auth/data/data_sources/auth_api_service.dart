import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: "https://accessories-eshop.runasp.net/api")
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("/auth/register")
  Future<RegisterResponseModel> register(@Body() RegisterRequestModel body);
}