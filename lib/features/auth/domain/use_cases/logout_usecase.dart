import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/core/storage/shared_prefs.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    // Call the API to logout
    final result = await repository.logout();

    // Clear local token regardless of API result
    await clearToken();

    return result;
  }
}
