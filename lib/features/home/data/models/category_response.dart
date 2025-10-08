import 'package:json_annotation/json_annotation.dart';
import 'category_model.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponse {
  final List<CategoryModel> categories;

  CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
