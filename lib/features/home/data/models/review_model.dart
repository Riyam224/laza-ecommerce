import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/home/domain/entities/review_entity.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String? id;
  final String userName;
  final String comment;
  final double rating;

  ReviewModel({
    this.id,
    required this.userName,
    required this.comment,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    userName: userName,
    comment: comment,
    rating: rating,
  );
}
