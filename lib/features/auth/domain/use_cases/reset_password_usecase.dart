import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import '../entities/reset_password_request_entity.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(ResetPasswordRequestEntity request) {
    return repository.resetPassword(request);
  }
}
