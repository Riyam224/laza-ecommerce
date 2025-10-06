import 'package:laza/features/auth/data/models/register_request_model.dart';
import 'package:laza/features/auth/domain/entities/register_response_entity.dart';

abstract class AuthRepository {
  Future<RegisterResponseEntity> register(RegisterRequestModel request);
}
