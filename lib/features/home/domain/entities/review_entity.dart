import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String comment;
  final double rating;
  final String reviewerName;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.comment,
    required this.rating,
    required this.reviewerName,
  });

  @override
  List<Object?> get props => [id, productId, rating, reviewerName];
}