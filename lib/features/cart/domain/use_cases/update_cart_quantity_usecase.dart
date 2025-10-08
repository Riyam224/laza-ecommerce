import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(String itemId, int quantity) async {
    return await repository.updateQuantity(itemId, quantity);
  }
}
