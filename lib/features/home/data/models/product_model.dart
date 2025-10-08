import '../../domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String coverPictureUrl;
  final double rating;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.coverPictureUrl,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      coverPictureUrl: json['coverPictureUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      coverPictureUrl: coverPictureUrl,
      rating: rating,
    );
  }
}
