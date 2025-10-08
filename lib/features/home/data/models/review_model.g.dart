// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['id'] as String?,
  userName: json['userName'] as String,
  comment: json['comment'] as String,
  rating: (json['rating'] as num).toDouble(),
  createdAt: json['createdAt'] as String?,
  userPicture: json['userPicture'] as String?,
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'comment': instance.comment,
      'rating': instance.rating,
      'createdAt': instance.createdAt,
      'userPicture': instance.userPicture,
    };
