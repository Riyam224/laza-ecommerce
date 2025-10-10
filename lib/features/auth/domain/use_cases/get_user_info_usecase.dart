import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/auth/domain/entities/user_entity.dart';
import 'package:laza/features/auth/domain/repositories/auth_repository.dart';

class GetUserInfoUsecase {
  final AuthRepository repository;

  GetUserInfoUsecase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserInfo();
  }
}
