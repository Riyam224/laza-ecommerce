import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, void>> call(CartItemEntity item) async {
    return await repository.addToCart(item);
  }
}
