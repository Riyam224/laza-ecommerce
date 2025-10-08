import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearCart();
  }
}
