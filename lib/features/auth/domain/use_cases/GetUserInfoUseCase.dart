import 'package:laza/features/auth/data/models/user/user_model.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class GetUserInfoUseCase {
  final AuthRepository repository;
  GetUserInfoUseCase(this.repository);

  Future<UserModel> call() async {
    return await repository.getUserInfo();
  }
}
