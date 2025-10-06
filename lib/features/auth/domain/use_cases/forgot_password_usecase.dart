import '../entities/forgot_password_request_entity.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(ForgotPasswordRequestEntity request) {
    return repository.forgotPassword(request);
  }
}
