import 'package:laza/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.price,
    required super.tax,
    required super.quantity,
    super.size,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id:
          (json['id'] ?? json['itemId'] ?? '')
              as String, // ✅ handles both id/itemId
      productId: (json['productId'] ?? '') as String,
      productName: (json['productName'] ?? '') as String,
      productImage:
          (json['productImage'] ??
                  json['productCoverUrl'] ?? // ✅ backend key fix
                  '')
              as String,
      price:
          (json['price'] ??
                  json['basePricePerUnit'] ??
                  json['finalPricePerUnit'] ??
                  0)
              .toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      quantity: (json['quantity'] ?? 1) as int,
      size: json['size'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'tax': tax,
      'quantity': quantity,
      if (size != null) 'size': size,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      productImage: entity.productImage,
      price: entity.price,
      tax: entity.tax,
      quantity: entity.quantity,
      size: entity.size,
    );
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? tax,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      tax: tax ?? this.tax,
      quantity: quantity ?? this.quantity,
    );
  }
}
