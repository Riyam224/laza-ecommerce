import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import '../entities/forgot_password_request_entity.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(ForgotPasswordRequestEntity request) {
    return repository.forgotPassword(request);
  }
}
