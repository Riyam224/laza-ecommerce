import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String coverPictureUrl;
  final double rating;
  final int reviewsCount;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.coverPictureUrl,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  List<Object?> get props => [id, name, description, price, coverPictureUrl, rating, reviewsCount];
}
