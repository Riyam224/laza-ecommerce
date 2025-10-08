import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String coverPictureUrl;
  final double rating;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.coverPictureUrl,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, name, price, coverPictureUrl];
}
