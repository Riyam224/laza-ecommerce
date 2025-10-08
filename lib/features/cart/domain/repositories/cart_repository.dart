import 'package:dartz/dartz.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, void>> addToCart(CartItemEntity item);
  Future<Either<Failure, void>> removeFromCart(String itemId);
  Future<Either<Failure, void>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, void>> clearCart();
}
