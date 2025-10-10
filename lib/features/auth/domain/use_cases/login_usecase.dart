import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call(LoginRequestEntity request) {
    return repository.login(request);
  }
}
