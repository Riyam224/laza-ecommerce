import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class GetUserInfoUseCase {
  final AuthRepository repository;
  GetUserInfoUseCase(this.repository);
}
