import '../../data/models/register_request_model.dart';
import '../entities/register_response_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repo;
  RegisterUseCase(this.repo);

  Future<RegisterResponseEntity> call(RegisterRequestModel request) {
    return repo.register(request);
  }
}
