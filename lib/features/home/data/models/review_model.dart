import '../../domain/entities/review_entity.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String comment;
  final double rating;
  final String reviewerName;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.comment,
    required this.rating,
    required this.reviewerName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewerName: json['reviewerName'] ?? '',
    );
  }

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      productId: entity.productId,
      comment: entity.comment,
      rating: entity.rating,
      reviewerName: entity.reviewerName,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'comment': comment,
        'rating': rating,
        'reviewerName': reviewerName,
      };

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      productId: productId,
      comment: comment,
      rating: rating,
      reviewerName: reviewerName,
    );
  }
}