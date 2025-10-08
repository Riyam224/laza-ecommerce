import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/cart/data/models/cart_item_model.dart';

part 'cart_response_model.g.dart';

@JsonSerializable()
class CartResponseModel {
  final String? cartId;

  // ✅ Use correct JSON key: "cartItems"
  @JsonKey(name: 'cartItems', defaultValue: [])
  final List<CartItemModel> cartItems;

  CartResponseModel({this.cartId, required this.cartItems});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);
}
