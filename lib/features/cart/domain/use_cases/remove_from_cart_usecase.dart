import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemId) async {
    return await repository.removeFromCart(itemId);
  }
}
