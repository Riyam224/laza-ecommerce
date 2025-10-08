import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double tax;
  final int quantity;
  final String? size;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.tax,
    required this.quantity,
    this.size,
  });

  double get totalPrice => (price - tax) * quantity;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productImage,
    price,
    tax,
    quantity,
    size,
  ];
}
