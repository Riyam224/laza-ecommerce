import 'package:equatable/equatable.dart';
import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemEntity> items;
  final double subtotal;
  final double shipping;
  final double total;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  @override
  List<Object?> get props => [items, subtotal, shipping, total];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}

class CartItemAdded extends CartState {
  final String productName;

  const CartItemAdded(this.productName);

  @override
  List<Object?> get props => [productName];
}
