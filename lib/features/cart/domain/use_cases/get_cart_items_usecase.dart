import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItemEntity>>> call() async {
    return await repository.getCartItems();
  }
}
