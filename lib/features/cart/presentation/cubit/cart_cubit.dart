import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:laza/features/cart/domain/use_cases/add_to_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/clear_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/get_cart_items_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/remove_from_cart_usecase.dart';
import 'package:laza/features/cart/domain/use_cases/update_cart_quantity_usecase.dart';
import 'package:laza/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartItemsUseCase getCartItems;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;
  final UpdateCartQuantityUseCase updateQuantity;
  final ClearCartUseCase clearCart;

  static const double shippingFee = 10.0;

  CartCubit({
    required this.getCartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateQuantity,
    required this.clearCart,
  }) : super(CartInitial());

  Future<void> loadCart() async {
    emit(CartLoading());
    final result = await getCartItems();

    result.fold((failure) => emit(CartError(failure.message)), (items) {
      print('🧺 CartCubit received ${items.length} items'); // Debug
      final subtotal = _calculateSubtotal(items);
      final total = subtotal + shippingFee;

      emit(
        CartLoaded(
          items: items,
          subtotal: subtotal,
          shipping: shippingFee,
          total: total,
        ),
      );
    });
  }

  Future<void> addItemToCart(CartItemEntity item) async {
    final result = await addToCart(item);

    result.fold((failure) => emit(CartError(failure.message)), (_) {
      emit(CartItemAdded(item.productName));
      loadCart();
    });
  }

  Future<void> removeItemFromCart(String itemId) async {
    final result = await removeFromCart(itemId);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> updateItemQuantity(String itemId, int quantity) async {
    final result = await updateQuantity(itemId, quantity);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> clearCartItems() async {
    final result = await clearCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  void incrementQuantity(String itemId) {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.items.firstWhere((i) => i.id == itemId);
      updateItemQuantity(itemId, item.quantity + 1);
    }
  }

  void decrementQuantity(String itemId) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;
      final item = currentState.items.firstWhere((i) => i.id == itemId);

      if (item.quantity > 1) {
        updateItemQuantity(itemId, item.quantity - 1);
      } else {
        removeItemFromCart(itemId);
      }
    }
  }

  double _calculateSubtotal(List<CartItemEntity> items) {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
