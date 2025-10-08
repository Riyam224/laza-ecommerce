import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/home/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String? arabicName;
  final String? arabicDescription;
  final String coverPictureUrl;
  final List<String>? productPictures;
  final double price;
  final int stock;
  final double weight;
  final String color;
  final double rating;
  final int reviewsCount;
  final int discountPercentage;
  final String sellerId;
  final List<String> categories;

  ProductModel({
    required this.id,
    required this.productCode,
    required this.name,
    required this.description,
    this.arabicName,
    this.arabicDescription,
    required this.coverPictureUrl,
    this.productPictures,
    required this.price,
    required this.stock,
    required this.weight,
    required this.color,
    required this.rating,
    required this.reviewsCount,
    required this.discountPercentage,
    required this.sellerId,
    required this.categories,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    price: price,
    coverPictureUrl: coverPictureUrl,
    rating: rating,
    reviewsCount: reviewsCount,
  );
}
