import 'package:laza/features/auth/data/data_sources/auth_api_service.dart';
import 'package:laza/features/auth/data/models/register_request_model.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService api;
  AuthRepositoryImpl(this.api);

  @override
  Future<RegisterResponseEntity> register(RegisterRequestModel request) async {
    final response = await api.register(request);
    return RegisterResponseEntity(message: response.message);
  }
}
