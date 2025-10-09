

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:laza/core/error/failure.dart';
import 'package:laza/features/cart/data/data_sources/cart_remote_data_source.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:laza/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  // 🧺 Get all items in the cart
  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final response = await remoteDataSource
          .getCartItems(); // ✅ returns CartResponseModel
      print(
        '🧾 Cart response: ${response.cartItems.length} items',
      ); // Debug log
      return Right(response.cartItems);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(ServerFailure(message: 'Please login to view your cart'));
      }
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to load cart items',
        ),
      );
    } catch (e) {
      print('❌ Cart repository error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // 🛒 Add product to cart
  @override
  Future<Either<Failure, void>> addToCart(CartItemEntity item) async {
    try {
      await remoteDataSource.addToCart({
        'productId': item.productId,
        'productName': item.productName,
        'productCoverUrl': item.productImage,
        'price': item.price,
        'tax': item.tax,
        'quantity': item.quantity,
        if (item.size != null) 'size': item.size,
      });
      print('✅ Added ${item.productName} to cart');
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to add item to cart',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // 🗑️ Remove item from cart
  @override
  Future<Either<Failure, void>> removeFromCart(String itemId) async {
    try {
      await remoteDataSource.removeFromCart(itemId);
      print('🗑️ Removed item $itemId from cart');
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to remove item',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // 🔁 Update quantity
  @override
  Future<Either<Failure, void>> updateQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      await remoteDataSource.updateQuantity(itemId, {'quantity': quantity});
      print('🔁 Updated quantity for item $itemId → $quantity');
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to update quantity',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // 🧹 Clear the entire cart
  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      print('🧹 Cart cleared');
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.response?.data['message'] ?? 'Failed to clear cart',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
