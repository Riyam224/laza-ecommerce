import 'package:json_annotation/json_annotation.dart';
import 'package:laza/features/home/domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? coverPictureUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.coverPictureUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    description: description,
    coverPictureUrl: coverPictureUrl,
  );
}
