import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import '../../data/models/register/register_request_model.dart';
import '../entities/register_response_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repo;
  RegisterUseCase(this.repo);

  Future<Either<Failure, RegisterResponseEntity>> call(RegisterRequestModel request) {
    return repo.register(request);
  }
}
